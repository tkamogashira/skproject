function SpikeTimes = ExtractSpikeTimes(SGSRfileName, Seq, Subseq, Rep);

% ExtractSpikeTimes - extract spike arrival times (in us) from SGSR data file
% SYNTAX:
% SpikeTimes = ExtractSpikeTimes(SGSRfileName, Seq, Subseq, Rep);
% SGSRfileName is name of data file. Extension '.SGSR' is assumed;
% Default directory is the <SGSRroot>\ExpData dir. An empty string
% will bring up the default Windows uigetfile dialog
% Seq, Subseq, and Rep are the numbers of the sequence, subsequence
% and repetition, respectively.
% SpikeTimes is a row vector containing the arrival times of spikes
% re the stimulus onset in us.

global DEFDIRS

error(nargchk(4,4,nargin));

if isempty(SGSRfileName),
   [NN PP] = uigetfile([DEFDIRS.IdfSpk '\*.SGSR']);
   if PP==0, return; end; % user cancelled
   SGSRfileName = [PP NN];
end

[PP NN EE] = fileparts(SGSRfileName);
if isempty(PP), PP= DEFDIRS.IdfSpk; end; % default dir
if isempty(EE), EE= '.SGSR'; end; % default  extension
fullName = [PP '\' NN EE];

if ~isequal(2,exist(fullName)),
   error(['cannot find file ''' fullName '''']);
end

% get SeqName from directory
load(fullName,'Directory','-mat');
if (Seq>Directory.Nseq),
   error(['Data file contains only ' num2str(Directory.Nseq) ' sequences']);
end
SeqName = Directory.SeqNames{Seq};
% load sequence
load(fullName, SeqName, '-mat');
% extract rep of subseq 

% spike times of i-th rep of j-th subseq are in Spiketimes.Subseq{j}.Rep{i}
% field of Sequence variable
addressStr = [SeqName '.SpikeTimes.SubSeq{' num2str(Subseq) '}.Rep{' ...
      num2str(Rep) '}'];
eval(['SpikeTimes = ' addressStr ';']);








   
   
   
   
   
   
   
   
   