function Hm = cascade(varargin)
%CASCADE  Cascade DFILT and MFILT filters.
%   Hm = MFILT.CASCADE(Hm1, Hm2) connects the filters Hm1 and Hm2 in series.
%   The block diagram of this cascade looks like:
%
%      x ---> Hm1 ---> Hm2 ---> y
%
%   Note that one usually does not construct CASCADE filters explicitly.
%   Instead, one obtains these filters as a result from a design using 
%   <a href="matlab:help fdesign">FDESIGN</a>. For more information on generating CASCADE objects from FDESIGN,
%   see the <a href="matlab:web([matlabroot,'\toolbox\dsp\dspdemos\html\multistagesrcdemo.html'])">Multistage Design Of Decimators/Interpolators</a> demo.
%
%   % EXAMPLE #1: Direct instantiation
%   hm(1) = mfilt.firdecim(2); 
%   hm(2) = dfilt.scalar(2); 
%   Hcas = mfilt.cascade(hm(1),hm(2))
%   realizemdl(Hcas)  % Requires Simulink
%   
%   % EXAMPLE #2: Design an multistage decimator filter 
%   Hcas = design(fdesign.decimator(8,'lowpass',.11,.12,.2,60), 'multistage')
%   fvtool(Hcas)        % Analyze filter
%   x = randn(100,1); % Input signal
%   y = filter(Hcas,x); % Apply filter to input signal
%
%   See also MFILT/STRUCTURES   
  
%   Copyright 1999-2009 The MathWorks, Inc.

if nargin == 0,
    varargin = {mfilt.firdecim,mfilt.firinterp};
end

Hm = mfilt.cascade;

Hm.FilterStructure = 'Cascade';

% Check that all are dfilts or mfilts before starting to set parameters.
for k=1:length(varargin)
  if isnumeric(varargin{k})
    g = squeeze(varargin{k});
    if isempty(g) || length(g)>1
      error(message('dsp:mfilt:cascade:cascade:MFILTErr'));
    end
    varargin{k} = dfilt.scalar(g);
  end
  if ~(isa(varargin{k}(end),'dfilt.abstractfilter') || isa(varargin{k}(end),'dfilt.multistage')),
      error(message('dsp:mfilt:cascade:cascade:InvalidEnum'));
  end
end

% Set the rate change factor and the sections of the cascade
allStages = Hm.Stage;
for k=1:length(varargin)
    newsec = varargin{k}(:);
    allStages = [allStages; newsec];
end
set(Hm, 'Stage', allStages);


