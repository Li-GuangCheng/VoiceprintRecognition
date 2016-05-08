function y=bansin(n)
    for j=1:n
        y(j)=(0.5+0.5*sin(pi*j/n));
    end