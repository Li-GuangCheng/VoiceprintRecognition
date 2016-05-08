%给出混合高斯模型的初始值：均值，方差，系数
function [init_m init_s init_p] = init(mfcc,mogs)
dim_x=(mogs);
dim_y=length(mfcc(:,1));
init_m(dim_y,dim_x)=0;
init_s(dim_y,dim_y,dim_x)=0;
init_p(dim_x)=0;

means=split(mfcc,1,mogs);
init_m=means;

for i=1:mogs
	for j=1:dim_y
		for k=1:dim_y
			if j==k
				init_s(j,k,i)=1;
			end
		end
	end
end

for i=1:mogs
	init_p(i)=1/mogs;
end