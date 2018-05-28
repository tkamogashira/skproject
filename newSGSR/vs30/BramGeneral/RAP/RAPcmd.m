function RAPcmd(varargin)
%RAPCMD runs a command in the current RAP session
%   RAPCMD(CmdStr) runs the command given by the character string CmdStr in
%   the current RAP session.
%   RAPCMD(TkStr1, TkStr2, ..., TkStrN) runs the command given by the tokens
%   TkStr1, TkStr2 up until TkStrN in the current RAP session. These tokens 
%   must be character strings. 
%
%   For further information on RAP see Users Guide on 
%   http://www.neurophys.wisc.edu/comp/docs/rap/rep007.html
%
%   See also RAP, RAPDS

%B. Van de Sande 12-02-2004

%Parsing arguments ...
if (nargin == 0), error('Wrong number of input arguments.');
elseif ~iscellstr(varargin) | ~all(cellfun('size', varargin, 1) == 1), 
    error('Arguments should be different character string tokens of an RAP command.'); 
end

NTokens = nargin; Tokens = varargin;
Cmd = vectorzip(Tokens, repmat({' '}, 1, NTokens));
Cmd = [Cmd{:}];

%Invoking the command in the current RAP session ...
rap(1, Cmd);