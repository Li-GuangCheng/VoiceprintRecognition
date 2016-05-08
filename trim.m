
function trimmedX = trim(x)
%Author:        Olutope Foluso Omogbenigun
%Email:         olutopeomogbenigun at hotmail.com
%University:    London Metropolitan University
%Date:          02/08/07
%Syntax:        trimmedSample = myVAD2(samplex);
%This function accepts an audio sample 'samplex' as input and returns a
%trimmed down version with non-speech sections trimmed off. Also known as
%voice activity detection, it utilises the algorithm due to Rabiner &
%Sambur (1975)
%[x,fs]=wavread('1');

       %Initial silence duration in seconds
Ts = 0.001;          %Frame width in seconds
Tsh = 0.0005;        %Frame shift in seconds
Fs = 8000;         %Sampling Frequency
counter1 = 0;   
counter2 = 0;

ZCRCountf = 0;      %Stores forward count of crossing rate > IZCT
ZCRCountb = 0;      %As above, for backward count
w_sam = fix(Ts*Fs);                   %No of Samples/window 
o_sam = fix(Tsh*Fs);                  %No of samples/overlap
lengthX = length(x);
segs = fix((lengthX-w_sam)/o_sam)+1;  %Number of segments in speech signal

win = hamming(w_sam);

Limit = o_sam*(segs-1)+1;             %Start index of last segment

FrmIndex = 1:o_sam:Limit;             %Vector containing starting index 
                                      %for each segment
ZCR_Vector = zeros(1,segs);           %Vector to hold zero crossing rate 
                                      %for all segments
                                     
%Below code computes and returns zero crossing rates for all segments in
%speech sample  
for t = 1:segs
    ZCRCounter = 0; 
    nextIndex = (t-1)*o_sam+1;
    for r = nextIndex+1:(nextIndex+w_sam-1)
        if (x(r) >= 0) && (x(r-1) >= 0)
         
        elseif (x(r) >= 0) && (x(r-1) < 0)
         ZCRCounter = ZCRCounter + 1;
        elseif (x(r) < 0) && (x(r-1) < 0)
         
        elseif (x(r) < 0) && (x(r-1) >= 0)
         ZCRCounter = ZCRCounter + 1;
        end
    end
    ZCR_Vector(t) = ZCRCounter;
end

%Below code computes and returns frame energy for all segments in speech
%sample
Erg_Vector = zeros(1,segs);
for u = 1:segs
    nextIndex = (u-1)*o_sam+1;
   Energy = x(nextIndex:nextIndex+w_sam-1).*win;
    Erg_Vector(u) = sum(abs(Energy));
end


IMX = max(Erg_Vector);          %Maximum energy for entire utterance
ITM=0.2*IMX^2;
IZCT=0.8*max(ZCR_Vector);



%Search forward for frame with energy greater than ITU
for i = 1:length(Erg_Vector)
    if ((Erg_Vector(i))^2 > ITM)
        counter1 = counter1 + 1;
        indexi(counter1) = i;
    end
end
for j=1:length(ZCR_Vector)
    if (ZCR_Vector(j)>IZCT)
        counter2=counter2+1;
        indexj(counter2)=j;
    end
end

start=min([indexi,indexj]);
finish=max([indexi,indexj]);

x_start = FrmIndex(start);      %actual sample index for frame 'start'
x_finish = FrmIndex(finish);  %actual sample index for frame 'finish'
trimmedX = x(x_start:x_finish); %Trim speech sample by start and finish 
                                %indices








