function [limlevel, limlabel] = updateMaxSPLinfo(maxSPLleft, maxSPLright, ...
   nominalFreqs, activeChan, ReportSingleFreq);

if nargin<5, ReportSingleFreq=0; end;

FreqReportType = 'both'; % default
if ReportSingleFreq | ~isequal(0,activeChan),
   FreqReportType = 'one';
end
if isnumeric(nominalFreqs),
   if any(isnan(nominalFreqs)),
      FreqReportType = 'none';
   end
end

Nchan = size(maxSPLleft,2)+size(maxSPLright,2); % not necessarily equal to #ACTIVE channels!
limlevel = zeros(1,Nchan)+inf;
limlabel = zeros(1,Nchan)+nan;
% LEFT
if ~isequal(activeChan,2),
   % extract labels
   if iscell(nominalFreqs), labL = nominalFreqs{1};
   else, labL = nominalFreqs(:,1); % first column
   end
   % find most critical and its label
   [llev llab] = findMaxSPL(maxSPLleft,labL);
   llev = 0.1*floor(10*llev);
   limlevel(1) = llev;
   limlabel(1) = llab;
   sll{1} = num2str(llev);
   slf{1} = num2str(llab);
end
% RIGHT
if ~isequal(activeChan,1),
   % extract labels
   if iscell(nominalFreqs), labR = nominalFreqs{end};
   else, labR = nominalFreqs(:,end); % last column
   end
   % find most critical and its label
   [llev llab] = findMaxSPL(maxSPLright,labR);
   llev = 0.1*floor(10*llev);
   limlevel(end) = llev;
   limlabel(end) = llab;
   sll{2} = num2str(llev);
   slf{2} = num2str(llab);
end


if activeChan==0, 
   line1 = ['max:  [' sll{1} ' ' sll{2} '] dB at ...'];
   switch FreqReportType
   case 'one'
      line2 = [ '... ' slf{1} ' Hz'];
   case 'both'
      line2 = ['... [' slf{1} ' ' slf{2} '] Hz'];
   case 'none'
      line1 = ['max:  [' sll{1} ' ' sll{2} '] dB'];
      line2 = '';
   end % switch
else, % single channel
   switch FreqReportType
   case 'none'
      cc = activeChan;
      line1 = ['max:  ' sll{cc} ' dB'];
      line2 = '';
   otherwise
      cc = activeChan;
      line1 = ['max:  ' sll{cc} ' dB at ...'];
      line2 = ['... ' slf{cc} ' Hz'];
   end
end

MaxSPLinfo = strvcat(line1, line2);
try, % write to text control
   global StimMenuStatus
   hh = StimMenuStatus.handles;
   setstring(hh.MaxSPLinfo, MaxSPLinfo);
catch % write to screen
   disp(MaxSPLinfo);
end


