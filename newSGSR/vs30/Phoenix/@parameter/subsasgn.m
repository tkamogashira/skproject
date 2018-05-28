function P = subsasgn(P, subscript, RHS, varargin);
% Parameter/subsasgn - subsasgn for Parameter objects
%   P.value = X changes the value of a parameter object to X. 
%   If X is a char string, setValue will try to
%   interpret it according to the parameter definition
%   of P. 
%   Setvalue(p) uses the ValueStr for the input X;
%   this is used during initialization.
%
%   P.maxDim = [I J] sets the maximum size of P to [I J].
%
%   P.dataType = 'foo' sets the datatype of P to 'foo'.
%   
%   An error results if X is incompatible with the 
%   datatype, maximum size or interpreter of P.
%
%   See also Parameter/setValue and the documentation 

%NP = numel(P);
%if (NP>1) & ~isequal('()', subscript(1).type), % multiple outargs, element-wise recursive call
%   % P(...) is exception because that call un-multiplies P.
%   for ii = 1:NP, 
%      varargout{ii} = subsref(P(ii), subscript);
%      % extraction P(ii) of ii-th element will not to loop back to overloaded subsref ...
%      % ... because of the exception in the if clause.
%   end
%   return
%end

% 'hello....', P, subscript, RHS, varargin{:}
NP = numel(P);
if (NP>1), % handle elementwise & recursively
   if isequal('.', subscript(1).type), % element-wise recursive call
      if length(subscript)>1,
         error(['Field reference for multiple structure elements that is followed ', ...
               'by more reference blocks is an error.']); % cf MatLab builtin subsref
      end
      for ii = 1:NP, 
         RHS = {RHS varargin{:}}; % nargin>3 for subsasgn is undocumented feature?
         P(ii) = subsasgn(P(ii), subscript, RHS{ii});
      end
   elseif isequal('()', subscript(1).type), % P(subs1)... = RHS
      % always use builtin () referencing
      if length(subscript)==1, % only a ()-reference; we're done
         P = builtin('subsasgn', P, subscript(1), RHS); 
      else, % further references follow, handle with recursive call
         Psub = builtin('subsref', P, subscript(1));
         if numel(Psub)==1,
            Psub = subsasgn(Psub, subscript(2:end), RHS);
            P = builtin('subsasgn', P, subscript(1), Psub); 
         else,
            NPsub = length(Psub);
            if ~iscell(RHS), RHS = repmat({RHS},1,NPsub); end
            for ii=1:NPsub, Psub(ii) = subsasgn(Psub(ii), subscript(2:end), RHS{ii}); end
            P = subsasgn(P, subscript(1), Psub);
         end
      end
   end
   return
end

if length(subscript)>1, % staggered subscripts
   % handle by recursion: P.a.b = RHS -> Pa = P.a; Pa.b=RHS; P.a = Pa;
   P1 = subsref(P, subscript(1));  % Pa = P.a
   P1 = subsasgn(P1, subscript(2:end), RHS); % Pa.b[...] = RHS
   P = subsasgn(P, subscript(1), P1);  % P.a = Pa;
   return;
end

% -----------single-level subsasgn from here
trivial = 1;
switch subscript.type,
case '()', 
   if ~isa(RHS, 'parameter'), error('RHS is not a parameter object.'); end
   P = builtin('subsasgn', P, subscript, RHS);
case '{}', error('S{...} not defined for parameter objects.');
otherwise, trivial = 0;
end
if trivial, return; end

% -----------single field asignment from here
mess = '';
fn = subscript.subs; % virtual fieldname
switch lower(fn),
case 'value', P = setValue(P, RHS);
case 'maxdim', [P, mess] = localSetMaxDim(P, RHS);
case 'datatype', P.DataType = RHS;
case {'name' 'valuestr' 'unit' 'interpreter' 'facvaluestr'}, 
   error(['The '''  fn ''' field of an existing parameter object may not be changed.']);
otherwise, error(['Invalid parameter field ''' fn '''.'])
end
error(mess);




%=====locals=================
function [P, mess] = localSetMaxDim(P, RHS);
mess = '';
if ~isreal(RHS), mess = ['MaxDim must be real row vector.']; 
elseif isempty(RHS), mess = ['MaxDim must be nonempty row vector.']; 
elseif size(RHS,1)>1, mess = ['MaxDim must be row vector.']; 
elseif any(rem(RHS,1)>0), mess = ['MaxDim components must be positive integers.']; 
elseif any(RHS<1), mess = ['MaxDim components must be positive integers.']; 
end
if ~isempty(mess), return; end 
% interpret single number as width (see parameter)
if numel(RHS)==1, RHS = [1 RHS]; end
P.MaxDim = RHS;
% check if maxdim does not conflict with P's current value
try, 
   setValue(P, P.Value); 
catch, 
   mess = ['New setting of MaxDim conflicts with current value of ''' P.Name ''' parameter.'];
end







