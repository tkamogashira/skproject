% method of class @frame
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/07/27 15:29:59 $
% $Revision: 1.12 $

function hand=plottemporalprofile(current_frame,options,ax)

if nargin <3
    ax=gca;
end
if nargin <2
    options=[];
end

start_time=getminimumtime(current_frame);
if start_time < 0 % these are frames read in from ams
% 	max_time=getmaximumtime(current_frame);
	fr=getpart(current_frame,start_time,0);
	current_frame=reverse(current_frame);
	start_time=0;
	current_frame=setstarttime(current_frame,0);
end



if ~isfield(options,'has_x_axis');
    has_x_axis=1;
else
    has_x_axis=options.has_x_axis;
end

if ~isfield(options,'is_log');
    is_log=1;
else
    is_log=options.is_log;
end

% for compatibility.
if isfield(options,'minimum_time');
	options.minimum_time_interval=options.minimum_time;
end
if isfield(options,'maximum_time');
	options.maximum_time_interval=options.maximum_time;
end

if ~isfield(options,'minimum_time_interval');
    if is_log
        minimum_time_interval=0.001;
    else
        minimum_time_interval=0;
    end
else
    minimum_time_interval=options.minimum_time_interval;
end

if isfield(options,'time_profile_scale');
    time_profile_scale=options.time_profile_scale;
else
    time_profile_scale=1;
end
% if the time scale is reversed (time from left to right)
if isfield(options,'time_reversed');
    time_reversed=options.time_reversed;
else
    time_reversed=0;
end

if ~isfield(options,'maximum_time_interval');
    maximum_time_interval=0.035;
else
    maximum_time_interval=options.maximum_time_interval;
end

% if maximum_time_interval>getmaximumtime(current_frame)
%     maximum_time_interval=getmaximumtime(current_frame);
% end


scale_summe=getscalesumme(current_frame); %for scaling properties

% start plotting:
plot_struct.t_min=minimum_time_interval;
plot_struct.t_max=maximum_time_interval;
plot_struct.has_axis=0;
plot_struct.is_log=is_log;
plot_struct.has_y_axis=0;

% interval sum
% partframe=getpart(current_frame,minimum_time_interval,maximum_time_interval);
% summe=getsum(partframe);  % here it is calculated
% axis off

sr=getsr(current_frame);
% start_time=getminimumtime(current_frame);
% sumvalues=getpart(summe,(minimum_time_interval+start_time),maximum_time_interval+start_time);
% min_x_screen=round(abs((minimum_time_interval-start_time+1/sr)*sr)); % thats the first point we want to see on the screen
% max_x_screen=round(abs((maximum_time_interval-start_time)*sr)); % thats the first point we want to see on the screen

start_time=getminimumtime(current_frame);
if is_log
    min_x_screen=1;
    max_x_screen=round(abs((maximum_time_interval-start_time)*sr)); % thats the first point we want to see on the screen
else
    min_x_screen=round(abs((minimum_time_interval-start_time+1/sr)*sr)); % thats the first point we want to see on the screen
    max_x_screen=round(abs((maximum_time_interval-start_time)*sr)); % thats the first point we want to see on the screen
end


if max_x_screen>getnrpoints(current_frame)
	max_x_screen=getnrpoints(current_frame);
	maximum_time_interval=(max_x_screen/sr)+start_time;
end


current_frame_values=getvalues(current_frame);
cvals=current_frame_values(:,min_x_screen:max_x_screen);

if getxaxis(current_frame)=='0'
    cvals=cvals/1000;
end;

if size(cvals,1)==1
    sumcvals=cvals;
else
    sumcvals=sum(cvals)';
end
% cvals=getvalues(summe);
% min_x_screen=1;
% max_x_screen=size(cvals,1);
hand=plot(ax,sumcvals);

maxshowy=1.1;
if min(cvals) >= 0
    minshowy=0;
else
    minshowy=-1;
end

maxy=maxshowy*scale_summe/time_profile_scale;
if maxy==0
	maxy=1;
end
if time_profile_scale==-1 % decide myself
	maxy=1.2*max(sumcvals);
end

% save the two profiles to text files for further analysis
% 1: freq profile
x1=getcf(current_frame);
y1=sum(cvals');
% x1=
% A1=[x1' y1'];
% save freqp.txt A1 -ascii
% dlmwrite('freqprofile.txt',A1, '\t')


% 2: temp profile
% sr=getsr(current_frame);
% x2=1000/sr:1000/sr:getlength(current_frame)*1000;
% y2=sum(cvals);
% A2=[x2' y2'];
% save tempp.txt A1 -ascii
% dlmwrite('tempprofile.txt',A2, '\t')





if is_log
    min_x_screen=round(abs((minimum_time_interval-start_time+1/sr)*sr)); % thats the first point we want to see on the screen
    if max_x_screen ==min_x_screen 
        max_x_screen =min_x_screen +1;
    end
    try
        set(ax,'xlim',[min_x_screen max_x_screen]);
        set(ax,'ylim',[minshowy maxy]);
        
%         axis([min_x_screen max_x_screen minshowy maxy]);
    end
    if time_reversed
        set(ax,'XDir','reverse')   % turn them around, because the higher values shell end on the right
    end
    set(ax,'XScale','log')
    t=minimum_time_interval;
    ti=[t 2*t 4*t 8*t 16*t 32*t 64*t];
    tix=(ti)*sr;  % there shell be the tix
%     tix(1)=tix(1)+1;
    ti=(ti*1000);
    ti=fround(ti,2);
else % its not logarithmic!
	if time_reversed
		set(ax,'XDir','reverse')   % turn them around, because the higher values shell end on the right
	else
		set(ax,'XDir','normal')   % normale ausrichtung
	end
	nrx=size(cvals,2);
    if scale_summe==0
        scale_summe=1;
    end
    axis([1 length(sumcvals) minshowy maxy]);
    nr_labels=8;
    tix=1:(nrx-1)/nr_labels:nrx;
    xstep=(maximum_time_interval-minimum_time_interval)*1000/(nr_labels);   %works from -35 to 5
    ti=([minimum_time_interval*1000:xstep:maximum_time_interval*1000+1]);
    ti=round(ti*10)/10;
    set(ax,'XScale','linear')
    %     text(min_x_screen*1.5,-scale_summe/5,'Time (ms)');    % this is at a nice position
end

if has_x_axis
    if max(tix)>1
        set(ax,'XTick',tix);
        set(ax,'XTickLabel',ti);
    end
else
    set(ax,'xtick',[]); % we dont want any z-Ticks!
end % axis    

% if scale_summe==0
%     axis([min_x_screen max_x_screen minshowy maxshowy]);
% else    
%     axis([min_x_screen max_x_screen minshowy maxshowy*scale_summe/time_profile_scale]);
% end

if getxaxis(current_frame)=='0'
    d=size(cvals);
    ti = [0:1:16];
    step=(d(2)/16);
    tix = [0:step:d(2)];
end;

% stefan for the scale profile
if strcmp(getxaxis(current_frame),'harmonic ratio')
    ti=get(ax,'XTickLabel');
    ti=str2num(ti)/1000;
end


set(ax,'XTick',tix);
set(ax,'XTickLabel',ti);
set(ax,'YTickLabel',[]);

