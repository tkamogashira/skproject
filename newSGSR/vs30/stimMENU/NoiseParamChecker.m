function [OK, lowFreq, highFreq, rho, NoiseChar, VarChan] = NoiseParamChecker(MultRho, Freeze);
if nargin<1, MultRho=0; end; % default: do not allow  multiple rho values
if nargin<2, Freeze=0; end; % default: running noise enabled

% pick up menu handles
global StimMenuStatus
hh = StimMenuStatus.handles;

OK = 0;
%--------frequencies----------------------
lowFreq = nan;
highFreq = nan;
rho = nan;
NoiseChar = nan;
% get low/high freq from dedicated function
[lowFreq, highFreq, frOK] = noiseParamCallback(hh.Root);
if ~frOK, return; end;

%-----------------rho-----------------------------------------
if nargout>3,
   textcolors;
   rh = hh.RhoEdit;
   if MultRho,
      rstr = getstring(rh);
      if isempty(rstr), setstring(rh,'??'); end;
      try, 
         rho = eval(rstr);
         rho = rho(:); % column vector
      end % try/catch
      if ~isreal(rho), 
         rho = nan; 
         set(rh,'foregroundcolor',RED);
      end;
   else,
      rho = UIdoubleFromStr(rh,1);
   end
   % rho bounds
   if any(abs(rho)>1),
      UIerror('Values of rho must lie between -1 and +1', hh.RhoEdit);
      return;
   end
end
%-----------------noise character(optional)-----------------------------------------
NoiseChar = 0;
if isfield(hh, 'NoiseCharButton'),
   if Freeze, % disable running noise
      nch = hh.NoiseCharButton; 
      setstring(nch,'frozen'); 
      set(nch,'userdata',1); 
      set(nch,'callback','');
      set(nch,'tooltip','');
      set(hh.NoiseCharPrompt, 'tooltip', '');
   end
   if nargout>4,
      NoiseChar = get(hh.NoiseCharButton,'userdata')-1; % 0|1 = frozen|running
   end
end

if nargout>5, % get varchan
   VarChan = get(hh.VarChanButton, 'userdata');
   % warn if varied channel is not active
   activeCh = activeChanCheck;
   if ~isequal(0,activeCh),
      if ~isequal(activeCh, VarChan),
         mess = 'Varied DA channel is not active';
         if StimMenuWarn(mess, hh.VarChanButton), return; end;
      end
   end
end

OK = 1;











