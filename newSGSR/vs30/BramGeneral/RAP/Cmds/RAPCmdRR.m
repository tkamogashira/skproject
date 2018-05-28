function [RAPStat, LineNr, ErrTxt] = RAPCmdRR(RAPStat, LineNr, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 23-06-2004

%-------------------------------------RAP Syntax------------------------------------
%   RR DEF			          Default range for X- and Y-variables
%   RR X #1 [#2] [#3]	      Re-set range of X-variable
%   RR Y #1 [#2] [#3]	      Re-set range of Y-variable
%   RR SEQ #1 [#2] [#3]	      Re-set range of stimulus points
%   RR SEQ DEF		          Def. range for stim. points (all of them) 
%-----------------------------------------------------------------------------------

%------------------------------implementation details-------------------------------
%   The subsequence numbers are not changed by multiple independent variables, cause
%   they are ordered by stimulus presentation. The command RR does work a little bit
%   different for two independent variables, when specifying an X or an Y range the 
%   range restriction is narrowed down instead of resetting the range. This is not
%   the case for specifying a range with subsequences ...
%   For independent variables with a logaritmic scale, the step size is given in
%   octaves ...
%-----------------------------------------------------------------------------------

ErrTxt = '';

Tol = 1e-3; %Numerical tolerance ...

Args = varargin; NArgs = length(Args); 
DefValue = ManageRAPStatus('CalcParam.SubSeqs');

DS = RAPStat.GenParam.DS;

if (NArgs == 0),
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'),
        if ~isRAPStatDef(RAPStat, 'GenParam.DS'),
            if strcmpi(RAPStat.GenParam.DS.FileFormat, 'EDF') & (RAPStat.GenParam.DS.indepnr == 2),
                incSubs = GetRAPCalcParam(RAPStat, 'n', 'SubSeqs'); if isempty(incSubs), ErrTxt = 'No recorded subsequences for this dataset'; return; end
                fprintf('Current range is :\n');
                fprintf(' X-indepval: %s (%s)\n', mat2str(RAPStat.GenParam.DS.xval(incSubs)'), RAPStat.GenParam.DS.xunit);
                fprintf(' Y-indepval: %s (%s)\n', mat2str(RAPStat.GenParam.DS.yval(incSubs)'), RAPStat.GenParam.DS.yunit);
            elseif ~isRAPStatDef(RAPStat, 'GenParam.DS'),  
                incSubs = GetRAPCalcParam(RAPStat, 'n', 'SubSeqs'); if isempty(incSubs), ErrTxt = 'No recorded subsequences for this dataset'; return; end
                fprintf('Current range is %s (%s).\n', mat2str(RAPStat.GenParam.DS.xval(incSubs)'), RAPStat.GenParam.DS.xunit); 
            end
        else, fprintf('Current included subsequences are %s.\n', GetRAPCalcParam(RAPStat, 's', 'SubSeqs')); end
    end
elseif all(cellfun('isclass', Args, 'char')) & strcmpi(Args{end}, 'def'),
    RAPStat.CalcParam.SubSeqs = DefValue;
    
    if any(strcmpi(DS.stimtype , {'thr', 'th'})),               % THR Curve: XData = freqs
        if strcmpi(DS.fileformat, 'sgsr'), Nsub = DS.nsub-1;
        else, Nsub = DS.nsub; end
        
        RAPStat.CalcData.XData = DS.OtherData.thrCurve.freq(1:Nsub);
    else,                                                       % Not THR: XData = IndepVal
        Nsub = DS.NRec;
        
        IndepVal = ExtractIndepVal(DS, 1:Nsub);
        [IndepVal, idx] = sort(IndepVal);
        RAPStat.CalcData.XData = IndepVal;
    end
else,
    if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
    ds = RAPStat.GenParam.DS; if isCALIBdata(ds), ErrTxt = 'Range cannot be restricted on current dataset'; return; end
    if isTHRdata(ds), iSubRec = 1:length(ds.xval); else, iSubRec = 1:ds.nrec; end
    if isempty(iSubRec), ErrTxt = 'No recorded subsequences for this dataset'; return; end

    switch Args{1},
    case 'x',
        if (NArgs == 1),
            if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
                incSubs = GetRAPCalcParam(RAPStat, 'n', 'SubSeqs');
                if strcmpi(ds.FileFormat, 'EDF') & (ds.indepnr == 2),
                    fprintf('Current range is :\n');
                    fprintf(' X-indepval: %s (%s)\n', mat2str(ds.xval(incSubs)'), ds.xunit);
                    fprintf(' Y-indepval: %s (%s)\n', mat2str(ds.yval(incSubs)'), ds.yunit);
                else, fprintf('Current range is %s (%s).\n', mat2str(ds.xval(incSubs)'), ds.xunit); end
            end
        else,    
            [Args{2:end}, ErrTxt] = GetRAPFloat(RAPStat, Args{2:end});
            if ~isempty(ErrTxt), return; end
            
            [Range, ErrTxt] = GetIndepVarRange(Tol, ds.xval(iSubRec), Args{2:end});
            if ~isempty(ErrTxt), return; end
            
            idx = find(ismember(roundoff(ds.xval, Tol), Range))';
            if strcmpi(ds.FileFormat, 'EDF') & (ds.indepnr == 2),
                RAPStat.CalcParam.SubSeqs = intersect(GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'), idx);
            else, RAPStat.CalcParam.SubSeqs = idx; end
        end
    case 'y', 
        if ~strcmpi(RAPStat.GenParam.DS.FileFormat, 'EDF'), 
            ErrTxt = 'Second independent variable only implemented for EDF datasets'; return;
        elseif (ds.indepnr == 1), 
            ErrTxt = 'No second independent variable present'; return;
        elseif (NArgs == 1),
            if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
                incSubs = GetRAPCalcParam(RAPStat, 'n', 'SubSeqs');
                fprintf('Current range is :\n');
                fprintf(' X-indepval: %s (%s)\n', mat2str(ds.xval(incSubs)'), ds.xunit);
                fprintf(' Y-indepval: %s (%s)\n', mat2str(ds.yval(incSubs)'), ds.yunit);
            end
        else,
            [Args{2:end}, ErrTxt] = GetRAPFloat(RAPStat, Args{2:end});
            if ~isempty(ErrTxt), return; end
            
            [Range, ErrTxt] = GetIndepVarRange(Tol, ds.yval(iSubRec), Args{2:end});
            if ~isempty(ErrTxt), return; end
            
            idx = find(ismember(roundoff(ds.yval, Tol), Range))';
            if strcmpi(ds.FileFormat, 'EDF') & (ds.indepnr == 2),
                RAPStat.CalcParam.SubSeqs = intersect(GetRAPCalcParam(RAPStat, 'nr', 'SubSeqs'), idx);
            else, RAPStat.CalcParam.SubSeqs = idx; end
        end    
    case 'seq',
        if (NArgs == 1),
            if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), fprintf('Current range is %s.\n', GetRAPCalcParam(RAPStat, 's', 'SubSeqs')); end
        else,    
            if (NArgs > 2), 
                [Bgn, End] = GetRAPInt(RAPStat, Args{2:3}); 
                if NArgs == 4, Step = Args{4}; else Step = 1; end
            else, 
                [Bgn, End] = deal(GetRAPInt(RAPStat, Args{2})); 
                Step = 1;
            end
            if (Bgn <= 0) | (Bgn > End) | Step <= 0 | ~all(ismember(Bgn:Step:End, iSubRec)), 
                ErrTxt = 'Invalid range'; return;
            end
            
            RAPStat.CalcParam.SubSeqs = Bgn:Step:End;
        end    
    end
    
    if any(strcmpi(DS.stimtype , {'thr', 'th'})),               % THR Curve: XData = freqs
        RAPStat.CalcData.XData = DS.OtherData.thrCurve.freq(RAPStat.CalcParam.SubSeqs);
    else,                                                       % Not THR: XData = IndepVal
        IndepVal = ExtractIndepVal(DS, RAPStat.CalcParam.SubSeqs);
        [IndepVal, idx] = sort(IndepVal);
        RAPStat.CalcData.XData = IndepVal;
    end
end

LineNr = LineNr + 1;

%--------------------------------local functions------------------------------
function  [Range, ErrTxt] = GetIndepVarRange(Tol, IndepVal, Bgn, End, Step)

Range = []; ErrTxt = '';

IndepVal = unique(IndepVal); %For multiple independent variables ...
if (length(IndepVal) == 1), DiffVal = IndepVal;
else, DiffVal  = unique(roundoff(diff(IndepVal), Tol)); end

%If Bgn is not in range, take first value higher than Bgn
H = IndepVal(find(IndepVal>=Bgn)); %Look for values higher or equal to Bgn
if ~isempty(H), Bgn = min(H);      %Bgn is smallers value in IndepVal higher or equal to Bgn
else ErrTxt = 'Invalid range'; return; end

if (nargin == 3), End = Bgn; 
else
    %Other way around for End
    L = IndepVal(find(IndepVal<=End));
    if ~isempty(L), End = max(L);
    else ErrTxt = 'Invalid range'; return; end;
end

if length(DiffVal) == 1, %Linear ...
    if (nargin < 5), Step = DiffVal; end
    Range = Bgn:Step:End;
else, %Logaritmic ...
    if (nargin < 5), Step = log2(IndepVal(2)/IndepVal(1)); end
    N = floor(log2(End/Bgn)/Step + 1);
    Range = Bgn * 2.^(Step * (0:N-1)'); 
end
Range = roundoff(Range, Tol);

if isempty(Range) | ~all(ismember(Range, roundoff(IndepVal, Tol))), ErrTxt = 'Invalid range'; return; end

%-------------------------------------------------------------------------------
function V = roundoff(V, Tol)

V = round(V/Tol)*Tol;