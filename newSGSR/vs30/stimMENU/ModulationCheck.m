function [OK, modDepth, modFreq, AnyModulation] = ModulationCheck(singleModFreq);

% reads & checks  modulation part of a number of stimmenus

if nargin<1, singleModFreq=0; end;

if singleModFreq, maxNMF = 1;
else, maxNMF = 2;
end


global StimMenuStatus
hh = StimMenuStatus.handles;

BLACK = [0 0 0];
GRAY = 0.5+BLACK;
RED = [1 0 0];
PURPLE = 0.6*[1 0 1];

OK = 0;

modDepth = abs(UIdoubleFromStr(hh.ModDepthEdit,2));
modFreq = abs(UIdoubleFromStr(hh.ModFreqEdit, maxNMF));
AnyModulation = NaN; % supress warnings in case of premature return

if ~CheckNanAndInf([modDepth modFreq]), return; end;

DontModulate = all((modFreq==0)  | (modDepth==0));
if DontModulate,
   UItextColor(hh.ModulationFrameTitle, GRAY);
else, 
   UItextColor(hh.ModulationFrameTitle, BLACK);
end
AnyModulation = ~DontModulate;
OK = 1;
