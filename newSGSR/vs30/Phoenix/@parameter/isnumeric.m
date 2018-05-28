function in = IsNumeric(P);
% Parameter/IsNumeric - IsNumeric for Parameter objects
%   IsNumeric(P) returns true if P is an array of
%   numeric parameters. 
%   Currently, all standard numeric parameter
%   data types are: 
%      real, ureal, int, uint.
%   Standard non-numeric data types are: 
%      char, dachan, switchstate.
%   For any newly defined parameter datatype, isnumeric
%   must be updated.
%
%   See also Parameter/defaultInterpreter, parameter.

if numel(P)>1, % recursive
   in = 1;
   for ii=1:numel(P),
      if ~isnumeric(P(ii)), % one oddball is enough
         in = 0;
         return;
      end
   end
   return;
end

%----------single P from here--------

switch lower(P.DataType),
case {'real', 'int', 'ureal', 'uint'},
   in = 1;
case {'char', 'dachan' 'switchstate'},
   in = 0;
otherwise,
   if isequal('none', P.Interpreter),
      error(['Datatype ''' P.DataType ''' is unknown to the parameter/isnumeric function.']);
   end
   fnc = ['isnum_' P.Interpreter];
   if exist(fnc, 'file'),
      in = feval(fnc, P);
   else,
      error(['A function named ''' fnc ''' needs to be written that tests the numericalness of ''' P.DataType '''-type parameters.']);
   end
end



