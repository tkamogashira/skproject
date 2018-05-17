function b2 = PZFC_b2(B2, B21, Pp, n2);
% compute the power-dependent pole position coeff b2 for the PZFC filter
% (same as OZGF_b2 until/unless we change it)

% try for 1.0 input-output slope approx when B21 is about like B2:
b2 = B2 * 10^((B21/(B2*n2)) * (Pp - 60)/20);  % arbitrary 60 dB ref point

% limit to a ridiculously small value:
if b2 <= 0.2
  b2 = 0.2;
end
