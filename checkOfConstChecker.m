% Checking Script for Constraint Checker (based on 2D NxN Truss Code)

% Initialization
clc;    
close all; 
clear;

% Input Constants
sidenum = 3; % Number of nodes on each size of square grid
nucFac = 2; % factor to indicate how many unit cells are in this model
            %   (so nucFac = 1 indicates the entire 5x5 is one unit cell,
            %    and nucFac = 2 indicates that the 5x5 contains four
            %    3x3 unit cells inside of it
sel = 0.05; % unit cube side length of 5 cm, truss length of 2.5 cm
r = 50*(10^-6); % Radius of 50 micrometers for cross-sectional 
                %   area of (assumed circular) truss members
A = pi*(r^2); % Cross-sectional area of truss member
E = 10000; % Young's Modulus of 10000 Pa (polymeric material)

% Input trial connectivity arrays
CAone = ...
    [1,2;2,3;1,4;1,5;2,5;3,5;3,6;4,5;5,6;4,7;5,7;5,8;5,9;6,9;7,8;8,9];
CAtwo = ...
    [1,2;2,3;1,4;2,4;2,5;2,6;3,6;4,5;5,6;4,7;4,8;5,8;6,8;6,9;7,8;8,9];
CAthree = ...
    [1,2;2,3;1,4;2,4;2,5;2,6;3,6;4,5;5,6;4,7;4,8;5,8;6,8;6,9;7,8;8,9;...
     1,5;3,5;5,7;5,9];
 
% Check constraints for all trial truss designs
ver_one = constChecker(CAone,sidenum);
ver_two = constChecker(CAtwo,sidenum);
ver_three = constChecker(CAthree,sidenum);

% FUNCTION FOR CONSTRAINT CHECKER
function constVerified = constChecker(CA,sidenum)
    constVerified = true;

    % First constraint: members only intersect at nodes (no crossing)
    for i = 1:1:size(CA,1)
        if CA(i,1)+sidenum+1 == CA(i,2)
            row = [CA(i,1)+1,CA(i,1)+sidenum];
            [crossed,where] = ismember(row,CA,'rows');
            if crossed == true
                constVerified = false;
                D = ['Element (',num2str(CA(i,1)),',',num2str(CA(i,2)),...
                     ') intersects with element (',num2str(CA(where,1)),...
                     ',',num2str(CA(where,2)),')'];
                disp(D);
                return
            end
        elseif CA(i,1)+sidenum-1 == CA(i,2)
            row = [CA(i,1)-1,CA(i,1)+sidenum];
            [crossed,where] = ismember(row,CA,'rows');
            if crossed == true
                constVerified = false;
                D = ['Element (',num2str(CA(i,1)),',',num2str(CA(i,2)),...
                     ') intersects with element (',num2str(CA(where,1)),...
                     ',',num2str(CA(where,2)),')'];
                disp(D);
                return
            end
        end
    end
end
