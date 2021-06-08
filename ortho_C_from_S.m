syms G23 G31 G12
S_b = [1/G23,0,0;0,1/G31,0;0,0,1/G12];
C_b = inv(S_b);

syms E1 E2 E3 v21 v31 v12 v32 v13 v23
S_a = [1/E1,-v21/E2,-v31/E3;
       -v12/E1,1/E2,-v32/E3;
       -v13/E1,-v23/E2,1/E3];
C_a = inv(S_a);



    