%利用最大似然概率寻找输入数据的高斯模型
function  pr=ident2(mc,filt,cdbk,p)
l=length(mc(1,:));
nosp=length(cdbk);
pr(nosp)=0;
prp(nosp)=0;
nocoeff=length(cdbk(1).means(:,1));
for m=1:nosp
	for j=1:16
		sigma=det(cdbk(m).cov(:,:,j))^(0.5);
		const(m,j)=1/(((2*pi)^(nocoeff/2))*sigma);
		cov(:,:,m,j)=inv(cdbk(m).cov(:,:,j));
	end
end
for k=1:l
   for s=1:length(p(1,:))
     sp=p(2,s);
	      prob=0;
		for j=1:16
			diff=mc(:,k)-cdbk(sp).means(:,j);
			val=det(diff'*cov(:,:,sp,j)*diff);
			prob=prob+exp(-0.5*val)*const(sp,j)*cdbk(sp).prob(j);
        end
		pr(sp)=pr(sp)+log(prob);
   end
     
end
