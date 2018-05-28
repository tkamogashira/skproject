function [p, mess] = setValue(p, Value);
% Parameter/setValue - setValue of Parameter
%   P.value = X or P = setvalue(p, X) changes the
%   value of a parameter object to X. 
%   If X is a char string, setValue will check if
%   the string is compatible with the datatype, 
%   maximum size and interpreter of the P.
%
%   Setvalue(p) uses the ValueStr for the input X;
%   this is used during initialization.
%   
%   An error results if X is somehow incompatible
%   with the definition of the parameter.
%
%   [p, mess] = setValue(p, value) suppresses errors and returns
%   the error message in output argument mess instead.
%
%   See also Parameter/getValue and the documentation 
%   on Parameter objects.

mess = '';

if isempty(p.Name), 
   mess = 'Non-initialized (void) Parameter objects cannot be assigned a value.';
end
if nargout<2, error(mess); else, if ~isempty(mess), return; end; end;

if nargin<2, Value = p.ValueStr; end

% real action is delegated to the interpreter
interpreter = lower(p.Interpreter);
if isequal('none', interpreter),
   interpreter = 'defaultInterpreter';
end
[p.Value, mess, p.ValueStr] = eval([interpreter '(p, Value);']);
if nargout<2, error(mess); else, if ~isempty(mess), return; end; end;

% check for sizes
if any(size(p.Value)>p.MaxDim),
   MXstr = strsubst(num2sstr(p.MaxDim), ' ', 'x'); % 2x1 etc
   if isnumeric(p),
      mess = {'Maximum size exceeded.', ['Max dim = ' MXstr '.']};
   else,
      mess = ['Maximum size of parameter ''' p.Name  ''' exceeded [max ' MXstr '].'];
   end
end
if nargout<2, error(errorStr(mess)); else, if ~isempty(mess), return; end; end;






