function newPanel = Panel(varargin)
% PANEL Creates a new Panel
%
% A Panel object contains information about one axes; it contains the
% properties of the axes, and it keeps track of all the plots that belong
% to that axes. A figure can contain multiple Panels. A Panel can contain
% multiple plots on one axes.
% This is usefull when a lot of information is plotted on one axes, and a
% lot of book keeping needs to be done. A Panel object is for example
% extensively used in the function kevCorr.
%
% newPanel = Panel(params, 'nodraw')
%  Creates a new Panel instance newPanel and opens a figure.
%
% Arguments:
%    params: Set properties of the Panel object. This is done in a 
%            'propName1', newValue1, 'propName2', newValue2, ... list.
%            Possible parameters and their default values are the 
%            following:
%             Param:            Default:
%              title             ''
%              xlabel            ''
%              ylabel            ''
%              xlim              [0 0]
%              ylim              [0 0]
%              xTicks            []
%              yTicks            []
%              xTickLabels       {}
%              yTickLabels       {}
%              reverseY          'no'
%              reverseX          'no'
%              ticksDir          'in'
%              rightYAxes        'no'
%              rightYPositions   []
%              rightYLabels      {}
%              rightYLabel       ''
%              box               'off'
%              logX              'no'
%              logY              'no'
%              position          [0.10, 0.10, 0.80, 0.80]
%              axes              true
%			   logXformat		 'xlog125'
%              logYformat		 'ylog125'
%            Most of these parameters can be found in the "Axes properties"
%            page of the help file. rightYAxes indicates whether you want an
%            extra Y Axes with different units. logX and logY allow to use
%            logarithmic axes. axes determines whether the axes are shown.
%
%  'nodraw': (optional) If this is added at the end of the parameter list,
%            the resulting plot will not be shown. This is usefull when a
%            lot of work is done on the object; to make things faster, just
%            plot at the end.

% Created by: Kevin Spiritus
% Last edited: April 25th, 2006

%% ---------------- CHANGELOG -----------------------
%  Wed Mar 9 2011  Abel   
%   - Added option to keep Xlog/Ylog axis in default matlab format
%  Tue Apr 19 2011  Abel   
%   - Added legendObject handling 

%% check if last argument is 'noredraw'
doRedraw = true;
if ~isempty(varargin) 
   if isequal('nodraw', varargin{end})
       varargin = {varargin{1:end-1}};
       doRedraw = false;
   end
end

%% standard properties
% Internals
newPanel.hdl                    = -1;
newPanel.plotObjects            = {};
newPanel.textObjects            = {};
newPanel.legendObjects          = {};
newPanel.isRegistered           = false;
% User adaptable options
newPanel.params.title           = '';
newPanel.params.xlabel          = '';
newPanel.params.ylabel          = '';
newPanel.params.xlim            = [0 0];
newPanel.params.ylim            = [0 0];
newPanel.params.xTicks          = [];
newPanel.params.yTicks          = [];
newPanel.params.xTickLabels     = {};
newPanel.params.yTickLabels     = {};
newPanel.params.reverseY        = 'no';
newPanel.params.reverseX        = 'no';
newPanel.params.ticksDir        = 'in';
newPanel.params.rightYAxes      = 'no';
newPanel.params.rightYPositions = [];
newPanel.params.rightYLabels    = {};
newPanel.params.rightYLabel     = '';
newPanel.params.box             = 'off';
newPanel.params.logX            = 'no';
newPanel.params.logY            = 'no';
newPanel.params.position        = [0, 0, 0, 0];
newPanel.params.axes            = true;
%by Abel
newPanel.params.logXformat		= 'xlog125';
newPanel.params.logYformat		= 'ylog125';

newPanel = processParams(varargin, newPanel);

%% construct
newPanel = class(newPanel, 'Panel');

%% redraw
if isequal(1, doRedraw)
    newPanel = redraw(newPanel);
end
