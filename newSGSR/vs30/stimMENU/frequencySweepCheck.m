function [OK, lofreq, dfreq, hifreq, carFreqs, Nseq, StepMode] = ...
   frequencySweepCheck(SingleValuesOnly);

% reads & checks frequency-sweep part of stimmenus like FS, BFS, etc,
% where the varied parameter is carrier freq
% stepmode is 'lin' | 'log' according to StepUnitButton
% uicontrol group is stored freqsweep.fig in UImenu\construction

global StimMenuStatus SGSR 
if nargin<1, SingleValuesOnly = 0; end;
% textcolor constants
textcolors;

% provide default return values to avoid MatLab warnings when
% returning prematurely in case of input errors
OK = 0; carFreqs = []; Nseq = 0;
% handles for getting params and reporting errors/warnings
hh = StimMenuStatus.handles; 

% step mode (linear [e.g. FS] or log [e.g. FSLOG])
logSteps = 0;
try, menubuttonmatch(hh.StepFreqButton); end
stepUnit = get(hh.StepFreqButton, 'string');
switch stepUnit
case 'Hz',
   StepMode = 'lin';
case 'Octaves',
   StepMode = 'log';
   logSteps = 1;
end
% frequency values
hifreq = UIdoubleFromStr(hh.HighFreqEdit);
dfreq = abs(UIdoubleFromStr(hh.StepFreqEdit));
lofreq = UIdoubleFromStr(hh.LowFreqEdit);
% any non-numerical input?
if any(isnan([hifreq dfreq lofreq])),
   mess = 'non-numerical values of numerical parameters';
   UIerror(mess);
   return;
end
% check number of freq values
if SingleValuesOnly, maxN = 1; else maxN = 2; end;
fh = [hh.LowFreqEdit hh.StepFreqEdit hh.HighFreqEdit];
tobig = ([length(lofreq) length(dfreq) length(hifreq)]>maxN);
if any(tobig), 
   mess = 'too many numbers specified';
   UIerror(mess);
   for ii = 1:3, if tobig(ii), UItextColor(fh(ii), RED); end; end;
   return;
end

% force freq specs to have equal sizes so that they can be put
% in a single 3x(1|2) matrix ff; columns are channels
[lofreq, dfreq, hifreq] = equalizeSize(lofreq(:)', dfreq(:)', hifreq(:)');
ff = [lofreq; dfreq; hifreq];
Nchan = size(ff,2); carFreqs = cell(1,Nchan);
% check range of freq values
MF = round(maxstimFreq);
nof = (ff>MF) | (ff< 0);
nof(2,:) = 0; % negative dfreq is allowed
if any(nof),
   mess = ['frequency values outside 0-' num2str(MF) '-Hz range'];
   UIerror(mess);
   for ii=1:3, if any(nof(ii,:)), UItextColor(fh(ii), RED); end; end;
   return;
end
% now check further details per channel
for ichan=1:Nchan,
   % force consistency of limits and step direction
   dfreq(ichan) = dfreq(ichan) * sign(hifreq(ichan)-lofreq(ichan));
   % in case of zero dfreq, check if freq limits are equal
   if (dfreq(ichan)==0) & (lofreq(ichan)~=hifreq(ichan)),
      mess = strvcat('zero step frequency', 'but unequal freq limits');
      UIerror(mess, hh.StepFreqEdit);
      return;
   end
   % now check if limits and steps are approx commensurate
   if logSteps, % Hz->octaves re 1 Hz
      LF = log2(lofreq(ichan)); HF = log2(hifreq(ichan));
   else, LF = lofreq(ichan); HF = hifreq(ichan);
   end
   if dfreq(ichan)~=0,
      fittingLF = HF-dfreq(ichan).*round((HF-LF)./dfreq(ichan));
      % make sure our rounding doesn't result in neg frequencies
      if fittingLF<0, fittingLF = fittingLF+dfreq(ichan); end;
   else, fittingLF = LF;
   end
   % evaluate mismatch
   if logSteps, mismatch = abs(LF-fittingLF)>0.1; 
   else, mismatch = abs(LF-fittingLF)>0.1*LF; end;
   if mismatch,
      mess = strvcat('non-integer number of sweep steps', ...
         'between start and end frequencies.', ...
         'Start freq will be adjusted.');
      if StimMenuWarn(mess, hh.LowFreqEdit), return; end;
   end
   % adjust lowest frequency
   LF = fittingLF; 
   if logSteps, lofreq(ichan) = pow2(LF); 
   else, lofreq(ichan) = LF; end;
   fstr = sprintf('%0.2f  ',lofreq);
   if mismatch, setstring(hh.LowFreqEdit,fstr); end;
   % now compute carrier freqs
   if dfreq(ichan)==0, carFreqs{ichan} = LF; % zero step
   else, carFreqs{ichan} = LF:dfreq(ichan):HF; end; % sweep
   % force carFreq into column vector
   carFreqs{ichan} = carFreqs{ichan}(:);
end % for ichan

% check if left- and right-channel sweeps have equal # steps
if Nchan==2,
   Nleft = length(carFreqs{1});
   Nright = length(carFreqs{2});
   if (Nleft>1) & (Nright>1) & (Nleft ~=Nright),
      mess = strvcat('unequal sweep steps of', ...
         'left and right channels.', ...
         'Change freq. sweep parameters');
      UIerror(mess, [hh.HighFreqEdit hh.StepFreqEdit hh.LowFreqEdit]);
      return;
   end
end
% return carFreqs as Nx(1|2) matrix
if Nchan==1, % 1x1 cell->matrix
   carFreqs = carFreqs{1};
elseif Nleft==1, % right channel determines length
   carFreqs = [carFreqs{1}+0*carFreqs{2}, carFreqs{2}];
elseif Nright==1, % left channel determines length
   carFreqs = [carFreqs{1}, 0*carFreqs{1}+ carFreqs{2}];
else, % equal Nleft & Nright - simply deal
   carFreqs = [carFreqs{1}, carFreqs{2}];
end

% if log scale, convert back from octaves-re-1-Hz to Hz proper
if logSteps, carFreqs = pow2(carFreqs); end;

% update info that has to do with frequencies
Nseq = size(carFreqs,1);
if ~ReportNsubSeq(Nseq), return; end;

OK = 1;