function BoxHdl = CreateRAPDateBox(FigHdl, RAPStat)
%CreateRAPDateBox    creates date box on figure object
%   BoxHdl = CreateRAPDateBox(FigHdl, RAPStat)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 19-03-2004

Str = [datestr(now), ' ', RAPStat.ComLineParam.McoName];

DateBox = RAPStat.PlotParam.DateBox;

Pos = [DateBox.Pos, eps, DateBox.Height]; %Height is important to specify fontsize ... 
BoxHdl  = axes('Parent', FigHdl, 'Position', Pos, 'Visible', 'off', 'Color', [0 0 0], ...
    'Units', 'normalized', 'Box', 'on', 'XLim', [0 1], 'YLim', [0 1], ...
    'XColor', [0 0 0], 'YColor', [0 0 0], ...
    'XTick', [], 'XTickLabel', '', 'YTick', [], 'YTickLabel', '');

if strcmpi(DateBox.Visible, 'on'),
    switch DateBox.Alignment
    case 'hor',    
        TxtHdl = text(0, 0, Str, ...
            'Units', 'normalized', 'Interpreter', 'tex', 'Color', DateBox.Color, ...
            'Rotation', 0, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
            'FontUnits', 'normalized', 'FontName', DateBox.FontName, 'FontSize', 1);
    case 'ver',
        TxtHdl = text(0, 0, Str, ...
            'Units', 'normalized', 'Interpreter', 'tex', 'Color', DateBox.Color, ...
            'Rotation', 90, 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', ...
            'FontUnits', 'normalized', 'FontName', DateBox.FontName, 'FontSize', 1);
    end
end

