%%% Test script for K-matrix sparse operations
clc; close all; clear;

% Generate individual matrices
Kbasket = [];
length = 10;
for i = 1:1:length
    Kbasket(:,:,i) = [i,0,0;0,i+1,0;0,0,i+2];
end

% Concatenate matrices
K = zeros((2*length)+1); c = 1;
for j = 1:2:(2*length)
    ke = (Kbasket(:,:,c));
    K(j:(j+2),j+1) = ke(:,2);
    K((j+1):(j+2),j) = ke(2:3,1);
    K(j:(j+1),(j+2)) = ke(1:2,3);
    K(j,j) = K(j,j) + ke(1,1);
    K((j+2),(j+2)) = K((j+2),(j+2)) + ke(3,3);
    c = c+1;
end

% Sparsify K
Ks = sparse(K);

% Partition sparse K
Kqq = Ks(1:5,1:5); Krq = Ks(6:21,1:5); 
Kqr = Ks(1:5,6:21); Krr = Ks(6:21,6:21);
Knn = sparseinv(Kqq);

% Partition unsparse K (to compare)
Kaa = K(1:5,1:5); Kba = K(6:21,1:5); 
Kab = K(1:5,6:21); Kbb = K(6:21,6:21);
Kmm = inv(Kaa);

% Multiply sparse matrices by row matrices
Kxx = Knn*[1;2;3;4;5]; %Kxx = full(Kxx);
Kyy = Kmm*[1;2;3;4;5];


 
