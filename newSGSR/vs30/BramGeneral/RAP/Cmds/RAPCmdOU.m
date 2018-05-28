function [RAPStat, LineNr, ErrTxt] = RAPCmdOU(RAPStat, LineNr, PlotType, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 24-06-2004

%-------------------------------------RAP Syntax------------------------------------
%   OU DI                     Output directory (display all information)
%   OU DI @@...@@ [@@..@@ ...]Directory output restricted to entries containing
%                             the given string. A list of extra substitution variables
%                             to display can be given.
%   OU DI # [@@..@@ ...]      Directory output restricted to given cell-number.
%                             A list of extra substitution variables to display
%                             can be given.
%   OU DS [@@@...@@@/#]       Output directory (display only dataset number)
%   OU ID [@@@...@@@/#]       Output directory (display only dataset identifiers)
%   OU TH			          Output Threshold (Tuning) curve plot
%   OU SP [COUNT/RATE] [HOLD] Output spike counts or rates vs. variable,
%                             when HOLD is specified the data is stored in
%                             a buffer to be plotted with OU COMB
%   OU COMB                   Plot the plots stored in the buffer all in
%                             the same figure
%   OU RAS                    Output dot raster
%   OU SYNC/SY	              Output Sync. Coeff. vs variable
%   OU PHASE/PH		          Output Phase vs. variables
%   OU PST/PS   	          Output Post Stimulus Time Histograms
%   OU ISI			          Output Inter-spike interval Histograms
%   OU CH			          Output Cycle (or Phase) Histograms
%   OU CHD                    Output Cycle Histogram Dot raster
%   OU LAT 		       	      Output First Spiketime Latency Histograms
%   OU SAC [COUNT/RATE/NORM]  Output Shuffled AutoCorrelation
%   OU XC [COUNT/RATE/NORM]   Output CrossCorrelation
%   OU DIF [COUNT/RATE/NORM]  Output DifCor (*)
%   OU RGL [CV]		          Regularity analysis (CV vs time)
%   OU RGL MEAN		          Regularity analysis (Mean & St.dev)
%   OU PKL                    Peak latency plot (*)
%   OU TRD [COUNT/RATE]       Output Trial Rate Distribution (*)
%   OU SCP @@..@@ @@..@@      Output Scatterplot
%   OU CR [NORM/COUNT]        Output Coincidence Rate (*)
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Make sure a figure is actually displayed ...
RAPStat.PlotParam.Figure.Visible = 'on';

switch PlotType
    case 'di',     %Overview of datasets in experiment (display all information) ...
        if (nargin >= 4)
            if ischar(varargin{1}) && ~isRAPVMemVar(varargin{1})
                [Pattern, ErrTxt] = GetRAPChar(RAPStat, varargin{1});
                if ~isempty(ErrTxt)
                    return
                end
            else
                [Pattern, ErrTxt] = GetRAPInt(RAPStat, varargin{1});
                if ~isempty(ErrTxt)
                    return
                end
            end
            ErrTxt = ListRAPDataFile(RAPStat, {'DSnr', 'dsID'}, Pattern, varargin{2:end});
        else
            ErrTxt = ListRAPDataFile(RAPStat, {'DSnr', 'dsID'});
        end
        if ~isempty(ErrTxt)
            return
        end
    case 'id',     %Overview of datasets in experiment (display only dataset identifiers) ...
        if (nargin >= 4)
            if ischar(varargin{1}) && ~isRAPVMemVar(varargin{1})
                [Pattern, ErrTxt] = GetRAPChar(RAPStat, varargin{1});
                if ~isempty(ErrTxt)
                    return
                end
            else
                [Pattern, ErrTxt] = GetRAPInt(RAPStat, varargin{1});
                if ~isempty(ErrTxt)
                    return
                end
            end
            ErrTxt = ListRAPDataFile(RAPStat, 'dsID', Pattern, varargin{2:end});
        else
            ErrTxt = ListRAPDataFile(RAPStat, 'dsID');
        end
        if ~isempty(ErrTxt)
            return
        end
    case 'ds',     %Overview of datasets in experiment (display only dataset sequence numbers) ...
        if (nargin >= 4)
            if ischar(varargin{1}) && ~isRAPVMemVar(varargin{1})
                [Pattern, ErrTxt] = GetRAPChar(RAPStat, varargin{1});
                if ~isempty(ErrTxt)
                    return
                end
            else
                [Pattern, ErrTxt] = GetRAPInt(RAPStat, varargin{1});
                if ~isempty(ErrTxt)
                    return
                end
            end
            ErrTxt = ListRAPDataFile(RAPStat, 'DSnr', Pattern, varargin{2:end});
        else
            ErrTxt = ListRAPDataFile(RAPStat, 'DSnr');
        end
        if ~isempty(ErrTxt)
            return
        end
    case 'th',     %Threshold curve ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPThr(RAPStat);
        if ~isempty(ErrTxt)
            return
        end
        [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
        if ~isempty(ErrTxt)
            return
        end
    case 'sp',     %Rate curve ...
        if nargin == 4 && any(strcmpi(varargin{1}, {'count' 'rate'}))
            RAPStat.PlotParam.Rate.YAxisUnit = varargin{1};
        end
        [RAPStat, PlotData, ErrTxt] = CalcRAPRate(RAPStat);
        if ~isempty(ErrTxt)
            return
        end
        if ~(~isempty(varargin) && strcmpi(varargin{end},'hold'))
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
            if ~isempty(ErrTxt)
                    return
            end
            RAPStat.PlotParam.Rate.YAxisUnit = ...
                 ManageRAPStatus('PlotParam.Rate.YAxisUnit');
        else
            PlotData.DS = RAPStat.GenParam.DS;
            if ~isfield(RAPStat, 'PlotPool')
                RAPStat.PlotPool = PlotData;
            else
                RAPStat.PlotPool = [RAPStat.PlotPool PlotData];
            end
        end
    case 'comb',
        if isfield(RAPStat, 'PlotPool') && ~isempty(RAPStat.PlotPool)
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, RAPStat.PlotPool);
            RAPStat.PlotParam.Rate.YAxisUnit = ...
                 ManageRAPStatus('PlotParam.Rate.YAxisUnit');
            RAPStat = rmfield(RAPStat, 'PlotPool');
        else
            return
        end
    case 'ras',    %Dot raster ...
        [RAPStat, ErrTxt] = CreateRAPRasPlot(RAPStat);
        if ~isempty(ErrTxt)
            return
        end
    case {'sync', 'sy'},   %Vector Strength Magnitude versus Independent Variable curve ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPVsm(RAPStat);
        if ~isempty(ErrTxt)
            return
        end
        if ~(~isempty(varargin) && strcmpi(varargin{end},'hold'))
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
            if ~isempty(ErrTxt)
                return
            end
        else
            PlotData.DS = RAPStat.GenParam.DS;
            if ~isfield(RAPStat, 'PlotPool')
                RAPStat.PlotPool = PlotData;
            else
                RAPStat.PlotPool = [RAPStat.PlotPool PlotData];
            end
        end
    case {'phase', 'ph'}   %Vector Strength Phase versus Independent Variable curve ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPVsp(RAPStat);
        if ~isempty(ErrTxt)
            return
        end
        if ~(~isempty(varargin) && strcmpi(varargin{end},'hold'))
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
            if ~isempty(ErrTxt)
                return
            end
        else
            PlotData.DS = RAPStat.GenParam.DS;
            if ~isfield(RAPStat, 'PlotPool')
                RAPStat.PlotPool = PlotData;
            else
                RAPStat.PlotPool = [RAPStat.PlotPool PlotData];
            end
        end
    case {'pst', 'ps'},    %Post-Stimulus Time histogram ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPPsth(RAPStat);
        if ~isempty(ErrTxt), return; end
        NPlots = length(PlotData);
        for n = 1:NPlots,
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
            if ~isempty(ErrTxt), break; end
        end
        if ~isempty(ErrTxt), return; end
    case 'ch',     %Period histogram ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPPrdh(RAPStat, 'hist');
        if ~isempty(ErrTxt), return; end
        NPlots = length(PlotData);
        for n = 1:NPlots,
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
            if ~isempty(ErrTxt), break; end
        end
        if ~isempty(ErrTxt), return; end
    case 'pol',    %Polar histogram
        [RAPStat, PlotData, ErrTxt] = CalcRAPPrdh(RAPStat, 'pol');
        if ~isempty(ErrTxt), return; end
        NPlots = length(PlotData);
        for n = 1:NPlots,
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
            if ~isempty(ErrTxt), break; end
        end
        if ~isempty(ErrTxt), return; end
    case 'chd',    %Period dot raster ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPPrdRas(RAPStat);
        if ~isempty(ErrTxt), return; end
        NPlots = length(PlotData);
        for n = 1:NPlots,
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
            if ~isempty(ErrTxt), break; end
        end
        if ~isempty(ErrTxt), return; end
    case 'isi',    %InterSpike Interval histogram ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPIsih(RAPStat);
        if ~isempty(ErrTxt), return; end
        NPlots = length(PlotData);
        for n = 1:NPlots,
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
            if ~isempty(ErrTxt), break; end
        end
        if ~isempty(ErrTxt), return; end
    case 'lat',    %First Spike Latency histogram ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPFslh(RAPStat);
        if ~isempty(ErrTxt), return; end
        NPlots = length(PlotData);
        for n = 1:NPlots,
            [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
            if ~isempty(ErrTxt), break; end
        end
        if ~isempty(ErrTxt), return; end
    case 'sac',    %Shuffled AutoCorrelogram ...
        if (nargin == 4), RAPStat.PlotParam.Corr.YAxisUnit = varargin{1};end
        [RAPStat, PlotData, ErrTxt] = CalcRAPSac(RAPStat);
        if isempty(ErrTxt),
            NPlots = length(PlotData);
            for n = 1:NPlots,
                [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
                if ~isempty(ErrTxt), break; end
            end
        end
        RAPStat.PlotParam.Corr.YAxisUnit = ManageRAPStatus('PlotParam.Corr.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'xc',     %CrossCorrelogram ...
        if (nargin == 4), RAPStat.PlotParam.Corr.YAxisUnit = varargin{1}; end
        [RAPStat, PlotData, ErrTxt] = CalcRAPXc(RAPStat);
        if isempty(ErrTxt),
            NPlots = length(PlotData);
            for n = 1:NPlots,
                [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
                if ~isempty(ErrTxt), break; end
            end
        end
        RAPStat.PlotParam.Corr.YAxisUnit = ManageRAPStatus('PlotParam.Corr.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'dif',     %DifCor ...
        if (nargin == 4), RAPStat.PlotParam.Corr.YAxisUnit = varargin{1}; end
        [RAPStat, PlotData, ErrTxt] = CalcRAPDif(RAPStat);
        if isempty(ErrTxt),
            NPlots = length(PlotData);
            for n = 1:NPlots,
                [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
                if ~isempty(ErrTxt), break; end
            end
        end
        RAPStat.PlotParam.Corr.YAxisUnit = ManageRAPStatus('PlotParam.Corr.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'rgl',    %Regularity analysis ...
        if (nargin == 4), RAPStat.PlotParam.Rgl.YAxisUnit = varargin{1}; end
        [RAPStat, PlotData, ErrTxt] = CalcRAPRglh(RAPStat);
        if isempty(ErrTxt),
            NPlots = length(PlotData);
            for n = 1:NPlots,
                [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
                if ~isempty(ErrTxt), break; end
            end
        end
        RAPStat.PlotParam.Rgl.YAxisUnit = ManageRAPStatus('PlotParam.Rgl.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'pkl',    %Peak latency plot ...
        [RAPStat, PlotData, ErrTxt] = CalcRAPPkl(RAPStat);
        if ~isempty(ErrTxt), return; end
        [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
        if ~isempty(ErrTxt), return; end
    case 'scp',    %Scatterplot ...
        [RAPStat, PlotData, ErrTxt] = AssembleRAPScatterPlot(RAPStat, varargin{:});
        if ~isempty(ErrTxt), return; end
        [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
        if ~isempty(ErrTxt), return; end
    case 'trd',    %Trial rate distribution ...
        if (nargin == 4), RAPStat.PlotParam.Trd.YAxisUnit = varargin{1}; end
        [RAPStat, PlotData, ErrTxt] = CalcRAPTrd(RAPStat);
        if isempty(ErrTxt),
            NPlots = length(PlotData);
            for n = 1:NPlots,
                [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData(n));
                if ~isempty(ErrTxt), break; end
            end
        end
        RAPStat.PlotParam.Trd.YAxisUnit = ManageRAPStatus('PlotParam.Trd.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'cr', %Coincidence rate ...
        if (nargin == 4), RAPStat.PlotParam.Cr.YAxisUnit = varargin{1}; end
        [RAPStat, PlotData, ErrTxt] = CalcRAPCr(RAPStat);
        if ~isempty(ErrTxt), return; end
        [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
        RAPStat.PlotParam.Cr.YAxisUnit = ManageRAPStatus('PlotParam.Cr.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'sr', %Sync rate ...
        if (nargin == 4), RAPStat.PlotParam.Sr.YAxisUnit = varargin{1}; end
        [RAPStat, PlotData, ErrTxt] = CalcRAPSr(RAPStat);
        if ~isempty(ErrTxt), return; end
        [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
        RAPStat.PlotParam.Sr.YAxisUnit = ManageRAPStatus('PlotParam.Sr.YAxisUnit');
        if ~isempty(ErrTxt), return; end
    case 'ry', %Rayleigh...
        [RAPStat, PlotData, ErrTxt] = CalcRAPRy(RAPStat);
        if ~isempty(ErrTxt), return; end
        [RAPStat, ErrTxt] = CreateRAPPlot(RAPStat, PlotData);
        if ~isempty(ErrTxt), return; end
end

LineNr = LineNr + 1;
