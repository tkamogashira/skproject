function SD = stimgen(SD, iwv, storage);

% STIMGEN -  computes (realizes) waveforms XXX update header comments
% SYNTAX:
% function SD = stimgen(SD, iwv, storage);
% INPUTS/OUTPUTS:
%    SD: stimdef struct
%    iwv: vector containing the cell numbers of the
%         waveforms to be generated/stored
%         a zero-valued or absent iwv means "all waveforms"
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%         if storage is a cell array, its cells apply to
%         the corresponding wavwform indices iwv
%         If the storage arg is absent, the storage destination
%         will be determined from the SD.DAstats.advice field
%         (see stimstats)
% OUTPUT:
% SD is the stimdef struct from which the waveforms are taken; 
%    only its SD.waveform{iwv}.GENdata.BufDBNs fields are affected.
%    BufDBNs is a matrix holding the addresses of samples:
%    positive elements of BufDBNs: AP2 DAMA Buffer Numbers
%    zero elements: not stored
%    negative: negative index of global SampleLib (see ToSampleLib)
% The real work is passed to stimtype-specific functions,
% except when storage has been done earlier (as read from
% the DAstats.stored):
%    if the k-th waveform has been stored in DAMA, (i.e.,if 
%       SD.DAstats.stored(k)=1), no action is taken
%       for that waveform;
%    if the k-th waveform has been stored in SampleLib, (i.e.,if
%       SD.DAstats.stored(k)=1), the waveform is copied from 
%       the SampleLib cell (see ToSampleLib).
% The SD.DAstats.stored vector is updated after storage.

% check input args
if nargin<1, error('insufficient # input args'); end;
if ~isfield(SD,'waveform'), 
   error('absent waveform field in stimDef struct'); 
end;
if ~iscell(SD.waveform), error('non-cell waveform field'); end;

if nargin<2, iwv = 0; end;
if isequal(iwv,0), iwv = 1:length(SD.waveform); end;
if nargin<3, 
   switch SD.DAstats.advice
   case 'StoreAllOnAP2',
      storage = 'AP2'; 
   case 'StorePerSubseq',
      storage = 'MatLab'; 
   case 'UseDoubleBuffering',
      errordlg(strvcat('Subsequence(s) too long',...
         'to fit in AP2 DAMA memory.', ...
         'Decrease length of stimuli.'),'Error while generating stimuli',...
         'modal');
      error('stimulus too long');
   otherwise,
      storage = 'MatLab'; 
   end;
end
if ~AP2present, storage = 'MatLab'; end;

if ~iscell(storage), storage = {storage}; end;
if (length(storage)~=1) & (length(storage)~=length(iwv)), 
      error('iwv and storage args must have equal lengths'); 
end;

% now visit all waveform cells one by one

for ii=iwv,
   stor = storage{min(length(storage), ii)};
   % check if waveform cell has stimtype
   if ~isfield(SD.waveform{ii}.GENdata,'GENfun'), 
      error(['no GENfun field in waveform cell nr ' num2str(ii)]);
   end
	if ~strcmp(stor,'AP2') & ~strcmp(stor,'MatLab'),
   	error(['unknown storage type ''' char(stor) '''']);
   end
   gf = SD.waveform{ii}.GENdata.GENfun;
	% check if stimtype is known, i.e., if a stimgen file exists
	if strcmp(gf,''), error('empty GENfun field in stimdef'); end;
	stimGenFile = ['stimgen' gf];
	if (exist(stimGenFile)~=2),
	   error(['do not know how to generate ''' gf ''' stimtype']);
   end
   % Surviving all checks, we delegate according to stimtype ...
   % ... or copy from SampleLib or do nothing (according to DAstats)
   if (SD.DAstats.stored(ii)==0) ... % nothing stored yet
         | (SD.DAstats.stored(ii)==1 & isequal(stor,'MatLab')), % needed for analysis
      evalstr = ['SD.waveform{ii}.DAdata.bufDBNs = ' ...
      	stimGenFile ...
      	'(SD.waveform{ii}, stor);'];
      eval(evalstr);
   elseif (SD.DAstats.stored(ii)==-1) ... % stored in SampleLib
         & strcmp(stor, 'AP2'),  % ..but wanted in AP2 DAMA
      global SampleLib
      SLi = -SD.waveform{ii}.DAdata.bufDBNs; % sampleLib indices
      N = prod(size(SLi)); % SLi might be matrix (?)
      for ibuf=1:N,
         SD.waveform{ii}.DAdata.bufDBNs(ibuf) ...
            = ML2dama(SampleLib.cell{SLi(ibuf)});
      end;
   end
   % update DAstats field;
   if strcmp(stor, 'AP2'), SD.DAstats.stored(ii)=1;
   elseif strcmp(stor, 'MatLab'), SD.DAstats.stored(ii)=-1;
   end
end % for ii

