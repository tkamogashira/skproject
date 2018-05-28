function [h, rapfname, xName, vchan] = IDF2rapheader(dataFileName,iseq, datasetName);

% function h = RAPheaderNewStyle(datasetName, dataFileName, Nrep, Dur, Interval, ActChan, xName, xVal, yName, yVal, Awin, MinIS, trialWin);
% new style: use Dataset function to retrieve data


if isnumeric(iseq), iseq = -iseq; end; % only farmington style data
try, ds = dataset(dataFileName, iseq);
catch,    
   h = [];
   rapfname = [];
   xName = [];
   vchan = [];
   warning(['Unable to read dataset ' datasetName]);
   return;
end;
if ~isequal('IDF/SPK',ds.fileformat), error('Non-Farmington data'); end;

x = ds.xval; % vector containing values of indep var in order of presentation
x = x(find(~isnan(x)));
dx = min(diff(x)); 
if isempty(dx), dx = 0; end
xVal = [x(1) x(end) dx]; % [Xstart Xend DX]
vchan = ds.activechan; if vchan==0, vchan=1; end;
try, Dur = max(ds.duration(vchan));
catch, Dur=nan;
end
yName = 'NONE';
yVal = [0 0 0];

rapfname = [dataFileName '-' num2str(-ds.iseq)  '-' ds.stimtype];

switch ds.stimtype,
case {'FS','FSLOG'},
   xName = 'FCARR';
   xVal = localFarmOrder(ds, vchan, 'freq');
   plist = local_infoLine(ds, ...
      'spl','SPL', ...
      'modfreq', 'FMOD', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case {'BFS'},
   xName = 'FCARR';
   xVal = localFarmOrder(ds, vchan, 'freq');
   plist = local_infoLine(ds, ...
      'spl','SPL', ...
      'beatfreq', 'FDIFF', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case 'LMS',
   xName = 'FMOD';
   xVal = localFarmOrder(ds, vchan, 'modfreq');
   plist = local_infoLine(ds, ...
      'spl','SPL', ...
      'carrierfreq', 'FCAR', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case 'IMS',
   xName = 'FMOD';
   xVal = localFarmOrder(ds, vchan, 'modfreq');
   plist = local_infoLine(ds, ...
      'lospl','SPL', ...
      'carrierfreq', 'FCAR', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case {'SPL'},
   xName = 'SPL';
   xVal = localFarmOrder(ds, vchan, 'spl');
   plist = local_infoLine(ds, ...
      'freq', 'FCARR', ...
      'modfreq', 'FMOD', ...
      'modpercent', 'DMOD', ...
      'delay', 'DELAY', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
case {'NTD'},
   xName = 'ITD';
   xVal = [ds.start_itd ds.end_itd ds.delta_itd];
   plist = local_infoLine(ds, ...
      'duration', 'DUR', ...
      'Flow', 'FLO', ...
      'Fhigh', 'FHI', ...
      'Rho', 'RHO', ...
      'RandomSeed', 'RSEED', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
   vchan = 1; % conventionally, ITDs stored in left-chan UETvar
case {'NSPL'},
   xName = 'SPL';
   xVal = localFarmOrder(ds, vchan, 'attn');
   minSPL = min(ds.total_pts);
   minAtt = min(xVal(1:2)); maxAtt = max(xVal(1:2)); 
   maxSPL = minSPL + (maxAtt-minAtt);
   if xVal(3)<0, 
      xVal=[minSPL maxSPL -xVal(3)];
   else, 
      xVal=[maxSPL minSPL -xVal(3)];
   end
   plist = local_infoLine(ds, ...
      'duration', 'DUR', ...
      'Flow', 'FLO', ...
      'Fhigh', 'FHI', ...
      'Rho', 'RHO', ...
      'RandomSeed', 'RSEED', ...
      'rise', 'TRISE', ...
      'fall', 'TFALL' ...
      );
otherwise, 
   h = [];
   rapfname = [];
   xName = [];
   vchan = [];
   warning([ds.stimtype '-to-RAP conversion not yet implemented']);
   return;
end

% prepend warnings
preh = '';
switch ds.stimtype,
case {'FSLOG','LMS'}, preh = [preh, '% LOGSTEPS!'];
end

switch ds.activechan
case 0, ActChan = 'YY';
case 1, ActChan = 'YN';
case 2, ActChan = 'NY';
end
h = strvcat(preh, plist, RAPheader(datasetName, dataFileName, ds.Nrep, Dur, ds.Interval, ActChan, xName, xVal, yName, yVal));
   
%-----------------------------
function  xVal = localFarmOrder(ds, ch, fn);
flo = ['lo' fn];
fhi = ['hi' fn]; 
fde = ['delta' fn];
%
xlo = getfield(ds, flo); xlo = xlo(min(end,ch));
xhi = getfield(ds, fhi); xhi = xhi(min(end,ch));
try,
   xde = getfield(ds, fde); 
catch,
   xde = getfield(ds, ['del' fn]); 
end
xde = xde(min(end,ch));
if xde<0, % upward according to Farmington wisdom
   xVal = [min(xlo,xhi) max(xlo,xhi) -xde];
else, % downw idem
   xVal = [max(xlo,xhi) min(xlo,xhi) -xde];
end



function L = local_infoLine(ds, varargin);
maxLen = 88; 
Npar = round((nargin-2)/2);
L = '';
for ipar = 1:Npar,
   stNam = varargin{2*ipar-1};
   newNam = varargin{2*ipar};
   sval = unique(getfield(ds,stNam));
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






