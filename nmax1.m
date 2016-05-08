function p1 =nmax1(p)
count=length(p(1,:));
l=ceil(count/2);

for j=1:l
   [a b]=min(p(1,:));
   p(:,b)=[];
end
p1=p;

         
   