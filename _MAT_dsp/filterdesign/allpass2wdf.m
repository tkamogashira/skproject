function w = allpass2wdf(a)
%ALLPASS2WDF Allpass to Wave Digital Filter coefficient transformation
% w = ALLPASS2WDF(a) where a is a vector of real allpass filter 
% coefficients, returns the Wave Digital Filter version w of the 
% coefficients a. w can be used with allpass filter objects (e.g. 
% dsp.AllpassFilter, dsp.CoupledAllpassFilter) with Structure set to 'Wave 
% Digital Filter'.
% a can only have length equal to 1, 2 and 4. When the length is 4, the 
% first and third components must both be zero.
% a can be a row or column vector while w is always returned as a row
% vector.
% 
% W = ALLPASS2WDF(A) where A is a vector cell array of allpass coefficient 
% vectors, returns the transformed multi-section coefficients in cell array
% W. Each cell of W holds the transformed version of the coefficients in 
% the corresponding cell of A. 
% Every cell of A must contain a real vector of length 1,2 or 4. When the 
% length is 4, the first and third components must both be zero.
% A can be a row or column vector of cells while W is always returned as
% column.
% 
% EXAMPLE
%   a = [0 0.5];    % Original 2nd order allpass coefficients
%   smm = dsp.AllpassFilter('AllpassCoefficients', a);
%   w = allpass2wdf(a); % Convert coefficients to Wave Digital Filter form
%   swdf = dsp.AllpassFilter('Structure', 'Wave Digital Filter',...
%       'WDFCoefficients', w);
%   in = randn(512, 1);
%   out_mm = step(smm, in);
%   out_wdf = step(swdf, in);
%   max(out_mm-out_wdf);  % Compare numerical difference of filter outputs
% 
% See also WDF2ALLPASS, TF2CA, DSP.ALLPASSFILTER, DSP.COUPLEDALLPASSFILTER.
 
% Reference: 
%   M. Lutovac, D. Tosic, B. Evans, Filter Design for Signal Processing 
%   using MATLAB and Mathematica. Prentice Hall, 2001.
%
%   Copyright 2013 The MathWorks, Inc.

try
    % Validate input coefficients using same method as of dsp.AllpassFilter
    % with structure option 1 (= 'Minimum multiplier'), corresponding to
    % the representation of the coefficients provided as input
    A = dsp.AllpassFilter.validateUserCoefficients(a, 1);
    
    % A is a cell array
    % assert(iscell(A))
    
    % Convert cell array of coefficients
    W = convertCoefficientsCellArray(A);

catch ME
    throw(ME)
end

if(isscalar(W) && isnumeric(a))
    % If single section, and input numeric simply return numerical array 
    % of coefficients
    w = W{1};
else
    % Else return cell array of cascaded sections
    w = W;
end

end % allpass2wdf

function W = convertCoefficientsCellArray(A)
% Convert cell array of coefficients

W = cell(size(A));

% Convert each section independently
for ks = 1:length(A)
    W{ks} = convertSection(A{ks});
end

end % convertCoefficientsCellArray

function ws = convertSection(as)
% Convert individual numeric section

if(~isempty(as))
    % assert(isrow(as))
    ws = dsp.AllpassFilter.poly2wdf(as);
else
    ws = [];
end

end % convertSection