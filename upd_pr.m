function p=upd_pr(p,p1)
for i=1:length(p(1,:))
   sp=p(2,i);
   p(1,i)=p(1,i)+p1(sp);
end