function [X, Mess]=EvalStepper(X0, Xstep, X1, StepMode, Adjust, MinMax, maxNcond);
% EvalStepper - compute stepped values from start, end, step.
%   [X, Mess]=EvalStepper(X0, Xstep, X1, StepMode, Adjust, Xminmax, maxNcond)
%   computes column array X containing values varying from X0 to X1, while
%   applying stepsize Xstep. If StepMode is 'linear', X runs from X0 to X1
%   in equal steps of Xstep. X0 may be larger than X1. If stepMode is 
%   'octave', equal log steps are used of StepSize octaves.
%   Xminmax equals [Xmin Xmax], i.e. the hard minimum and maximum values for
%   X. If adjusting X0 or X1 results in exceeding these limiting values,
%   the offending conditions X(k,:) will be removed from X.
%   The last input arg, maxNcond, is the maximum number of conditions.
%
%   If Xstep does not fit an integer # of steps, either X0, X1, or Xstep is
%   adjusted to the nearest value that leads to an exact # steps. Which
%   parameter is adjust depends on Adjust, which is one of 'Start', 'End',
%   'Step', 'None'. If Adjust equals 'None' and Xstep  does not fit, X is 
%   set to [] and a Mess equals 'Nofit'. If the number of steps in the two 
%   channels is unequal, Mess equals 'cripple'. If the number of X values
%   exceeds maxNcond, Mess equals 'toomany'. Mess is empty in all other 
%   cases.  
%
%   If one or several of X0, X1, Xstep are pairs of numbers (2x1 arrays),X
%   is a Nx2 matrix whose columns are step arrays as in the scalar case.
%
%   EvalStepper is typically invoked by other helper functions like 
%   EvalFrequencyStepper.
%
%   See StimGUI, EvalFrequencyStepper.

if nargin<4, StepMode = 'linear'; end 
if nargin<5, Adjust = 'step'; end 
if nargin<6, MinMax = [-inf inf]; end % the sky is the limit
if nargin<7, maxNcond = inf; end % the sky is the limit

[StepMode, Smess] = keywordMatch(StepMode, {'Linear' 'Octave'}, 'StepMode argument');
error(Smess);
[Adjust, Amess] = keywordMatch(Adjust, {'Start' 'End' 'Step' 'None'}, 'Adjust argument');
error(Amess);

[X0, Xstep, X1] = sameSize(X0, Xstep, X1);
Nchan = numel(X0);
if isequal('Octave', StepMode), % convert to octave scale
    X0 = log2(X0); X1 = log2(X1);
end

% tmp default values
Mess = ''; X = [];
% evaluate # steps & potential errors with that
Nstep = abs(X1-X0)./Xstep;
if isequal('None', Adjust) && any(Nstep~=round(Nstep)),
    Mess = 'nofit';
    return;
end
if any(Nstep<0.5) && ~isequal(X0,X1),
    Mess = 'largestep';
    return;
end
Nstep = round(Nstep);
if any(Nstep~=Nstep(1)),
    Mess = 'cripple'; % see help text
    return;
end

for ii=1:Nchan,
    x0=X0(ii); x1=X1(ii); xstep = Xstep(ii); nstep = Nstep(ii);
    switch Adjust,
        case 'Start',
            x0 = x1-nstep*xstep;
        case 'End',
            x1 = x0+nstep*xstep;
    end
    x = linspace(min(x0,x1),max(x0,x1),nstep+1).';
    if x0>x1, x = flipud(x); end
    X = [X x];
end
if isequal('Octave', StepMode), % convert back from octave scale to linear
    X = 2.^X;
end
% restrict range to meet MinMax criterion
Xmax = max(X,[],2); % per-cond max over all channels
Xmin = min(X,[],2); % idem min
absMin = min(MinMax);  % prescribed min
absMax = max(MinMax);  % idem max
ioops = (Xmin<absMin) | (Xmax>absMax); % out-of-range conditions
X(ioops,:) = []; % remove faulty conditions

% check # conditions
if size(X,1)>maxNcond,
    Mess = 'toomany';
    X = [];
end






