function [cost] = myDTW(featureMatrix,RefMatrix)
%Author:        Olutope Foluso Omogbenigun
%Email:         olutopeomogbenigun at hotmail.com
%University:    London Metropolitan University
%Date:          23/06/07
%Syntax:        cost = myDTW(featureMatrix,RefMatrix);
%This function accepts two matrices one of reference template and
%the other of test feature vectors and returns the minimum cost
%via DTW (unconstrained)

F = featureMatrix;
R = RefMatrix;
[r1,c1]=size(F);         %test matrix dimensions
[r2,c2]=size(R);         %reference matrix dimensions
localDistance = zeros(r1,r2);%Matrix to hold local distance values
%The local distance matrix is derived below
for n=1:r1
    for m=1:r2
        FR=F(n,:)-R(m,:);
        FR=FR.^2;
        localDistance(n,m)=sqrt(sum(FR));
    end
end

D = zeros(r1+1,r2+1);   %Matrix of zeros for local dist matrix
D(1,:) = inf;           %Pads top with horizontal infinite values
D(:,1) = inf;           %Pads left with vertical infinite values 
D(1,1) = 0;
D(2:(r1+1), 2:(r2+1)) = localDistance;


%This loop iterates through distance matrix to obtain global
%minimum distance
for i = 1:r1; 
 for j = 1:r2;
   [dmin] = min([D(i, j), D(i, j+1), D(i+1, j)]);
   D(i+1,j+1) = D(i+1,j+1)+dmin;
 end
end

cost = D(r1+1,r2+1);    %returns overall global minimum score

