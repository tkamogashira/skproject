function [CD, FN] = CDread(ext, fname, DAchan, prompt);
% CDread - read calibration data
% DAchan = B|L|R|U|A = both|left|right|AskUserIfBothExist|allThereIs
% default DAchan='U'
if nargin<2, fname = ''; end;
if nargin<3, DAchan='U'; end; % default: take only channel that exists or let user choose
if nargin<4, prompt = ['Select ' ext ' calibration file']; end;
CD = []; FN = '';
ext = upper(ext);
switch ext,
case {'CAV', 'PRB', 'PRL', '*'}, defdir = calibdir;
case {'ERC'}, defdir = datadir;
end
if isequal('*', ext),
   ext = 'CAV;*.PRB;*.PRL';
end

if isempty(fname), 
   [fn fp] = uigetfile([defdir '\*.' ext], prompt);
   if fn==0, return; end; % user cancelled
   FN = [fp fn];
else, FN = fullFilename(fname, defdir, ext, 'calibration file');
end

CD = load(FN, '-mat');
if isfield(CD, 'dummyvarname'),
   CD = CD.dummyvarname;
elseif ~isfield(CD, 'CalType'), % % robust against old style calib data [<vs 2]
elseif isequal('ERC', CD.CalType), 
   CD = localPickChan(CD, DAchan); % select channel(s) from ERC data
end
for ii=1:length(CD), CD(ii).filename = FN; end;
%---------------
function CD = localPickChan(CD, DAchan); % select channel(s) from ERC data
% convention: DAchan = 0|1|2|U|inf = both|left|right|askUserIfBothExist|everything
Lpresent = isfield(CD, 'L'); Rpresent = isfield(CD, 'R'); % presence in data  of channels
% Lpresent, Rpresent
rmess = 'requested D/A channels not present in ERC data';
switch upper(DAchan),
case 'U', % if CD contains single channel, take it, else ask user
   if Lpresent & Rpresent, % both channels present in data - user decides interactively
      DAchan = warnchoice1('Select D/A Channel', '', '\DA channel:', 'Left','Right');
      DAchan = DAchan(1);
      CD = getfield(CD, DAchan);
   elseif Lpresent, CD = CD.L;
   elseif Rpresent, CD = CD.R;
   end
case 'A', % take all there is; return 1x2 vector if there's two
   if Lpresent & Rpresent, CD = [CD.L CD.R]; % 2 channels present in data; take both
   elseif Lpresent, CD = CD.L;
   elseif Rpresent, CD = CD.R;
   end
otherwise, % select specified channel
   DAchan = channelChar(DAchan); % converts numerical format to single uppercase B|L|R
   if isequal('B', DAchan), 
      if ~(Lpresent&Rpresent), error(rmess); end;
      CD = [CD.L CD.R];
   elseif isequal('L', DAchan), 
      if ~Lpresent, error(rmess); end;
      CD = CD.L;
   elseif isequal('R', DAchan), 
      if ~Rpresent, error(rmess); end;
      CD = CD.R;
   end
end % switch/case


