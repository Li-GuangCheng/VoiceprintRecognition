
%建立一mel频率滤波器组，每个滤波器都是一个三角滤波器
%spacing是滤波器间的通带间隔
%bandwidth是滤波器组的通带
%p是创建的滤波器的个数
%返回一个n*p矩阵，每一列代表一个滤波器的响应
function filt=melfilter(spacing,bandwidth,p)
mcentre=bandwidth/2;
centre=melinv(mcentre);
lastf=melinv(p*bandwidth);
for i=1:p
	mstart=mcentre-bandwidth/2;
	mend=mcentre+bandwidth/2;
	start=melinv(mstart);
	term=melinv(mend);
	trfilt=triang(round(term)-round(start)+1);
	c=0;
	for j=round(start):round(term)
		filt(j+1,i)=trfilt(c+1);
		c=c+1;
	end
	mcentre=mcentre+spacing;
	centre=melinv(mcentre);
end



	
