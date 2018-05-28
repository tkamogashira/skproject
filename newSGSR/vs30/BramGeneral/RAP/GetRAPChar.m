function varargout = GetRAPChar(RAPStat, varargin)
%GetRAPChar   get character argument from RAP command
%   [V1, V2, ..., VN, ErrTxt] = GetRAPChar(RAPStat, InputArg1, InputArg2, ..., InputArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

NInArgs   = length(varargin);
NOutArgs  = NInArgs + 1;
varargout = cell(1, NOutArgs);

ErrTxt = '';

for n = 1:NInArgs,
    Token = varargin{n};
    if isRAPCMemVar(Token), %Character memory variable ...
        Value = GetRAPMemVar(RAPStat, Token);
        if isempty(Value), ErrTxt = sprintf('Memory variable %s not yet set', Token); break;
        else, varargout{n} = Value; end
    elseif isRAPSubstVar(Token, 'char'), %Character substitution variable ...
        Value = GetRAPSubstVar(RAPStat, Token);
        if isempty(Value), ErrTxt = 'Could not retrieve substitution variable'; break;
        else, varargout{n} = Value; end
    else, varargout{n} = Token; end %Character string ...
end

varargout{NOutArgs} = ErrTxt; %Error-text ...