function outVal = cicdecimator(df,dd,fp,ast)
%CICDECIMATOR CIC decimator design
% Signatures:
% g = cicdecimator(df,dd);
% g = cicdecimator(df,dd,fp);
% g = cicdecimator(df,dd,fp,ast)
%   
% Inputs:
%  Required:
%   df - decimation factor
%   dd - differential delay
%  Optional:
%   fp - frequency at the start of the pass band. Specified in normalized frequency units. 
%        default: 0.01
%   ast - attenuation in the stop band in decibels
%         default: 60
%   dd - differential delay
%   fp - frequency at the start of the pass band. Specified in normalized frequency units. 
%   ast - attenuation in the stop band in decibels
%
% Outputs:
%   g - Number of sections
%
% EXAMPLE: CIC decimator design using fdesign.decimator and CICDECIMATOR
%    fp = 0.1; df = 3; dd = 1;
%    f = fdesign.decimator(df,'cic',dd,fp);
%    h = design(f);
%    g = cicdecimator(df,dd,fp);

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

%Default values
if(exist('fp','var')&&isempty(fp))
  fp = 0.01;
end
if(exist('ast','var')&&isempty(ast))
  ast = 60;
end

switch nargin
    case 0
        error(message('MATLAB:nargchk:notEnoughInputs'));
    case 1
        error('MATLAB:dsp:cicdecimator:noDiffDelay','Differential delay must be provided as the second input');
    case 2
        fdesignInputs = {df,'cic',dd};
    case 3
        fdesignInputs = {df,'cic',dd,fp};
    case 4
        fdesignInputs = {df,'cic',dd,fp,ast};
    otherwise
        error(message('MATLAB:TooManyInputs'));
end

f = fdesign.decimator(fdesignInputs{:});
h = design(f);
g = filt2struct(h);

outVal = g.NumberOfSections;

end

