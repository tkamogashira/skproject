function [Value, ErrMsg, DispStr] = DQParamInterpreter(P, ArgIn, DataType)
%DQPARAMINTERPRETER interpret parameter of a DataQuest-specific datatype

%B. Van de Sande 09-07-2004
%Based on @PARAMETER\DEFAULTINTERPRETER.M

%Attention! A possible enhancement would be to allow for the specification of
%the fieldname suffix to be used. But the user can easily add those suffices
%himself before the logical expression is evaluated ...

[Value, ErrMsg, DispStr] = deal([], '', '');

%Checking input arguments ...
if (nargin < 3), DataType = P.DataType; end; DataType = lower(DataType);

%For error messages ...
ParamStr = sprintf('%s parameter ''%s''', P.DataType, P.Name);

switch DataType,
%----------------------------------------------------------------------   
case {'real', 'int', 'ureal' 'uint'},
   %For numerical values different types are present: signed real number (real), 
   %unsigned real number (ureal), signed integer number (int) and an unsigned 
   %integer number (uint). All these types also except 'void' or '' as a possible
   %value, which designates that no restriction is present for the parameter ...
   if isempty(ArgIn), [Value, DispStr] = deal(NaN, 'void');
   elseif isnumeric(ArgIn),
      if isnan(ArgIn), [Value, DispStr] = deal(NaN, 'void');
      else,
          Value   = ArgIn;
          DispStr = mat2str(Value);
      end    
   elseif ~ischar(ArgIn),
      ErrMsg = sprintf('Attempt to assign a ''%s'' value to %s.', class(ArgIn), ParamStr); return;
   else, 
      if strcmpi(ArgIn, 'void'), [Value, DispStr] = deal(NaN, 'void');
      else,    
          Value = str2num(ArgIn);
          if ~isnumeric(Value) | isempty(Value), ErrMsg = sprintf('%s connat be assigned ''%s''.', ParamStr, ArgIn); return; end    
          DispStr = mat2str(Value);
      end
   end
   
   if ~isnan(Value),
       if any(~isreal(Value(:))), ErrMsg = sprintf('Complex %s.', P.Name); return; end
       if isequal('int', DataType) | isequal('uint', DataType),
           if ~isequal(Value, round(Value)), ErrMsg = sprintf('Non-integer %s.', P.Name); return; end
       end
       if isequal('uint', DataType) | isequal('ureal', DataType),
           if any(Value(:) < 0), ErrMsg = sprintf('Negative %s.', P.Name); return; end
       end
   end   
%----------------------------------------------------------------------   
case 'char', 
    %The user can supply a value of type char in the following ways:
    %   1)'void' or ''
    %   2)whitespace or comma delimited tokens
    %Values of type char are internally represented by a cell-array of strings and
    %not by a character string. This must be kept in mind when restricting the size ...
    if iscellstr(ArgIn),
        Value   = ArgIn; 
        DispStr = cellstr2str(ArgIn, ' ');
    elseif ischar(ArgIn),
        if isempty(ArgIn) | strcmpi(ArgIn, 'void'),
            Value   = '';
            DispStr = 'void';
        else,
            if any(ArgIn == ','), Dlm = ','; else Dlm = ' '; end
            Value   = cleanstr(Words2Cell(ArgIn, Dlm));
            DispStr = cellstr2str(Value, ' ');   
        end
    else, ErrMsg = sprintf('Attempt to assign a ''%s'' value to %s.', class(ArgIn), ParamStr); return; end    
%----------------------------------------------------------------------   
case 'interval', 
    %A restriction interval can be defined by the user in the following ways:
    % 1)'void' or '': there is no restriction on the value. This can also be
    %   defined by the following notations ']-Inf, +Inf[', '>-Inf' and '<+Inf'.
    % 2)numerical value optionaly prefixed with a relational operator, e.g.
    %   '<=90', '> 90', '= 90' (the same as '90').
    % 3)Mathematical interval notation, e.g. [-5,+5], ]-5, +5[, ]-Inf, 90], ...
    %The internal interpretation of an interval is done via a structure with
    %the fieldnames 'rng' and 'border' ...

    if isstruct(ArgIn),
        [Value, ErrMsg] = CheckInterval(ArgIn);
        if ~isempty(ErrMsg), return; end
        DispStr  = Interval2Str(Value);
    elseif ischar(ArgIn), 
        [Value, ErrMsg] = Str2Interval(ArgIn);
        if ~isempty(ErrMsg), return; end
        DispStr  = Interval2Str(Value);
    else, ErrMsg = sprintf('Attempt to assign a ''%s'' value to %s.', class(ArgIn), ParamStr); return; end  
