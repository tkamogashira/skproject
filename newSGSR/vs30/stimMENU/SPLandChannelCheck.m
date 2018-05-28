function [OK, SPLs, activeCh, SPLs2] = SPLandChannelCheck(forceBothActive,singleLevel,EnableSweep);

% reads & checks  SPL/active D/A-channel part of
% most stimmenus
if nargin<1, forceBothActive = 0; end
if nargin<2, singleLevel = 0; end
if nargin<3, EnableSweep = [0 0]; end;
OK = 0;

global StimMenuStatus
hh = StimMenuStatus.handles; 
textcolors;

if isequal(-1, singleLevel), maxNspl = 30; 
elseif singleLevel, maxNspl = 1;
else, maxNspl = 2;
end;

SPLs = UIdoubleFromStr(hh.LevelEdit,maxNspl,EnableSweep(1));
if nargout>3,
   if EnableSweep(2), maxNspl = inf; end;
   SPLs2 = UIdoubleFromStr(hh.Level2Edit,maxNspl,EnableSweep(2));
end

[activeCh, acOK] = activeChanCheck;
if ~acOK, return; end

if isnan(SPLs),
   UIerror('non-numerical values of numerical parameters');
   return;
end
if isinf(SPLs),
   UIerror('too many numbers entered in SPL field', hh.LevelEdit);
   return;
end

if nargout>3,
   if isnan(SPLs2),
      UIerror('non-numerical values of numerical parameters');
      return;
   end
   if isinf(SPLs2),
      UIerror('too many numbers entered in SPL field', hh.Level2Edit);
      return;
   end
end

OK = 1;