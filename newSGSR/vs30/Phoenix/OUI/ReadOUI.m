function [S, mess] = ReadOUI(ParamSetName);
% readOUI = read parameter values from current paramOUI
%   S = readOUI returns a paramset object S that contains the 
%   parameters as they are displayed in the current OUI. 
%   If any invalid input is encountered, an empty S is returned.
%   If multiple paramsets are contained in the OUI, S will 
%   be an paramset array. 
%   The difference between OUIdata and ReadOUI is that OUIdata
%   always returns the factory settings of the parameters;
%   ReadOUI returns the values entered by the user.
%
%   S = readOUI('FOO') only retrieves the parameterset whose
%   type or name is FOO.
%   Any parameters of other paramsets than FOO contained in the OUI
%   are not considered. Use the syntax readOUI({'FOO', 'GOO'}) to
%   select multiple paramsets.
%
%   [S, mess] also returns a message describing what went wrong
%   during retrieval - if anything. 
%
%   If multiple OUIs are opened, paramOUI(figh) can be used to select
%   a single OUI. 
%
%   See also parameter/setvalue, OUIdata, paramOUI.

if nargin<1, ParamSetName=''; end;
mess = '';

SI = OUIdata;
allTypes = types(SI.ParamData); % all paramset types
allNames = names(SI.ParamData); % all paramset names
if isempty(ParamSetName), ParamSetName = allNames; end % take 'm all

ParamSetName = cellstr(ParamSetName); % now numel gives # names, not # chars in a single name!
S = paramset; % initialize: empty paramset
for ii=1:numel(ParamSetName),
   [S, mess] = localReadSingleParamset(S, ParamSetName{ii}, allNames, allTypes);
   if OUIerror(mess), return; end
end
   
%=============locals============
function [S, mess] = localReadSingleParamset(S, pname, allNames, allTypes);
mess = '';
iset = strmatch(lower(pname), lower(allNames), 'exact');
jset = strmatch(lower(pname), lower(allTypes), 'exact');
if isempty(iset) & isempty(jset),
   error(['Active OUI does not contain a paramset typed or named ''' pname '''.']);
elseif ~isempty(iset) & ~isempty(jset),
   error(['Ambiguous paramset spec ''' pname ''' occurs both as type and as name in active OUI.'])
end
% get the selected paramset
SI = OUIdata; 
if ~isempty(jset), Sselect = SI.ParamData(jset);
else,  Sselect = SI.ParamData(iset);
end
Items = Sselect.OUI.item;
iquery = strmatch('query', {Items.class}, 'exact'); % indices of query-class items
Q = Sselect.OUI.item(iquery);
for ii=1:length(Q), % visit each query
   q = Q(ii);
   [h, s] = OUIhandle(q.name);
   if isequal('off', get(h,'visible')), % not fair to complain about invisible stuff
      continue;
   elseif isequal('off', get(h,'enable')), % disabled; mark as such
      P = getfield(Sselect, q.name);
      P.datatype = 'disabled';
   else, % regular case: read string, try to set value of parameter accordingly
      set(h,'foregroundcolor', [0 0 0]);
      P = getfield(Sselect, q.name);
      [P, mess] = setValue(P, s);
   end 
   Sselect = setfield(Sselect, q.name, P);
   if ~isempty(mess),
      if isempty(s), OUIhandle(q.name, '??'); mess = 'Missing value.'; end
      set(h,'foregroundcolor', [1 0 0]); % bright red on white backgrouns of edit or gray button
      S = paramset; % void paramset object
      return;
   end
end
% success: add element to S
if isvoid(S), S = Sselect;
else, S = [S Sselect];
end










