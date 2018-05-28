function [str, ini]= SessionInfoString(fighandle);

global SESSION;

% default values
str = 'No session initialized yet';
ini = 0;

try,
   if isempty(SESSION), error('jumptoentry'); end;
   rec1 = min(SESSION.SeqRecorded);
   rec2 = max(SESSION.SeqRecorded);
   if isempty(rec1), recstr = 'none';
   elseif rec1==rec2, recstr = num2str(rec1);
   else, recstr = [num2str(rec1) '..' num2str(rec2)];
   end
   
   switch SESSION.DAchannel
   case 'B', dac = 'Both';
   case 'L', dac = 'Left';
   case 'R', dac = 'Right';
   end
   
   str = strvcat(...
      ['Data Files: ' SESSION.dataFile],...
      ['Next sequence to record: ' num2str(SESSION.iSeq)],...
      ['Recorded during this session: ' recstr],...
      ['Recording side: ' SESSION.RecordingSide],...
      ['DAC channels used: ' dac],...
      ['ERC file: ' SESSION.ERCfile]);
   ini = 1;
end % try

if nargin>0,
   if isstr(fighandle),
      fighandle = findobj('tag',fighandle);
   end
   hh = findobj(fighandle,'tag','SessionText');
   set(hh,'string', str);
end


