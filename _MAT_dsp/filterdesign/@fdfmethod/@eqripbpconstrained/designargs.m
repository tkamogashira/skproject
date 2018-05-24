function args = designargs(this, hs)
%DESIGNARGS Return the design function inputs.

%   Copyright 2011 The MathWorks, Inc.

constraintFlagVector = ...
  [hs.Stopband1Constrained hs.PassbandConstrained hs.Stopband2Constrained];

numConstrainedBands = sum(constraintFlagVector);

if numConstrainedBands > 2
  % Cannot constrain all the bands
  error(message('dsp:fdfmethod:eqripbpconstrained:designargs:invalidNumConstraints'));
elseif numConstrainedBands == 2
  % If two bands have been constrained then weights are
  % irrelevant
  constraintValues = [1 1 1];
   constraintAttributes = {'w','w','w'};   
else % only one constrained band. In this case, weights are relevant.
  constraintValues = [this.Wstop1 this.Wpass this.Wstop2];
  constraintAttributes = {'w','w','w'};
end

if constraintFlagVector(1)
  aStop1 = convertmagunits(hs.Astop1,'db','linear','stop');
  % Apply a small correction to meet the specs
  constraintValues(1) = aStop1*.99;
  constraintAttributes{1} = 'c';
end

if constraintFlagVector(2)
  aPass = convertmagunits(hs.Apass,'db','linear','pass');
  % Apply a small correction to meet the specs
  constraintValues(2) = aPass;
  constraintAttributes{2} = 'c';
end

if constraintFlagVector(3)
  aStop2 = convertmagunits(hs.Astop2,'db','linear','stop');
  % Apply a small correction to meet the specs
  constraintValues(3) = aStop2*.99;
  constraintAttributes{3} = 'c';
end

% Cache the constrained bands for the info method.
this.privConstrainedBands = double(constraintFlagVector);

args = {hs.FilterOrder, [0 hs.Fstop1 hs.Fpass1 hs.Fpass2 hs.Fstop2 1], ...
    [0 0 1 1 0 0], constraintValues, constraintAttributes};

% [EOF]
