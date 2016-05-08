function mels=train(snd,filt,nmfcc)
n=length(snd(1,:));
for i=1:n
%	fft_snd=fft(snd(:,i),10423);
%	fft_snd=fft_snd(1:4000);
%	fft_snd(5211)=0;
	fft_snd=fft(snd(:,i),10423);
	fft_snd(1)=[];
	fft_snd=fft_snd(1:5211);
	pwr_snd=abs(fft_snd).^2;
	tmels=mfcc(filt,pwr_snd,nmfcc);
	mels(:,i)=tmels';
end
	