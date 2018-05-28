function fixTrain(keyword, varargin);
% fixTrain - fixation training
Dev = 'RP2_2'; 

if nargin<1, % try tag of gcbo; default is 'init'
   h = gcbo;
   if isonehandle(h),
      keyword = get(h, 'tag');
   else,
      keyword = 'init'; 
   end
end



switch lower(keyword), 
case 'init', localInit(Dev, varargin{:});
case 'keypress', 
   if nargin<2, ch = get(gcf,'currentchar'); else, ch = varargin{1}; end
   localKey(Dev, ch);
otherwise, error(['Invalid keyword ''' keyword '''.']);
end

%==================================================
function localInit(Dev, varargin);
% make sure activeX stuff in intialized; do it now or interference with paramOUI might result
try, sys3getpar('fixtraining.ID', 'RP2_2'); catch, sys3dev; end 
% initialize OUI
maxNreward = 12; BigButt = [51 25]; % size of big button
FX = paramset('OUIparam', 'FIX', 'Fixation training', 1, [700 440], mfilename);
FX = AddParam(FX,  'gracetime',       500,  'ms',  'ureal',  1);
FX = AddParam(FX,  'LEDofftime', 2000,  'ms',  'ureal',  1);
FX = AddParam(FX,  'Timeout', 200,  's',  'ureal',  1);
for ii=1:maxNreward,
   iistr = num2str(ii); defval = 100*double(ii==1);
   FX = AddParam(FX,  ['fixdur_'  iistr],  defval, 'ms', 'ureal',  1);
   FX = AddParam(FX,  ['drinkdur_' iistr],  100,   'ms', 'ureal',  1);
   FX = AddParam(FX,  ['pausedur_' iistr],  0,     'ms', 'ureal',  1);
end
%===
FX = InitOUIgroup(FX, 'Generics', [480 10 205 75]);
FX = DefineQuery(FX, 'gracetime', 0, 'edit', 'grace time:', '12000', 'Maximum interval between LED-on time and fixation. A timeoff is called when fixation is not reached after the grace time has elapsed.' );
FX = DefineQuery(FX, 'LEDofftime', 20, 'edit', 'off-time:', '12000', 'Duration of timeoff after failing to fixate within the grace time.' );
FX = DefineQuery(FX, 'TimeOut', [10 40], 'edit', 'time out:', '20', 'Timout after which to abort ongoing traning block.' );
FX = defineReporter(FX, 'Start', [130 10], 'Hit ''S'' to start.    ', '', 'fontsize', 12);
FX = defineReporter(FX, 'Stop', [130 30], 'Hit ''Q'' to quit.    ', '', 'fontsize', 12);
FX = defineReporter(FX, 'Help', [130 50], 'Hit ''H'' for help.    ', '', 'fontsize', 12);
%===
FX = InitOUIgroup(FX, 'messages', [480 90 205 76]);
FX = defineReporter(FX, 'stdmess', [15 5], [15-1e6 68]);
%===
FX = InitOUIgroup(FX, 'Timing_details', [480 175 205 20+maxNreward*20]);
FX = defineReporter(FX, 'Timing', [20 10], '-----------------------------------------------------------------');
for ii=1:maxNreward,
   iistr = num2str(ii);
   prompt = [iistr ' ']; if ii<10, prompt = [' ' prompt]; end;
   switch ii, case 1, nth = '1st'; case 2, nth = '2nd'; case 3, nth = '3rd'; otherwise, nth = [iistr 'th']; end
   Ypos = 10 + 20*(ii-1);
   FX = DefineQuery(FX, ['fixdur_' iistr],  [10 Ypos], 'edit', prompt, '12000', ...
      ['Fixation interval before ' nth ' reward. Zero indicates end of block.'] );
   FX = DefineQuery(FX, ['drinkdur_' iistr], [70 Ypos], 'edit', ' ', '12000', ...
      ['Duration of ' nth ' reward.'] );
   FX = DefineQuery(FX, ['pausedur_' iistr], [120 Ypos], 'edit', ' ', '12000', ...
      ['Duration of LED-off pause following ' nth ' reward.'] );
end
paramoui(FX);
% remove units of fixdur and rewarddur columns
for ii=1:maxNreward,
   iistr = num2str(ii);
   delete(ouihandle(['fixdur_' iistr '.unit']));
   delete(ouihandle(['drinkdur_' iistr '.unit']));
end
OUIdefault('impose');
OUIhandle('start', 'Hit ''S'' to start.' ); OUIhandle('stop', 'Hit ''Q'' to quit.' ); OUIhandle('help', 'Hit ''H'' for help.' ); 
OUIhandle('timing', '  Fixation              Reward          Pause' ); 
figh = paramOUI;
% RP2 circuit
eyedisplay('init', Dev, 'fixtraining', figh);
delete(findobj(figh, 'tag', 'patch1Text'));
set(figh, 'keypressfcn', [mfilename ' keypress;']);
drawnow;
sys3halt(Dev);
sys3run(Dev);
sys3trig(2,Dev); % don't run at once

function IV = localInterrupt(IV);
persistent interruptValue
if isempty(interruptValue), interruptValue=0; end
if nargin>0, interruptValue = IV; end
IV = interruptValue;

function localKey(Dev, ch);
% handle keypress
switch lower(ch),
case 's', 
   if localUpload(Dev),
      localInterrupt(0); % clear interrupt value
      sys3trig(1, Dev); % this starts the training
      OUIreport('Training started.', '-append');
      localTimeOut(Dev);
   end
case 'q',
      sys3trig(2, Dev); % this stops the training
      localInterrupt(1); % set interrupt value
      OUIreport('Training interrupted.');
case 'h', 
   helpStr = {'Click over plot to (re)enter keymode', 'Click & drag to move target frame.', ...
         '---Keys in key mode---', ...
         '  SPACE to toggle tracking eye position.', ...
         '  <> to resize target frame.', ...
         '  S to start a training block.', ...
         '  Q to interrupt ongoing training block.'};
   ouiReport(helpStr);
otherwise, % delegate to eyedisplay
   eyedisplay('keypress', '', ch);
end

function localTimeOut(Dev, T);
persistent TimeOut
if nargin>1, % set persistent timeout
   TimeOut = T; 
   return;
end
tic;
while 1,
   Idle = sys3getpar('isIDLE', Dev);
   if Idle & ~localInterrupt, 
      OUIreport('Training block finished.'); 
      break;
   end
   if toc>TimeOut, 
      sys3trig(2, Dev); % this stops the training
      OUIreport('Training aborted - TIME OUT');
      break;
   end
   pause(0.2);
end


function OK = localUpload(Dev);
% read params from OUI and upload them to the circuit
OK = 0; % pessimist default
FX = readOUI;
if isvoid(FX), return; end; % invalid params etc
% put fix times and drink times in array
[Dfix, Ddrink, Dpause] = deal([]);
for ii=1:1000,
   iistr = num2str(ii);
   fxn = ['fixdur_' iistr];
   drn = ['drinkdur_' iistr];
   pan = ['pausedur_' iistr];
   if ~hasQuery(FX, fxn), break; end;
   Dfix = [Dfix eval(['FX.' fxn '.in_ms;'])];   % FX.fixdur_1 etc
   Ddrink = [Ddrink eval(['FX.' drn '.in_ms;'])]; % FX.drinkdur_1 etc
   Dpause = [Dpause eval(['FX.' pan '.in_ms;'])]; % FX.pausedur_1 etc
end
Dfix = [Dfix 0]; Ddrink = [Ddrink 0]; Dpause = [Dpause 0]; % provide stopping zero to make sure the block will end
% the error sieve
emess = ''; eh = {};
if any(Dfix>10e3), emess = 'Fixation times may not exceed 10 s'; end
if any(Ddrink>2000), emess = 'Drinking times may not exceed 2000 ms'; end
if any(Dpause>10e5), emess = 'Pause times may not exceed 100 s'; end
if OUIerror(emess, eh), return; end
OUIreport('Parameters OK.');
OUIdefault('save', FX);
localTimeOut(Dev, FX.Timeout.in_s); % pass timeout value to loacl fcn
ipause = find(Dpause~=0);
inonpause = find(Dpause==0);
% remove zero-valued pauses themselves
Dpause(inonpause) = [];
Ddrink(ipause) = -Ddrink(ipause); % invert sign of reward duration followed by nonzero pause, so that the circuit knows when to expect a pause
% convert all times to sample counts; % make sure all uploaded vectors have at least 2 elements or sys3write will crash
Fsam = 1e-3*initboardLeds('fsam', Dev, 'fixtraining'); % in kHz 
Ngrace = round(Fsam*FX.gracetime.in_ms);
NLEDofftime = round(Fsam*FX.LEDofftime.in_ms);
Nfix = [round(Fsam*Dfix) 0 0];
Ndrink = [round(Fsam*Ddrink) 0 0];
Npause = [round(Fsam*Dpause) 0 0]; 
% upload
try,
   sys3setpar(Ngrace, 'Tgrace', Dev);
   sys3setpar(NLEDofftime, 'Toff', Dev);
   sys3write(Nfix, 'DurFix', Dev, 0, 'I32');
   sys3write(Ndrink, 'DurReward', Dev, 0, 'I32');
   sys3write(Npause, 'DurPause', Dev, 0, 'I32');
   OUIreport('Parameters uploaded.', '-append');
catch,
   OUIerror({'Trouble uploading parameters.', 'Matlab complains:', lasterr});
   return;
end
OK = 1;







