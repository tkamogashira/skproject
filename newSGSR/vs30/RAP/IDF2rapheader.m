function [h, rapfname, xName, vchan] = IDF2rapheader(dataFileName,iseq, datasetName);

% function h = RAPheader(datasetName, dataFileName, Nrep, Dur, Interval, ActChan, xName, xVal, yName, yVal, Awin, MinIS, trialWin);

if isnumeric(dataFileName), 
   dataFileName = pdptestsetname(dataFileName);
end
IDF = idfget(dataFileName, iseq);

sctl = IDF.stimcntrl;

stimName = upper(idfStimName(sctl.stimtype));
Nseq = sctl.seqnum;
Nrep = sctl.repcount;
Interval = sctl.interval;

UETvar = spkUETvar(dataFileName, iseq);
rapfname = [dataFileName '-' num2str(Nseq)  '-' stimName];

chan = sctl.activechan;
switch chan
case 0, ActChan = 'YY';
case 1, ActChan = 'YN';
case 2, ActChan = 'NY';
end
% default yval
yName = 'NONE';
yVal = [0 0 1];

% from here, stimtype dependent action
% Dur = 
% xName
% xVal
st = IDF.indiv.stim; st1 = st{1}; st2 = st{2};
cm = getFieldOrDef(IDF.indiv, 'stimcmn', nan);
vchan = chan;
warnem = 0;
switch stimName
case {'FS','FSLOG'},
   xName = 'FCARR';
   flim = {'lofreq', 'hifreq', 'deltafreq'};
   [vchan, warnem] = local_pickChan(IDF, vchan, {flim{:}, 'duration'});
   xVal = local_getXval(IDF, vchan, flim{:});
   if abs(xVal(1)-UETvar(1,vchan)) > abs(xVal(2)-UETvar(1,vchan)),
      order = -1;
   else, order = 1;
   end
   xVal = Local_FixXval(xVal, order);
   Dur = st{vchan}.duration;
   plist = local_infoLine(IDF, chan, ...
      'spl','SPL', ...
      'modfreq', 'FMOD', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case {'BFS'},
   xName = 'FCARR';
   flim = {'lofreq', 'hifreq', 'deltafreq'};
   vchan = 1; 
   % [vchan, warnem] = local_pickChan(IDF, vchan, {flim{:}, 'duration'});
   xVal = local_getXval(IDF, -vchan, flim{:});
   if 0,%(IDF.),
      order = -1;
   else, order = 1;
   end
   xVal = Local_FixXval(xVal, order);
   Dur = cm.duration;
   plist = local_infoLine(IDF, chan, ...
      'spl','SPL', ...
      'beatfreq', 'FDIFF', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case 'LMS',
   xName = 'FMOD';
   flim = {'lomodfreq', 'himodfreq', 'deltamodfreq'};
   [vchan, warnem] = local_pickChan(IDF, vchan, {flim{:}, 'duration'});
   xVal = local_getXval(IDF, vchan, flim{:});
   if abs(xVal(1)-UETvar(1,vchan)) > abs(xVal(2)-UETvar(1,vchan)),
      order = -1;
   else, order = 1;
   end
   xVal = Local_FixXval(xVal, order);
   Dur = st{vchan}.duration;
   plist = local_infoLine(IDF, chan, ...
      'spl','SPL', ...
      'carrierfreq', 'FCAR', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case 'IMS',
   xName = 'FMOD';
   flim = {'lomodfreq', 'himodfreq', 'deltamodfreq'};
   [vchan, warnem] = local_pickChan(IDF, vchan, {flim{:}, 'duration'});
   xVal = local_getXval(IDF, vchan, flim{:});
   if abs(xVal(1)-UETvar(1,vchan)) > abs(xVal(2)-UETvar(1,vchan)),
      order = -1;
   else, order = 1;
   end
   xVal = Local_FixXval(xVal, order);
   Dur = st{vchan}.duration;
   plist = local_infoLine(IDF, chan, ...
      'lospl','SPL', ...
      'carrierfreq', 'FCAR', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case {'SPL'},
   xName = 'SPL';
   flim = {'lospl', 'hispl', 'deltaspl'};
   [vchan, warnem] = local_pickChan(IDF, vchan, {flim{:}, 'duration'});
   xVal = local_getXval(IDF, vchan, flim{:});
   if abs(xVal(1)-UETvar(1,vchan)) > abs(xVal(2)-UETvar(1,vchan)),
      order = -1;
   else, order = 1;
   end
   xVal = Local_FixXval(xVal, order);
   Dur = st{vchan}.duration;
   plist = local_infoLine(IDF, chan, ...
      'freq', 'FCARR', ...
      'modfreq', 'FMOD', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case {'NTD'},
   % extract new-style params
   [Flow, Fhigh, Rho, RandSeed] = extractNewNoiseParams(IDF);
   % insert these params in cm
   cm = combineStruct(cm, collectInstruct(Flow, Fhigh, Rho, RandSeed));
   IDF.indiv.stimcmn = cm;
   xName = 'ITD';
   flim = {'start_itd', 'end_itd', 'delta_itd'};
   xVal = local_getXval(IDF, -1, flim{:});
   Dur = cm.duration;
   plist = local_infoLine(IDF, chan, ...
      'duration', 'DUR', ...
      'Flow', 'FLO', ...
      'Fhigh', 'FHI', ...
      'Rho', 'RHO', ...
      'RandSeed', 'RSEED', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
   vchan = 1; % conventionally, ITDs stored in left-chan UETvar
case {'NSPL'},
   [vchan, warnem] = local_pickChan(IDF, vchan, {'delattn', 'duration'});
   % extract new-style params
   [Flow, Fhigh, Rho, RandSeed, startSPL, endSPL, stepSPL] = extractNewNoiseParams(IDF);
   active = IDF.stimcntrl.activechan;
   [SPLsweepOK, SPL] = SPLsweepchecker(CollectInStruct(startSPL, stepSPL, endSPL, active), 0);
   vchan = idfLimitChan(IDF.stimcntrl.activechan, SPL);
   XVAL = SPL(:, vchan);
   usualXval = 0;
   % insert these params in cm
   cm = combineStruct(cm, collectInstruct(Flow, Fhigh, Rho, RandSeed, startSPL, endSPL, stepSPL));
   IDF.indiv.stimcmn = cm;
   xName = 'SPL';
   flim = {'startSPL', 'endSPL', 'stepSPL'};
   xVal = local_getXval(IDF, min(-1, -vchan), flim{:});
   Dur = st{vchan}.duration;
   plist = local_infoLine(IDF, chan, ...
      'duration', 'DUR', ...
      'Flow', 'FLO', ...
      'Fhigh', 'FHI', ...
      'Rho', 'RHO', ...
      'RandSeed', 'RSEED', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
otherwise, 
   h = [];
   rapfname = [];
   xName = [];
   vchan = [];
   warning([stimName '-to-RAP conversion not yet implemented']);
   return;
end

% prepend warnings
preh = '';
switch stimName,
case {'FSLOG','LMS'}, preh = [preh, '% LOGSTEPS!'];
end

if warnem, preh = [preh, '% CHECK SYMMETRY!'];
end


h = strvcat(preh, plist, RAPheader(datasetName, dataFileName, Nrep, Dur, Interval, ActChan, xName, xVal, yName, yVal));
   
%-----------------------------
function [vchan, warnem] = local_pickChan(IDF, vchan, stfn);
warnem = 0;
if vchan~=0, return; end;
vchan = 1; % default: left channel
st1 = IDF.indiv.stim{1};
st2 = IDF.indiv.stim{2};
OK = 1;
for ii=1:length(stfn),
   fn = stfn{ii};
   OK = OK & isequal(getfield(st1,fn),getfield(st2,fn));
end
warnem=~OK;

function XV = local_getXval(IDF, vchan, f0, f1, df);
if vchan>0, st = IDF.indiv.stim{vchan};
else, st = IDF.indiv.stimcmn;
end
if vchan<0, ichan = -vchan; else, ichan = 1; end;
X0 = getfield(st, f0);
X1 = getfield(st, f1);
DX = getfield(st, df);
if DX>0, % downward according to Farmington wisdom
   XV = [max(X0(ichan),X1(ichan)) min(X0(ichan),X1(ichan))  -DX(ichan)];
else, % upward idem
   XV = [min(X0(ichan),X1(ichan)) max(X0(ichan),X1(ichan))  -DX(ichan)];
end

function L = local_infoLine(IDF, chan, varargin);
maxLen = 88; 
Npar = round((nargin-2)/2);
st = IDF.indiv.stim;
cm = getFieldOrDef(IDF.indiv, 'stimcmn', nan);
L = '';
for ipar = 1:Npar,
   stNam = varargin{2*ipar-1};
   newNam = varargin{2*ipar};
   if isfield(st{1},stNam),
      if chan==0,
         sval = unique([getfield(st{1},stNam) getfield(st{2},stNam)]);
      else,
         sval = getfield(st{chan}, stNam);
      end
   else, sval = getfield(cm, stNam);
   end
   valstring = trimspace(num2str(sval(:)'));
   if length(sval)>1, valstring = ['[' valstring ']']; end; % provide brackets for multivalued params
   stStr = [newNam '=' valstring ';'];
   L = addToTextBlock(stStr, L, maxLen);
end


function xVal = Local_FixXval(xVal, order);
% sign of step
xVal(3) = abs(xVal(3))*sign(xVal(2)-xVal(1));
if xVal(3)*order<0, % flip the order
   xVal = xVal([2 1 3]).*[1 1 -1];
end






