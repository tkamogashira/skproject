function [outVal,mStructOut] = peqQ(N,F0,Fc,G0,Q,opts)
% PEQQ : Parametric equalizer filter design based on Quality Factor
% Signatures:
% g = peqQ(N,F0,Fc,G0,Q);
% g = peqQ(N,F0,Fc,G0,Q,opts);
% [g,mStruct] = peqQ(N,F0,Fc,G0,Q,...);
%
% Inputs:
%
%  Required:
%   N - Filter Order
%   F0 - Center Frequency
%   Fc - Cutoff frequency.
%   G0 -  Center Frequency Gain (decibels)
%   Q - Quality Factor
%
%  Optional:
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
% EXAMPLE: A Parameter equilization filter design using fdesign.parameq (with quality factor input) and PEQQ
%    f = fdesign.parameq('N,F0,Fc,Qa,G0',10,0,0.25,5,10);
%    h = design(f);
%    g = peqQ(10,0,0.25,10,5);

%   Author(s): Praveen Yenduri
%   Copyright 2013 The MathWorks, Inc.

specString = 'N,F0,Fc,Qa,G0'; % Default spec string
         
designInputs = {}; % is empty by default.

switch nargin
    case {0,1,2,3,4}
        error(message('MATLAB:nargchk:notEnoughInputs'));
    case 5
        fdesignInputs = {specString,N,F0,Fc,Q,G0};
    case 6
        fdesignInputs = {specString,N,F0,Fc,Q,G0};
                       
        if(~isempty(opts))
            fopts = fdopts.sosscaling;
            fopts.sosReorder = opts.sosReorder;
            fopts.MaxNumerator = opts.MaxNumerator;
            fopts.NumeratorConstraint = opts.NumeratorConstraint;
            fopts.OverflowMode = opts.OverflowMode;
            fopts.ScaleValueConstraint = opts.ScaleValueConstraint;
            fopts.MaxScaleValue = opts.MaxScaleValue;
            designInputs = {'SOSScaleOpts',fopts};
        end
    otherwise
        error(message('MATLAB:TooManyInputs'));
end

% Removing any trailing empties from fdesignInputs 
fdesignInputs = removeTrailingEmpties(fdesignInputs);

% Designing the filter
f = fdesign.parameq(fdesignInputs{:});
f.G0 = G0; % Making sure G0 is always passed to 'f'
f.Qa = Q; % Making sure Qa is always passed to 'f'
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

function mStructOut = removeEmptyFields(mStruct)
fieldcell = fields(mStruct);
for ii = 1:length(fieldcell),
    if(~isempty(mStruct.(fieldcell{ii})))
        mStructOut.(fieldcell{ii}) = mStruct.(fieldcell{ii});
    end
end

end
