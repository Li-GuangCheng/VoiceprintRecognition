%为输入系数乘半升正弦函数
function mc2=banshengsin(mc1)
[n,m]=size(mc1);
mc2=zeros(n,m);
for i=1:m
    for j=1:n
        mc2(j,i)=mc1(j,i)*(0.5+0.5*sin(pi*j/n));
    end
end
        