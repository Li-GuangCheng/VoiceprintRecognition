function means=split(mels,row,mogs)
data=mels(row,:);
nocoeff=length(mels(:,1));
%function ddd=probdist(data)
l=length(data);
lddl=round(max(data))+51;
ddd(lddl)=0;
col(l)=0;
for i=1:l
	val=round(data(i));
	ddd(val+50)=ddd(val+50)+1;
    col(i)=val+50;
end
start=1;
term=l;
for i=1:lddl
    if ddd(i)~=0
           start=i;
           break;
    end
end
for i=lddl:-1:1
    if ddd(i)~=0
            term=i;
            break;
    end
end
width=(term-start)/mogs;
temp=start;
m(mogs,2)=0;
for i=1:mogs
    m(i,1)=temp;
    m(i,2)=temp+width;
    temp=temp+width;
end
noelem(mogs)=0;
means(nocoeff,mogs)=0;
for i=1:mogs
    for j=1:l
        if and(col(j)>=m(i,1),col(j)<m(i,2))
            for k=1:nocoeff
                means(k,i)=(means(k,i)*noelem(i)+mels(k,j))/(noelem(i)+1);
            end
            noelem(i)=noelem(i)+1;
        end
    end
end