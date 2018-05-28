function [Freqs, Nfreq] = OUIfrequencySweep(S, CT);
% OUIfrequencySweep - compute frequencies of lin or log frequency sweep
%   [Freqs Nfreq] = OUIfrequencySweep(S, CT) returns the respective 
%   frequencies of the frequency sweep implied by paramset object S 
%   and stimulus context CT. The default CT is the value returned
%   by stimulusContext. Nfreq is the number of frequencies.
%
%   S must contain the following parameters:
%      startFreq, stepType, linStepFreq, logStepFreq, endFreq, activeDA.
%   Any invalid values of or inconsistencies among the parameters will 
%   be reported using OUIerror. If such errors occur, a void Freqs is
%   returned. On succesful exit, Freqs will contain the respective 
%   frequencies of the sweep as a Nfreq x M parameter object, 
%   where M is the number of *different* channels. Thus M=2 if both DA 
%   channels are active and if the frequencies in the two channels differ; 
%   M=1 otherwise.
%
%   See also OUIerror, stimDefinitionFS, GenericParamSubset.

if nargin<2, CT = stimulusContext; end;

[Freqs, Nfreq] = deal(parameter, nan); % pessimistic defaults, i.e., void parameter and nan

% check if freq limits are ok
if ~OUIcheckStimulusFreqs(S, {'startFreq', 'endFreq'}), return; end
   
f0 = S.startFreq.in_Hz;
linStep = S.linStepFreq.in_Hz;
logStep = S.logStepFreq.in_octave;
f1 = S.endFreq.in_Hz;
% make sure all variables are 1x2
[f0, linStep, logStep, f1] = StereoVar(f0, linStep, logStep, f1);

switch S.stepType.value,
case 'Hz',
   if any((linStep==0) & (f0~=f1)),
      OUIerror({'Step size is zero altough', 'sweep limits do not coincide.'}, 'linStepFreq');
      return
   end
   [f, Nfreq] = localLinSweep(f0,linStep,f1);
   if isnan(f), return; end % OUIerror handled by local
case 'octave',
   if any((logStep==0) & (f0~=f1)),
      OUIerror({'Step size is zero altough', 'sweep limits do not coincide.'}, 'linStepFreq');
      return
   end
   % octaves: convert to log2 scale, do linear sweep, convert back
   [f, Nfreq] = localLinSweep(log2(f0),logStep,log2(f1));
   f = 2.^f; % octaves->Hz
otherwise,
   error(['invalid type of frequency step ''' S.stepType.value '''.']);
end
Freqs = parameter('sweepFrequency', f, 'Hz', 'ureal');

%-----------locals-----------
function [f, NL, NR] = localLinSweep(f0,step,f1);
f = nan; % pessimistic default
if length(f0)>1, % recursive, channelwise, call
   [fL, NL] = localLinSweep(f0(1), step(1), f1(1));
   [fR, NR] = localLinSweep(f0(2), step(2), f1(2));
   if NL~=NR, 
      OUIerror({'Different # steps in left', 'right channels.'}, ...
         {'startfreq' 'linstepfreq' 'endfreq' });
      return;
   end
   if all(fL==fR), f = [fL];
   else, f = [fL,fR];
   end
   return;
end
if isequal(f0,f1), f=f1; NL=[1,1]; return; end
NL = 1+floor(0.1+abs(f1-f0)/abs(step));
[flow, fhigh] = minMax(f0,f1);
f = fhigh-abs(step)*(0:NL-1).'; % decreasing freqs; lower freq is adjusted in case of mismatch
if f0<=f1, f = flipUD(f); end













