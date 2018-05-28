function varargout = GetRAPInt(RAPStat, varargin)
%GetRAPInt   get integer argument from RAP command
%   [V1, V2, ..., VN, ErrTxt] = GetRAPInt(RAPStat, InputArg1, InputArg2, ..., InputArgN)
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
        %No need to check if Token is an integer, this is done
        %by the syntactical analyzer (isRAPInt.m) ...
        varargout{n} = Token; 
    else
        %Must be a numeric memory variable or it wouldn't have passed the 
        %syntactical analyzer ...
        Value = GetRAPMemVar(RAPStat, Token);
        if isempty(Value)
            ErrTxt = sprintf('Memory variable %s not yet set', Token);
            break; 
        elseif (mod(Value, 1) ~= 0)
            ErrTxt = sprintf('Memory variable %s doesn''t contain integer', Token);
            break;
        else
            varargout{n} = Value;
        end
    end
end

varargout{NOutArgs} = ErrTxt; %Error-text ...