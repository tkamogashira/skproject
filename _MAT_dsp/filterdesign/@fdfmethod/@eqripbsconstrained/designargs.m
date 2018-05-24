function args = designargs(this, hs)
%DESIGNARGS Return the design function inputs.

%   Copyright 2011 The MathWorks, Inc.

constraintFlagVector = ...
  [hs.Passband1Constrained hs.StopbandConstrained hs.Passband2Constrained];

numConstrainedBands = sum(constraintFlagVector);

if numConstrainedBands > 2
  % Cannot constrain all the bands
  error(message('dsp:fdfmethod:eqripbsconstrained:designargs:invalidNumConstraints'));
elseif numConstrainedBands == 2
  % If two bands have been constrained then weights are
  % irrelevant
  constraintValues = [1 1 1];
   constraintAttributes = {'w','w','w'};   
else % only one constrained band. In this case, weights are relevant.
  constraintValues = [this.Wpass1 this.Wstop this.Wpass2];
  constraintAttributes = {'w','w','w'};
end

if constraintFlagVector(1)
  aPass1 = convertmagunits(hs.APass1,'db','linear','pass');
  % Apply a small correction to meet the specs
  constraintValues(1) = aPass1*0.99;
  constraintAttributes{1} = 'c';
end

if constraintFlagVector(2)
  aStop = convertmagunits(hs.AStop,'db','linear','stop');
  % Apply a small correction to meet the specs
  constraintValues(2) = aStop*0.99;
  constraintAttributes{2} = 'c';
end

if constraintFlagVector(3)
  aPass2 = convertmagunits(hs.Apass2,'db','linear','pass');
  % Apply a small correction to meet the specs  
  constraintValues(3) = aPass2*.99;
  constraintAttributes{3} = 'c';
end

% Cache the constrained bands for the info method.
this.privConstrainedBands = double(constraintFlagVector);

args = {hs.FilterOrder, [0 hs.Fpass1 hs.Fstop1 hs.Fstop2 hs.Fpass2 1], ...
    [1 1 0 0 1 1], constraintValues, constraintAttributes};

% [EOF]
