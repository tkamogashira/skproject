function [RAPStat, LineNr, ErrTxt] = RAPCmdTR(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-02-2004

%-------------------------------------RAP Syntax------------------------------------
%   TR #1 #2 [#3 #4 ...]      Specify trials to be included in analyses
%   TR DEF                    Default value for trial numbers
%-----------------------------------------------------------------------------------

ErrTxt = '';

Args = varargin; NArgs = length(Args); 
DefValue = ManageRAPStatus('CalcParam.Reps');

if (NArgs == 0),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current included repetitions numbers are %s.\n', GetRAPCalcParam(RAPStat, 's', 'Reps')); end
elseif (NArgs == 1) & ischar(Args{1}) & strcmpi(Args{1}, 'def'), 
    RAPStat.CalcParam.Reps = DefValue;
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    ds = RAPStat.GenParam.DS;
    
    Reps = [];
    for n = 1:2:NArgs,
        [Bgn, End, ErrTxt] = GetRAPInt(RAPStat, Args{n:n+1});
        if ~isempty(ErrTxt), return; end
        if (Bgn < 0) | (Bgn > End), ErrTxt = 'Invalid range'; return;
        elseif any(ismember(Reps, Bgn:End)), ErrTxt = 'Duplicate range'; return;
        else, Reps = [Reps, Bgn:End]; end
    end
    
    if ~all(ismember(Reps, 1:ds.nrep)), ErrTxt = 'Invalid range'; return; end
    RAPStat.CalcParam.Reps = sort(Reps);
end

LineNr = LineNr + 1;