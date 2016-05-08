function is=readcov(nis1)
%temp=csvread(file);
l=length(nis1(:,1));
count=1;
t=length(nis1(1,:))/l;
for i=1:t
	is(:,:,count)=nis1(:,(count-1)*l+1:count*l);
	count=count+1;
end
