%% Sanity check for PBC application (from Basic_Truss_Stiffness_V3)

clc;    
close all; 
clear;

syms e11 e22 e33 e12 e23 e31;
strains = [e11, e22, e33, e12, e23, e31];
e21 = e12; e32 = e23; e13 = e31;
emat = [e11, e12, e13;
     e21, e22, e23;
     e31, e32, e33];

% For corners:
B = emat*[0;0;1]; C = emat*[0;1;0]; D = emat*[0;1;1];
E = emat*[1;0;0]; F = emat*[1;0;1]; G = emat*[1;1;0]; H = emat*[1;1;1];
ucorners = [B,C,D,E,F,G,H];

% For edges:
BF = emat*[0;0;1]; EF = emat*[1;0;0]; FH = emat*[1;0;1];
CG = emat*[0;1;0]; EG = emat*[1;0;0]; GH = emat*[1;1;0];
BD = emat*[0;0;1]; CD = emat*[0;1;0]; DH = emat*[0;1;1];
uedges = [BF,EF,FH,CG,EG,GH,BD,CD,DH];

% For faces:
EFGH = emat*[1;0;0]; CDHG = emat*[0;1;0]; BDFH = emat*[0;0;1];
ufaces = [EFGH,CDHG,BDFH];