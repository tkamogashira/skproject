function p = parameter(D, varargin);
% parameter - constructor for parameter objects
%    Parameters are created using so-called spec strings. 
%    To create a parameter named 'startfreq' use:
%       X = parameter('startfreq 500 Hz ureal 2 stimfreq'); 
%    or, equivalenty:
%       X = parameter('startfreq', 500, 'Hz', 'ureal', 2, 'stimfreq'); 
%
%   See documentation on Paramset and Parameter objects.

if nargin==0, % implicit call in matrix manipulation, etc
   [Name, Value, ValueStr, Unit, DataType, MaxDim, Interpreter, FacValueStr] ...
      = deal([]); 
elseif isa(D, 'parameter'), p = D; return;  % (pseudo) casting
elseif isa(D, 'struct'), p = class(D, 'parameter'); return;  % (pseudo) casting
elseif ~ischar(D), error(['Cannot convert ' class(D) ' to parameter object.']);
else, % literal passing of args or D is defining string as in help text, parse it
   [mess, Name, Value, ValueStr, Unit, DataType, MaxDim, Interpreter, FacValueStr] ...
      = localParseArgs(D, varargin{:});
   error(errorStr(mess)); % report any errors in main fnc for simpler debug stack
end

p = CollectInStruct(Name, Value, ValueStr, Unit, DataType, MaxDim, Interpreter, FacValueStr);
p = class(p, 'parameter');

%try, % set actual value by interpreting the value string
   if ~isempty(p.Name), p = SetValue(p);  end
   %catch, error(lasterr); end

% ================locals=============
function [mess, Name, Value, ValueStr, Unit, DataType, MaxDim, Interpreter, FacValueStr] ...
   = localParseArgs(D, varargin);
% suppress warnings on un-assigned outargs in case of premature exit
[mess, Name, Value, ValueStr, Unit, DataType, MaxDim, Interpreter, FacValueStr] = deal([]);
mess = ''; % default: no errors
if nargin==1, % spec string: % tokenize says Bram
   WW = words2cell(D); 
else, [WW{1:nargin}] = deal(D, varargin{:});
end
%- - - - - - - - - - - - - - - - - - - - - 
% sample: 'startfreq 500 Hz real 2 stimfreq'
%   ^          1       2  3   4  5    6
%- - - - - - - - - - - - - - - - - - - - - 
if length(WW)<3, 
   mess = ['Incomplete specs for parameter definition (spec string reads: ''' D ''').']; 
   return; 
end 
% defaults
if length(WW)<4, WW{4} = 'real'; end % real values (non-complex doubles)
if length(WW)<5, WW{5} = '@'; end % size of factory value (found out below)
if length(WW)<6, WW{6} = 'none'; end % no interpreter
% Parse tokens one by one.
% 1) name
Name = WW{1};
if ~isvarname(Name), mess = ['Invalid parameter name ''' Name '''.']; return ; end;
% 4) get datatype before valuestr
DataType = WW{4};
if ~isvarname(DataType), mess = ['Invalid name of data type ''' DataType '''.']; return ; end;
% 2) value string
[ValueStr, ValueDim] = localAdaptValueStr(WW{2}, DataType);
if isnan(ValueDim), mess = ['Invalid matrix specification ''' WW{2} '''.']; return; end;
if any(ValueDim==0), mess = ['Empty default value not allowed.']; return; end;
% 3) unit
Unit = strsubst(WW{3}, '_', ' '); % replace underscores by spaces
% 5) maximum dimension(s)
MaxDim = localParseMaxdim(WW{5}, ValueDim);
if isnan(MaxDim), mess = ['Invalid maxdim spec ''' WW{5} '''.']; return ; end;
% 6) interpreter (e.g. stimfreq function checks for range of stimulus freqs, etc)
Interpreter = WW{6};
if ~isequal('none', lower(Interpreter)),
   if ~exist(Interpreter, 'file'),
      mess = ['Invalid parameter interpreter ''' Interpreter '''; use ''none'' or existing function'];
      return
   end
end
% 7) factory default string is set to value string at defining time. e.i. now
FacValueStr = ValueStr;

function MaxDim = localParseMaxdim(str, ValueDim);
% 2x3 -> [3,3] etc
if isequal('@', str), MaxDim = ValueDim; % max size is size of factory value
elseif isnumeric(str), MaxDim = str; % literal passing
else, % parse specs like '2x3'
   str = strsubst(str, 'x', ' '); % '2x3' -> '2 3'
   str = words2cell(str); % '2 3' -> {'2' '3'}
   MaxDim = str2double(str); % {'2' '3'} -> [2 3]
end;
if any(isnan(MaxDim)), MaxDim=nan; end; % any NaN is wrong -> replace by single NaN
% irregular feature: single number indicates WIDTH, i.e. 3-> [1, 3]
if ~isnan(MaxDim) & isequal(1, numel(MaxDim)),
   MaxDim = [1 MaxDim];
end

function [ValueStr, Dim] = localAdaptValueStr(ValueStr, DataType);
% For known datatypes, change the notation according to the rules.
% By default, replace underscores by spaces.
Dim = [1,1]; % default dimension
doMatrixParsing = ismember(lower(DataType), {'real' 'int' 'ureal' 'uint'});
if isequal('char', lower(DataType)), % trivial: ValueStr goes unaffected ...
   Dim = size(ValueStr); % ... Dim is simply the size of the string
elseif doMatrixParsing & ischar(ValueStr), % underscores and vertical bars are used as matrix notation ...
   % ... convert this stuff to MatLab conventions
   isSingleVal = isempty(findstr(ValueStr, '_')) & isempty(findstr(ValueStr,'|'));
   if ~isSingleVal, % '23_45|25_48'  ->  [23 45; 25 48]
      % get dimensions
      height = 1 + length(findstr('|', ValueStr));
      width = 1 + (length(findstr('_', ValueStr)))/height;
      Dim = [height width];
      ValueStr = strsubst(ValueStr, '_', ' '); % replace underscores by spaces
      ValueStr = strsubst(ValueStr, '|', '; '); % replace vertical bars by semicolons
      ValueStr = ['[' ValueStr ']'];  % use [] to bracket matrix spec
   end
elseif doMatrixParsing & isnumeric(ValueStr), % literal value
   Dim = size(ValueStr);
elseif isequal('dachan', lower(DataType)) | isequal('switchstate', lower(DataType)),
   Dim = 10;
else, % no matrix; only substitue  '_'  by ' '
   ValueStr = strsubst(ValueStr, '_', ' '); % replace underscores by spaces
end
% substitute NaN for Dim if Dim doesn't make sense
if ~isequal(Dim, round(Dim)),
   Dim = NaN;
end





