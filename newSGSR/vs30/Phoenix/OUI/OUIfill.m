function mess = OUIfill(S, ignoreProblems);
% OUIfill - set queries of OUI to match values in paramset
%   OUIfill(S) fills the edits and sets the toggles to match the
%   parameter values stored in paramset S. 
%   OUIfill returns '' if all went well, or else a message 
%   describing what went wrong, e.g., an attempt to set a 
%   non-existing query.
%
%   By convention, parameters in S whos datatype equals
%   'disabled' are not imposed on the OUI. In order to
%   signal these omissions, the foreground color of the
%   OUI items of the disabled parameters is set to purple.
%
%   OUIfill(S, 1) does not stop when something goes wrong.
%
%   See also paramOUI, readOUI.

if nargin<2, ignoreProblems=0; end

mess = ''; % optimist default

if numel(S)>1, % recursive call
   for ii=1:numel(S),
      mess = OUIfill(S(ii), ignoreProblems);
      if ~isempty(mess) & ~ignoreProblems, 
         break; 
      end
   end
   return
end

%----single-elemenent S from here-----------

GD = ouiData;
figure(GD.handles.Root); % bring OUI to the fore
OUI_S = GD.ParamData; % paramset(s) carried by OUI

for ii=1:numel(S.param),
   p = S.param(ii);
   if isequal('disable', p.datatype), continue; end % see help text & OUIitemContextMenuCallback
   if ~any(hasQuery(OUI_S, p.name)),
      mess = strvcat(mess, ['Current OUI contains no query for parameter ''' p.name '''.']);
      if ~ignoreProblems, return; end;
   end
end
% if we survived the previous loop, we can fill the uicontrols
for ii=1:numel(S.param),
   p = S.param(ii);
   % find out what kind of item we are dealing with
   item = OUIitem(p.name);
   if isempty(item) & ignoreProblems, continue; end % just jump to next item
   if isequal('disabled', p.datatype), 
      OUIhandle(p.name, nan, 'foregroundcolor', [0.8 0 1]);
      continue; 
   end % see help text & OUIitemContextMenuCallback
   qstyle = item.spec.spec{1};
   switch qstyle,
   case 'edit', % simply fill the edit with the parameter's valueStr
      OUIhandle(p.name, p.valueStr);
   case 'toggle',
      % p.name, p.valueStr,
      toggleCallback(p.name, p.valueStr);
   otherwise, error NYI
   end
end





