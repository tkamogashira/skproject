function [V, mess, Vstring] = defaultInterpreter(p, Value, datatype);
% Parameter/defaultInterpreter - interpret input for Parameter value
%   [V, mess, Vstring] = defaultInterpreter(P, Value) attemps to
%   interpret the Value for assigment of parameter P.
%   DefaultInterpreter uses P's datatype.
%   An invalid input Value results in an error message
%   contained in Mess.
%
%   Assigment of parameters whose 'interpreter' field is a 
%   user-defined function call that interpreter function
%   instead of the defaultInterpreter. Stimfreq is an example.
%   [XXX StimFreq is not yet implemented!]
%
%   See also Parameter/setValue, Stimfreq.

[V, mess, Vstring] = deal([], '', '');

if nargin<3, datatype = p.DataType; end
datatype = lower(datatype);
parStr = [p.DataType ' parameter ''' p.Name '''']; % for error messages

switch datatype,
case {'real', 'int', 'ureal' 'uint'}, %================================================================================
   if isnumeric(Value),
      V = Value;
      Vstring = localWriteMatrix(V);
   elseif ~ischar(Value),
      mess = ['Attempt to assign a ''' class(Value) ''' value to '  parStr '.']; return
   else, % Value string must be MatLab matrix notation as in '[1 2; 3 4]'  ...
      % ... no symbolic stuff allowed except 'pi'
      Value = strSubst(Value, 'pi', sprintf('%0.16f',pi));
      [V, mess] = localReadMatrix(Value);
      % all went well - return value string that was passed
      Vstring = Value;
   end
   if any(~isreal(V(:))),
      mess = ['Complex ' p.Name '.']; return
   end
   if isequal('int', datatype) | isequal('uint', datatype),
      if ~isequal(V, round(V)),
         mess = ['Non-integer ' p.Name '.']; return
      end
   end
   if isequal('uint', datatype) | isequal('ureal', datatype),
      if any(V(:)<0),
         mess = ['Negative ' p.Name '.']; return
      end
   end
case 'char', %================================================================================
   if ~ischar(Value), mess = ['Attempt to assign ' class(Value) ' value to ' parStr '.']; return; end
   V = Value;
   Vstring = Value;
case 'dachan', %==============================================================================
   if ~ischar(Value) & ~isequal('chanNum', p.Unit), mess = ['Attempt to assign ' class(Value) ' value to ' parStr '.']; return;
   elseif ~isnumeric(Value) & isequal('chanNum', p.Unit), mess = ['Attempt to assign ' class(Value) ' value to ' parStr '.']; return; end
   V = Value;
   if isequal('chanNum', p.Unit), Vstring = num2str(Value);
   else, Vstring = Value;
   end
   % use the converter of getValue to test if this value makes sense
   p.Value = V;
   if ~isfield(DAchanNaming, p.Unit),
      mess = ['''' p.Unit ''' is not a valid unit for a DAchan parameter.'];
      return;
   end
   try, getvalue(p, 'recSide'); getvalue(p, 'LRB'); 
   catch,
      mess = ['''' Value ''' is not a valid ' p.Unit '-type channel parameter. ']; return;
   end
case 'switchstate', %==============================================================================
   if ~ischar(Value), mess = ['Attempt to assign ' class(Value) ' value to ' parStr '.']; return; end
   V = Value;
   Vstring = Value;
   % use the converter of getValue to test if this value makes sense
   p.Value = V;
   if ~isfield(SwitchStateNaming, p.Unit),
      mess = ['''' p.Unit ''' is not a valid unit for a Switch parameter.'];
      return;
   end
   try, getvalue(p, 'ONOFF'); getvalue(p, 'logical'); 
   catch,
      mess = ['''' Value ''' is not a valid ' p.Unit '-type channel parameter. ']; return;
   end
otherwise, 
   error(['Undefined data type ''' datatype '''. ', ...
         'Builtin parameter data types are: real, int, ureal, uint, char, dachan, switchstate.']);
end % switch/case

isnumeric(p); % just a reminder to define isnumeric for new data types

%===locals=================================

function [V, mess] = localReadMatrix(Str);
% read expr like [34 57; 57 87] without using eval 
%  (eval -> side effects, function calls etc)
% str2double does the job once we have changed [] -> {} and put quotes around each member
V = nan; mess = '';
CValue = trimspace(Str); % remove leading & trailing white space and un-double internal whites
if isempty(CValue), V = nan;  mess = 'Empty string.'; return; end
if isempty(findstr('[', Str)), % must be simple number or matrix with surrounding [] omitted
   V = str2double(Str);
   if isnan(V), CValue = bracket(CValue); end
end
if isnan(V), % interpret matrix value
   CValue = strSubst(CValue, ';', ' ; '); % #;# -> # ; #
   CValue = trimspace(CValue); % multiple space -> single space
   CValue = strSubst(CValue, ' ', ''' '''); % #5 6# -> #5' '6#
   CValue = strSubst(CValue, ''';''', ';');  % #';'# -> #;#
   CValue = strSubst(CValue, '[', '{'''); % #[# -> #{'#
   CValue = strSubst(CValue, ']', '''}'); % #]# -> #}'#
   V = eval(['str2double(' CValue ');']);
end
if any(isnan(V(:))), % str2double never complains - use str2num ...
   try, eval(Str); % ... to test what went wrong, if anything
   catch,
      mess = ['Non-numerical expression.'];
      Cvalue = NaN;
      return;
   end
end

function Vstr = localWriteMatrix(V);
% compact matrix notation
[height width] = size(V);
V = V.'; V = V(:).'; % read along rows, like a book
Vstr = num2str(V);
if numel(V)==1, return; end
Vstr = trimspace(Vstr);
ispace = find(Vstr == ' ');
isubst = ispace(width:width:end); % locations of spaces after group of width elements
Vstr(isubst) = ';';
Vstr = StrSubst(Vstr, ';', '; ');
Vstr = ['[' Vstr ']'];


