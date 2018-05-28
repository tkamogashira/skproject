function Param = printhelp(Param, varargin)
%PRINTHELP           Print formatted help message
%
% DESCRIPTION
%                    Print formatted help message, set last argument to 1
%                    in order to terminate the function with error().
%
% INPUT
%        Param:             Struct containing the default parameters for a function
%
%        varargin{1:end-1}: Optional message string
%
%        varargin{end}     If set to 1, printhelp ends all functions by an error message
% OUTPUT
%        Param:         Struct containing the updated input parameters.
%
%
% EXAMPLES
%        Param = struct();
%        Param.help = {'Functions USE Message'};
%        Param = printhelp(Param, 'My help message', 1)
%
% SEE ALSO          processParams

%---------------- CHANGELOG -----------------------
% date         developer       short description
% 1/12/2010    Abel            Initial creation

%---------------- Main program --------------------

% did we receive a message? Then build message
doDie = ~isempty(varargin) && all(varargin{end} == 1);
hasMessage = ~isempty(varargin) && ischar(varargin{1});
if (hasMessage)
    myMessage = sprintf('* Message: ');
    myMessage = strcat(myMessage, sprintf('\t%s\n', varargin{:}));
end

% does the Param struct contains a help field? Then print Help message
hasHelp = isfield(Param, 'help');
if (hasHelp)
    fprintf('* USE: *\n\t%s\n', Param.help{:});
end

% print defaults
fprintf('* Function parameters: *\t\n');
disp(Param);

% if final argument was 1, die with error, else just print message if
% there was one
if (hasMessage && doDie)
    error(myMessage);
elseif (doDie)
    error('Aborting execution');
elseif (hasMessage)
    disp(myMessage);
end
end

