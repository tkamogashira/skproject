function SR = subsref(S, subscript);
% paramset/subsref - subsref for paramset objects
%   S.foo returns virtual field of paramset object S.
%   foo is one of:
%    type
%    name
%    description, descr
%    createdby, creator
%    params, param, stimparam, stimparams
%    values, value
%    units, unit
%    query, queries
%    oui
%    ouilist
%    qlist
%    help
%
%   See also paramset, paramset/subsasgn.

if length(subscript)>1, % handle by recursion
   S = subsref(S, subscript(1));
   SR = subsref(S, subscript(2:end));
   return;
end

% -----------single-level subscript from here
trivial = 1;
switch subscript.type,
case '()', 
   SR = builtin('subsref', S, subscript);
case '{}', error('S{...} not defined for paramset objects.');
otherwise, trivial = 0;
end
if trivial, return; end

% -----------single field reference from here
if numel(S)>1,
   error('Fields reference of paramset arrays is an error.'); 
end

fn = subscript.subs; % virtual fieldname
pIndex = ParamIndex(S, fn);
if ~isnan(pIndex), SR = S.Stimparam(pIndex); 
else, 
   switch lower(fn),
   case {'help'},
      help paramset/subsref; SR = [];
   case {'type'},
      SR = S.Type;
   case {'name'},
      SR = S.Name;
   case {'description', 'descr'},
      SR = S.Description;
   case {'createdby', 'creator'},
      SR = S.createdBy;
   case {'params', 'param', 'stimparam', 'stimparams'}, % return parameter array
      SR = S.Stimparam;
   case {'values', 'value'},
      if isempty(S.Stimparam), SR = []; 
      else, % return parameter values in struct using param names as fieldnames
         Names = {S.Stimparam.Name};
         Values = {S.Stimparam.Value};
         NV = {Names{:}; Values{:}}; NV = NV(:); % zipped name-value-name-value...
         SR = struct(NV{:});
      end
   case {'units', 'unit'},
      if isempty(S.Stimparam), SR = []; 
      else, % return parameter values in struct using param names as fieldnames
         Names = {S.Stimparam.Name};
         Units = {S.Stimparam.Unit};
         NV = {Names{:}; Units{:}}; NV = NV(:); % zipped name-value-name-value...
         SR = struct(NV{:});
      end
   case {'query', 'queries'},
      SR = query; % avoid type mismatch in subasgn below
      if isempty(S.OUI), SR(1) = []; return; end % return empty query object
      for ii=1:length(S.OUI.query),
         q = S.OUI.query(ii);
         SR(ii) = query(S.Stimparam(q.iparam), q.spec{:});
      end
   case {'oui'},
      SR = S.OUI;
   case {'ouilist'},
      SR = structdisp(rmfield(S.OUI.item, 'spec'));
   case {'qlist'}, % display of queries and their groups
      dp = ''; if nargout>0, SR=''; end;
      oldGroupName = '';
      for ii=1:length(S.OUI.item),
         it = S.OUI.item(ii);
         groupname = S.OUI.group(it.igroup).Name;
         if ~isequal(oldGroupName, groupname),
            dp = strvcat(dp, ['-----' groupname '-----']);
            oldGroupName = groupname;
         end
         if isequal('query', it.class),
            qq = query(S.Stimparam(it.spec.iparam), it.spec.spec{:});
            dp = strvcat(dp, disp(qq,2));
            if nargout==0, disp(dp),
            else, SR = dp;
            end
         end
      end
   otherwise, error(['Invalid field ''' fn '''.']);
   end
end;








