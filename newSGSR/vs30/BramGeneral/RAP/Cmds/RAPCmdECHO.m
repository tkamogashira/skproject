function [RAPStat, LineNr, ErrTxt] = RAPCmdECHO(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 23-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   ECHO ON/OFF               Turns on/off echoing of commands inside macro (~)
%   ECHO "..." [V#/C# "..." V#/C# ...] Displays text on the command window (~)
%-----------------------------------------------------------------------------------

ErrTxt = '';

Args = varargin; NArgs = length(varargin);

if any(strcmpi(Args{1}, {'on', 'off'})), 
    if (NArgs ~= 1), ErrTxt = 'Invalid syntax'; return;
    else,
        RAPStat.ComLineParam.McoEcho = lower(Args{1});
        if strcmpi(RAPStat.ComLineParam.InMco, 'yes'), 
            if strcmpi(Args{1}, 'on'), RAPStat.ComLineParam.Verbose = 'yes'; 
            else, RAPStat.ComLineParam.Verbose = 'no'; end    
        end
    end
else, 
    %Always display the requested text, even if verbose mode is set to 'off' ...
    Str = ParseRAPStrArgs(RAPStat, Args);
    if isempty(Str), ErrTxt = 'One of the variables is not yet set'; return; end
    fprintf('%s\n', Str); 
end

LineNr = LineNr + 1;