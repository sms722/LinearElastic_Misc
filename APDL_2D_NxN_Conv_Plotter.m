% -----------------------------------------------------------------
% Plotting Convergence Functions for ANSYS APDL 2D NxN Convergence Analysis

%% Plotting C11 Convergence
%-% Initialization
clc;   
close all; 
clear;

%-% Input values
UC2 = ([1,2,3,4,6,8,10].^2);

% Arrow
C11_ARROW = [50.066310583862350,29.025287792050320,24.031379549277176,...
    21.765456381234554,19.678959994448963,18.752461563362015,...
    18.280089298151800];
fARROW = fit(UC2',C11_ARROW','exp2');

% Case 1
C11_Case1 = [58.186008778000010,50.339044958000010,47.724622964666670,...
    46.418792213000000,45.116933942000010,44.471473520499990,...
    44.089978850800000];
fCase_1 = fit(UC2',C11_Case1','exp2');

% Walkman
C11_Walkman = [40.885896290000005,20.664679447180000,14.053795524200000,...
    10.847166158005003,7.699349931316668,6.150863541970001,...
    5.241061629198200];

fWalkman = fit(UC2',C11_Walkman','exp2');

% F3N2
C11_F3N2 = [49.137159600000004,40.609054882000000,37.528584076000010,...
    35.945377717500000,34.373789556333330,33.619388485750000,...
    33.192448694400000];
fF3N2 = fit(UC2',C11_F3N2','exp2');

% F3N4
C11_F3N4 = [34.624773132000000,25.412588289000002,22.400099130000005,...
    20.911589845000000,19.445423095600006,18.733891115275000,...
    18.326882750520000];
fF3N4 = fit(UC2',C11_F3N4','exp2');

% F3N5
C11_F3N5 = [32.064025581324685,24.035107152184594,21.288303739637870,...
    19.899652870674400,18.526274103590770,17.872903909899200,...
    17.512036393670560];

fF3N5 = fit(UC2',C11_F3N5','exp2');

%-% Plot functions
figure(1);
subplot(3,2,1)
plot(fARROW,UC2,C11_ARROW)
title('Design 1')

subplot(3,2,2)
plot(fCase_1,UC2,C11_Case1)
title('Design 2')

subplot(3,2,3)
plot(fWalkman,UC2,C11_Walkman)
title('Design 3')

subplot(3,2,4)
plot(fF3N2,UC2,C11_F3N2)
title('Design 4')

subplot(3,2,5)
plot(fF3N4,UC2,C11_F3N4)
title('Design 5')

subplot(3,2,6)
plot(fF3N5,UC2,C11_F3N5)
title('Design 6')

figure(2);
plot(fARROW,'b')
hold on
plot(fCase_1,'r')
plot(fWalkman,'g')
plot(fF3N2,'k')
plot(fF3N4,'m')
plot(fF3N5,'c')
title('All Fits')
legend('Design 1','Design 2','Design 3','Design 4','Design 5','Design 6')
%axis([0 110 0 65])
hold off

%% Plotting C44 Convergence
%-% Initialization
clc;   
close all; 
clear;

%-% Input values
UC2 = ([1,2,3,4,6,8,10].^2);

% Arrow
C44_ARROW = [1.344271723500000,0.854520958200000,0.719782993100000,...
    0.650593885000000,0.564427823166667,0.506403850125000,...
    0.465244061700000];
fARROW = fit(UC2',C44_ARROW','exp2');

% Case 1
C44_Case1 = [5.549865946000001,4.401413408000001,3.684775822000001,...
    3.178882813500001,2.515229818333334,2.098840284250000,...
    1.811950048600000];
fCase_1 = fit(UC2',C44_Case1','exp2');

% Walkman
C44_Walkman = [4.549736154000001,2.310036450500001,1.657633609000000,...
    1.340486077250000,1.019894246500000,0.853474884125000,...
    0.751492972600000];

fWalkman = fit(UC2',C44_Walkman','exp2');

% F3N2
C44_F3N2 = [6.382308472000001e-04,0.002600809823000,0.006055130151667,...
    0.011159604690000,0.026235848070000,0.046580558625000,...
    0.069548458840000];
fF3N2 = fit(UC2',C44_F3N2','exp2');

% F3N4
C44_F3N4 = [4.492272238000000,2.962225244000000,2.429634285333334,...
    2.122248938750000,1.738887913166667,1.495816593375000,...
    1.325913255600000];
fF3N4 = fit(UC2',C44_F3N4','exp2');

% F3N5
C44_F3N5 = [1.344264605680600,1.074739425150000,0.871102116966667,...
    0.743606011500000,0.613826343500000,0.558665898875000,...
    0.534744205200000];

fF3N5 = fit(UC2',C44_F3N5','exp2');

%-% Plot functions
figure(1);
subplot(3,2,1)
plot(fARROW,UC2,C44_ARROW)
title('Design 1')

subplot(3,2,2)
plot(fCase_1,UC2,C44_Case1)
title('Design 2')

subplot(3,2,3)
plot(fWalkman,UC2,C44_Walkman)
title('Design 3')

subplot(3,2,4)
plot(fF3N2,UC2,C44_F3N2)
title('Design 4')

subplot(3,2,5)
plot(fF3N4,UC2,C44_F3N4)
title('Design 5')

