function [outVal,mStructOut] = peqmin(F0,BW,G0,varargin)
% PEQMIN : Minimum order Parametric equalizer filter design
% Signatures:
% g = peqmin(F0,BW,G0)
% g = peqmin(F0,BW,G0,BWbands)
% g = peqmin(F0,BW,G0,BWbands,Gref)
% g = peqmin(F0,BW,G0,BWbands,Gref,GBW)
% g = peqmin(F0,BW,G0,BWbands,Gref,GBW,Gbands)
% g = peqmin(...,designmethod)
% g = peqmin(...,opts)
% g = peqmin(...,designmethod,opts)
% [g,mStruct] = peqmin(F0,BW,G0,...)
%
% Inputs:
%
%  Required:
%   F0 - Center Frequency
%   BW - Bandwidth
%   G0 -  Center Frequency Gain (decibels)
%
%  Optional:
%   Note: For boost: G0 > Gp > GBW > Gst > Gref; For cut: G0 < Gp < GBW < Gst < Gref
%   BWbands -  Bandwidth, BWp (Passband) OR BWst (Stopband), BWst > BW > BWp, 
%              default: Bwp = 0.2, BWst = 0.4 
%   Gref -  Reference Gain (decibels)
%           default: -10
%   GBW -   Gain at which Bandwidth (BW) is measured (decibels)
%           default: -3.0103
%   Gbands - Gain (decibels), Gp (Passband) or Gst (Stopband) or both [Gp,Gst]
%            default: Gp = -1, Gst = -9
%   designmethod - {'default','butter','cheby1','cheby2','ellip'}
%   opts - A structure containing SOSscaling options, 
%          default: opts = sosReorder: 'auto'
%                          MaxNumerator: 2
%                          NumeratorConstraint: 'none'
%                          OverflowMode: 'wrap'
%                          ScaleValueConstraint: 'unit'
%                          MaxScaleValue: 'Not used'
% Outputs:
%    g - A structure containing 'SOSMatrix' and 'ScaleValues' as fields.
%    mStruct - A structure containing the output of MEASURE on the designed
%    filter.
%  
% EXAMPLE 1: A Parameter equilization filter design using fdesign.parameq and PEQMIN
%    f = fdesign.parameq('F0,BW,BWp,Gref,G0,GBW,Gp',0.5,0.4,0.2,0,6,6+10*log10(.5),5.5);
%    h = design(f);
%    g = peqmin(0.5,0.4,6,0.2,0,6+10*log10(.5),5.5);
%
% EXAMPLE 2:
%    f = fdesign.parameq('F0,BW,BWp,Gref,G0,GBW,Gp,Gst',0.5,0.4,0.35,0,6,3,5.5,2);
%    h = design(f,'ellip');
%    [g,ms] = peqmin(0.5,0.4,6,0.35,0,3,[5.5,2],'ellip');

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

if(nargin < 3),
    error(message('MATLAB:nargchk:notEnoughInputs'));
elseif(nargin > 9),
    error(message('MATLAB:TooManyInputs'));
end

[BWbands,Gref,GBW,Gbands,designmethod,opts] = parseInputs(varargin);

% Determining a specification string from the given inputs
specString = 'F0,BW,BWp,Gref,G0,GBW,Gp'; % Default spec string
if(exist('BWbands','var') && ~isempty(BWbands))
    if(BWbands > BW)
        % BWst = BWbands;
        specString = 'F0,BW,BWst,Gref,G0,GBW,Gst'; % Next default spec string
    else
        % BWp = BWbands;
        if(exist('Gbands','var')&&length(Gbands)>1)
            specString = 'F0,BW,BWp,Gref,G0,GBW,Gp,Gst';
        end
    end
end
% The cell array 'designInputs' contains the inputs to the 'design' function           
designInputs = {}; % is empty by default.

if(length(Gbands)>1),
    fdesignInputs = {specString,F0,BW,BWbands,Gref,G0,GBW,Gbands(1),Gbands(2)};
