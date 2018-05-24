function phase = set_phase(this, phase)
%SET_PHASE   PreSet function for the 'phase' property.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

% Make sure to clear metadata
clearmetadata(this);

% Construct a set of private dfilts to store as phases
privphase = constructdfilts(this,phase);
this.privphase = privphase;

% Store a second set of "upsampled dfilts" for analysis
storeupsampleddfilts(this,privphase);

% Always reset
reset(this);

% Don't duplicate storage 
phase = [];
%--------------------------------------------------------------------------
function privphase = constructdfilts(this,phase)

% Convert structure to cell
cellphase = struct2cell(phase);

% Get constructor of dfilt for given mfilt
constr = dfiltconstructor(this);
for k = 1:length(cellphase),
    phasecoeffs = struct2cell(cellphase{k});
    % Check for special cases, a delay for linear-phase or a scalar in the
    % case of a low order ellip design such as
    % f=fdesign.decimator(2,'halfband',.1,10)
    if length(phasecoeffs) == 1 && length(phasecoeffs{1}) == 1 && phasecoeffs{1} == 1,
        % Scalar passed in, low order ellip design such as f=fdesign.decimator(2,'halfband',.1,10)
        privphase(k) = dfilt.scalar;
    elseif length(phasecoeffs) == 1 && length(find(phasecoeffs{1}==1))==1 && length(find(phasecoeffs{1}==0)) == length(phasecoeffs{1})-1,
        % Delay
        privphase(k) = dfilt.delay(find(phasecoeffs{1}==1)-1);
    else
        privphase(k) = feval(constr,phasecoeffs{:});
    end
end

%--------------------------------------------------------------------------
function storeupsampleddfilts(this,phase)
% Get rcf from new phase
rcf = length(phase);

% For each phase, create  cascade of equivalent dfilts and store them
for k = 1:rcf,
    if strcmpi(class(phase(k)),'dfilt.delay'),
        % First branch of quasilinear phase designs
        dfiltphase(k) = dfilt.delay(rcf*phase(k).latency);
    elseif strcmpi(class(phase(k)),'dfilt.scalar'),
        % low order ellip such as f=fdesign.decimator(2,'halfband',.1,10)
        dfiltphase(k) = dfilt.delay(k-1);
    else
        hc = copy(phase(k));
        allpasscoeffs = hc.AllpassCoefficients;
        fn = fieldnames(allpasscoeffs);
        for m = 1:length(fn),
             newcoeffs = upsample(getfield(allpasscoeffs,fn{m}),rcf,rcf-1);
             allpasscoeffs = setfield(allpasscoeffs,fn{m},newcoeffs(:).');
        end
        hc.AllpassCoefficients = allpasscoeffs;
        dfiltphase(k) = cascade(dfilt.delay(k-1),hc);
    end
end

if isa(this,'mfilt.abstractiirinterp');
    gain = 1;
else
    gain = 1/rcf;
end

Hd = cascade(dfilt.scalar(gain),dfilt.parallel(dfiltphase));

this.Filters = Hd;

% [EOF]