subplot(3,2,6)
plot(fF3N5,UC2,C44_F3N5)
title('Design 6')

%{
figure(2);
plot(fARROW,'b')
hold on
plot(fCase_1,'r')
plot(fWalkman,'g')
plot(fF3N2,'k')
plot(fF3N4,'m')
plot(fF3N5,'c')
title('All Fits')
legend('Design 1','Design 2','Design 3','Design 4','Design 5','Design 6')
axis([0 110 0 65])
hold off
%}

%% Plotting C11 Convergence w/ UC, not UC^2
%-% Initialization
clc;   
close all; 
clear;

%-% Input values
UC = [1,2,3,4,6,8,10];

% Arrow
C11_ARROW = [50.066310583862350,29.025287792050320,24.031379549277176,...
    21.765456381234554,19.678959994448963,18.752461563362015,...
    18.280089298151800];
fARROW = fit(UC',C11_ARROW','exp2');

% Case 1
C11_Case1 = [58.186008778000010,50.339044958000010,47.724622964666670,...
    46.418792213000000,45.116933942000010,44.471473520499990,...
    44.089978850800000];
fCase_1 = fit(UC',C11_Case1','exp2');

% Walkman
C11_Walkman = [40.885896290000005,20.664679447180000,14.053795524200000,...
    10.847166158005003,7.699349931316668,6.150863541970001,...
    5.241061629198200];

fWalkman = fit(UC',C11_Walkman','exp2');

% F3N2
C11_F3N2 = [49.137159600000004,40.609054882000000,37.528584076000010,...
    35.945377717500000,34.373789556333330,33.619388485750000,...
    33.192448694400000];
fF3N2 = fit(UC',C11_F3N2','exp2');

% F3N4
C11_F3N4 = [34.624773132000000,25.412588289000002,22.400099130000005,...
    20.911589845000000,19.445423095600006,18.733891115275000,...
    18.326882750520000];
fF3N4 = fit(UC',C11_F3N4','exp2');

% F3N5
C11_F3N5 = [32.064025581324685,24.035107152184594,21.288303739637870,...
    19.899652870674400,18.526274103590770,17.872903909899200,...
    17.512036393670560];

fF3N5 = fit(UC',C11_F3N5','exp2');

%-% Plot functions
figure(1);
subplot(3,2,1)
plot(fARROW,UC,C11_ARROW)
title('Design 1')

subplot(3,2,2)
plot(fCase_1,UC,C11_Case1)
title('Design 2')

subplot(3,2,3)
plot(fWalkman,UC,C11_Walkman)
title('Design 3')

subplot(3,2,4)
plot(fF3N2,UC,C11_F3N2)
title('Design 4')

subplot(3,2,5)
plot(fF3N4,UC,C11_F3N4)
title('Design 5')

subplot(3,2,6)
plot(fF3N5,UC,C11_F3N5)
title('Design 6')

%% Plotting C44 Convergence w/ UC, not UC^2
%-% Initialization
clc;   
close all; 
clear;

%-% Input values
UC = [1,2,3,4,6,8,10];

% Arrow
C44_ARROW = [1.344271723500000,0.854520958200000,0.719782993100000,...
    0.650593885000000,0.564427823166667,0.506403850125000,...
    0.465244061700000];
fARROW = fit(UC',C44_ARROW','exp2');

% Case 1
C44_Case1 = [5.549865946000001,4.401413408000001,3.684775822000001,...
    3.178882813500001,2.515229818333334,2.098840284250000,...
    1.811950048600000];
fCase_1 = fit(UC',C44_Case1','exp2');

% Walkman
C44_Walkman = [4.549736154000001,2.310036450500001,1.657633609000000,...
    1.340486077250000,1.019894246500000,0.853474884125000,...
    0.751492972600000];

fWalkman = fit(UC',C44_Walkman','exp2');

% F3N2
C44_F3N2 = [6.382308472000001e-04,0.002600809823000,0.006055130151667,...
    0.011159604690000,0.026235848070000,0.046580558625000,...
    0.069548458840000];
fF3N2 = fit(UC',C44_F3N2','exp2');

% F3N4
C44_F3N4 = [4.492272238000000,2.962225244000000,2.429634285333334,...
    2.122248938750000,1.738887913166667,1.495816593375000,...
    1.325913255600000];
fF3N4 = fit(UC',C44_F3N4','exp2');

% F3N5
C44_F3N5 = [1.344264605680600,1.074739425150000,0.871102116966667,...
    0.743606011500000,0.613826343500000,0.558665898875000,...
    0.534744205200000];

fF3N5 = fit(UC',C44_F3N5','exp2');

%-% Plot functions
figure(1);
subplot(3,2,1)
plot(fARROW,UC,C44_ARROW)
title('Design 1')

subplot(3,2,2)
plot(fCase_1,UC,C44_Case1)
title('Design 2')

subplot(3,2,3)
plot(fWalkman,UC,C44_Walkman)
title('Design 3')

subplot(3,2,4)
plot(fF3N2,UC,C44_F3N2)
title('Design 4')

subplot(3,2,5)
plot(fF3N4,UC,C44_F3N4)
title('Design 5')

subplot(3,2,6)
plot(fF3N5,UC,C44_F3N5)
title('Design 6')


