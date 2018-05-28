function OK = var2base(val, name);
% var2base - export a variable from function to matlab workspace
%   var2base(Val, 'foo') defines a variable foo in the MatLab 
%   base workspace and gives it a value Val.
%   Note: the variable thus defined is not a global variable.

global var2base_______
var2base_______ = val;
if ~isvarname(name),
   error(['Invalid variable name ''' name '''.']);
end
evalin('base', ['global  var2base_______; ' name ' = var2base_______;']);
clear global var2base_______




