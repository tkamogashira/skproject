function [outVal,mStructOut] = peqflh(N,FLH,G0,varargin)
% PEQFLH : Parametric equalizer filter design with specification of filter
% order 'N' and Edge frequencies 'Flow' and 'Fhigh'
% Signatures:
% g = peqflh(N,FLH,G0)
% g = peqflh(N,FLH,G0,Gref)
% g = peqflh(N,FLH,G0,Gref,GBW)
% g = peqflh(N,FLH,G0,Gref,GBW,Gbands)
% g = peqflh(...,designmethod)
% g = peqflh(...,opts)
% g = peqflh(...,designmethod,opts)
% [g,mStruct] = peqflh(N,FLH,G0,...);
%
% Inputs:
%
%  Required:
%   N - Filter Order
%   FLH - [Flow Fhigh], Lower Frequency at Gain GBW and Higher Frequency at Gain GBW
%   G0 -  Center Frequency Gain (decibels)
%
%  Optional:
%   Gref -  Reference Gain (decibels)
%           default: -10
%   GBW -   Gain at which Bandwidth (BW) is measured (decibels)
%           default: -3.0103
%   Gbands - Gain (decibels), Gp (Passband) or Gst (Stopband) or both [Gp,Gst]
%            For boost: G0 > Gp > GBW > Gst > Gref; For cut: G0 < Gp < GBW < Gst < Gref
%            default: Gp = -1, Gst = -9
%   designmethod - {'default','butter','cheby1','checby2','ellip'}
%   opts - A structure containing SOSscaling options, 
%          default: opts = sosReorder: 'auto'
%                          MaxNumerator: 2
%                          NumeratorConstraint: 'none'
%                          OverflowMode: 'wrap'
%                          ScaleValueConstraint: 'unit'
%                          MaxScaleValue: 'Not used'
%
% Outputs:
%    g - A structure containing 'SOSMatrix' and 'ScaleValues' as fields.
%    mStruct - A structure containing the output of MEASURE on the designed
%    filter.
%  
% EXAMPLE 1: A Parameter equilization filter design using fdesign.parameq (with 'Flow' and 'Fhigh' inputs) and PEQFLH
%    f = fdesign.parameq('N,Flow,Fhigh,Gref,G0,GBW',2,0.4,0.6,0,6,3);
%    h = design(f);
%    g = peqflh(2,[0.4,0.6],6,0,3);
%
% EXAMPLE 2: 
%    f = fdesign.parameq('N,Flow,Fhigh,Gref,G0,GBW',2,0.4,0.6);
%    f.G0 = 5;
%    h = design(f);
%    [g,ms] = peqflh(2,[0.4,0.6],5,'default');

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

if(nargin < 3),
    error(message('MATLAB:nargchk:notEnoughInputs'));
elseif(nargin > 8),
    error(message('MATLAB:TooManyInputs'));
end

[Gref,GBW,Gbands,designmethod,opts] = parseInputs(varargin);

% Determining a specification string from the given inputs
specString = 'N,Flow,Fhigh,Gref,G0,GBW'; % Default spec string
         
designInputs = {}; % is empty by default.

if(length(Gbands)>1),
    specString = 'N,Flow,Fhigh,Gref,G0,GBW,Gp,Gst';
    fdesignInputs = {specString,N,FLH(1),FLH(2),Gref,G0,GBW,Gbands(1),Gbands(2)};
elseif(length(Gbands)==1),
    if(Gbands > Gref) %boost
        if(Gbands > GBW),
            specString = 'N,Flow,Fhigh,Gref,G0,GBW,Gp';
        else
            specString = 'N,Flow,Fhigh,Gref,G0,GBW,Gst';
        end
    else %cut
        if(Gbands < GBW),
            specString = 'N,Flow,Fhigh,Gref,G0,GBW,Gp';
        else
            specString = 'N,Flow,Fhigh,Gref,G0,GBW,Gst';
        end
    end
    fdesignInputs = {specString,N,FLH(1),FLH(2),Gref,G0,GBW,Gbands};
else
    fdesignInputs = {specString,N,FLH(1),FLH(2),Gref,G0,GBW};
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

function [Gref,GBW,Gbands,designmethod,opts] = parseInputs(inVarargin)

[Gref,GBW,Gbands,designmethod,opts] = deal([],[],[],[],[]);
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
for ii = 1:(3-length(inVarargin)),
    newVarargin{end+1} = [];
end
[Gref,GBW,Gbands] = deal(newVarargin{1:3});
end

function mStructOut = removeEmptyFields(mStruct)
fieldcell = fields(mStruct);
for ii = 1:length(fieldcell),
    if(~isempty(mStruct.(fieldcell{ii})))
        mStructOut.(fieldcell{ii}) = mStruct.(fieldcell{ii});
    end
end

end