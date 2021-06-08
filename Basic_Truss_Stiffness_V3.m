%% Generating 3D Stiffness Matrix 

clc;    
close all; 
clear;

%sel = 0.1; % unit cube side length of 10 cm/ truss length of 5 cm
%A = 0.00005; % Cross-sectional area of 0.005 m^2 / 0.5 cm^2
%E = 10000; % Young's Modulus of 10 kPa (polymeric material)

sel = 1; % unit cube side length of 1 m/ truss length of 0.5 m
A = 0.0005; % Cross-sectional area of 0.0005 m^2 / 5 cm^2
E = 10000; % Young's Modulus of 10 kPa (polymeric material)

% Initializing Nodal Coordinates (Standard Grid)
NC = sel.*[0,0,0;0,0.5,0;0,1,0;0.5,0,0;0.5,0.5,0;0.5,1,0;1,0,0;1,0.5,0;1,1,0;
      0,0,0.5;0,0.5,0.5;0,1,0.5;0.5,0,0.5;0.5,0.5,0.5;0.5,1,0.5;1,0,0.5;1,0.5,0.5;1,1,0.5;
      0,0,1;0,0.5,1;0,1,1;0.5,0,1;0.5,0.5,1;0.5,1,1;1,0,1;1,0.5,1;1,1,1];

% Initializing Connectivity Array (Elements)
CA = [1,2;2,3;3,6;6,9;8,9;7,8;4,7;1,4;2,5;5,8;4,5;5,6;1,5;5,9;3,5;5,7;
      10,11;11,12;12,15;15,18;17,18;16,17;13,16;10,13;11,14;14,17;13,14;14,15;10,14;14,18;12,14;14,16;
      19,20;20,21;21,24;24,27;26,27;25,26;22,25;19,22;20,23;23,26;22,23;23,24;19,23;23,27;21,23;23,25;
      1,10;10,19;2,11;11,20;3,12;12,21;4,13;13,22;5,14;14,23;6,15;15,24;7,16;16,25;8,17;17,26;9,18;18,27;
      7,17;17,27;9,17;17,25;4,14;14,24;6,14;14,22;1,11;11,21;3,11;11,19;
      7,13;13,19;1,13;13,25;8,14;14,20;2,14;14,26;9,15;15,21;3,15;15,27;
      1,14;3,14;7,14;9,14;14,19;14,21;14,25;14,27];

% Forming Elemental Stiffness Matrices
Kbasket = [];
for i = 1:size(CA,1)
    x1 = NC(CA(i,1),1); x2 = NC(CA(i,2),1);
    y1 = NC(CA(i,1),2); y2 = NC(CA(i,2),2);
    z1 = NC(CA(i,1),3); z2 = NC(CA(i,2),3);
    L = sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2));
    c=(x2-x1)/L; c2 = c^2;
    s=(y2-y1)/L; s2 = s^2;
    n=(z2-z1)/L; n2 = n^2;
    ktemp = [c2,   c*s,  c*n,  -c2,  -c*s, -c*n;  
             c*s,  s2,   s*n,  -c*s, -s2,  -s*n;  
             c*n,  s*n,  n2,   -c*n, -s*n, -n2 ;   
             -c2,  -c*s, -c*n, c2,   c*s,  c*n ; 
             -c*s, -s2,  -s*n, c*s,  s2,   s*n ;
             -c*n, -s*n, -n2,  c*n,  c*n,  n2  ];
    ke = ((A.*E)./L).*ktemp;
    Kbasket(:,:,i) = ke;
end

% Global-to-local-coordinate-system Coordination
GlobToLoc=zeros(size(CA,1),6);
for n=1:2  
    GN=CA(:,n); 
    for d=1:3 
        GlobToLoc(:,(n-1)*3+d)=(GN-1)*3+d;
    end
end

% Forming Global Truss Stiffness Matrix
K = zeros(3*size(NC,1));
for e=1:size(CA,1) 
    ke = Kbasket(:,:,e);
    for lr = 1:6
        gr = GlobToLoc(e,lr); 
        for lc = 1:6
            gc = GlobToLoc(e,lc); 
            K(gr,gc) = K(gr,gc) + ke(lr,lc);
        end
    end
end


%% Generating Stiffness Matrix

% - for each possible strain:
%   - set given strain to preset value, all others to zero
%   - Iterate through PBC displacement-strain relation matrices/equations
%     for corners, then edges, then faces
%   - Enforce traction free surfaces ???
%   - solve for unknown u's, F's (How???)
%   - use generated F, u data to determine desired C-matrix component

