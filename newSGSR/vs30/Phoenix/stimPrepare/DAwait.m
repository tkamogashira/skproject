function IRR = DAwait(TimeOut);
% DAwait - wait for ongoing D/A conversion to finish
%   DAwait pauses until current D/A has finished. The
%   device to be queried depends on TDTsystem.
%   If nothing special or irregular happened during D/A conversion,
%   DAwait returns 0. DAwait reurns one if D/A conversion
%   was interrupted by DAstop or if the Timout was reached (see below).
%
%   DAwait(T) uses a timeout of T ms. Default T is inf.
%
%   see also stimulus/play, TDTsystem, DAhalt.

IRR = 0;
if nargin<1, TimeOut = inf; end
switch TDTsystem,
case 'sys2',
   tic; 
   while 1,
      if (1e3*toc>TimeOut) | DAhalt('status'),
         IRR = 1;
         return;
      end
      for ii=1:33,
         if isequal(0, s232('PD1status',1)), return; end
      end
      drawnow; % allow interrupts to come through
   end
case 'sys3',
   error NYI;
otherwise,
   error(['DAwait for TDTsystem = ''' TDTsystem ''' not implemented.']);
end


