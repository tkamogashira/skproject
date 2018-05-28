function sd=dataDir(D)
% DATADIR - returns data directory as char string
%   DATADIR returns current datadir
%   DATADIR(D) sets it to D
global DEFDIRS
if nargin<1,
   try
       sd = DEFDIRS.IdfSpk;
   catch
       local_setdd;
   end
else
   if exist(D,'dir')
      DEFDIRS.IdfSpk = D;
   else
       local_setdd;
   end
end

% ---------------
function local_setdd
ViewDirectories init
