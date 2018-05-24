function qstart(varargin);
% personal MatLab startup file - template

global UserName % this global is set by <MatLabRoot>\local\qstart, i.e., the calling function

% start SGSR
cd c:\SGSR\startupdir
startup

% set data directory
dataDir(['c:\ExpData\Spikes']);

% set current dir
cd(['C:\USR\' UserName '\mfiles']);

  
