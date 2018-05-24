function phasedelayslider(ah, varargin);
% phasedelayslider - create phase delay slider next to axes
%    phasedelayslider(ah) places a slider next to the axes with handle ah.
%    Using the slider results in the phase data displayed in ah to be
%    advanced or delayed. A label next to the slider indicates the current
%    delay in ms. It is assumed that the data in ah are phase-freq data
%    with phase in cycles and frequency in Hz. New lines may be plotted
%    after the slider is placed, but the slider must be clecked before teh
%    new lines are incorporated in the slider action.
%   
%    phasedelayslider(ah, 'kHz') is used when the abscissa is in kHz, The
%    default is Hz.
%
%    phasedelayslider(ah, 'off') removes the slider and restores the
%    undelayed display.
%
%    phasedelayslider(ah, 'refresh') applies the current phasedelay to all
%    lines in the axes; even if they were plotted after creating the
%    slider.
%
%    See also delayphase.

if istypedhandle(ah, 'axes'),
    local_draw(ah, varargin{:});
end



%==============================
function local_draw(ah, Unit);
if nargin<2, Unit = 'Hz'; end
% remove any previous sliders
if isequal('refresh', Unit),
    local_refresh(ah);
    return;
end
% make sure any existing slider is removed
local_off(ah);
if isequal('off', Unit), % removing was all - thnx
    return;
end
fh = parentfigh(ah);
tbprop = get(fh,'toolbar');
AxPos = getposInUnits(ah, 'pixels')';
Spos = [sum(AxPos([1 3]))+2 [1 0.5]*AxPos([2 4])-30 20 60];
Cdelay = 0;
th = text('parent', ah, 'position', [AxPos(3)+2 AxPos(4)/2-30], ...
    'verticalalign', 'bottom', 'units', 'pixels', 'string', '  0 ms', 'rotation', -90, 'color', [0.7 0 0], ...
    'fontsize', 9, 'fontweight', 'bold');
uh = uicontrol('parent', fh, 'Tag', 'phasedelayslider', 'style', 'slider', 'position', Spos, ...
    'min', -10, 'max', 10, 'sliderstep', [0.0025 0.05], 'callback', @local_delayplots);
set(th, 'string', [num2str(get(uh,'value')) ' ms']); % update display
if ~isequal('none', tbprop), set(fh, 'toolbar', 'figure'); end % restore toolbar if it was suppressed by calling uicontrol
lh = findobj(ah, 'type', 'line'); % all lines in graph to be delayed/advanced
titleh = get(ah,'title'); % handle to the title of axes ah
if ~isempty(get(titleh,'string')), % do not claim it
    titleh = [];
end
S = collectInStruct(ah, th, titleh, Cdelay, Unit, lh);
set(uh, 'userdata', S, 'units', 'normalized');
set(th, 'units', 'normalized');

function local_delayplots(Src,Ev);
S = get(Src, 'UserData');
newDelay = get(Src, 'value');
% check whether any lines were added to the plot after slider was created.
% If so, refresh the action of the slider to include those, too.
all_lh = findobj(S.ah, 'type', 'line');
if ~isempty(setdiff(all_lh, S.lh)),
    todoDelay = newDelay;
    newDelay = 0; % undo current delay
else,
    todoDelay = [];
end
dStr = [num2str(get(Src,'value')) ' ms'];
if issinglehandle(S.th),
    set(S.th, 'string', dStr); % update display
end
if issinglehandle(S.titleh) && ~isempty(S.titleh),
    set(S.titleh, 'string', ['Cdelay = ' dStr]);
end
DeltaDelay = newDelay - S.Cdelay;
if isequal('Hz', S.Unit), ScalFac = 1000; else ScalFac = 1; end
for iline=1:numel(S.lh), % visit line and apply delay
    lhi = S.lh(iline); % handle to current line
    if ~issingleHandle(lhi), continue; end
    freq = get(lhi, 'xdata');
    phase = get(lhi, 'ydata');
    newphase = delayPhase(phase, freq/ScalFac, DeltaDelay, 2);
    set(lhi, 'ydata', newphase);
end
drawnow;
S.Cdelay = newDelay;
set(Src, 'UserData', S);
if ~isempty(todoDelay), % incorporate new lines and activate new delay
    S.lh = all_lh;
    set(Src, 'Value', todoDelay);
    set(Src, 'UserData', S);
    local_delayplots(Src,Ev);
end

function [uh, S] = local_find(ah);
% ===find slider of axes ah
% find all sliders in figure
uh = findobj(parentfigh(ah), 'style', 'slider', 'Tag', 'phasedelayslider');
if isempty(uh), 
    S = [];
    return; 
end
for ii=1:numel(uh),
    S(ii) = get(uh(ii), 'UserData');
end
% select the slider linked to axes ah
uh = uh([S.ah]==ah);
S = S([S.ah]==ah);

function local_off(ah);
% ===remove ah's slider, if any
[uh, S] = local_find(ah);
if isempty(uh), return; end
% there is a slider - undo its effect
set(uh, 'value', 0); % zero delay
local_delayplots(uh,[]); % force update
% delete slider & its text box
delete(uh);
if issinglehandle(S.th),
    delete(S.th);
end
if issinglehandle(S.titleh) && ~isempty(S.titleh),
    set(S.titleh, 'string', '');
end

function local_refresh(ah);
% refresh slider action to include any new line objects
[uh, S] = local_find(ah)
Delay = S.Cdelay; % store current delay
Unit = S.Unit; % store current delay
% remove slider
local_off(ah);
% create new one
local_draw(ah, Unit);
% restore delay
[uh, S] = local_find(ah);
set(uh, 'value', Delay);
local_delayplots(uh,[]); % force update 












