function Sn = structtemplate(varargin)
%STRUCTTEMPLATE  apply template on structure.
%   S = STRUCTTEMPLATE(S, T) force template given by a scalar structure
%   T on structure S, so that S has exactly the same fieldnames of T in
%   the same order. The values of T are overridden by those given in S,
%   if the fieldnames is present in S.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.

%B. Van de Sande 10-09-2004

%--------------------------default parameters-------------------------
DefParam.warning   = 'on'; %Display warnings or not ...
DefParam.reduction = 'on'; %Reduce the size of a field when not the same
                           %as the size of the default value ...

%----------------------------main program-----------------------------
%Checking input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:');
    disp(DefParam);
    return;
elseif nargin < 2, error('Wrong number of input arguments.'); end
[S, T] = deal(varargin{1:2});
if ~isstruct(S) & ~isa(S, 'dataset'), error('First argument should be structure.'); end
if ~isstruct(T) | (length(T) ~= 1), error('Second argument should be template structure.'); end
Param = CheckPropList(DefParam, varargin{3:end});
CheckParam(Param);

%Apply template ...
Sn = T;
FNames = fieldnames(T); NFields = length(FNames); NElem = length(S);
for n = 1:NFields,
    FName = FNames{n}; TValue = getfield(T, FName);
    for i = 1:NElem,
        %Use recusrion for branched structures ...
        if isa(TValue, 'struct'), 
            if ismember(FName, fieldnames(S)), Ssub = getfield(S, {i}, FName);
            else, continue; end
            if isstruct(Ssub) | isa(Ssub, 'dataset'),
                Ssub = structtemplate(Ssub, TValue, Param);
                Sn = setfield(Sn, {i}, FName, Ssub);
            elseif strcmpi(Param.warning, 'on'),
                warning(sprintf('Class of template and target value doesn''t correspond for field %s.', FName));
            end    
        else
        %To allow for the use of datasets as inputs, checking if fieldname of template is present in
        %a dataset with ISFIELD.M cannot be done. Using exception handling instead. This way virtual
        %fields of a dataset can also be used in a template ...
            try,
                SValue = getfield(S, {i}, FName);
                if ~strcmpi(class(TValue), class(SValue)) & strcmpi(Param.warning, 'on'),
                    warning(sprintf('Class of template and target value doesn''t correspond for field %s.', FName));
                elseif isnumeric(TValue) & ~isequal(size(TValue), size(SValue)) & strcmpi(Param.reduction, 'on'),
                    if strcmpi(Param.warning, 'on'), 
                        warning(sprintf('Size of numeric field %s doesn''t correspond. Reducing matrix of target structure to fit template.', FName));
                    end
                    TSz = size(TValue); N = prod(TSz);
                    SValue = reshape(SValue(1:N), TSz);
                end    
                Sn = setfield(Sn, {i}, FName, SValue); 
            catch, lasterr(''); end; 
        end        
    end
end

%--------------------------local functions----------------------------
function CheckParam(Param)

if ~ischar(Param.warning) | ~any(strcmpi(Param.warning, {'on', 'off'})), error('Property warning must be ''on'' or ''off''.'); end
if ~ischar(Param.reduction) | ~any(strcmpi(Param.reduction, {'on', 'off'})), error('Property reduction must be ''on'' or ''off''.'); end

%---------------------------------------------------------------------