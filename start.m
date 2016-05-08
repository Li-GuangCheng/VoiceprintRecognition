
close all;
chos=0;
possibility=5;

messaggio='Insert the number of set: each set determins a class. This set should include a number of speech for each person, with some variations in expression and in the lighting.';

while chos~=possibility,
    chos=menu('speaker identification System by LiGuangCheng','Select speech signal and add to database','Select speech signal for speaker identification','Delete database',...
        'speech signal: visualization','Exit');
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    % Calculate gmm of the speech and Add to Database
    if chos==1
        clc;
        close all;
        selezionato=0;
        while selezionato==0
            [namefile,pathname]=uigetfile({'*.wav','speech Files (*.wav)'},'Chose speech signal');
            if namefile~=0
     
                selezionato=1;
            else
                disp('Select a speech signal');
            end
           
        end
        filt=melfilter(150,300,15);
        fr1=frm(strcat(pathname,namefile),16,8000,1);
        mc2=train(fr1,filt,20); 
        mc2=mc2(3:18,:);
        mc1=banshengsin(mc2);
        s1=pitch(pathname,namefile);
        a=length(s1);
        b=length(mc1(1,:));
        if a>b
            s1(b+1:a)=[];
        else
            s1(a+1:b)=0;
        end
        mc1=[mc1;s1];
        [im is ip]=init(mc1,16);
        [nim1 nis1 nip1 times]=gmm(im,is,ip,mc1);
      data=struct('name',{},'means',{},'cov',{},'prob',{},'pitch',{});
        
        if (exist('speech_database.dat')==2)
           load('speech_database.dat','-mat');
            speaker_number=speaker_number+1;
           prompt={'Enter the name of speaker to add'};
   name='the speaker ';
   numlines=1;
   defaultanswer={'no one'};
   answer=inputdlg(prompt,name,numlines,defaultanswer);
   data(speaker_number).name=answer{1,1};
          data(speaker_number).means=nim1;
          data(speaker_number).cov=readcov(nis1);
          data(speaker_number).prob=nip1;
          data(speaker_number).pitch=s1;
          save('speech_database.dat','data','speaker_number','-append');
       else
           speaker_number=1;   
    prompt={'Enter the name of speaker to add'};
   name='the speaker ';
   numlines=1;
   defaultanswer={'no one'};
   answer=inputdlg(prompt,name,numlines,defaultanswer);
   data(speaker_number).name=answer{1,1};
           data(speaker_number).means=nim1;
        data(speaker_number).cov=readcov(nis1);
        data(speaker_number).prob=nip1;
        data(speaker_number).pitch=s1;
           save('speech_database.dat','data','speaker_number');
       end
        
        message=strcat('speechsignal was succesfully added to database. speaker is.. ',answer{1,1})
        msgbox(message,'speechsignal DataBase','help')
    end
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    % speaker recognition
    if chos==2
        clc;
        close all;
        selezionato=0;
        while selezionato==0
            [namefile,pathname]=uigetfile({'*.wav','speech Files (*.wav)'},'Chose speech signal');
            if namefile~=0
             
                selezionato=1;
            else
                disp('Select a speech signal');
            end
          
        end
      
        if (exist('speech_database.dat')==2)
            load('speech_database.dat','-mat');
            filt=melfilter(150,300,15);
 fr=frm(strcat(pathname,namefile),16,8000,3);
 l=length(fr(1,:));
 nosp=length(data);
 k=0;
 b=0;
 r=nosp;
 while(r~=1)
  r=floor(r/2);
  k=k+1;
end
p(2,nosp)=0;p(1,1)=0;
for i=1:nosp
    p(2,i)=i;
end
mc4=train(fr,filt,20);
mc4=mc4(3:18,:);
mc=banshengsin(mc4);
pitch2=pitch(pathname,namefile);
a=length(pitch2);
b=length(mc(1,:));
if a>b
    pitch2(b+1:a)=[];
else
    pitch2(a+1:b)=0;
end
mc=[mc;pitch2];
coff=length(mc(:,1));
o=length(mc(1,:));
frameparts=struct('frame',{});
s=mod(l,k);
y=floor(l/k);
if s==0
   for i=1:k
       frameparts(i).frame(coff,y)=0;
   end
