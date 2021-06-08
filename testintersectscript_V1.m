%% Method 1 (DNW)
A = [1,1,1]; B = [4,4,4]; C = [1,1,4]; D = [4,4,1];
a = [(A(1)-B(1)),(D(1)-C(1));(A(2)-B(2)),(D(2)-C(2))];
b = [(D(1)-B(1)); (D(2)-B(2))];
x = a\b;
if ((x(1)>=0)&&(x(1)<=1)) && ((x(2)>=0)&&(x(2)<=1))
    if (((x(1))*(A(3)-B(3)))+((x(2))*(D(3)-C(3)))) == (D(3)-B(3))
        intersect = true;
    else
        intersect = false;
    end
else
    intersect = false;
end

%% Method 2 (works for lines, not line segments)
A = [0,0,0]; B = [0,0.5,0.5]; C = [0,0,0.5]; D = [0,0.5,1];
T1 = B-A;
M1 = cross(A,B);
T2 = D-C;
M2 = cross(C,D);
val = dot(T1,M2)+dot(T2,M1);
if val == 0
    intersect = true;
else
    intersect = false;
end

%% Method 3 (DNW)
A = [0,0,0]; B = [0,0.5,0.5]; C = [0,0,0.5]; D = [0,0.5,0];
a = [(B(1)-A(1)),(C(1)-D(1));(B(2)-A(2)),(C(2)-D(2))];
b = [(C(1)-A(1)); (C(2)-A(2))];
x = a\b;

%% Method 4 (Works so far...)
%A = [0,0,0]; B = [0.5,0.5,0.5]; C = [0,0,0.5]; D = [0.5,0.5,0];
%A = [0.5,0.5,0.5]; B = [0.5,0.5,1]; C = [0,0,1]; D = [1,1,0.5];
%A = [0,0,0]; B = [0,0,0.5]; C = [0,0.5,0.5]; D = [0,1,1];
%A = [0,0,0]; B = [0.5,0.5,0.5]; C = [0,0,0.5]; D = [0.5,0.5,0];
A = [0,0,0]; B = [1,1,1]; C = [0.5,0.5,0.5]; D = [1,1,0];

d_ACDC = ((A(1)-C(1))*(D(1)-C(1)))+((A(2)-C(2))*(D(2)-C(2)))+...
         ((A(3)-C(3))*(D(3)-C(3)));
d_DCBA = ((D(1)-C(1))*(B(1)-A(1)))+((D(2)-C(2))*(B(2)-A(2)))+...
         ((D(3)-C(3))*(B(3)-A(3)));
d_ACBA = ((A(1)-C(1))*(B(1)-A(1)))+((A(2)-C(2))*(B(2)-A(2)))+...
         ((A(3)-C(3))*(B(3)-A(3)));
d_DCDC = ((D(1)-C(1))*(D(1)-C(1)))+((D(2)-C(2))*(D(2)-C(2)))+...
         ((D(3)-C(3))*(D(3)-C(3)));
d_BABA = ((B(1)-A(1))*(B(1)-A(1)))+((B(2)-A(2))*(B(2)-A(2)))+...
         ((B(3)-A(3))*(B(3)-A(3)));

mua = ((d_ACDC*d_DCBA)-(d_ACBA*d_DCDC))/((d_BABA*d_DCDC)-(d_DCBA*d_DCBA));
mub = (d_ACDC+(mua*d_DCBA))/d_DCDC;
Pa = A + (mua.*(B-A));
Pb = C + (mub.*(D-C));
if (Pa == Pb)
    if (((Pa(1)>=A(1))&&(Pa(1)<=B(1)))||((Pa(1)>=B(1))&&(Pa(1)<=A(1)))) &&...
       (((Pa(2)>=A(2))&&(Pa(2)<=B(2)))||((Pa(2)>=B(2))&&(Pa(2)<=A(2)))) &&...
       (((Pa(3)>=A(3))&&(Pa(3)<=B(3)))||((Pa(3)>=B(3))&&(Pa(3)<=A(3)))) &&...
       (((Pb(1)>=C(1))&&(Pb(1)<=D(1)))||((Pb(1)>=D(1))&&(Pb(1)<=C(1)))) &&...
       (((Pb(2)>=C(2))&&(Pb(2)<=D(2)))||((Pb(2)>=D(2))&&(Pb(2)<=C(2)))) &&...
       (((Pb(3)>=C(3))&&(Pb(3)<=D(3)))||((Pb(3)>=D(3))&&(Pb(3)<=C(3)))) 
        if (Pa==A)
            intersect = false;
        elseif (Pa==B)
            intersect = false;
        elseif (Pb==C)
            intersect = false;
        elseif (Pb==D)
            intersect = false;
        else
            intersect = true;
        end
    else
        intersect = false;
    end
else
    intersect = false;
end


