function [FigHdl, RAPStat] = CreateRAPFigure(ArgIn)
    %CreateRAPFigure     creates figure object for RAP
    %   [FigHdl, RAPStat] = CreateRAPFigure(RAPStat)
    %
    %   Attention! This function is an internal function belonging to the RAP
    %   project and should not be invoked from the MATLAB command prompt.
    
    %B. Van de Sande 31-03-2004
    
%% ---------------- CHANGELOG -----------------------
%  Thu Jun 9 2011  Abel   
%   - introduced Kplot's defaultPage() to create the page.
%   - RAP now uses Kplot's headerObject to create the header
%
%% ---------------- TODO ----------------------------
%  Thu Jun 9 2011  Abel   
%   - Introduce Kplot to RAP's plotting functions
	
	
    if isstruct(ArgIn)
        Flag = 'init';
        RAPStat = ArgIn;
    else
        Flag = lower(ArgIn);
    end
    
    switch Flag
        case 'init'
            xMargin = 0.05;
            yMargin = 0.15;
            X = xMargin;
            Y = yMargin;
            Width = 1 - 2*xMargin;
            Height = 1 - 2*yMargin;
            FigSize = [X, Y, Width, Height];
            
            FigName = RAPStat.PlotParam.Figure.Caption;
            FigVisible = RAPStat.PlotParam.Figure.Visible;
			FigHdl = defaultPage(FigName);
%             FigHdl = figure( ...
%                 'Name', FigName, ...
%                 'Visible', FigVisible, ...     %Creation of invisible figure necessary
%                 ...                            %when redirecting output to printer ... (NOT YET IMPLEMENTED)
%                 'PaperType', 'A4', ...         %To remove shift to right on printouts ...
%                 'PaperUnits', 'normalized', ...
%                 'PaperPositionMode', 'manual', ...
%                 'PaperPosition', [0.05 0.05 0.90 0.90], ...
%                 'PaperOrientation', 'landscape', ...
%                 'RendererMode', 'manual', ...  %Setting the renderer default to painters,
%                 'Units', 'normalized', ...
%                 'Position', FigSize, ...
%                 'ResizeFcn', 'CreateRAPFigure(''resize'');', ...
%                 'Tag', 'RAP', ...
%                 'NumberTitle', 'off', ...      %To avoid interference with other active MATLAB plots no
%                 'IntegerHandle', 'off');       %integer handles are used for RAP figures ...
%             
			set(FigHdl, 'ResizeFcn', '');
			headPanel = headerPanel('dataset', RAPStat.GenParam.DS, 'FontSize', 8);
			headPanel = redraw(headPanel);
			HdrHdl = getHdl(headPanel);
			
            %HdrHdl = CreateRAPHeader(FigHdl, RAPStat);
            if strcmpi(RAPStat.PlotParam.DateBox.Visible, 'on')
                DateHdl = CreateRAPDateBox(FigHdl, RAPStat);
            else
                DateHdl = NaN;
            end
            
            RAPStat.PlotParam.Figure.Hdl  = FigHdl;
            RAPStat.PlotParam.Header.Hdl  = HdrHdl;
            RAPStat.PlotParam.DateBox.Hdl = DateHdl;
            
            %To prevent memory overflow when multiple figures are open
            %simultaneously in RAP, the RAP status variable that is assigned to
            %a figure doesn't contain the spiketimes of the dataset,
            %the LUT for the datafile and various unneeded parameters ...
            UD = RAPStat;
            UD.GenParam.DS = EmptyDataset(UD.GenParam.DS);
            if ~isempty(UD.GenParam.DS2)
                UD.GenParam.DS2 = EmptyDataset(UD.GenParam.DS2);
            end
            UD = rmfield(UD, {'ComLineParam', 'Memory', 'CalcData'});
            UD.GenParam.LUT = [];
            set(FigHdl, 'UserData', UD);
        case 'resize'
            [dummy, FigHdl]  = gcbo;
            RAPStat = get(FigHdl, 'UserData');
            
            %The header needs to be resized even if the units of all child objects are normalized.
            %The problem is that the fontsize is normalized with respect to the height of the header,
            %thus if the header only changes in width the fontsize doesn't change but the separating
            %lines do change!
            delete(RAPStat.PlotParam.Header.Hdl);       %Deleting old header object ...
            HdrHdl = CreateRAPHeader(FigHdl, RAPStat);  %Creating new one ...
            
            RAPStat.PlotParam.Header.Hdl = HdrHdl;
            set(FigHdl, 'UserData', RAPStat);
    end
