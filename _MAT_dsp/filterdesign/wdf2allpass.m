function a = wdf2allpass(w)
%WDF2ALLPASS Wave Digital Filter to Allpass coefficient transformation
% A = WDF2ALLPASS(W) where W is a vector of real allpass Wave Digital 
% Filter coefficients, returns the allpass polynomial version A of the 
% coefficients W. A can be used with allpass filter objects (e.g. 
% dsp.AllpassFilter, dsp.CoupledAllpassFilter) with Structure set to 
% 'Minimum multiplier'.
% All elements of W must have absolute value smaller or equal to one and W
% must have length equal to 1, 2 and 4. When the length is 4, the 
% second and fourth components must both be zero.
% W can be a row or column vector while A is always returned as a row
% vector
% 
% A = WDF2ALLPASS(W) where W is a vector cell array of allpass Wave Digital 
% Filter coefficient vectors, returns the transformed multi-section 
% allpass coefficients in cell array A. Each cell of A holds the 
% transformed version of the coefficients in the corresponding cell of W. 
% Every cell of W must contain a real vector of length 1,2 or 4 with all 
% elements having absolute value smaller or equal to one. When the 
% length is 4, the second and fourth components must both be zero.
% W can be a row or column vector of cells while A is always returned as
% column.
% 
% EXAMPLE
%   w = [0.5 0];    % 2nd order allpass Wave Digital Filter coefficients
%   swdf = dsp.AllpassFilter('Structure', 'Wave Digital Filter',...
%       'WDFCoefficients', w);
%   a = wdf2allpass(w); % Convert coefficients to allpass polynomial form
%   smm = dsp.AllpassFilter('AllpassCoefficients', a);
%   in = randn(512, 1);
%   out_wdf = step(swdf, in);
%   out_mm = step(smm, in);
%   max(out_wdf-out_mm);  % Compare numerical difference of filter outputs
% 
% See also ALLPASS2WDF, TF2CA, DSP.ALLPASSFILTER, DSP.COUPLEDALLPASSFILTER.
 
% Reference: 
%   M. Lutovac, D. Tosic, B. Evans, Filter Design for Signal Processing 
%   using MATLAB and Mathematica. Prentice Hall, 2001.
%
%   Copyright 2013 The MathWorks, Inc.

try
    % Validate input coefficients using same method as of dsp.AllpassFilter
    % with structure option 2 (= 'Wave Digital Filter'), corresponding to the 
    % representation of the coefficients provided as input
    W = dsp.AllpassFilter.validateUserCoefficients(w, 2);

    % W is a cell array
    % assert(iscell(W))
    
    % Convert cell array of coefficients
    A = convertCoefficientsCellArray(W);

catch ME
    throw(ME)
end

if(isscalar(A) && isnumeric(w))
    % If single section, and input numeric simply return numerical array 
    % of coefficients
    a = A{1};
else
    % Else return cell array of cascaded sections
    a = A;
end

end % wdf2allpass

function A = convertCoefficientsCellArray(W)
% Convert cell array of coefficients

A = cell(size(W));

% Convert each section independently
for ks = 1:length(W)
    A{ks} = convertSection(W{ks});
end

end % convertCoefficientsCellArray

function as = convertSection(ws)

if(~isempty(ws))
    % assert(isrow(ws))
    as = dsp.AllpassFilter.wdf2poly(ws);
else
    as = [];
end

end % convertSection