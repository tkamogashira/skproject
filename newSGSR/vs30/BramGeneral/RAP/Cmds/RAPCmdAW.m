function [RAPStat, LineNr, ErrTxt] = RAPCmdAW(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 11-05-2004

%-------------------------------------RAP Syntax------------------------------------
%   AW #1 #2 [#3 #4 ...]      Specify analysis window (msecs)
%   AW DEF                    Default value for analysis window
%-----------------------------------------------------------------------------------

ErrTxt = '';

Args = varargin; NArgs = length(Args); 
DefValue = ManageRAPStatus('CalcParam.AnWin');

if (NArgs == 0),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current analysis window is %s.\n', GetRAPCalcParam(RAPStat, 's', 'AnWin')); end
elseif (NArgs == 1) & ischar(Args{1}) & strcmpi(Args{1}, 'def'),
    RAPStat.CalcParam.AnWin = DefValue;
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    RepDur = max(RAPStat.GenParam.DS.repdur);
    
    AnWin = [];
    for n = 1:2:NArgs,
        [Bgn, End, ErrTxt] = GetRAPFloat(RAPStat, Args{n:n+1});
        if ~isempty(ErrTxt), return; end
        if (Bgn < 0) | (Bgn > End)
            ErrTxt = 'Invalid range'; 
            return;
        elseif ~isempty(AnWin) & (AnWin(end) >= Bgn)
            ErrTxt = 'Intervals cannot coincide'; 
            return;
        else
            AnWin = [AnWin, Bgn, End]; 
        end
        
        if (End > RepDur)
            warning('Analysis window exceeds repetition duration.'); 
        end
    end
    RAPStat.CalcParam.AnWin = AnWin;
end

LineNr = LineNr + 1;