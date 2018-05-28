function Hdl = printinfo(Pos, TextCell, FigHdl, varargin)
%PRINTINFO  print bordered text on figure
%   Hdl = PRINTINFO(Pos, S) prints text in character string or cell-array of strings S on the current figure. The 
%   position of the textbox on the figure must be given with a four-element vector Pos. The handle of the axes
%   object created is returned.
%
%   Hdl = PRINTINFO(Pos, S, FigHdl) prints text box in the figure with handle FigHdl. 
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default value, use 'list' as only property.

%B. Van de Sande 24-03-2003

DefParam.boxcolor   = [0.7 0.7 0.7];
DefParam.textcolor  = [0 0 0];
DefParam.fontname   = 'arial';
DefParam.fontangle  = 'normal';
DefParam.fontweight = 'demi';
DefParam.fontsize   = 9;
 
if (nargin < 2), error('Wrong number of input arguments.'); end
if nargin == 2, FigHdl  = gcf; end
Param = checkproplist(DefParam, varargin{:});

Ax_hdl = axes('Parent', gcf, ...
              'Position', Pos, ...
              'Box', 'on', ...
              'Color', Param.boxcolor, ...
              'Units', 'normalized');
          
set(Ax_hdl, 'YTick', [], ...
            'YTickLabel', [], ...
            'XTick', [], ...
            'XTickLabel', []);
          
Txt_hdl = text(0.5,0.5, TextCell);
set(Txt_hdl, 'VerticalAlignment', 'middle', ...
             'HorizontalAlignment', 'center', ...
             'Color', Param.textcolor, ...
             'FontName', Param.fontname, ...
             'FontAngle', Param.fontangle, ...
             'FontSize', Param.fontsize, ...
             'FontWeight', Param.fontweight);
              
Hdl = [ Ax_hdl ; Txt_hdl ];