else
    for i=1:s
      frameparts(i).frame(coff,y+1)=0;
    end
    for i=s+1:k
      frameparts(i).frame(coff,y)=0;
    end
end
for r=1:k
 count=1;
   for i=r:k:l
      frameparts(r).frame(:,count)=mc(:,i);
      count=count+1;
   end
end
c=length(data);
for  i=1:k
   % tic
   p1=ident2(frameparts(i).frame,filt,data,p);
 %  toc
   p=upd_pr(p,p1);
   p=nmax1(p);
end
p2=p(1)/o;
scores=zeros(nosp,1);
for i=1:nosp
   pitch1=data(i).pitch';
  % tic
   scores(i,1)=myDTW(pitch2,pitch1(1:length(pitch2)));
  % toc
end
scores;
[m,n]=sort(scores);

b=p(2,1);
if or((p2>-25),b==n)
nm=data(b).name;
       message=strcat('The speaker is : ',nm);
       msgbox(message,'DataBase Info','help');
else
    message='the speaker is a stranger.';
    msgbox(message,'DataBase Info','help');
end
        else
            message='DataBase is empty. No check is possible.';
            msgbox(message,'speech DataBase Error','warn');    
        end
        
    end 
   
%删除全部数据，或只删除一个人的数据    
    if chos==3
        clc;
        close all;
        if (exist('speech_database.dat')==2)
             load('speech_database.dat','-mat');
            button = questdlg('which speaker do you want to delete?',...
                   'Genie Question',...
                   'all','specified','all');
             if strcmp(button,'all')
                delete('speech_database.dat');
                msgbox('Database was succesfully removed from the current directory.','Database removed','help');
             else 
                  prompt={'Enter the name of speaker you want to delete'};
   name='specified speaker delete';
   numlines=1;
   defaultanswer={'0'};
   answer=inputdlg(prompt,name,numlines,defaultanswer);
nspeaker=length(data);
 names=cell(1,nspeaker);
 for i=1:nspeaker
names{1,i}=data(i).name;
 end
[a,b]=ismember(answer{1,1},names);
 if a==0
       warndlg('the speaker is not exist.','Warining')
   else 
      data(b)=[];
      speaker_number=length(data);
      save('speech_database.dat','data','speaker_number','-append');
   message=strcat('you have succesfully removed The speaker  : ',answer{1,1});
            msgbox(message,'specified speaker removed','help');
 end
             end
        else
            warndlg('Database is empty.',' Warning ')
        end
    end 
    if chos==4
        clc;
        close all;
        selezionato=0;
        while selezionato==0
            [namefile,pathname]=uigetfile({'*.wav','speech signal (*.wav)'},'Chose speech signal');
            if namefile~=0
               [x,fs]=wavread(strcat(pathname,namefile));
                selezionato=1;
            else
                disp('Select a speech signal');
            end
        
        end
        figure('Name','Selected speech signal');
        plot(x);
        pause;
        x=trim(x);
        plot(x);
        pause;
        filt=melfilter(150,300,15);
        fr1=frm(strcat(pathname,namefile),16,8000,1);
        size(fr1)
        mc2=train(fr1,filt,20); 
       colormap(1-gray);
        imagesc(mc2);
        pause;
        mc2=mc2(3:18,:);
        imagesc(mc2);
        pause;
        y=bansin(16)
        plot(y);
        pause;
        mc1=banshengsin(mc2);
        imagesc(mc1);
        pause;
      %  cor=CorrelogramArray(fr1,x,256);
       % [pixels frames] = size(cor);
	  %  colormap(1-gray);
	%for j=1:frames
	%	imagesc(reshape(cor(:,j),pixels/256,256));
	%	drawnow;
    %end
    %  pitch=CorrelogramPitch(cor,256,8000);
    %  plot(pitch)
	 s11=pitch(pathname,namefile);
     plot(s11);
    pause;
   %[im is ip]=init(mc1,16);
    % [nim1 nis1 nip1 times]=gmm(im,is,ip,mc1);
     
     end  
end