else
    fdesignInputs = {specString,F0,BW,BWbands,Gref,G0,GBW,Gbands};
end

if(exist('designmethod','var') && ~isempty(designmethod))
    designInputs = {designmethod};
else
    designmethod = 'default';
end

if(exist('opts','var') && ~isempty(opts))
    fopts = fdopts.sosscaling;
    fopts.sosReorder = opts.sosReorder;
    fopts.MaxNumerator = opts.MaxNumerator;
    fopts.NumeratorConstraint = opts.NumeratorConstraint;
    fopts.OverflowMode = opts.OverflowMode;
    fopts.ScaleValueConstraint = opts.ScaleValueConstraint;
    fopts.MaxScaleValue = opts.MaxScaleValue;
    designInputs = {designmethod,'SOSScaleOpts',fopts};
end


% Removing any trailing empties from fdesignInputs 
fdesignInputs = removeTrailingEmpties(fdesignInputs);

% Designing the filter
f = fdesign.parameq(fdesignInputs{:});
f.G0 = G0; % Making sure G0 is always passed to 'f'
% since G0 is a required input - it should not be removed by removeTrailingEmpties, but it will be in some cases.
h = design(f,designInputs{:});

% converting the output object to a structure
g = filt2struct(h);
outVal = rmfield(g,'class'); % Removing the reference to the class of the design output 'h'

% Second output: Output of 'measure' converted to a structure
if(nargout > 1),
    m = measure(h);
    %mStruct.Fs = m.Fs;
    mStruct.F0 = m.F0;
    mStruct.BW = m.BW;
    mStruct.BWp = m.BWp;
    mStruct.BWst = m.BWst;
    mStruct.Flow = m.Flow;
    mStruct.Fhigh = m.Fhigh;
    mStruct.GBW = m.GBW;
    mStruct.LowTransitionWidth = m.LowTransitionWidth;
    mStruct.HighTransitionWidth = m.HighTransitionWidth;
    mStruct.Gref = m.Gref;
    mStruct.G0 = m.G0;
    mStruct.Gp = m.Gp;
    mStruct.Gst = m.Gst;
    mStructOut = removeEmptyFields(mStruct);
end



end

function outCell = removeTrailingEmpties(inCell)
outCell = inCell;
nCells = length(inCell);
emptyStartIndex = nCells + 1;
for ii = 1:nCells,
    if(isempty(inCell{ii}))
        emptyStartIndex = ii;
        break;
    end
end
if(emptyStartIndex <= nCells)
    outCell(emptyStartIndex:end) = []; %removing the empties
end
end

function [BWbands,Gref,GBW,Gbands,designmethod,opts] = parseInputs(inVarargin)

[BWbands,Gref,GBW,Gbands,designmethod,opts] = deal([],[],[],[],[],[]);
designMethodOpts = {'default','butter','cheby1','cheby2','ellip'};

for ii = 1:2,
    if(isempty(inVarargin))
        break;
    end
    % Check for a opts structure
    if(isstruct(inVarargin{end}))
        opts = inVarargin{end};
        inVarargin = inVarargin(1:end-1);
        continue;
    end
    % Check for a design method
    indx = find(strncmpi(inVarargin{end},designMethodOpts,length(inVarargin{end})));
    if(~isempty(indx))
        designmethod = designMethodOpts{indx(1)};
        inVarargin = inVarargin(1:end-1);
        continue;
    end
      
end
newVarargin = inVarargin;
% fill the missing inputs in newVarargin with empties
for ii = 1:(4-length(inVarargin)),
    newVarargin{end+1} = [];
end
[BWbands,Gref,GBW,Gbands] = deal(newVarargin{1:4});
end

function mStructOut = removeEmptyFields(mStruct)
fieldcell = fields(mStruct);
for ii = 1:length(fieldcell),
    if(~isempty(mStruct.(fieldcell{ii})))
        mStructOut.(fieldcell{ii}) = mStruct.(fieldcell{ii});
    end
end

end