% Strains: declaring the strains that we will use
strains = [e11, e22, e33, e12, e23, e31];
e21 = e12; e32 = e23; e13 = e31;
emat = [e11, e12, e13;
     e21, e22, e23;
     e31, e32, e33];

% Node tagging for positions: 1 = corner, 2 = edge, 3 = face, 
% 0 = center node
nTPos = [1;2;1;2;3;2;1;2;1;2;3;2;3;0;3;2;3;2;1;2;1;2;3;2;1;2;1];

% Node tagging for tractions: 1 = fixed in xyz, 2 = fixed in xy, 
% 3 = fixed in yz, 4 = fixed in xz, 5 = fixed in x, 6 = fixed in y,
% 7 = fixed in z, 8 = traction free, 9 = free, 10 = enforced displacement
% Note the directional tag for current strain direction follows the
% order of the 'strains' vector
% *
% CHANGEME (this is the direction of strain tag)
dtag = [];
% *
nTTrac = [];
for i = 1:size(NC,1)
    nCoord = NC(i,:);
    if nCoord(1) == 0
        if (nCoord(2) == 0) && (nCoord(3) == 0) % for node tag 1 (xyz fixed)
            nTTrac = [nTTrac;1];
        elseif nCoord(2) == 0 % for node tag 2 (xy fixed)
            nTTrac = [nTTrac;2];
        elseif nCoord(3) == 0 % for node tag 4 (xz fixed)
            nTTrac = [nTTrac;4];
        else % for node tag 5 (x fixed)
            nTTrac = [nTTrac;5];
        end
    elseif nCoord(2) == 0
        if nCoord(3) == 0 % for node tag 3 (yz fixed)
            nTTrac = [nTTrac;3];
        else % for node tag 6 (y fixed)
            nTTrac = [nTTrac;6]; 
        end
    elseif nCoord(3) == 0 % for node tag 7 (z fixed)
        nTTrac = [nTTrac;7];
    elseif nCoord(1) == sel
        if (dtag == 1) || (dtag == 4) || (dtag == 6)
            % for node tag 10 (enforced displacement)
            nTTrac = [nTTrac;10];
        else % for node tag 8 (traction-free BC)
            nTTrac = [nTTrac;8];
        end
    elseif nCoord(2) == sel
        if (dtag == 2) || (dtag == 4) || (dtag == 5)
            % for node tag 10 (enforced displacement)
            nTTrac = [nTTrac;10];
        else % for node tag 8 (traction-free BC)
            nTTrac = [nTTrac;8];
        end
    elseif nCoord(3) == sel
        if (dtag == 3) || (dtag == 5) || (dtag == 6)
            % for node tag 10 (enforced displacement)
            nTTrac = [nTTrac;10];
        else % for node tag 8 (traction-free BC)
            nTTrac = [nTTrac;8];
        end
    else % for node tag 9 (unconstrained/interior) 
        nTTrac = [nTTrac;9];        
    end
end


% Developing PBC disp-strain relations (corner A is fixed)
% For corners:
B = emat*[0;0;1]; C = emat*[0;1;0]; D = emat*[0;1;1];
E = emat*[1;0;0]; F = emat*[1;0;1]; G = emat*[1;1;0]; H = emat*[1;1;1];
ecorners = [B,C,D,E,F,G,H];

% For edges:
BF = emat*[0;0;1]; EF = emat*[1;0;0]; FH = emat*[1;0;1];
CG = emat*[0;1;0]; EG = emat*[1;0;0]; GH = emat*[1;1;0];
BD = emat*[0;0;1]; CD = emat*[0;1;0]; DH = emat*[0;1;1];
eedges = [BF,EF,FH,CG,EG,GH,BD,CD,DH];

% For faces:
EFGH = emat*[1;0;0]; CDHG = emat*[0;1;0]; BDFH = emat*[0;0;1];
efaces = [EFGH,CDHG,BDFH];

% Developing F and u vectors, implementing traction-free surfaces
F = [];
u = []; % F = k*u
for i = 1:length(nTTrac)
    if nTTrac(i) == 1 % for fixed in xyz
        u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 2 % for fixed in xy
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 3 % for fixed in yz
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 4 % for fixed in xz
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 5 % for fixed in x
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 6 % for fixed in y
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 7 % for fixed in z
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    elseif nTTrac(i) == 8 % for traction-free BC
        %u = [u;0;0;0];
        %F = [F;0;0;0];
    elseif nTTrac(i) == 10 % for enforced displacement 
        %u = [u;0;0;0];
        %F = [F;1;1;1];
    else % for unconstrained/interior node (nTTrac(i) = 9)
        %u = [u;0;0;0];
        F = [F;1;1;1];
    end
end




