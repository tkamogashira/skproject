function [CarSwept, CarFreq, OK] = BFSweepChecker(figh);
% BFSweepChecker - params checker & callback for BFSweep unit
if nargin<1, figh=gcbf; end;

OK = 0;
hh = stimmenuhandles;
SWh = hh.SweepWhatButton;
CFh = hh.CarFreqEdit;

CarSwept = 2-get(SWh,'userdata');
if CarSwept,
   [CarFreq, cfOK] = localGetCarFreq(CFh);
   if ~cfOK, return; end
else, CarFreq = 0;
end
OK = 1;
localSetVis(CarSwept,CFh);
if nargin>1, return; end; % this was a call from BFScheck
%---from here: callback operation----
TAG = get(gcbo,'tag');
switch TAG
case 'SweepWhatButton',
   localSwapSwept(CarSwept, SWh, CFh);
otherwise, error(['unknown uicontrol atagged ''' TAG '''']);
end % case
%------------------
function [CarFreq, OK]=localGetCarFreq(CFh);
OK = 0;
CarFreq = abs(uidoubleFromStr(CFh,1));
if ~checkNaNandInf(CarFreq), return; end;
if (CarFreq>MaxStimFreq),
   UIerror('Carrier Freq too high',CFh);
elseif (CarFreq==0),
   UIerror('Carrier Freq muist be positive',CFh);
else, OK = 1;
end
%--
function localSetVis(CarSwept, CFh);
if CarSwept, set(CFh,'visible', 'off');
else, set(CFh,'visible', 'on');
end
%--
function localSwapSwept(CarSwept, SWh, CFh);
if CarSwept, % car->mod
   set(SWh, 'string', 'modulation');
   set(SWh, 'userdata', 1);
else, % mod-> car
   set(SWh, 'string', 'carrier');
   set(SWh, 'userdata', 2);
end
localSetVis(~CarSwept, CFh);
