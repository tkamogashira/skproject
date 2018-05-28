function [RAPStat, LineNr, ErrTxt] = RAPCmdSM(RAPStat, LineNr, Token1, Token2)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-06-2004

%-------------------------------------RAP Syntax------------------------------------
%   SM PKL #		          Smoothing for peak latency computation
%   SM PKL DEF		          Default smoothing for peak latency computation
%   SM LIN #		          Smoothing for data lines
%   SM LIN DEF		          Default smoothing for data lines
%   SM HI #		              Smoothing for histograms (*)
%   SM HI DEF		          Default smoothing for histograms (*)
%   SM ENV #                  Smoothing for envelope of difcor (*)  
%   SM ENV DEF                Default smoothing for envelope of difcor (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

switch lower(Token1),
case 'pkl',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Running average for peak latency computation is %s.\n', GetRAPCalcParam(RAPStat, 's', 'PklRunAv')); 
        end
    elseif ischar(Token2) & strcmpi(Token2, 'def'), RAPStat.CalcParam.PklRunAv = ManageRAPStatus('CalcParam.PklRunAv');
    else,
        if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
        
        [RunAv, ErrTxt] = GetRAPInt(RAPStat, Token2);
        if ~isempty(ErrTxt), return; end
        if mod(RunAv, 1), ErrTxt = 'The running average must be supplied as an integer'; return; end
        if (RunAv >= 0), RAPStat.CalcParam.PklRunAv = RunAv;
        else, ErrTxt = 'The running average cannot be negative'; return; end
    end    
case 'lin',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Running average on curves is %s.\n', GetRAPCalcParam(RAPStat, 's', 'CurveRunAv')); 
        end
    elseif ischar(Token2) & strcmpi(Token2, 'def'), RAPStat.CalcParam.CurveRunAv = ManageRAPStatus('CalcParam.CurveRunAv');
    else,
        if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
        
        [RunAv, ErrTxt] = GetRAPInt(RAPStat, Token2);
        if ~isempty(ErrTxt), return; end
        if mod(RunAv, 1), ErrTxt = 'The running average must be supplied as an integer'; return; end
        if (RunAv >= 0), RAPStat.CalcParam.CurveRunAv = RunAv;
        else, ErrTxt = 'The running average cannot be negative'; return; end
    end    
case 'hi',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Running average on histograms is %s.\n', GetRAPCalcParam(RAPStat, 's', 'HistRunAv')); 
        end
    elseif ischar(Token2) & strcmpi(Token2, 'def'), RAPStat.CalcParam.HistRunAv = ManageRAPStatus('CalcParam.HistRunAv');
    else,
        if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
        
        [RunAv, ErrTxt] = GetRAPInt(RAPStat, Token2);
        if ~isempty(ErrTxt), return; end
        if mod(RunAv, 1), ErrTxt = 'The running average must be supplied as an integer'; return; end
        if (RunAv >= 0), RAPStat.CalcParam.HistRunAv = RunAv;
        else, ErrTxt = 'The running average cannot be negative'; return; end
    end    
case 'env',    
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Running average on envelope is %s.\n', GetRAPCalcParam(RAPStat, 's', 'EnvRunAv')); 
        end
    elseif ischar(Token2) & strcmpi(Token2, 'def'), RAPStat.CalcParam.EnvRunAv = ManageRAPStatus('CalcParam.EnvRunAv');
    else,
        if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
        
        [RunAv, ErrTxt] = GetRAPFloat(RAPStat, Token2);
        if ~isempty(ErrTxt), return; end
        if (RunAv >= 0), RAPStat.CalcParam.EnvRunAv = RunAv;
        else, ErrTxt = 'The running average cannot be negative'; return; end
    end    
end

LineNr = LineNr + 1;