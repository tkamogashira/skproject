function varargout = Subsref(P, subscript);
% Parameter/Subsref - Subsref for Parameter objects
%   P.value returns current value of parameter
%
%   See also ...

NP = numel(P);
if (NP>1), % multiple outargs?
   if isequal('.', subscript(1).type), % element-wise recursive call
      if length(subscript)>1,
         error(['Field reference for multiple structure elements that is followed ', ...
               'by more reference blocks is an error.']); % cf MatLab builtin subsref
      end
      for ii = 1:NP, % there is a weird inversion of the order of the outputs...
         Pii = P(ii); % ...this is a bug in MatLab's syntax handling
         ErrorOnNewRelease('12.1');
         varargout{NP+1-ii} = subsref(P(ii), subscript);
      end
   elseif isequal('()', subscript(1).type), % P(subs1)...
      % In extracting P(ii) of ii-th element(s), take care to no loop back to overloaded subsref.
      P = [builtin('subsref', P, subscript(1))]; % brackets [] necessary to handle multiple argouts
      if length(subscript)==1, % only a ()-reference; we're ready
         varargout{1} = P;
      else, % further references follow, handle with recursive call
         NP = length(P);
         if NP>1, % MatLab sux
            error('Overloaded P(vector).field syntax fails due to bugged implementation of MatLab subsref handling.');
         end
         for ii = 1:NP, 
            Pii = P(ii);
            varargout{ii} = subsref(P(ii), subscript(2:end));
         end
      end
   end
   return
end

if length(subscript)>1, % staggered subscripts
   % handle by recursion: P.a.b = (P.a).b
   SR = subsref(P,subscript(1)); % SR = P.a
   SR = subsref(SR,subscript(2:end)); % SR = SR.b[...]
   varargout{1} = SR; return;
end

% -----------single-level subscript from here
trivial = 1;
switch subscript.type,
case '()',
   SR = builtin('subsref', P, subscript);
case '{}', error('P{...} not defined for parameter objects.');
otherwise, trivial = 0;
end
if trivial, varargout{1} = SR; return; end

% -----------single field reference from here

fn = subscript.subs; % virtual fieldname
if isequal(1, strfind(fn, 'in_')) | isequal(1, strfind(fn, 'as_')), % P.in_kHz etc
   convertUnit = fn(4:end);
   fn = 'value';
else, convertUnit = '';
end
switch lower(fn),
case 'name', SR = P.Name;
case 'value', SR = getValue(P, convertUnit);
case 'maxdim', SR = P.MaxDim;
case 'unit', SR = P.Unit;
case 'datatype', SR = P.DataType;
case 'interpreter', SR = P.Interpreter;
case 'facvaluestr', SR = P.FacValueStr;
case {'facvalue', 'factory'}, P.ValueStr = P.FacValueStr; SR = getValue(P);
case {'string','valuestring','valuestr'}, SR = P.ValueStr;
otherwise, error(['Invalid parameter field ''' fn '''.'])
end
varargout{1} = SR;




