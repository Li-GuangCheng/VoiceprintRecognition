function mc=mfcc(filt,powspectrum,L)
K=length(filt(1,:));
N=length(filt(:,1));
for j=1:K
	m(j)=0;
	for i=1:N
		m(j)=m(j)+powspectrum(i)*filt(i,j);
	end
end
if m~=0
 m=log(m);
 end
for i=1:L
	mc(i)=0;
	for j=1:K
		mc(i)=mc(i)+m(j)*cos(i*(j-0.5)*pi/K);
	end
end
