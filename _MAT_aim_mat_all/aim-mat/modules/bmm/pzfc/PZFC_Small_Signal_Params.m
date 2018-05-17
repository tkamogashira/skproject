function [b1, b2, c, n1, n2, frat] = PZFC_Small_Signal_Params(Fc, ValParam)
% function [b1, b2, c, n1, n2, frat] = PZFC_Small_Signal_Params(Fc, ValParam)
%
% get all the PZFC parameters, including b2 in the small-signal limit

[b1, B2, B21, c, n1, n2, frat, P0] = PZFC_Params(Fc, ValParam);

% The P0 is the noise floor that sets the small-signal limit of b2

b2 = PZFC_b2(B2, B21, P0, n2);

