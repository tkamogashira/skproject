function dsOut = subsasgn(dsIn, S, Value)
%SUBSASGN   subscripted assignment dor adjustable dataset
%   The possible adjustments that can be made are accessible via following 
%   virtual fields (case-insensitive):
%
%   ds.Reps       : the repetitions wanted in the analysis
%   ds.AnWin      : the analysis window
%   ds.ReWin      : the reject window
%   ds.MinISI     : the minimum interspike interval, thus if this field is
%                   set to 2ms, and there are two spikes within 1 millisec of 
%                   each other, then the second of those spikes is not included
%                   in the analysis
%   ds.ConSubst   : the specified time (in milliseconds) is subtracted from each
%                   spike time before any analysis or window is applied to it. 

%B. Van de Sande 02-03-2004

if (length(S) == 1) & strcmp(S.type, '.'),
    switch lower(S.subs)
    case 'reps',     dsOut = SetIncReps(dsIn, Value);
    case 'minisi',   dsOut = ApplyMinISI(dsIn, Value);
    case 'consubst', dsOut = SubstTimeConst(dsIn, Value);
    case 'anwin',    dsOut = ApplyAnWin(dsIn, Value);
    case 'rewin',    dsOut = ApplyReWin(dsIn, Value);
    otherwise, error('Invalid virtual fieldname.'); end
else, error('Invalid assignment for an adjustable dataset.'); end

%---------------------------------local functions------------------------------
function ds = SetIncReps(ds, Reps)

NReps = subsref(ds, struct('type', '.', 'subs', 'nrep'));
if isnumeric(Reps) & any(size(Reps) == 1) & all(ismember(Reps, 1:NReps)),
    Reps  = unique(Reps); %Duplicate repetition numbers are removed and the order of
                          %repetitions is always preserved ...
    pards = struct(ds.dataset);
    pards.Data.SpikeTimes = pards.Data.SpikeTimes(:, Reps);
    pards.Sizes.Nrep      = length(Reps);
    ds.dataset = dataset(pards, 'convert');
else, error('Invalid repetition range.'); end

%------------------------------------------------------------------------------
function ds = ApplyMinISI(ds, MinISI)

if ~isnumeric(MinISI) | (length(MinISI) ~= 1) | (MinISI < 0), 
    error('Invalid mininum interspike interval.'); 
end

if (MinISI == 0), return; end %Nothing to do ...

pards = struct(ds.dataset);

%Making sure that every the interval between spikes can never
%less than the mininum ISI requested ... Logical indexing is not
%good enough ...
N = prod(size(pards.Data.SpikeTimes));
for n = 1:N,
    OldSpkTrain = pards.Data.SpikeTimes{n}; 
    if isempty(OldSpkTrain), continue; end
    
    NSpks = length(OldSpkTrain);
    Intervals = diff(OldSpkTrain);
    NewSpkTrain = OldSpkTrain(1);
    idx = 1;
    while 1,
        %Without cumulative intervals, the next spike included has an interval
        %equal or larger than MinISI ...
        newidx = min(find(Intervals(idx:end) >= MinISI));
        %Using cumulative intervals, the interval between the next spike and the 
        %following is equal or larger than MinISI ...
        %newidx = min(find(cumsum(Intervals(idx:end)) >= MinISI));
        if isempty(newidx), break; end
        idx = idx + newidx;
        NewSpkTrain = [NewSpkTrain, OldSpkTrain(idx)];
    end    
    
    pards.Data.SpikeTimes{n} = NewSpkTrain;
end    

ds.dataset = dataset(pards, 'convert');

%------------------------------------------------------------------------------
function ds = SubstTimeConst(ds, Const)

if ~isnumeric(Const) | (length(Const) ~= 1), 
    error('Invalid time constant.'); 
end

pards = struct(ds.dataset);

N = prod(size(pards.Data.SpikeTimes));
for n = 1:N,
    %Negative spiketimes are discarded ...
    SpkTimes = pards.Data.SpikeTimes{n} - Const;
    idx = find(SpkTimes >= 0);
    pards.Data.SpikeTimes{n} = SpkTimes(idx);
end    

ds.dataset = dataset(pards, 'convert');

%------------------------------------------------------------------------------
function ds = ApplyAnWin(ds, Win)

if isempty(Win), return;
elseif ~isnumeric(Win) | ~any(size(Win) == 1) | (mod(length(Win), 2) ~= 0)| any(Win < 0) | ...
   (Win ~= unique(Win)),
    error('Invalid analysis window.');
end

pards = struct(ds.dataset);

N = length(Win); EvalStr = '(SpkTimes >= Win(1) & SpkTimes < Win(2))';
for n = 3:2:N, EvalStr = sprintf('%s | (SpkTimes >= Win(%d) & SpkTimes < Win(%d))', EvalStr, n, n+1); end

N = prod(size(pards.Data.SpikeTimes));
for n = 1:N,
    SpkTimes = pards.Data.SpikeTimes{n};
    idx = find(eval(EvalStr));
    pards.Data.SpikeTimes{n} = SpkTimes(idx);
end    

ds.dataset = dataset(pards, 'convert');

%------------------------------------------------------------------------------
function ds = ApplyReWin(ds, Win)

if isempty(Win), return;
elseif ~isnumeric(Win) | ~any(size(Win) == 1) | (mod(length(Win), 2) ~= 0)| any(Win < 0) | ...
   (Win ~= unique(Win)),
    error('Invalid reject window.');
end

pards = struct(ds.dataset);

N = length(Win); EvalStr = '(SpkTimes < Win(1) | SpkTimes > Win(2))';
for n = 3:2:N, EvalStr = sprintf('%s & (SpkTimes < Win(%d) & SpkTimes > Win(%d))', EvalStr, n, n+1); end

N = prod(size(pards.Data.SpikeTimes));
for n = 1:N,
    SpkTimes = pards.Data.SpikeTimes{n};
    idx = find(eval(EvalStr));
    pards.Data.SpikeTimes{n} = SpkTimes(idx);
end    

ds.dataset = dataset(pards, 'convert');