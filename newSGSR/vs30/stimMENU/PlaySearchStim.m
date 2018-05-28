function PlaySearchStim(FN);

if nargin<1, FN=''; end;

if isempty(FN),
   [FN, FP] = uigetfile([UIdefDir '\search\*.sdef']);
   if isequal(0,FN), return; end;
   FN = [FP FN];
else,
   FN = [UIdefDir '\Search\' FN '.sdef'];
end

qq = load(FN,'SMS','-mat');
global CALIB
try,
   %CALIB.ERC.filename, qq.SMS.GlobalInfo.calib,
   if ~isequal(CALIB.ERC.filename, qq.SMS.GlobalInfo.calib),
      UIerror(strvcat('Search stim has wrong calibration.', 'Redefine search stimulus.'));
      return;
   end
   global SMS
   SMS = qq.SMS;
   sms2prp;
   PRPplay(0,1); % no record, yes repeat
catch, 
   UIerror(lasterr);
end


