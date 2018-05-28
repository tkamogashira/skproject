function [RAPStat, LineNr, ErrTxt] = RAPCmdRW(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 11-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   RW #1 #2 [#3 #4 ...]      Specify reject window (msecs)
%   RW DEF                    Default value for reject window
%-----------------------------------------------------------------------------------

ErrTxt = '';

Args = varargin; NArgs = length(Args); 
DefValue = ManageRAPStatus('CalcParam.ReWin');

if (NArgs == 0),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current reject window is %s.\n', GetRAPCalcParam(RAPStat, 's', 'ReWin')); end
elseif (NArgs == 1) & ischar(Args{1}) & strcmpi(Args{1}, 'def'),
    RAPStat.CalcParam.ReWin = DefValue;
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    RepDur = max(RAPStat.GenParam.DS.repdur);
    
    ReWin = [];
    for n = 1:2:NArgs,
        [Bgn, End, ErrTxt] = GetRAPFloat(RAPStat, Args{n:n+1});
        if ~isempty(ErrTxt), return; end
        if (Bgn < 0) | (Bgn > End), ErrTxt = 'Invalid range'; return;
        elseif (End > RepDur), ErrTxt = 'Reject window cannot exceed repetition duration.'; return;    
        elseif ~isempty(ReWin) & (ReWin(end) >= Bgn), ErrTxt = 'Intervals cannot coincide'; return;
        else, ReWin = [ReWin, Bgn, End]; end
    end
    RAPStat.CalcParam.ReWin = ReWin;
end

LineNr = LineNr + 1;