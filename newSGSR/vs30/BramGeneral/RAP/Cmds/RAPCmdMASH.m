function [RAPStat, LineNr, ErrTxt] = RAPCmdMASH(RAPStat, LineNr, N)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%R. de Norre 14-09-2009

%-------------------------------------RAP Syntax------------------------------------
% MASH #        Define the number of repetitions to be mashed
%-----------------------------------------------------------------------------------

ErrTxt = '';

if ~isnumeric(N)
    ErrTxt = 'Input argument has to be a number';
    return;
end

ds = RAPds;
if ~isempty(ds)
    mds = spikemasher(ds, N);
    
    RAPStat.GenParam.DS = mds;
    
    % change the ds output to include -mash#N, when we are operating on an
    % already mashed dataset we just add #N
    mashed = '-mashed#';
    if ~isempty(strfind(RAPStat.GenParam.SeqNr, mashed))
        seqnr = sprintf('%s%s%d', RAPStat.GenParam.SeqNr, '#', N);
    else
        seqnr = sprintf('%d%s%d', RAPStat.GenParam.SeqNr, mashed, N);
    end
    RAPStat.GenParam.SeqNr = seqnr;
    
    %Reset plot and calculation parameters ...
    RAPStat.CalcParam  = ManageRAPStatus('CalcParam');
    RAPStat.CalcParam2 = ManageRAPStatus('CalcParam2');
    RAPStat.PlotParam  = ManageRAPStatus('PlotParam');
    %Start a new figure ...
    RAPStat = NewRAPFigure(RAPStat);
else
    ErrTxt = 'No dataset specified yet';
end

LineNr = LineNr + 1;
