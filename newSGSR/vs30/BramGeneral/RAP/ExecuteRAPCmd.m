function [RAPStat, LineNr, ErrTxt] = ExecuteRAPCmd(RAPStat, LineNr, Cmd, varargin)
%ExecuteRAPCmd  executes RAP command
%   [RAPStat, LineNr, ErrTxt] = ExecuteRAPCmd(RAPStat, LineNr, Cmd, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 28-10-2003

%--------------------------------implementation details------------------------------
%   Each different RAP command is delegated to a different M-file. These M-files
%   must have a name of the format RAPCmdXXX, where XXX is the RAP command name in 
%   upper case. This function must except an RAP status structure as first argument, a
%   line number as second argument followed by a list of the input arguments the 
%   command actually needs.
%   It should the RAP status structure, followed by a line number and a character 
%   string with possible error messages.
%   The overal layout is:
%
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   There is one exception to this rule: if the command is the name of a memory 
%   variable 
%   These arithmetic operations are delegated to the function RAPCmdVAR. This function
%   has a special syntax:
%
%   [RAPStat, LineNr, ErrTxt] = RAPCmdVAR(RAPStat, LineNr, Var1, Operator, Var2)
%------------------------------------------------------------------------------------
%   Classification of RAP commands according to influence on the RAP status structure:
%   1)The commands SET DEF and DF reset all the elements of RAPStat, this includes
%     the general, calculation and plot parameters. The calculated data is also reset
%     and a new figure is started. The RAP memory is only reset by SET DEF.
%   2)ID, DS and NX DS reset the calculation and plot parameters and the calculated
%     data. A new figure is also started.
%   3)PP only sets the plot parameters to the default values and starts a new figure.
%   4)A new figure is started with the command SOU DEF. SOU NX only starts a new figure
%     when necessary and SOU <int> <int> never starts a new figure.
%
%   The following functions can be used to reset items from the RAP status structure:
%   1)ManageRAPStatus.m (without input arguments or with name of superfield)
%   2)NewRAPFigure.m
%------------------------------------------------------------------------------------

ErrTxt = '';
Args = varargin;

if isRAPMemVar(Cmd)
    CmdFileName = 'RAPCmdVAR';
    Args = {Cmd, Args{:}};
else
    CmdFileName = ['RAPCmd' upper(Cmd) ];
end

if ~exist(CmdFileName, 'file')
    ErrTxt = sprintf('%s doesn''t exist or is not yet implemented', upper(Cmd));
else
    [RAPStat, LineNr, ErrTxt] = feval(CmdFileName, RAPStat, LineNr, Args{:});
end
