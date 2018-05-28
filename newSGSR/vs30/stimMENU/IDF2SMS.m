function SMS=IDF2SMS(idfSeq,calib)

% IDF2SMS - convert IDF menu parameters to SMS
global CALIB
stimName = IDFstimname(idfSeq.stimcntrl.stimtype);
evalFun = [upper(stimName) '2SMS'];
if ~isequal(exist(evalFun, 'file'),2), 
   error(['don''t know how to convert ''' stimName ''' stimtype.']); 
end;
if nargin<2
   calib = getFieldOrdef(CALIB, 'ERCfile', '?'); 
end;

global SESSION
SESSION.RecordingSide = channelChar(3-idfSeq.stimcntrl.contrachan,1);

SMS = feval(evalFun, idfSeq, calib);
% add idfSeq to GlobalInfo of SMS
SMS.GlobalInfo.cmenu = idfSeq;
% add stim menu name to GlobalInfo of SMS
global StimMenuStatus
if ~isempty(StimMenuStatus),
   STname = StimMenuStatus.MenuName;
   SMS.GlobalInfo.StimMenuName = STname;
   % add stim menu params to GlobalInfo of SMS
   try
      StimParams = saveMenuDefaults(STname, ''); % nothing written to file
   catch
       StimParams = [];
   end
   SMS.GlobalInfo.StimParams = StimParams;
end

