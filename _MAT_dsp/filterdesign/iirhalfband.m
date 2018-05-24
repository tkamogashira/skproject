function [outVal,mStruct] = iirhalfband(N,varargin)
%IIRHALFBAND Halfband IIR filter design.
% Signatures:
% g = iirhalfband(n,fp);
% g = iirhalfband(n,dev,'dev');
% g = iirhalfband('minorder',fp,dev);
% g = iirhalfband(...,'high');
% g = iirhalfband(...,designmethod);
% g = iirhalfband(...,filterstructure);
% [g,mStruct] = iirhalfband(n,...);
%
% Inputs:
%  Required:
%   N - Filter order
%   fp - determines the passband edge frequency, and it must satisfy 0 < fp < 1/2, 
%        where 1/2 corresponds to pi/2 rad/sample.
%
%  Optional:
%   dev - sets the value for the maximum passband and stopband ripple allowed.
%         default: 0.0001
%   'high' - returns a high pass filter.
%   designmethod - {'butter','ellip','iirlinphase'}
%   filterstructure - {'cascadeallpass','cascadewdfallpass','iirdecim',
%                                      'iirwdfdecim','iirinterp','iirwdfinterp'}
%                      default: 'cascadeallpass'
%
% Outputs:
%    g - A structure containing the filter coefficients
%    mStruct - A structure containing the output of MEASURE on the designed
%              filter.
%
% EXAMPLE 1: A minimum order IIR halfband filter design using fdesign.halfband and IIRHALFBAND
%    f = fdesign.halfband('tw,ast',0.2,80,'type','highpass');
%    h = design(f,'ellip','FilterStructure','cascadewdfallpass');
%    g = iirhalfband('minorder',0.4,0.0001,'high','ellip','cascadewdfallpass');
%
% EXAMPLE 2: A high pass IIR halfband filter design using fdesign.halfband and IIRHALFBAND
%    n = 32; tw = 0.2; fp = 0.5 - tw/2;
%    f = fdesign.halfband('n,tw',n,tw,'type','highpass');
%    h = design(f,'iirlinphase','FilterStructure','cascadewdfallpass');
%    [g,ms] = iirhalfband(n,fp,'cascadewdfallpass','high','iirlinphase');

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

if(nargin < 1),
    error(message('MATLAB:nargchk:notEnoughInputs'));
end

[flags,newVarargin] = parseInputs(varargin);


switch 1+length(newVarargin),
    case 1
        specString = 'n';
        if(isvalidscalar(N)),
            fdesignInputs = {specString,N};
        else
            error('MATLAB:IIRHALFBAND:Filterr1','The first argument ''N'' is not a valid scalar');
        end
    case 2
        specString = 'n,tw';
        fp = newVarargin{1};
        if(isvalidscalar(N) && isvalidscalar(fp)),
            tw = 1-2*fp;
            fdesignInputs = {specString,N,tw};
        else
            error('MATLAB:IIRHALFBAND:Filterr2','One or both of the arguments ''N,fp'' are not valid scalars');
        end
    case 3
        if ~strncmpi(N,'minorder',length(N)),
            dev = newVarargin{1};
            ast = -20*log10(dev);
            specString = 'n,ast';
            fdesignInputs = {specString,N,ast};
        else
            fp = newVarargin{1};
            dev = newVarargin{2};
            tw = 1-2*fp;
            ast = -20*log10(dev);
            specString = 'tw,ast';
            fdesignInputs = {specString,tw,ast};
        end
    otherwise
        error(message('MATLAB:TooManyInputs'));
end

if(flags.highpass),
    fdesignInputs{end+1} = 'type';
    fdesignInputs{end+1} = 'highpass';
end
designInputs = getDesignInputs(flags,specString);

f = fdesign.halfband(fdesignInputs{:});
h = design(f,designInputs{:});

% converting the output object to a structure
g = filt2struct(h);
outVal = shortenFieldNames(g);

