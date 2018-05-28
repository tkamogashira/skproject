function [RAPStat, LineNr, ErrTxt] = RAPCmdSET(RAPStat, LineNr, FirstToken, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 26-07-2005

%-------------------------------------RAP Syntax------------------------------------
%   SET                       Displays the current RAP settings
%   SET DEF                   Set all parameters to default
%   SET TXT @@ UL/UR/LL/LR    Set location of any of the following (*)
%                               SSQ  : Subsequence information                        
%                               CLC  : Calculation parameters of foreground dataset
%                               CLC2 : Calculation parameters of background dataset
%                               EXT  : Extracted data
%   SET TXT @@ ON/OFF         Display any of the following (*)
%                               SSQ : Subsequence information                        
%                               CLC : Calculation parameters of foreground dataset
%                               CLC2 : Calculation parameters of background dataset
%                               EXT : Extracted data
%   SET YLOC RIGHT/LEFT       Plot axis to use as the Y-axis
%   SET YLOC DEF              Set plot Y-axis to default
%   SET TI "..." [V#/C# "..." V#/C# ...]    Set value of title
%   SET XLBL "..." [V#/C# "..." V#/C# ...]     Set value of X-axis label
%   SET YLBL "..." [V#/C# "..." V#/C# ...]     Set value of Y-axis label
%   SET TI/XLBL/YLBL DEF      Set specified title or label to default
%   SET RGL WIN #1 #2	      Averagng wndow for regularity analysis
%   SET RGL WIN DEF	          Set averaging window to default
%   SET RGL MINSPK #          Min. intervals/bin for regl. analysis
%   SET RGL MINSPK DEF        Min. spikes for regularity to default
%   SET PKL SRW #1 #2         Window for spon. rate estimation for peak latency computation (*)
%   SET PKL SRW DEF           Window for spon. rate estimation to default (*)
%   SET PKL PKW #1 #2         Peak window for peak latency computation (*)
%   SET PKL PKW DEF           Peak window to default (*)
%   SET TH Q #                Thresold for Q-factor estimation (*)
%   SET TH Q DEF              Default threshold for Q-factor (*)
%   SET SYNC THR #            Set cutoff threshold on synchronisation curve (*)
%   SET SYNC THR DEF          Default cutoff threshold on synchronisation curve (*)
%   SET SP ERR ON/OFF/DEF     Plot or do not plot error bars on rate level curves (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), FirstToken = 'list'; end

switch lower(FirstToken),
case 'list', 
    if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), ListRAPStatus(RAPStat); end
case 'def', 
    oldGenParam = RAPStat.GenParam;
    RAPStat = ManageRAPStatus;
    RAPStat.GenParam = oldGenParam;
case 'yloc',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('The current ordinate location is %s\n', RAPStat.PlotParam.Axis.Y.Location);
        end
    elseif strcmp(varargin{1}, 'def'), 
        RAPStat.PlotParam.Axis.Y.Location = ManageRAPStatus('PlotParam.Axis.Y.Location');
    elseif isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return;    
    else, RAPStat.PlotParam.Axis.Y.Location = varargin{1}; end
case 'xlbl',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('The current abcis label is %s\n', ConvRAPStatLabel(RAPStat.PlotParam.Axis.X.Label.String));
        end
    elseif strcmp(varargin{1}, 'def'), 
        if (nargin > 4), ErrTxt = 'Syntax error'; return; end
        RAPStat.PlotParam.Axis.X.Label.String = ManageRAPStatus('PlotParam.Axis.X.Label.String');
    elseif isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return;    
    else, 
        Str = ParseRAPStrArgs(RAPStat, varargin);
        if isempty(Str), ErrTxt = 'One of the variables is not yet set'; return; end
        RAPStat.PlotParam.Axis.X.Label = Str; 
    end
case 'ylbl',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('The current ordinate label is %s\n', ConvRAPStatLabel(RAPStat.PlotParam.Axis.Y.Label.String));
        end
    elseif strcmp(varargin{1}, 'def'), 
        if (nargin > 4), ErrTxt = 'Syntax error'; return; end
        RAPStat.PlotParam.Axis.Y.Label.String = ManageRAPStatus('PlotParam.Axis.Y.Label.String');
    elseif isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return;    
    else, 
        Str = ParseRAPStrArgs(RAPStat, varargin);
        if isempty(Str), ErrTxt = 'One of the variables is not yet set'; return; end
        RAPStat.PlotParam.Axis.Y.Label.String = Str; 
    end
case 'ti',    
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('The current title label is %s\n', ConvRAPStatLabel(RAPStat.PlotParam.Axis.Title.Label));
        end
    elseif strcmp(varargin{1}, 'def'), 
        if (nargin > 4), ErrTxt = 'Syntax error'; return; end
        RAPStat.PlotParam.Axis.Title.Label = ManageRAPStatus('PlotParam.Axis.Title.Label');
    elseif isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return;    
    else, 
        Str = ParseRAPStrArgs(RAPStat, varargin);
        if isempty(Str), ErrTxt = 'One of the variables is not yet set'; return; end
        RAPStat.PlotParam.Axis.Title.Label = Str; 
    end
case 'txt',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Text location subseq. info: %s\n', RAPStat.PlotParam.Axis.Text.Location.SubSeq);
            fprintf('Text location calc. param : %s\n', RAPStat.PlotParam.Axis.Text.Location.CalcParam);
            fprintf('Text location calc. param2: %s\n', RAPStat.PlotParam.Axis.Text.Location.CalcParam2);
            fprintf('Text location extr. data  : %s\n', RAPStat.PlotParam.Axis.Text.Location.CalcData);
            fprintf('Text display subseq. info : %s\n', RAPStat.PlotParam.Axis.Text.SubSeq);
            fprintf('Text display calc. param  : %s\n', RAPStat.PlotParam.Axis.Text.CalcParam);
            fprintf('Text display calc. param2 : %s\n', RAPStat.PlotParam.Axis.Text.CalcParam2);
            fprintf('Text display extr. data   : %s\n', RAPStat.PlotParam.Axis.Text.CalcData);
        end
    elseif strcmpi(varargin{1}, 'ssq'),
        if any(strcmpi(varargin{2}, {'on', 'off'})), RAPStat.PlotParam.Axis.Text.SubSeq = varargin{2};
        else, RAPStat.PlotParam.Axis.Text.Location.SubSeq = varargin{2}; end
    elseif strcmpi(varargin{1}, 'clc'),
        if any(strcmpi(varargin{2}, {'on', 'off'})), RAPStat.PlotParam.Axis.Text.CalcParam = varargin{2};
        else, RAPStat.PlotParam.Axis.Text.Location.CalcParam = varargin{2}; end
    elseif strcmpi(varargin{1}, 'clc2'),
        if any(strcmpi(varargin{2}, {'on', 'off'})), RAPStat.PlotParam.Axis.Text.CalcParam2 = varargin{2};
        else, RAPStat.PlotParam.Axis.Text.Location.CalcParam2 = varargin{2}; end
    elseif strcmpi(varargin{1}, 'ext'),
        if any(strcmpi(varargin{2}, {'on', 'off'})), RAPStat.PlotParam.Axis.Text.CalcData = varargin{2};
        else, RAPStat.PlotParam.Axis.Text.Location.CalcData = varargin{2}; end
    end
case 'rgl',    
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Averaging window          : %s\n', GetRAPCalcParam(RAPStat, 's', 'AvgWin'));
            fprintf('Min nr. of intervals      : %s\n', GetRAPCalcParam(RAPStat, 's', 'MinNInt'));
        end
    elseif strcmpi(varargin{1}, 'win')
        if (nargin == 5) & ischar(varargin{2}) & strcmpi(varargin{2}, 'def'),
            RAPStat.CalcParam.AvgWin = ManageRAPStatus('CalcParam.AvgWin');
        else,
            [AvgWin(1), AvgWin(2), ErrTxt] = GetRAPFloat(RAPStat, varargin{2:3});
            if ~isempty(ErrTxt), return; end
            if any(AvgWin < 0) | (diff(AvgWin) < 0), 
                ErrTxt = 'Invalid averaging window for regularity analysis'; 
                return; 
            end
            RAPStat.CalcParam.AvgWin = AvgWin;
        end
    else,
        if ischar(varargin{2}) & strcmpi(varargin{2}, 'def'),
            RAPStat.CalcParam.MinNInt = ManageRAPStatus('CalcParam.MinNInt');
        else,
            [MinNInt, ErrTxt] = GetRAPInt(RAPStat, varargin{2});
            if ~isempty(ErrTxt), return; end
            if (MinNInt < 0), ErrTxt = 'Minimum number of intervals for regularity analysis cannot be negative'; return; end
            RAPStat.CalcParam.MinNInt = MinNInt;
        end
    end
case 'pkl',
    if (nargin == 3),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Peak window (PKL)         : %s\n', GetRAPCalcParam(RAPStat, 's', 'PklPkWin'));
            fprintf('Spon. rate window (PKL)   : %s\n', GetRAPCalcParam(RAPStat, 's', 'PklSrWin'));
        end
    elseif strcmpi(varargin{1}, 'srw')
        if (nargin == 5) & ischar(varargin{2}) & strcmpi(varargin{2}, 'def'),
            RAPStat.CalcParam.PklSrWin = ManageRAPStatus('CalcParam.PklSrWin');
        else,
            [SrWin(1), SrWin(2), ErrTxt] = GetRAPFloat(RAPStat, varargin{2:3});
            if ~isempty(ErrTxt), return; end
            if any(SrWin < 0) | (diff(SrWin) < 0), 
                ErrTxt = 'Invalid window for spon. rate estimation'; 
                return; 
            end
            RAPStat.CalcParam.PklSrWin = SrWin;
        end
    else,
        if (nargin == 5) & ischar(varargin{2}) & strcmpi(varargin{2}, 'def'),
            RAPStat.CalcParam.PklPkWin = ManageRAPStatus('CalcParam.PklPkWin');
        else,
            [PkWin(1), PkWin(2), ErrTxt] = GetRAPFloat(RAPStat, varargin{2:3});
            if ~isempty(ErrTxt), return; end
            if any(PkWin < 0) | (diff(PkWin) < 0), 
                ErrTxt = 'Invalid peak window'; 
                return; 
            end
            RAPStat.CalcParam.PklPkWin = PkWin;
        end
    end
case 'th',
    if (nargin == 4),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Q-factor threshold is %s\n', GetRAPCalcParam(RAPStat, 's', 'ThrQ'));
        end
    elseif ischar(varargin{2}) & strcmpi(varargin{2}, 'def'), RAPStat.CalcParam.ThrQ = ManageRAPStatus('CalcParam.ThrQ');
    else,
        [Thr, ErrTxt] = GetRAPFloat(RAPStat, varargin{2});
        if ~isempty(ErrTxt), return; end
        if (Thr <= 0), ErrTxt = 'Invalid Q-factor treshold'; return; end
        RAPStat.CalcParam.ThrQ = Thr;
    end
case 'sync',
    if (nargin == 4),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Cutoff threshold on synchronisation curve is %s\n', GetRAPCalcParam(RAPStat, 's', 'SyncThr'));
        end
    elseif ischar(varargin{2}) & strcmpi(varargin{2}, 'def'), RAPStat.CalcParam.SyncThr = ManageRAPStatus('CalcParam.SyncThr');
    else,
        [Thr, ErrTxt] = GetRAPFloat(RAPStat, varargin{2});
        if ~isempty(ErrTxt), return; end
        if (Thr <= 0), ErrTxt = 'Invalid cutoff treshold'; return; end
        RAPStat.CalcParam.SyncThr = Thr;
    end
case 'sp',
    if (nargin == 4),
        if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
            fprintf('Error bars on rate curves: %s\n', RAPStat.PlotParam.Rate.ErrorBars.Plot);
        end
    elseif strcmp(varargin{2}, 'def'), 
        RAPStat.PlotParam.Rate.ErrorBars.Plot = ManageRAPStatus('PlotParam.Rate.ErrorBars.Plot');
    elseif strcmp(varargin{2}, 'on'), RAPStat.PlotParam.Rate.ErrorBars.Plot = 'yes';
    else, RAPStat.PlotParam.Rate.ErrorBars.Plot = 'no'; end
end

LineNr = LineNr + 1;