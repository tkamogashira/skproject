function [RAPStat, PlotStruct, ErrTxt] = AssembleRAPScatterPlot(RAPStat, XExpr, YExpr)
%CalcRAPXXX   actual code for the calculation of RAP curves  
%   [RAPStat, PlotData, ErrTxt] = CalcRAPXXX(RAPStat) 
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 05-05-2004

%------------------------------implementation details-------------------------------
%   Following steps need to be taken for the implementation of a curve:
%
%   1)Checking of a dataset is already specified in the RAP session and if the 
%     particular curve can be calculated from the dataset ...
%   2)Applying calculation parameters ...
%   3)Calculating additional information if necessary ...
%   4)Assembling of a structure that contains all the data to generate an RAP plot, see
%     CreateRAPPlot.m for the layout of this structure. It can be passed entirely to this
%     function. The mandatoty text on a plot is the number of subsequences included
%     in the analysis in the upper left corner, the appliable calculation parameters in
%     the lower left corner (use AssembleRAPCalcParam.m) and if present calculated 
%     data extracted from the curve in the upper right corner ... 
%   5)Every calculation routine of the RAP project can change the RAP status variable,
%     this is neccessary because data retrieved from the calculations needs to be 
%     accessible afterwards, e.g. to replace substitution variables.
%
%   Attention! If the number of subsequences included in the analysis is more than one
%   and the curve can only be calculated for a single subsequence, an array of 
%   PlotStruct's needs to be returned ...
%-----------------------------------------------------------------------------------

ErrTxt = '';

%Checking expressions ...
if isRAPSubstVar(XExpr, 'char'), %Character substitution variable ...
    ErrTxt = 'Character substitution variable is not valid for a scatterplot'; return;
else, %Valid numeric expression ...
    [PFExpr, ErrTxt] = TransExprIF2PF(XExpr);
    if ~isempty(ErrTxt), return; end
    X = EvalPFExpr(RAPStat, PFExpr);
    if isempty(X), ErrTxt = 'Could not evaluate expression'; return; end
end
if isRAPSubstVar(YExpr, 'char'), %Character substitution variable ...
    ErrTxt = 'Character substitution variable is not valid for a scatterplot'; return;
else, %Valid numeric expression ...
    [PFExpr, ErrTxt] = TransExprIF2PF(YExpr);
    if ~isempty(ErrTxt), return; end
    Y = EvalPFExpr(RAPStat, PFExpr);
    if isempty(Y), ErrTxt = 'Could not evaluate expression'; return; end
end

%Check length of resulting vectors and perform scalar expansion if necessary ...
if (length(X) == 1), X = repmat(X, size(Y));
elseif (length(Y) == 1), Y = repmat(Y, size(X));   
elseif ~isequal(length(X), length(Y)), 
    ErrTxt = 'Vectors must have same length for a scatter plot';
end

%Assembling the PlotStruct structure ...
PlotStruct.Layout         = 'uni';
PlotStruct.Plot.Type      = 'line';
PlotStruct.Plot.XData     = X; 
PlotStruct.Plot.YData     = Y;
PlotStruct.Plot.FaceColor = RAPStat.PlotParam.Scp.LineColor;
PlotStruct.Plot.EdgeColor = [];
PlotStruct.Plot.LineStyle = RAPStat.PlotParam.Scp.LineStyle;
PlotStruct.Plot.LineWidth = RAPStat.PlotParam.Scp.LineWidth;
PlotStruct.Plot.Marker    = RAPStat.PlotParam.Scp.Marker;

PlotStruct.Axis.Color     = RAPStat.PlotParam.Axis.Color;
PlotStruct.Axis.Box       = RAPStat.PlotParam.Axis.Box;
PlotStruct.Axis.TickDir   = RAPStat.PlotParam.Axis.TickDir;
PlotStruct.Axis.LineWidth = RAPStat.PlotParam.Axis.LineWidth;
PlotStruct.Axis.FontName  = RAPStat.PlotParam.Axis.Tic.FontName;
PlotStruct.Axis.FontSize  = RAPStat.PlotParam.Axis.Tic.FontSize;

PlotStruct.Axis.X = RAPStat.PlotParam.Axis.X;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Label.String'), PlotStruct.Axis.X.Label.String = 'X'; end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.X.Scale'), PlotStruct.Axis.X.Scale = 'linear'; end

PlotStruct.Axis.Y = RAPStat.PlotParam.Axis.Y;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Label.String'), PlotStruct.Axis.Y.Label.String = 'Y'; end
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Y.Scale'), PlotStruct.Axis.Y.Scale = 'linear'; end

PlotStruct.Title = RAPStat.PlotParam.Axis.Title;
if isRAPStatDef(RAPStat, 'PlotParam.Axis.Title.Label'), PlotStruct.Title.Label = 'Scatter Plot'; end

%No extra information needs to be plotted ...
PlotStruct.Text = struct([]);

%Setting calculated data information in the RAP status variable...
RAPStat.CalcData.XData       = PlotStruct.Plot.XData;
RAPStat.CalcData.YData       = PlotStruct.Plot.YData;