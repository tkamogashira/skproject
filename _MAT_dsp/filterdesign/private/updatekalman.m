function S = updatekalman(x,e,S)
% Execute one iteration of the random walk Kalman adaptive filter.

%   Author(s): A. Ramasubramanian
%   Copyright 1999-2002 The MathWorks, Inc.

uvec = [x ; S.states(:)].';                    
S.gain = S.errcov * uvec.' ./ (uvec * S.errcov * uvec.' + S.measvar); 
S.coeffs = S.coeffs + S.gain.'* e;   
S.errcov   = S.errcov + S.procov - S.gain * uvec * S.errcov;

