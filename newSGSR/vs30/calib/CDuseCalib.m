function OK = CDuseCalib(ERCfile, DAchan);
% CDuseCalib - read ERC file and make it the actual calibration

OK = 0;
if nargin<2, DAchan = 'A'; end; % default: all channels present in the ERC file
global CALIB
CALIB = []; % start from scratch
if isempty(ERCfile) | isequal('?', ERCfile), ERCfile = '!FLAT @ 133 dB SPL'; end;
if isequal(ERCfile(1),'!'), % fake, flat calib '!FLAT @ 134 dB SPL' etc
   CALIB.ERCfile = ERCfile;
   dig = find(double(ERCfile)<=double('9')&double(ERCfile)>=double('0'));
   CALIB.ERC = str2num(ERCfile(dig));
   if isequal(1, channelnum(DAchan)), CALIB.ichan = [1 0];
   elseif isequal(2, channelnum(DAchan)), CALIB.ichan = [0 1];
   else, CALIB.ichan = [1 1];
   end
   OK = 1; return;
end
if isequal('prompt', lower(ERCfile)), ERCfile = ''; end; % CDread will lauch uigetfile for erc file
try, CALIB.ERC = CDread('ERC', ERCfile, DAchan);
catch,
   eh = errordlg(lasterr,'Error reading Calibration data');
   return;
end
if ~isfield(CALIB.ERC, 'CalType'),
   eh = errordlg('Obsolete ERC data (SGSR version<2.0)','Error reading Calibration data');
   return;
end
if ~CDcompareFilterSettings(CALIB.ERC(1)),
   mess = strvcat('ERC data were measured with sample-rate settings', ...
      'that are different from current settings.',...
      'A different or new ERC transfer function is needed.');
   eh = errordlg(mess, 'Incompatible ERC data', 'modal');
   uiwait(eh);
   return;
end
DApresent = cat(2,CALIB.ERC.DAchan);
% store vector that points to array index of desired DAchannel, or 0 if absent
ChanIndex = [0 0]; % pessimistic start: no channel present
whereIs1 = find(DApresent==1);
whereIs2 = find(DApresent==2);
if ~isempty(whereIs1), ChanIndex(1) = whereIs1; end;
if ~isempty(whereIs2), ChanIndex(2) = whereIs2; end;
CALIB.ichan = ChanIndex;
CALIB.ERCfile = CALIB.ERC(1).filename;
OK = 1;

