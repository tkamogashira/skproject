function SD = STIMDEF(SMS, noStimEval);
% STIMDEF - generates STIMDEF struct for arbitrary stimtype XXX 
% XXX update comments & help
% INPUTS: 
% 1. SMS (stimulus-menu structure) is struct containing
%    both generic (i.e., stimtype-independent) and particular 
%    (i.e., stimtype-specific) information
%    fields of SMS:
%     StimCat: string identifying stimulus category.
%     GlobalInfo: generic, (stimcat-independent info)
%       contained in the following fields:
%          cmenu: string identifying the caling stimMenu
%          calib: string identifying the calibration table
%          plotInfo: struct for on-line spike-rate plotting
%            (see createPlotInfo)
%          SGSRversion: version of SGSR that generated SMS
%     MON, BIN, LEFT, RIGHT, SPL, NREP: 
%     COVAR:
%     PRP: instruction for playing, recording & plotting
%          during measurements (e.g., order of subseqs, axis labels, etc)
% 2. noStimEval (optional), return before calling stimEval
%    default: 0 (do not return)
%
% OUTPUTS:
% SD (stimDef) is a struct containing the following fields:
%  * waveform: cell array specifying waveforms to be computed
%     each waveform element contains the follwing fields:
%       - stimCat: equal to stimCat arg passed
%       - stimpar: a struct containing stimtype-specific params
%          (see stimEval<stimType> and StimGen<stimType>)
%       - DAdata: stimtype-independent info for D/A conversion
%         this info is destilled from the stimulus parameters by
%         stimeval (see stimEval)
%       - GENdata: stimulus-specific info for generating the 
%         waveform. This info is used by stimGen (see stimGen)
%  * subseq: cell array specifying subsequences to be played
%      The information in subseq is stimtype-independent and
%      is contained in the fields: DAmode, ipool, atten, Nrep.
%      This information is used to compile instructions for
%      D/A (see playInstr)
%  * DAstats: totals for D/A conversion. Stimtype-independent.
% For more details, see stimEval and stimGen and try dispStimDef.
%
% This function delegates the stimtype-specific work to
% stimDEF<stimtype>
% MvdH, Sep 1999.

% ----arg checking-----
% # args
if nargin<1, error('insufficient # input args'); end;
if nargin<2, 
   global NoStimEval
   noStimEval = isequal(NoStimEval,1);
end;
if nargout~=1, error('incorrect # output args'); end;

% read calibration table
CDuseCalib(SMS.GlobalInfo.calib);

% is stimCat known?
stimCat = SMS.StimCat;
stimdefFun = ['stimDEF' stimCat];
if ~isequal(2, exist(stimdefFun)),
   error(['don''t know how to define ''' stimCat ''' stim category ']);
end

% delegate to stimtype-specific stimDef function
SD = feval(stimdefFun, SMS);

% Now store the GlobalInfo and PRP info
SD.GlobalInfo =  SMS.GlobalInfo;
SD.PRP =  SMS.PRP;

if noStimEval, return; end;
% Compute the DAdata and GENdata of each waveform
Npool = size(SD.waveform,2);
for ipool=1:Npool,
   [SD.waveform{ipool}.DAdata SD.waveform{ipool}.GENdata ] ...
      = stimeval(SD.waveform{ipool});
end


% check level ranges: 
% 1. if subseqs demand excessive levels quit with an error.
% 2. if subseqs demand very low levels, modify numerical 
%    attenuation.
SD = levelChecking(SD);

% Do some stats on the total waveform  pool and subseqs
SD.DAstats = stimStats(SD.waveform, SD.subseq);
