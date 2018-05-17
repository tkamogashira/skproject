% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function rethandle=plot(sig,border,style,ax)
% usage: handle=plot(sig,border,style)
% plots the class signal. This plot works a little bit different from usual.
% Parameter can either be: plot(signal,style) or plot(signal,border) or plot(signal,border,style)
% the border can consist of times and y-value or only the times that should be plotted (in seconeds!)

if nargin<4
    ax=gca;
end
if nargin<3
    style='b-';
end

if nargin==2 && all(ishandle(border))
    ax=border;
end
if nargin==3 && ishandle(style)
    ax=style;
end



durationbin=size(sig.werte,1);
% duration=durationbin/sr;
if nargin<2
    t1=1;
    t2=durationbin;
    border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
end

if isstruct(border) || isempty(border)
    options=border;
    t1=1;
    t2=durationbin;
    border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
else
    options=[];
    if ischar(border)
        style=border;
        t1=1;
        t2=durationbin;
        border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
    else
        if isempty(border)
            t1=1;
            t2=durationbin;
            border=[t1 t2 min(sig.werte(t1:t2)) max(sig.werte(t1:t2))];
        else
            t1=border(1);
            t2=border(2);
            x1=time2bin(sig,t1);
            x2=time2bin(sig,t2);
            nr=size(border,2);
            if nr==2    % wenn nur die x-Werte angegeben werden
                border=[x1 x2 min(sig.werte(x1+1:x2)) max(sig.werte(x1+1:x2))];
            else
                border(1)=x1;
                border(2)=x2;
            end
        end
    end
end

if ~isfield(options,'is_log');
    is_log=0;
else
    is_log=options.is_log;
end

if isfield(options,'minimum_time');
    border(1)=time2bin(sig,options.minimum_time);
    minimum_time=options.minimum_time;
else
    minimum_time=bin2time(sig,border(1));
end

if isfield(options,'maximum_time');
    border(2)=time2bin(sig,options.maximum_time);
    maximum_time=options.maximum_time;
else
    maximum_time=bin2time(sig,border(2));
end


% if the time scale is reversed (time from left to right)
if isfield(options,'time_reversed');
    time_reversed=options.time_reversed;
else
    time_reversed=0;
end

start_time=getminimumtime(sig);

min_x_screen=border(1);   % einer wird abgezogen damit wir bei Null beginnen, nicht beim ersten bin, was blöde aussieht
max_x_screen=border(2);
minshowy=border(3);
maxy=border(4);

xvals=getxvalues(sig);
% if we are dealing with milliseconds (very often), then the units are in
% ms as well
% if strfind(sig.unit_x,'(ms)')>0
%     multiplier=1000;
% else
    multiplier=1;
% end


xvals=xvals.*multiplier;
yvals=getvalues(sig);

if ishandle(style) % ups, something gone wrong
    style='b-';
end

% this is the plotting command:
handle=plot(ax,xvals,yvals,style);

if time_reversed
    set(ax,'XDir','reverse')   % turn them around, because the higher values shell end on the right
else
    set(ax,'XDir','normal')   % normale ausrichtung
end

if is_log
    set(ax,'XScale','log')
    t=minimum_time*multiplier;
    tix=[t 2*t 4*t 8*t 16*t 32*t 64*t 128*t 256*t 512*t 1024*t];
    if ~isempty(sig.x_tick_labels)
        ti=sig.x_tick_labels;
        set(ax,'XTicklabel',ti);
    end
    set(ax,'XTick',tix);
else % its linear
    set(ax,'XScale','linear')
end

miny=border(3);
maxy=border(4);
y=[miny maxy];
if miny==maxy
    maxy=miny+1;
    miny=miny-1;
end
try
    set(ax,'xlim',[minimum_time*multiplier maximum_time*multiplier ])
    set(ax,'ylim',[miny*1.05 maxy*1.05])
    axis([minimum_time*multiplier maximum_time*multiplier miny*1.05 maxy*1.05]);
end


xlabel(sig.unit_x);
ylabel(sig.unit_y);
title(sig.name,'Interpreter','none');

if nargout==1
    rethandle=handle;
end

return
