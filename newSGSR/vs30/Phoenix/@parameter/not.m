function p = Not(p);
% Parameter/NOT - NOT for Parameter objects
%   not(P) or ~P returns the negation of a parameter P,
%   for the few parameter data types cases where this 
%   makes any sense:
%     DAchan:      L <-> R and B <-> N
%     switchState: ON <-> OFF
%
%   See also parameter/getValue.

switch lower(p.DataType),
case 'dachan',
   NN = DAchanNaming;
   values = getfield(NN, p.Unit);
   ival = strmatch(p.Value, values, 'exact');
   NIVAL = [2 1 4 3];
   nival = NIVAL(ival);
   nvalue = values{nival};
   p = setvalue(p, nvalue);
case 'switchstate',
   NN = SwitchStateNaming;
   values = getfield(NN, p.Unit);
   ival = strmatch(p.Value, values, 'exact');
   nvalue = values{3-ival}; % 1<->2
   p = setvalue(p, nvalue);
otherwise, error(['Negation not defined for ' p.DataType '-type parameter objects.']);
end
   
   
   
   
   
   