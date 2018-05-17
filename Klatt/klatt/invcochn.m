function f = invcochn(f, A, a, k, F)
%INVCOCHN Inverse normalized cochlear frequency

if length(F) == 1
    Fa = F;
    Fb = F;
else
    Fa = F(1);
    Fb = F(2);
end

Ah = 165.4;
ah = 0.06;
kh = 1;

c = grnwd(Fa, Ah, ah, kh) - grnwd(Fb, A, a, k);
x = grnwd(f, A, a, k) + c;
f = invgrnwd(x, Ah, ah, kh);