%----------------------------------------------------------------------
case 'time',
    %Time must be supplied by the user as a character string in the following
    %form 'dd-mmm-yyyy HH:MM:SS' or 'dd-mmm-yyyy'. 'void' or '' can also be
    %supplied ...
    
    if isempty(ArgIn) | strcmpi(ArgIn, 'void'),
        Value   = '';
        DispStr = 'void';
    else,    
        try, [Value, DispStr] = deal(datestr(datenum(ArgIn)));
        catch, ErrMsg = sprintf('Invalid time specification used for %s.', ParamStr); return; end
    end    
otherwise, error(sprintf('Undefined data type ''%s''.', DataType)); end

isnumeric(P); %Just a reminder to define isnumeric for new data types

%-------------------------------locals---------------------------------
function [Interval, ErrMsg] = CheckInterval(Interval)

[Rng, Border] = deal(Interval.rng, Interval.border);

if (diff(Rng) < 0), ErrMsg = sprintf('Invalid range for interval.');
elseif isinf(Rng(1)) & (Border{1} == '['), ErrMsg = 'Minus infinite cannot be included in an interval.';
elseif isinf(Rng(2)) & (Border{2} == ']'), ErrMsg = 'Infinite cannot be included in an interval'; end

%----------------------------------------------------------------------
function [Interval, ErrMsg] = Str2Interval(Str)

[Interval, ErrMsg] = deal([], '');

%Remove whitespaces from input string ...
Str(find(isspace(Str))) = []; N = length(Str);

%Translate interval ...
if isempty(Str) | any(strcmpi(Str, {'void', ']-Inf,+Inf[', ']-Inf,Inf[', ...
            '>-Inf', '<+Inf', '<Inf'})), %Void interval ...
    Interval = struct([]);
elseif any(Str(1) == '[]'), %User defined interval ...
    Border = cellstr(Str([1,end])')';
    if ~all(ismember(Border, {'[', ']'})), ErrMsg = sprintf('Invalid interval syntax used in ''%s''.', Str); return; end
    [Rng, N, ErrMsg] = sscanf(Str(2:end-1), '%f,%f');
    if isempty(ErrMsg) & (N == 2),
        %Check a little bit semantics ...
        if (diff(Rng) < 0), ErrMsg = sprintf('Invalid range for interval ''%s''.', Str); return;
        elseif isinf(Rng(1)) & (Border{1} == '['), ErrMsg = sprintf('Minus infinite cannot be included in an interval: ''%s''.', Str); return;
        elseif isinf(Rng(2)) & (Border{2} == ']'), ErrMsg = sprintf('Infinite cannot be included in an interval: ''%s''.', Str); return;
        else, 
            Interval.rng    = Rng;
            Interval.border = Border;
        end   
    else, ErrMsg = sprintf('Invalid interval syntax used in ''%s''.', Str); return; end    
elseif any(Str(1) == '<>'), %Interval defined via relational operator ...
    if strncmpi(Str, '<=', 2),     idx = 3; Rng = [-Inf, NaN]; Border = {']', ']'};
    elseif strncmpi(Str, '>=', 2), idx = 3; Rng = [NaN, +Inf]; Border = {'[', '['};
    elseif strncmpi(Str, '<', 1),  idx = 2; Rng = [-Inf, NaN]; Border = {']', '['};
    elseif strncmpi(Str, '>', 1),  idx = 2; Rng = [NaN, +Inf]; Border = {']', '['};
    else, ErrMsg = sprintf('Invalid interval syntax used in ''%s''.', Str); return; end
    [Val, N, ErrMsg] = sscanf(Str(idx:end), '%f');
    if isempty(ErrMsg) & (N == 1), 
        Rng(isnan(Rng)) = Val;
        Interval.rng    = Rng;
        Interval.border = Border;
    else, ErrMsg = sprintf('Invalid interval syntax used in ''%s''.', Str); return; end    
else, %Single number ...
    if (Str(1) == '='), Val = str2num(Str(2:end)); else, Val = str2num(Str); end
    if ~isempty(Val) & isnumeric(Val),
        Interval.rng    = Val([1 1]);
        Interval.border = {'[', ']'};
    else, ErrMsg = sprintf('Invalid interval syntax used in ''%s''.', Str); return; end
end

%----------------------------------------------------------------------
function Str = Interval2Str(Interval)

if isempty(Interval), Str = 'void';
elseif (diff(Interval.rng) == 0), Str = sprintf('%+.16g', Interval.rng(1));
else, Str  = sprintf('%s%+.16g,%+.16g%s', Interval.border{1}, Interval.rng, Interval.border{2}); end

%----------------------------------------------------------------------