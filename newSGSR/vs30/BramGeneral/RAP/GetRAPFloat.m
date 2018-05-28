function varargout = GetRAPFloat(RAPStat, varargin)
%GetRAPFloat   get float argument from RAP command
%   [V1, V2, ..., VN, ErrTxt] = GetRAPFloat(RAPStat, InputArg1, InputArg2, ..., InputArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-11-2003

NInArgs   = length(varargin);
NOutArgs  = NInArgs + 1;
varargout = cell(1, NOutArgs);

ErrTxt = '';

for n = 1:NInArgs,
    Token = varargin{n};
    if isnumeric(Token), 
        varargout{n} = Token; 
    else, 
        %Must be a numeric memory variable or it wouldn't have passed the 
        %syntactical analyzer ...
        Value = GetRAPMemVar(RAPStat, Token);
        if ~isempty(Value), varargout{n} = Value;
        else, ErrTxt = sprintf('Memory variable %s not yet set', Token); break; end    
    end
end

varargout{NOutArgs} = ErrTxt; %Error-text ...