function varargout = Monitor(varargin)
% MONITOR Application M-file for Monitor.fig
%    FIG = MONITOR launch Monitor GUI.
%    MONITOR('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 27-Jun-2002 16:19:15

global MonitorSetting MonitorHandles

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end
    
    %Keep the handles of the figure
    MonitorHandles=handles;
    
    %Initialize the setting structure
    Monitor('Initialize')
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end
drawnow; %update the figure


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Subfunctions for running external commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
% Set default MonitorSetting values
% --------------------------------------------------------------------
function DefaultSetting
global MonitorSetting MonitorHandles

    %%%%%%%%%%%%%%%%%%%%%%%
    %Flag for the window style
    MonitorSetting.ModalFlag=0; %Flag for whether the window should be modal
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Waveform amplitude voltage (ms) as 100 %
    MonitorSetting.VoltageFor100Percent=7; %
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Parameters of the bandpass filter
    MonitorSetting.FilterOrder=3; %IIR filter order
    MonitorSetting.FilterPassband=[300 5000]; %Passband of the IIR filter
    MonitorSetting.FilterB=[]; %Filter coefficients B
    MonitorSetting.FilterA=[]; %Filter coefficients A
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for waveform
    MonitorSetting.Waveform.Flag=1; %Flag for whether the plot is active
    MonitorSetting.Waveform.XLim=[]; %XLim; [] for default
    MonitorSetting.Waveform.YLim=[]; %YLim; [] for default
    MonitorSetting.Waveform.ReverseFlag=0; %Flag for whether the amplitude should be reversed
    MonitorSetting.Waveform.FilterFlag=1; %Flag for bandpass filtering
    MonitorSetting.Waveform.XData=[]; %XData
    MonitorSetting.Waveform.YData=[]; %YData
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for spikes
    MonitorSetting.Spikes.Flag=1; %Flag for whether the plot is active
    MonitorSetting.Spikes.XLim=[-1 2]; %XLim; [] for default
    MonitorSetting.Spikes.YLim=[-50 50]; %YLim; [] for default
    MonitorSetting.Spikes.CutThresh=[20]; %Cutoff threshold for spike detection; [] for default
    
    MonitorSetting.Spikes.Criterion1.Flag=0; %Flag for whether applying criterion 1
    MonitorSetting.Spikes.Criterion1.t=[0.5]; %Time of the criterions; [] for default
    MonitorSetting.Spikes.Criterion1.Hi=[100]; %Upper threshold; [] for default
    MonitorSetting.Spikes.Criterion1.Lo=[-100]; %Lower threshold; [] for default
    
    MonitorSetting.Spikes.Criterion2.Flag=0; %Flag for whether applying criterion 1
    MonitorSetting.Spikes.Criterion2.t=[1]; %Time of the criterions; [] for default
    MonitorSetting.Spikes.Criterion2.Hi=[100]; %Upper threshold; [] for default
    MonitorSetting.Spikes.Criterion2.Lo=[-100]; %Lower threshold; [] for default
    
    MonitorSetting.Spikes.XData=[];
    MonitorSetting.Spikes.YDataFail=[];
    MonitorSetting.Spikes.YDataPass=[];
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for raster plot
    MonitorSetting.Raster.Flag=1; %Flag for whether the plot is active
    MonitorSetting.Raster.XData=[]; %
    MonitorSetting.Raster.YData=[]; %
    MonitorSetting.Raster.ZData=[]; %Data matrix to display
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for PSTH
    MonitorSetting.PSTH.Flag=1; %Flag for whether the plot is active
    MonitorSetting.PSTH.XLim=[]; %XLim; [] for default
    MonitorSetting.PSTH.XData=[]; %
    MonitorSetting.PSTH.YData=[]; %
    MonitorSetting.PSTH.ZData=[]; %Data matrix to display

    
% --------------------------------------------------------------------
% Reset data
% --------------------------------------------------------------------
function ResetData
global MonitorSetting MonitorHandles

if ~isempty(MonitorSetting)
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for waveform
    MonitorSetting.Waveform.XData=[]; %XData
    MonitorSetting.Waveform.YData=[]; %YData
%	if ~isempty(findobj('Tag','figure_Monitor'))
%        set(MonitorHandles.axes_Waveform,'XLimMode','auto','YLimMode','auto');
%    end
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for spikes
    MonitorSetting.Spikes.XData=[];
    MonitorSetting.Spikes.YDataFail=[];
    MonitorSetting.Spikes.YDataPass=[];
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for raster plot
    MonitorSetting.Raster.XData=[]; %
    MonitorSetting.Raster.YData=[]; %
    MonitorSetting.Raster.ZData=[]; %Data matrix to display
    
    %%%%%%%%%%%%%%%%%%%%%%%
    %Settings for PSTH
    MonitorSetting.PSTH.XData=[]; %
    MonitorSetting.PSTH.YData=[]; %
    MonitorSetting.PSTH.ZData=[]; %Data matrix to display
end

% --------------------------------------------------------------------
% Update the monitor
% --------------------------------------------------------------------
function Update
global MonitorSetting

if ~isempty(findobj('Tag','figure_Monitor'))
    
    %Draw waveform
    if MonitorSetting.Waveform.Flag
        Monitor DrawWaveForm;
    end
    %Spike waveform
    if MonitorSetting.Spikes.Flag
        Monitor DrawSpikes;
    end
    %Raster
    if MonitorSetting.Raster.Flag
        Monitor ShowRaster;
    end
    %PSTH
    if MonitorSetting.PSTH.Flag
        Monitor ShowPSTH;
    end
    
end

% --------------------------------------------------------------------
% Plot a waveform
% --------------------------------------------------------------------
function DrawWaveForm
global MonitorSetting MonitorHandles

%Get handles for lines
myh=findobj(MonitorHandles.axes_Waveform,'Tag','WaveformLine');

%coordinates of the line
x=MonitorSetting.Waveform.XData;
y=MonitorSetting.Waveform.YData;
if isempty(x) | isempty(y) %If no data are supplied, draw nothing
    x=[]; y=[];
end

if isempty(myh)
    line(x,y,'Tag','WaveformLine','Parent',MonitorHandles.axes_Waveform,...
        'LineStyle','-','Color','b');
else
    set(myh,'XData',x,'YData',y);
end


% --------------------------------------------------------------------
% Plot spikes
% --------------------------------------------------------------------
function DrawSpikes
global MonitorSetting MonitorHandles

%Get handles for lines
hFail=findobj(MonitorHandles.axes_Spikes,'Tag','SpikesLineFail');
delete(hFail);
hPass=findobj(MonitorHandles.axes_Spikes,'Tag','SpikesLinePass');
delete(hPass);

%coordinates of the line for spikes that failed the criteria
xFail=MonitorSetting.Spikes.XData;
yFail=MonitorSetting.Spikes.YDataFail;
if isempty(xFail) | isempty(yFail) %If no data are supplied, draw nothing
    xFail=[];
    yFail=[];
end
hFail=line(xFail,yFail,'Tag','SpikesLineFail','Parent',MonitorHandles.axes_Spikes,...
    'LineStyle','-','Color',[1 1 1]*.75);

%coordinates of the line for spikes that passed the criteria
xPass=MonitorSetting.Spikes.XData;
yPass=MonitorSetting.Spikes.YDataPass;
if isempty(xPass) | isempty(yPass) %If no data are supplied, draw nothing
    xPass=[];
    yPass=[];
end
hPass=line(xPass,yPass,'Tag','SpikesLinePass','Parent',MonitorHandles.axes_Spikes,...
    'LineStyle','-','Color','b');


% --------------------------------------------------------------------
% Show raster
% --------------------------------------------------------------------
function ShowRaster
global MonitorSetting MonitorHandles

%Get handles for lines
myh=findobj(MonitorHandles.axes_Raster,'Tag','RasterImage');
%delete(myh);

%coordinates of the line
x=MonitorSetting.Raster.XData;
y=MonitorSetting.Raster.YData;
c=64*MonitorSetting.Raster.ZData;
if isempty(x) | isempty(y) | isempty(c) %If no data are supplied, draw nothing
    x=[]; y=[];  c=[];
    myc=[];
else
    myc=c*64;
end

if ~isempty(myh)
    set(myh,'XData',x,'YData',y,'CData',myc);
else
    myh=image('XData',x,'YData',y,'CData',myc,'Parent',MonitorHandles.axes_Raster,'Tag','RasterImage');
end
%Adjust limits
if isempty(myc)
    return;
end
dx=abs(x(2)-x(1));
dy=abs(y(2)-y(1));
set(MonitorHandles.axes_Raster,'XLim',[min(x)-dx/2 max(x)+dx/2],'TickDir','out');
set(MonitorHandles.axes_Raster,'YLim',[min(y)-dy/2 max(y)+dy/2]);

% --------------------------------------------------------------------
% Show PSTH
% --------------------------------------------------------------------
function ShowPSTH
global MonitorSetting MonitorHandles

%Get handles for lines
myh=findobj(MonitorHandles.axes_PSTH,'Tag','PSTHImage');

%Data handling
x=MonitorSetting.PSTH.XData;
y=MonitorSetting.PSTH.YData;
c=MonitorSetting.PSTH.ZData;
if isempty(x) | isempty(y) | isempty(c) %If no data are supplied, draw nothing
    x=[];  y=[];   c=[];
    myc=[];
    maxc=0;
else
    maxc=max(c(:));
    if maxc>0
        myc=c/maxc*64;
    else
        myc=zeros(size(c));
    end
end

%Show the data by image
if ~isempty(myh)
    set(myh,'XData',x,'YData',y,'CData',myc);
else
    myh=image('XData',x,'YData',y,'CData',myc,'Parent',MonitorHandles.axes_PSTH,'Tag','PSTHImage');
end
if isempty(myc)
    return;
end
dx=abs(x(2)-x(1));
%dy=abs(y(2)-y(1));
dy=1;
if strcmpi(get(MonitorHandles.axes_PSTH,'XLimMode'),'auto') | ...
        isempty(MonitorSetting.PSTH.XLim)
    set(MonitorHandles.axes_PSTH,'XLim',[min(x)-dx/2 max(x)+dx/2]);
else
    set(MonitorHandles.axes_PSTH,'XLim',MonitorSetting.PSTH.XLim);
end

step=ceil(length(y)/10);
myytick=min(y):step:max(y);

set(MonitorHandles.axes_PSTH,'YLim',[min(y)-dy/2 max(y)+dy/2],'TickDir','out','YTick',myytick);
%myytick=get(MonitorHandles.axes_PSTH,'YTick');
%myytick=ceil(myytick);
%set(MonitorHandles.axes_PSTH,'YTick',myytick,'YTickLabel',myytick);

%Indicate the stimulus number
%Get handles for lines
myh=findobj(MonitorHandles.axes_PSTH,'Tag','StimIdx');
%coordinates of the point
myxlim=xlim(MonitorHandles.axes_PSTH);
x=myxlim(2)+diff(myxlim)*0.02;
y=MonitorSetting.PSTH.StimIdx;
if isempty(x) | isempty(y) %If no data are supplied, draw nothing
    x=[]; y=[];
end
if isempty(myh)
    line(x,y,'Tag','StimIdx','Parent',MonitorHandles.axes_PSTH,...
        'LineStyle','none','Marker','<','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','Clipping','off');
else
    set(myh,'XData',x,'YData',y);
end


%Arrange the color bar
myh=findobj(MonitorHandles.axes_PSTHColorBar,'Tag','PSTHColorBarImage');
if ~isempty(myh)
    set(myh,'XData',1:64,'YData',1,'CData',1:64);
else
    myh=image('XData',1:64,'YData',1,'CData',1:64,...
        'Parent',MonitorHandles.axes_PSTHColorBar,'Tag','PSTHColorBarImage');
end

if maxc>0
    mytick=[1 64];
    myticklabel=[0 maxc*1000];
else
    mytick=[1 64];
    myticklabel=[0 1];
end
set(MonitorHandles.axes_PSTHColorBar,'XTick',mytick,'XTicklabel',myticklabel,'XLim',[0.5 64.5]);

% --------------------------------------------------------------------
% Close the monitor window
% --------------------------------------------------------------------
function CloseMonitor
global MonitorHandles

myh=findobj('Tag','figure_Monitor');
if ~isempty(myh)
    delete (myh);
end

% --------------------------------------------------------------------
% Toggle off the button for the monitor in ExptMan
function varargout = myclosereq

Monitor('CloseMonitor');
if ~isempty(findobj('Tag','fig_exptman'))
    ExptMan('MonitorClosed');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Subfunctions for internal use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
% Initialize the structure for the settings
% --------------------------------------------------------------------
function Initialize
global MonitorSetting MonitorHandles


%Create structure for storing the settings if not exist already
if isempty(MonitorSetting)
    Monitor DefaultSetting;
end %if isempty(MonitorSetting)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the paramters
h=MonitorHandles;
s=MonitorSetting;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Colormap for the figure
set(h.figure_Monitor,'ColorMap',jet(64));

%Checkbox for modal
set(h.checkbox_ModalFlag,'value',s.ModalFlag);
ToggleModal;

%Voltage as 100%
set(h.edit_VoltageFor100Percent,'string',num2str(s.VoltageFor100Percent));

%Waveform
set(h.checkbox_Waveform,'value',s.Waveform.Flag);
set(h.edit_WaveXLim,'string',num2str(s.Waveform.XLim));
set(h.edit_WaveYLim,'string',num2str(s.Waveform.YLim));
if isempty(s.Waveform.XLim)
    set(h.axes_Waveform,'XLim',[0 1],'XLimMode','auto');
else
    set(h.axes_Waveform,'XLim',s.Waveform.XLim,'XLimMode','manual');
end
if isempty(s.Waveform.YLim)
    set(h.axes_Waveform,'YLim',[0 1],'YLimMode','auto');
else
    set(h.axes_Waveform,'YLim',s.Waveform.YLim,'YLimMode','manual');
end
set(h.checkbox_ReverseWave,'value',s.Waveform.ReverseFlag);
set(h.checkbox_FilterWave,'value',s.Waveform.FilterFlag);
ToggleWaveform;

%Spikes
set(h.checkbox_Spikes,'value',s.Spikes.Flag);
set(h.edit_SpikeXLim,'string',num2str(s.Spikes.XLim));
set(h.edit_SpikeYLim,'string',num2str(s.Spikes.YLim));
set(h.axes_Spikes,'XLim',s.Spikes.XLim);
set(h.axes_Spikes,'YLim',s.Spikes.YLim);
set(h.slider_SpikeCutThresh,'value',s.Spikes.CutThresh);
set(h.edit_SpikeCutThresh,'string',num2str(s.Spikes.CutThresh));
set(h.checkbox_SpikeCriterion1,'value',s.Spikes.Criterion1.Flag);
set(h.edit_SpikeT1,'string',num2str(s.Spikes.Criterion1.t));
set(h.slider_SpikeT1,'value',s.Spikes.Criterion1.t);
set(h.edit_SpikeHi1,'string',num2str(s.Spikes.Criterion1.Hi));
set(h.slider_SpikeHi1,'value',s.Spikes.Criterion1.Hi);
set(h.edit_SpikeLo1,'string',num2str(s.Spikes.Criterion1.Lo));
set(h.slider_SpikeLo1,'value',s.Spikes.Criterion1.Lo);
set(h.checkbox_SpikeCriterion2,'value',s.Spikes.Criterion2.Flag);
set(h.edit_SpikeT2,'string',num2str(s.Spikes.Criterion2.t));
set(h.slider_SpikeT2,'value',s.Spikes.Criterion2.t);
set(h.edit_SpikeHi2,'string',num2str(s.Spikes.Criterion2.Hi));
set(h.slider_SpikeHi2,'value',s.Spikes.Criterion2.Hi);
set(h.edit_SpikeLo2,'string',num2str(s.Spikes.Criterion2.Lo));
set(h.slider_SpikeLo2,'value',s.Spikes.Criterion2.Lo);
ToggleSpikes;

%Raster
set(h.checkbox_Raster,'value',s.Raster.Flag);
ToggleRaster;

%PSTH
set(h.checkbox_PSTH,'value',s.PSTH.Flag);
set(h.edit_PSTHXLim,'string',num2str(s.PSTH.XLim));
TogglePSTH;

%
set(h.figure_Monitor,'ColorMap',hot);

    
% --------------------------------------------------------------------
% Toggle between modal on and off for the window
% --------------------------------------------------------------------
function ToggleModal
global MonitorSetting MonitorHandles

Flag=get(MonitorHandles.checkbox_ModalFlag,'value');
if Flag
    set(get(MonitorHandles.checkbox_ModalFlag,'parent'),'WindowStyle','modal');
else
    set(get(MonitorHandles.checkbox_ModalFlag,'parent'),'WindowStyle','normal');
end

%Update the setting structure
MonitorSetting.ModalFlag=Flag;


% --------------------------------------------------------------------
% Toggle the plot for waveform
% --------------------------------------------------------------------
function ToggleWaveform
global MonitorSetting MonitorHandles

myh=[   MonitorHandles.text_WaveXLim MonitorHandles.edit_WaveXLim ...
        MonitorHandles.text_WaveYLim MonitorHandles.edit_WaveYLim ...
        MonitorHandles.checkbox_ReverseWave MonitorHandles.checkbox_FilterWave ...
        MonitorHandles.text_WaveformXLabel MonitorHandles.text_WaveformYLabel ...
    ];

Flag=get(MonitorHandles.checkbox_Waveform,'value');
if Flag
    set(myh,'Enable','on');
    set(MonitorHandles.axes_Waveform,'Color','w');
else
    set(myh,'Enable','off');
    set(MonitorHandles.axes_Waveform,'Color',[.83 .81 .78]);
end

%Update the setting structure
MonitorSetting.Waveform.Flag=Flag;

% --------------------------------------------------------------------
% Toggle the plot for spikes
% --------------------------------------------------------------------
function ToggleSpikes
global MonitorSetting MonitorHandles

myh=[   MonitorHandles.text_SpikeXLim MonitorHandles.edit_SpikeXLim ...
        MonitorHandles.text_SpikeYLim MonitorHandles.edit_SpikeYLim ...
        MonitorHandles.text_SpikeXLabel MonitorHandles.text_SpikeYLabel ...
        MonitorHandles.text_SpikeCutThresh MonitorHandles.edit_SpikeCutThresh ...
        MonitorHandles.checkbox_SpikeCriterion1 MonitorHandles.checkbox_SpikeCriterion2 ...
    ];
myh1=[   MonitorHandles.text_SpikeT1 MonitorHandles.slider_SpikeT1 MonitorHandles.edit_SpikeT1 ...
        MonitorHandles.text_SpikeHi1 MonitorHandles.slider_SpikeHi1 MonitorHandles.edit_SpikeHi1 ...
        MonitorHandles.text_SpikeLo1 MonitorHandles.slider_SpikeLo1 MonitorHandles.edit_SpikeLo1 ...
    ];
myh2=[   MonitorHandles.text_SpikeT2 MonitorHandles.slider_SpikeT2 MonitorHandles.edit_SpikeT2 ...
        MonitorHandles.text_SpikeHi2 MonitorHandles.slider_SpikeHi2 MonitorHandles.edit_SpikeHi2 ...
        MonitorHandles.text_SpikeLo2 MonitorHandles.slider_SpikeLo2 MonitorHandles.edit_SpikeLo2 ...
    ];

Flag=get(MonitorHandles.checkbox_Spikes,'value');
if Flag
    set(myh,'Enable','on');
    set(MonitorHandles.axes_Spikes,'Color','w');
    ToggleSpikeCriterion1;
    ToggleSpikeCriterion2;
else
    set(myh,'Enable','off');
    set(myh1,'Enable','off');
    set(myh2,'Enable','off');
    set(MonitorHandles.axes_Spikes,'Color',[.83 .81 .78]);
end
%Update the setting structure
MonitorSetting.Spikes.Flag=Flag;

% --------------------------------------------------------------------
% Toggle settings for spike detection criterion 1
% --------------------------------------------------------------------
function ToggleSpikeCriterion1
global MonitorSetting MonitorHandles

myh=[   MonitorHandles.text_SpikeT1 MonitorHandles.slider_SpikeT1 MonitorHandles.edit_SpikeT1 ...
        MonitorHandles.text_SpikeHi1 MonitorHandles.slider_SpikeHi1 MonitorHandles.edit_SpikeHi1 ...
        MonitorHandles.text_SpikeLo1 MonitorHandles.slider_SpikeLo1 MonitorHandles.edit_SpikeLo1 ...
    ];

Flag=get(MonitorHandles.checkbox_SpikeCriterion1,'value');
if Flag
    set(myh,'Enable','on');
else
    set(myh,'Enable','off');
end

%Update the setting structure
MonitorSetting.Spikes.Criterion1.Flag=Flag;
%Draw a line indicating criterion
DrawCriterionLines

% --------------------------------------------------------------------
% Toggle settings for spike detection criterion 2
% --------------------------------------------------------------------
function ToggleSpikeCriterion2
global MonitorSetting MonitorHandles

myh=[   MonitorHandles.text_SpikeT2 MonitorHandles.slider_SpikeT2 MonitorHandles.edit_SpikeT2 ...
        MonitorHandles.text_SpikeHi2 MonitorHandles.slider_SpikeHi2 MonitorHandles.edit_SpikeHi2 ...
        MonitorHandles.text_SpikeLo2 MonitorHandles.slider_SpikeLo2 MonitorHandles.edit_SpikeLo2 ...
    ];

Flag=get(MonitorHandles.checkbox_SpikeCriterion2,'value');
if Flag
    set(myh,'Enable','on');
else
    set(myh,'Enable','off');
end

%Update the setting structure
MonitorSetting.Spikes.Criterion2.Flag=Flag;

%Draw a line indicating criterion
DrawCriterionLines

% --------------------------------------------------------------------
% Toggle the plot for raster
% --------------------------------------------------------------------
function ToggleRaster
global MonitorSetting MonitorHandles

Flag=get(MonitorHandles.checkbox_Raster,'value');
if Flag
    set(MonitorHandles.text_RasterXLabel,'Enable','on');
    set(MonitorHandles.axes_Raster,'XColor','k','YColor','k');
else
    set(MonitorHandles.text_RasterXLabel,'Enable','off');
    set(MonitorHandles.axes_Raster,'XColor',[.83 .81 .78],'YColor',[.83 .81 .78]);
end

%Update the setting structure
MonitorSetting.Raster.Flag=Flag;


% --------------------------------------------------------------------
% Toggle the plot for PSTH
% --------------------------------------------------------------------
function TogglePSTH
global MonitorSetting MonitorHandles

myh=[   MonitorHandles.text_PSTHXLim MonitorHandles.edit_PSTHXLim ...
        MonitorHandles.text_PSTHXLabel MonitorHandles.text_PSTHYLabel ...
        MonitorHandles.text_PSTHColorBarLabel MonitorHandles.pushbutton_PSTHRefresh...        
    ];

Flag=get(MonitorHandles.checkbox_PSTH,'value');

if Flag
    set(myh,'Enable','on');
    set(MonitorHandles.axes_PSTH,'XColor','k','YColor','k');
    set(MonitorHandles.axes_PSTHColorBar,'XColor','k','YColor','k');
else
    set(myh,'Enable','off');
    set(MonitorHandles.axes_PSTH,'XColor',[.83 .81 .78],'YColor',[.83 .81 .78]);
    set(MonitorHandles.axes_PSTHColorBar,'XColor',[.83 .81 .78],'YColor',[.83 .81 .78]);
end

%Update the setting structure
MonitorSetting.PSTH.Flag=Flag;

% --------------------------------------------------------------------
% Draw lines for criterions
% --------------------------------------------------------------------
function DrawCriterionLines
global MonitorSetting MonitorHandles

%Get handles for lines
h0s=findobj(MonitorHandles.axes_Spikes,'Tag','CutThreshLine');
h0w=findobj(MonitorHandles.axes_Waveform,'Tag','CutThreshLine');
h1=findobj(MonitorHandles.axes_Spikes,'Tag','CriterionLine1');
h2=findobj(MonitorHandles.axes_Spikes,'Tag','CriterionLine2');

%Cut threshold for waveform plot
%coordinates of the line
if ~isempty(MonitorSetting.Waveform.XData)
    x=[min(MonitorSetting.Waveform.XData) max(MonitorSetting.Waveform.XData)];
    y=[1 1]*MonitorSetting.Spikes.CutThresh;
else
    x=[];
    y=[];
end
if isempty(h0w)
    h0w=line(x,y,'Tag','CutThreshLine','Parent',MonitorHandles.axes_Waveform,...
        'LineStyle','--','Color','k');
else
    set(h0w,'XData',x,'YData',y);
end

%Cut threshold for spike plot
%coordinates of the line
x=get(MonitorHandles.axes_Spikes,'XLim');
y=[1 1]*MonitorSetting.Spikes.CutThresh;
if isempty(h0s)
    h0s=line(x,y,'Tag','CutThreshLine','Parent',MonitorHandles.axes_Spikes,...
        'LineStyle','--','Color','k');
else
    set(h0s,'XData',x,'YData',y);
end

if MonitorSetting.Spikes.Criterion1.Flag %If the flag for the criterion is on
    %coordinates of the line
    x=[1 1]*MonitorSetting.Spikes.Criterion1.t;
    y=[MonitorSetting.Spikes.Criterion1.Lo MonitorSetting.Spikes.Criterion1.Hi];
    if isempty(h1)
        h1=line(x,y);
        set(h1,'Tag','CriterionLine1','Parent',MonitorHandles.axes_Spikes,...
            'LineStyle','-','Color','r','Marker','.','MarkerEdgeColor','auto');
    else
        set(h1,'XData',x,'YData',y);
    end
else %Delete the line if the flag is off
    if ~isempty(h1)
        delete(h1);
    end
end

if MonitorSetting.Spikes.Criterion2.Flag %If the flag for the criterion is on
    %coordinates of the line
    x=[1 1]*MonitorSetting.Spikes.Criterion2.t;
    y=[MonitorSetting.Spikes.Criterion2.Lo MonitorSetting.Spikes.Criterion2.Hi];
    if isempty(h2)
        h2=line(x,y);
        set(h2,'Tag','CriterionLine2','Parent',MonitorHandles.axes_Spikes,...
            'LineStyle','-','Color',[0 0.75 0],'Marker','.','MarkerEdgeColor','auto');
    else
        set(h2,'XData',x,'YData',y);
    end
else %Delete the line if the flag is off
    if ~isempty(h2)
        delete(h2);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = checkbox_Waveform_Callback(h, eventdata, handles, varargin)
global MonitorSetting

ToggleWaveform;


% --------------------------------------------------------------------
function varargout = checkbox_ReverseWave_Callback(h, eventdata, handles, varargin)
global MonitorSetting

MonitorSetting.Waveform.ReverseFlag=get(h,'value'); %Update the setting structure



% --------------------------------------------------------------------
function varargout = checkbox_FilterWave_Callback(h, eventdata, handles, varargin)
global MonitorSetting

MonitorSetting.Waveform.FilterFlag=get(h,'value'); %Update the setting structure



% --------------------------------------------------------------------
function varargout = edit_WaveXLim_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

if length(myval)==1 %If only one number is specified, use that for upper and lower lim
    myval=[0 1]*abs(myval);
elseif length(myval(:))>2 %More than 2 numbers
    myval=[myval(1) myval(2)];
end
if any(isnan(myval)) %Not a number
    myval=[];
end
myval=sort(myval);

if isempty(myval) %Empty value indicates 'auto' mode
    set(handles.axes_Waveform,'XLimMode','auto');
else
    set(handles.axes_Waveform,'XLim',myval);
end

MonitorSetting.Waveform.XLim=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_WaveYLim_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

if length(myval)==1 %If only one number is specified, use that for upper and lower lim
    myval=[-1 1]*abs(myval);
elseif length(myval(:))>2 %More than 2 numbers
    myval=[myval(1) myval(2)];
end
if any(isnan(myval)) %Not a number
    myval=[];
end
myval=sort(myval);

if isempty(myval) %Empty value indicates 'auto' mode
    set(handles.axes_Waveform,'YLimMode','auto');
else
    set(handles.axes_Waveform,'YLim',myval);
end

MonitorSetting.Waveform.YLim=myval; %Update the setting structure


% --------------------------------------------------------------------
function varargout = checkbox_Spikes_Callback(h, eventdata, handles, varargin)

ToggleSpikes;


% --------------------------------------------------------------------
function varargout = edit_SpikeXLim_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

if length(myval)==1 %If only one number is specified, use that for upper and lower lim
    myval=[0 1]*abs(myval);
elseif length(myval(:))>2 %More than 2 numbers
    myval=[myval(1) myval(2)];
end
if any(isnan(myval)) %Not a number
    myval=[];
end
myval=sort(myval);

if isempty(myval) %Empty value indicates 'auto' mode
    set(handles.axes_Spikes,'XLimMode','auto');
else
    set(handles.axes_Spikes,'XLim',myval);
end

MonitorSetting.Spikes.XLim=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_SpikeYLim_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

if length(myval)==1 %If only one number is specified, use that for upper and lower lim
    myval=[-1 1]*abs(myval);
elseif length(myval(:))>2 %More than 2 numbers
    myval=[myval(1) myval(2)];
end
if any(isnan(myval)) %Not a number
    myval=[];
end
myval=sort(myval);

if isempty(myval) %Empty value indicates 'auto' mode
    set(handles.axes_Spikes,'YLimMode','auto');
else
    set(handles.axes_Spikes,'YLim',myval);
end

MonitorSetting.Spikes.YLim=myval; %Update the setting structure



% --------------------------------------------------------------------
function varargout = slider_SpikeCutThresh_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value
set(handles.edit_SpikeCutThresh,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.CutThresh=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_SpikeCutThresh_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string'));
%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.CutThresh;
    set(handles.edit_SpikeCutThresh,'string',num2str(myval)); %Correct the edit box
elseif myval>100
    myval=100;
    set(handles.edit_SpikeCutThresh,'string',num2str(myval)); %Correct the edit box
elseif myval<-0
    myval=0;
    set(handles.edit_SpikeCutThresh,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.CutThresh;
    set(handles.edit_SpikeCutThresh,'string',num2str(myval)); %Correct the edit box
end

set(handles.slider_SpikeCutThresh,'value',myval); %Update the slider
MonitorSetting.Spikes.CutThresh=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = checkbox_SpikeCriterion1_Callback(h, eventdata, handles, varargin)

ToggleSpikeCriterion1;


% --------------------------------------------------------------------
function varargout = slider_SpikeT1_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value
set(handles.edit_SpikeT1,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.Criterion1.t=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines

% --------------------------------------------------------------------
function varargout = edit_SpikeT1_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string')); %get the current value

%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.Criterion1.t;
    set(handles.edit_SpikeT1,'string',num2str(myval)); %Correct the edit box
elseif myval>2
    myval=2;
    set(handles.edit_SpikeT1,'string',num2str(myval)); %Correct the edit box
elseif myval<0
    myval=0;
    set(handles.edit_SpikeT1,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.Criterion1.t;
    set(handles.edit_SpikeT1,'string',num2str(myval)); %Correct the edit box
end

set(handles.slider_SpikeT1,'value',myval); %Update the slider
MonitorSetting.Spikes.Criterion1.t=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = slider_SpikeHi1_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value

%Error handling -- Higher cutoff lower than the lower cutoff
myvalLo=get(handles.slider_SpikeLo1,'value');
if myval<myvalLo
    myval=myvalLo;
    set(h,'value',myval);
end

set(handles.edit_SpikeHi1,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.Criterion1.Hi=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines

% --------------------------------------------------------------------
function varargout = edit_SpikeHi1_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string')); %get the current value

%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.Criterion1.Hi;
    set(handles.edit_SpikeHi1,'string',num2str(myval)); %Correct the edit box
elseif myval>100
    myval=100;
    set(handles.edit_SpikeHi1,'string',num2str(myval)); %Correct the edit box
elseif myval<-100
    myval=-100;
    set(handles.edit_SpikeHi1,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.Criterion1.Hi;
    set(handles.edit_SpikeHi1,'string',num2str(myval)); %Correct the edit box
end

%Error handling -- Higher cutoff lower than the lower cutoff
myvalLo=str2num(get(handles.edit_SpikeLo1,'string'));
if myval<myvalLo
    myval=myvalLo;
    set(h,'string',num2str(myval));
end

set(handles.slider_SpikeHi1,'value',myval); %Update the slider
MonitorSetting.Spikes.Criterion1.Hi=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = slider_SpikeLo1_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value

%Error handling -- Higher cutoff lower than the lower cutoff
myvalHi=get(handles.slider_SpikeHi1,'value');
if myval>myvalHi
    myval=myvalHi;
    set(h,'value',myval);
end

set(handles.edit_SpikeLo1,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.Criterion1.Lo=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_SpikeLo1_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string')); %get the current value

%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.Criterion1.Lo;
    set(handles.edit_SpikeLo1,'string',num2str(myval)); %Correct the edit box
elseif myval>100
    myval=100;
    set(handles.edit_SpikeLo1,'string',num2str(myval)); %Correct the edit box
elseif myval<-100
    myval=-100;
    set(handles.edit_SpikeLo1,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.Criterion1.Lo;
    set(handles.edit_SpikeLo1,'string',num2str(myval)); %Correct the edit box
end

%Error handling -- Higher cutoff lower than the lower cutoff
myvalHi=str2num(get(handles.edit_SpikeHi1,'string'));
if myval>myvalHi
    myval=myvalHi;
    set(h,'string',num2str(myval));
end

set(handles.slider_SpikeLo1,'value',myval); %Update the slider
MonitorSetting.Spikes.Criterion1.Lo=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines




% --------------------------------------------------------------------
function varargout = checkbox_SpikeCriterion2_Callback(h, eventdata, handles, varargin)

ToggleSpikeCriterion2;


% --------------------------------------------------------------------
function varargout = slider_SpikeT2_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value
set(handles.edit_SpikeT2,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.Criterion2.t=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_SpikeT2_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string')); %get the current value

%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.Criterion2.t;
    set(handles.edit_SpikeT2,'string',num2str(myval)); %Correct the edit box
elseif myval>2
    myval=2;
    set(handles.edit_SpikeT2,'string',num2str(myval)); %Correct the edit box
elseif myval<0
    myval=0;
    set(handles.edit_SpikeT2,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.Criterion2.t;
    set(handles.edit_SpikeT2,'string',num2str(myval)); %Correct the edit box
end

set(handles.slider_SpikeT2,'value',myval); %Update the slider
MonitorSetting.Spikes.Criterion2.t=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines




% --------------------------------------------------------------------
function varargout = slider_SpikeHi2_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value

%Error handling -- Higher cutoff lower than the lower cutoff
myvalLo=get(handles.slider_SpikeLo2,'value');
if myval<myvalLo
    myval=myvalLo;
    set(h,'value',myval);
end

set(handles.edit_SpikeHi2,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.Criterion2.Hi=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_SpikeHi2_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string')); %get the current value

%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.Criterion2.Hi;
    set(handles.edit_SpikeHi2,'string',num2str(myval)); %Correct the edit box
elseif myval>100
    myval=100;
    set(handles.edit_SpikeHi2,'string',num2str(myval)); %Correct the edit box
elseif myval<-100
    myval=-100;
    set(handles.edit_SpikeHi2,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.Criterion2.Hi;
    set(handles.edit_SpikeHi2,'string',num2str(myval)); %Correct the edit box
end

%Error handling -- Higher cutoff lower than the lower cutoff
myvalLo=str2num(get(handles.edit_SpikeLo2,'string'));
if myval<myvalLo
    myval=myvalLo;
    set(h,'string',num2str(myval));
end

set(handles.slider_SpikeHi2,'value',myval); %Update the slider
MonitorSetting.Spikes.Criterion2.Hi=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = slider_SpikeLo2_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=get(h,'value'); %get the current value

%Error handling -- Higher cutoff lower than the lower cutoff
myvalHi=get(handles.slider_SpikeHi2,'value');
if myval>myvalHi
    myval=myvalHi;
    set(h,'value',myval);
end

set(handles.edit_SpikeLo2,'string',num2str(myval)); %Update the edit box
MonitorSetting.Spikes.Criterion2.Lo=myval; %Update the setting structure

%Draw a line indicating criterion
DrawCriterionLines


% --------------------------------------------------------------------
function varargout = edit_SpikeLo2_Callback(h, eventdata, handles, varargin)
global MonitorSetting

myval=str2num(get(h,'string')); %get the current value

%Error handling
if length(myval)~=1 %Number should be a scalar
    myval=MonitorSetting.Spikes.Criterion2.Lo;
    set(handles.edit_SpikeLo2,'string',num2str(myval)); %Correct the edit box
elseif myval>100
    myval=100;
    set(handles.edit_SpikeLo2,'string',num2str(myval)); %Correct the edit box
elseif myval<-100
    myval=-100;
    set(handles.edit_SpikeLo2,'string',num2str(myval)); %Correct the edit box
elseif isnan(myval) | ~isreal(myval)
    myval=MonitorSetting.Spikes.Criterion2.Lo;
    set(handles.edit_SpikeLo2,'string',num2str(myval)); %Correct the edit box
end

%Error handling -- Higher cutoff lower than the lower cutoff
myvalHi=str2num(get(handles.edit_SpikeHi2,'string'));
if myval>myvalHi
    myval=myvalHi;
    set(h,'string',num2str(myval));
end

set(handles.slider_SpikeLo2,'value',myval); %Update the slider
MonitorSetting.Spikes.Criterion2.Lo=myval; %Update the setting structure


%Draw a line indicating criterion
DrawCriterionLines



% --------------------------------------------------------------------
function varargout = checkbox_Raster_Callback(h, eventdata, handles, varargin)

ToggleRaster;


% --------------------------------------------------------------------
function varargout = checkbox_PSTH_Callback(h, eventdata, handles, varargin)

TogglePSTH;


% --------------------------------------------------------------------
function varargout = edit_PSTHXLim_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

if length(myval)==1 %If only one number is specified, use that for upper and lower lim
    myval=[0 1]*abs(myval);
elseif length(myval(:))>2 %More than 2 numbers
    myval=[myval(1) myval(2)];
end
if any(isnan(myval)) %Not a number
    myval=[];
end
myval=sort(myval);

if isempty(myval) %Empty value indicates 'auto' mode
    set(handles.axes_PSTH,'XLimMode','auto');
else
    set(handles.axes_PSTH,'XLim',myval);
end

MonitorSetting.PSTH.XLim=myval; %Update the setting structure




% --------------------------------------------------------------------
function varargout = pushbutton_PSTHRefresh_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Clear the PSTH data
MonitorSetting.PSTH.XData=[];
MonitorSetting.PSTH.YData=[];
MonitorSetting.PSTH.ZData=[];


% --------------------------------------------------------------------
function varargout = checkbox_ModalFlag_Callback(h, eventdata, handles, varargin)

ToggleModal;




% --------------------------------------------------------------------
function varargout = edit_VoltageFor100Percent_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

%Illegal value -- use the current one
if isempty(myval) | any(isnan(myval))
    set(h,'string',num2str(MonitorSetting.VoltageFor100Percent));
else
    MonitorSetting.VoltageFor100Percent=myval(1);
end





% --------------------------------------------------------------------
function varargout = edit_FilterOrder_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

%Illegal value -- use the current one
if isempty(myval)
    set(h,'string',num2str(MonitorSetting.FilterOrder));
elseif myval(1)< 1 | any(isnan(myval))
    set(h,'string',num2str(MonitorSetting.FilterOrder));
else
    MonitorSetting.FilterOrder=myval(1);

    %Reset the coefficients
    MonitorSetting.FilterB=[]; %Filter coefficients B
    MonitorSetting.FilterA=[]; %Filter coefficients A
end


% --------------------------------------------------------------------
function varargout = edit_FilterPassband_Callback(h, eventdata, handles, varargin)
global MonitorSetting

%Get the value
myval=str2num(get(h,'string'));

%Illegal value -- use the current one
if length(myval)~=2
    set(h,'string',num2str(MonitorSetting.FilterPassband));
elseif any(isnan(myval)) | min(myval)<=0
    set(h,'string',num2str(MonitorSetting.FilterPassband));
else
    MonitorSetting.FilterPassband=sort(myval);

    %Reset the coefficients
    MonitorSetting.FilterB=[]; %Filter coefficients B
    MonitorSetting.FilterA=[]; %Filter coefficients A
end