% Second output: Output of 'measure' converted to a structure
if(nargout > 1),
    m = measure(h);
    %mStruct.Fs = m.Fs;
    mStruct.Fstop = m.Fstop;
    mStruct.F6dB = m.F6dB;
    mStruct.F3dB = m.F3dB;
    mStruct.Fp = m.Fp;
    mStruct.Astop = m.Astop;
    mStruct.Apass = m.Apass;
    mStruct.TransitionWidth = m.TransitionWidth;
end    
        
end

function bol = isvalidscalar(a)
bol = true;

if length(a) > 1 || ~isnumeric(a) || isempty(a) || isnan(a) || isinf(a),
    bol = false;
end
end

function [flags,newVarargin] = parseInputs(inVarargin)

% Generate defaults
flags.highpass = 0;
flags.designmethod = 0;
flags.filterstruct = 0;

filtStructOpts = {'cascadeallpass','cascadewdfallpass','iirdecim','iirwdfdecim','iirinterp','iirwdfinterp'};
designMethodOpts = {'butter','ellip','iirlinphase'};

for ii = 1:3,
    if(isempty(inVarargin))
        break;
    end
    % Check for a filter structure option
    indx = find(strncmpi(inVarargin{end},filtStructOpts,length(inVarargin{end})));
    if(~isempty(indx))
        flags.filterstruct = indx(1);
        inVarargin = inVarargin(1:end-1);
        continue;
    end
    % Check for a design method
    indx = find(strncmpi(inVarargin{end},designMethodOpts,length(inVarargin{end})));
    if(~isempty(indx))
        flags.designmethod = indx(1);
        inVarargin = inVarargin(1:end-1);
        continue;
    end
    % Check for high pass
    indx = strncmpi(inVarargin{end},'high',length(inVarargin{end}));
    if(indx),
        flags.highpass = 1;
        inVarargin = inVarargin(1:end-1);
        continue;
    end
    
end
newVarargin = inVarargin;
end

function designInputs = getDesignInputs(flags,specString)
filtStructOpts = {'cascadeallpass','cascadewdfallpass','iirdecim','iirwdfdecim','iirinterp','iirwdfinterp'};
designMethodOpts = {'butter','ellip','iirlinphase'};
designInputs = {};
if(flags.designmethod),
    designInputs{end+1} = designMethodOpts{flags.designmethod};
else
    if(strcmp(specString,'n,tw') || strcmp(specString,'n,ast'))
        designInputs{end+1} = 'ellip';
    elseif(strcmp(specString,'n') || strcmp(specString,'tw,ast'))
        designInputs{end+1} = 'butter';
    end
end
        
if(flags.filterstruct),
    designInputs{end+1} = 'FilterStructure';
    designInputs{end+1} = filtStructOpts{flags.filterstruct};
end
end

function gNew = shortenFieldNames(g)
% Removes any 'class' fields and shortens any 'AllpassCoefficients' to
% 'AllpassCoeffs' and shorten 'Section' to 'Sec1'
fieldNames = fields(g);
gNew = g;
for ii = 1:length(fieldNames),
    if(strcmp(fieldNames{ii},'class'))
        gNew = rmfield(gNew,'class');
    elseif(strcmp(fieldNames{ii},'AllpassCoefficients'))
        gNew.AllpassCoeffs = gNew.AllpassCoefficients;
        gNew = rmfield(gNew,'AllpassCoefficients');
        fieldNames{ii} = 'AllpassCoeffs';
    elseif(strncmpi('Sect',fieldNames{ii},4))
        gNew.(['Sec' fieldNames{ii}(end)]) = gNew.(fieldNames{ii});
        gNew = rmfield(gNew,fieldNames{ii});
    end
    if((strncmpi('Stage',fieldNames{ii},5) || strncmpi('Allpass',fieldNames{ii},7)) && isstruct(gNew.(fieldNames{ii})))
        
        gNew.(fieldNames{ii}) = shortenFieldNames(gNew.(fieldNames{ii}));
    end
end
end