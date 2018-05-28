function [RAPStat, LineNr, ErrTxt] = RAPCmdPR(RAPStat, LineNr, OptArg)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 04-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   PR [CUR]                  Print current RAP figure
%   PR ALL                    Print all RAP figures
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), OptArg = 'cur'; end

switch OptArg
case 'all',
    FigHdls = findobj(0, 'Tag', 'RAP');
    NPages  = length(FigHdls);
    for n = 1:NPages,
        fprintf('Printing RAP figure %d/%d ...\n', n, NPages);
        print(FigHdls(n));
    end
case 'cur',
    if ishandle(RAPStat.PlotParam.Figure.Hdl), 
        fprintf('Printing current RAP figure ...\n');
        print(RAPStat.PlotParam.Figure.Hdl);
    elseif ~isempty(findobj('Type', 'figure')) & strcmp(get(gcf, 'Tag'), 'RAP'), 
        fprintf('Printing current RAP figure ...\n');
        print(gcf);
    else, ErrTxt = 'No active RAP figure'; return; end    
end    

LineNr = LineNr + 1;