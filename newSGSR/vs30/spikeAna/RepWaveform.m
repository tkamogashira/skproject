function y = RepWaveform(DataFileName, cond, isubseq);
% RepWaveform - reproduce waveform of a dataset ****OBSOLETE**** no longer supported!
%   SYNTAX: wv = RepWaveform(DataFileName, seq, isubseq)
%   wv is struct with fields:
%  allXvars: values of varied parameters oif all subsequences (conditions)
%   isubseq: condition number
%      xvar: value of varied parameter
%   varname: what was varied
%   fsample: sample freq in Hz
%         y: samples in row vector, or 2xN matrix if stereo
%
%   See also SAVEWAVEFORM

error('RepWaveForm is obsolete. Use StimSam instead.' );
if nargin<3, isubseq = 1; end;

global idfSeq SMS

% use "flat" calibration
readcalib([datadir '\flat']);

if isstruct(DataFileName),
   idfSeq = DataFileName;
else,
   disp('retrieving stimulus parameters ..');
   if ischar(cond),
      [iseq, isIDF] = id2iseq(DataFileName, cond,1);
      cond = id2iseq;
      if ~isIDF, error('Sequence is not in IDF/SPK format'); end;
   else, iseq = cond;
   end
   disp('computing stimuli ..');
   idfSeq = idfget(DataFileName, iseq);
end


idfSeq.stimcntrl.repcount = 1;
SMS = idf2sms(idfSeq);

SMS2PRP(0,1);

global PRPinstr

act = idfSeq.stimcntrl.activechan;

samp = PRPinstr.PLAY(isubseq).SamP;
global SGSR;
Nswitch = round(1e3*SGSR.switchDur/samp);

y.DataFileName = DataFileName;
y.cond = cond;
y.allXvars = PRPinstr.PLOT.varValues(:)';
y.isubseq = isubseq;
y.xvar = y.allXvars(isubseq);
y.varname = PRPinstr.PLOT.xlabel; 
y.fsample = 1e6/samp;
y.waveform = localGetSamples(PRPinstr.PLAY(isubseq), act, Nswitch);


% -------locals----------
function s = localGetSamples(pin, act, Nswitch);
if act==0,
   s1 = PL2samp(pin.playList(1,:));
   s2 = PL2samp(pin.playList(2,:));
   N1 = length(s1);
   N2 = length(s2);
   if N1<N2, s1 = [s1 zeros(1,N2-N1)];
   elseif N1>N2, s2 = [s2 zeros(1,N1-N2)];
   end
   s = [s1;s2];
else,
   pl = pin.playList(1,:);
   s = PL2samp(pl);
end
s = s(:,Nswitch+1:end);

function y = PL2samp(p);
global SampleLib
z1 = min(find(p==0));
p = p(1:z1-1);
dbn = p(1:2:end);
rep = p(2:2:end);
y = [];
for ii=1:length(dbn),
   dd = dbn(ii);
   if dd>0,
      nn = dama2ml(dd);
   else,
      nn = SampleLib.cell{-dd};
   end
   y = [y repmat(nn, 1,rep(ii))];
end




