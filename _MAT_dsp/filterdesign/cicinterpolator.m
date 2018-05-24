function outVal = cicinterpolator(If,dd,fp,ast)
%CICINTERPOLATOR CIC interpolator design
% Signatures:
% g = cicinterpolator(If,dd);
% g = cicinterpolator(If,dd,fp);
% g = cicinterpolator(If,dd,fp,ast)
%   
% Inputs:
%  Required:
%   If - Interpolation factor
%   dd - differential delay
%  Optional:
%   fp - frequency at the start of the pass band. Specified in normalized frequency units. 
%        default: 0.05
%   ast - attenuation in the stop band in decibels
%         default: 60
%
% Outputs:
%   g - Number of sections
%
% EXAMPLE: CIC interpolator design using fdesign.interpolator and CICINTERPOLATOR
%    fp = 0.1; If = 3; dd = 1;
%    f = fdesign.interpolator(If,'cic',dd,fp);
%    h = design(f);
%    g = cicinterpolator(If,dd,fp);

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

%Default values
if(exist('fp','var')&&isempty(fp))
  fp = 0.05;
end
if(exist('ast','var')&&isempty(ast))
  ast = 60;
end

switch nargin
    case 0
        error(message('MATLAB:nargchk:notEnoughInputs'));
    case 1
        error('MATLAB:dsp:cicinterpolator:noDiffDelay','Differential delay must be provided as the second input');
    case 2
        fdesignInputs = {If,'cic',dd};
    case 3
        fdesignInputs = {If,'cic',dd,fp};
    case 4
        fdesignInputs = {If,'cic',dd,fp,ast};
    otherwise
        error(message('MATLAB:TooManyInputs'));
end

f = fdesign.interpolator(fdesignInputs{:});
h = design(f);
g = filt2struct(h);

outVal = g.NumberOfSections;

end

