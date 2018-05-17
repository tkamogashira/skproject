function [b1, B2, B21, c, n1, n2, frat, P0] = PZFC_Params(Fc, ValParam)
% function [b1, B2, B21, c, n1, n2, frat, Pref, P0] = OZGF_Params(Fc, ValParam)
%
% Make filter parameters from the ValParam
% inputs:
%  Fc is filter nominal center frequency
%  ValParam:  Nx3 array of fitting parameters
%   row 1 are constant, f and f^2 coeffs for first return value, etc.
% outputs:
%   the parameter scalars as listed; B21 is power coeff for B2 to make b2

if nargout < 7
  error('wrong number of args out, OZGF_Params')
end

% adjust any frequency-dependent parameters, on normalized ERBRate scale:
DpndF = Freq2ERB(Fc)/Freq2ERB(1000) - 1;       % corresponding to Ef

% compute all of: [b1; B2; B21; c; n1; n2; frat; Pref] 
params = ValParam * [1; DpndF; DpndF.^2]; 

b1   = params(1);
B2   = params(2);
B21  = params(3);
c    = params(4);
n1   = params(5);
n2   = params(6);
frat = params(7);
P0   = params(8);

% b1 = b1*B2;  % make b1 vary like B2 (w/o level dependent part)
