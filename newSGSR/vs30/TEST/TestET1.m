function [T, Tbyte] = TestET1(Dev, skipFirsthalf, Interval);

if nargin<1, Dev=1; end;
if nargin<2, skipFirsthalf=0; end;
if nargin<3, Interval = 500; end; % default 500 ms of pulse recording
AutoRun = 0;
if Interval<0, % "autorun" - no prompts; plot only when errors occur
   Interval = -Interval;
   AutoRun = 1;
end


if ~skipFirsthalf
   disp('disconnect inputs of ET1');
   disp('hit return to continue...');
   pause
   disp(' ');
   
   % test et1report from software
   Nzeros = 103;
   s232('ET1clear', Dev);
   for ii=1:Nzeros,
      s232('ET1go', Dev); % each et1go should place one zero in FIFO
   end
   s232('ET1stop', Dev);
   
   % A. check # events returned by ET1report
   Nrecorded = s232('ET1report', Dev);
   if ~isequal(Nzeros, Nrecorded),
      disp('>>ERROR - # zeros reported is unequal to # zeros sent');
   else,
      disp('>>ET1report OK');
      disp(' ');
   end
   
   % B. check if there are really N zeros
   T = [];
   while 1, % don't rely on ET1report - break when encountering -1
      t = s232('ET1read32', Dev);
      if isequal(t,-1), 
         break; 
      else,
         T = [T t];
      end;
   end
   if ~isequal(T,zeros(1,Nzeros)),
      disp('>>ERROR - recorded events do no match zeros sent');
   else,
      disp('>>correct # zeros read'); 
      disp(' ');
   end
end % if skipFirsthalf

% C. check "real" events from a pulse generator
if ~AutoRun,
   disp(' ');
   disp('connect TTL pulse generator to IN-1 connector of ET1');
   disp('(frequency about 1 kHz)');
   disp('hit return to continue...');
   pause
end
s232('ET1clear', Dev);
tic;
s232('ET1go', Dev);
pause(Interval*1e-3); % ms->s
s232('ET1stop', Dev);
TrueInterval = 1e3*toc; % s->ms
% read events
if ~AutoRun, disp('loading events from ET1...'); end;
T = [];
while 1, % don't rely on ET1report - break when encountering -1
   t = s232('ET1read32', Dev);
   if isequal(t,-1), 
      break; 
   else,
      T = [T t];
   end;
end
if ~AutoRun, disp('done'); disp(' '); end;
% C1. check if event times increase monotonically
NonDec = 0;
if any(diff(T)<0),
   disp('>>ERROR - event times are non-increasing');
   NonDec = 1;
elseif ~AutoRun,
   disp('>>event times increasing')
   disp(' ');
end
% C2. check for unrealistic high numbers
upperLimit = TrueInterval*1.5e3; % ms -> us; factor of 1.5
TooBig = 0;
if any(T>upperLimit),
   disp(['>>ERROR - unrealistic high event times (max= ' num2str(1e-6*max(T)) ' s)']);
   TooBig = 1;
elseif ~AutoRun,
   disp('>>event times within reasonable range')
end
% plot event times if needed
if (~AutoRun) | TooBig | NonDec,
   figure; 
   plot(1e-6*T);
   xlabel('event count');
   ylabel('event time (s)');
end

Tbyte = byterep(T);












