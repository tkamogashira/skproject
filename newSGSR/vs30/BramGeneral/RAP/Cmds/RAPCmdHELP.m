function [RAPStat, LineNr, ErrTxt] = RAPCmdHELP(RAPStat, LineNr)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

HelpFileName = 'RAPHelp';

if exist(HelpFileName, 'file'), 
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
        %Setting the last error to a meaningful string... This error message 
        %appears when user interrupts the output on the command window by
        %pressing 'q' on the '--more--' prompt ...
        if strcmpi(RAPStat.ComLineParam.More, 'on')
            lasterr('Screen output interrupted by user.');
        end
        help(HelpFileName); 
    end
    
    ErrTxt = ''; LineNr = LineNr + 1;
else
    ErrTxt = sprintf('Cannot find file %s.m', HelpFileName);
end
