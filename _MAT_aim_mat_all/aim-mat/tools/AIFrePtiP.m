% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function options=AIFrePtiP(framestruct_a);
% plots the current frame (cframe) together with its sum of intervals
% and the sum of frequencies
% no pitch is calculated or plotted! for this use AIFrePtiPstress
% all relevant data must be in the frame-object
% the return value "pitch" is the result from the call to "calcresidualprobability"


if ~isstruct(framestruct_a)
    %     error('AIsum must be called with a structure');
    framestruct.current_frame=framestruct_a;
else
    framestruct=framestruct_a;
end

if ~isfield(framestruct,'show_time');
    show_time=1;
else
    show_time=framestruct.show_time;
end

if ~isfield(framestruct,'plot_scale');
    plot_scale=1;
else
    plot_scale=framestruct.plot_scale;
end


if ~isfield(framestruct,'minimum_time_interval');
    minimum_time_interval=1;
else
    minimum_time_interval=framestruct.minimum_time_interval;
end

if ~isfield(framestruct,'is_log');
    is_log=1;
else
    is_log=framestruct.is_log;;
end

if isfield(framestruct,'frequency_profile_scale');
    frequency_profile_scale=framestruct.frequency_profile_scale;
else
    frequency_profile_scale=1;
end
if isfield(framestruct,'time_profile_scale');
    time_profile_scale=framestruct.time_profile_scale;
else
    time_profile_scale=1;
end
% if the time scale is reversed (time from left to right)
if isfield(framestruct,'time_reversed');
    time_reversed=framestruct.time_reversed;
else
    time_reversed=0;
end

% hier wird der current frame definiert:
current_frame=framestruct.current_frame;

if ~isfield(framestruct,'maximum_time_interval');
    maximum_time_interval=35;
else
    maximum_time_interval=framestruct.maximum_time_interval;
end

if maximum_time_interval/1000>getlength(current_frame)
    maximum_time_interval=getlength(current_frame)*1000;
end

if isfield(framestruct,'options');
    options=framestruct.options;
else
    options=[];
end
if ~isfield(options,'oldhandle1')
    options.oldhandle1=0;
end
if ~isfield(options,'oldhandle2')
    options.oldhandle2=0;
end
if ~isfield(options,'oldhandle3')
    options.oldhandle3=0;
end


% schmeisse die physikalisch nicht sinnvollen Bereiche raus!
% current_frame=extractpitchregion(current_frame);

scale_summe=getscalesumme(current_frame);

% start plotting:
% clf;
axis off
caxes=get(gca,'position');

channel_density=0.015; % passt für 76 channels von 100 bis 6000
% channel_density=2*0.015; % passt für 76 channels von 100 bis 6000
hoehe=getnrchannels(current_frame)*channel_density;
if hoehe>1
    hoehe=1;
end
if hoehe < 0.2
    hoehe = 0.2;
end

rect=[-0.04 0.15 0.9 hoehe*0.85];
rect(1:2)=caxes(1:2)+(rect(1:2).*caxes(3:4));
rect(3:4)=rect(3:4).*caxes(3:4);

hint=1; % this indicate that we dont want a title
mysubplot(1,1,1,rect, hint);
if options.oldhandle1~=0
    delete(options.oldhandle1);
end
options.oldhandle1=gca;

plot_struct.t_min=minimum_time_interval/1000;
plot_struct.t_max=maximum_time_interval/1000;
plot_struct.has_axis=0;
plot_struct.is_log=is_log;
plot_struct.has_y_axis=0;
axis off

plot(current_frame,plot_struct);
set(gca,'zlim',[0 1/plot_scale]);

if show_time
    srate=getsr(current_frame);
    text_x=0.8*maximum_time_interval*srate/1000;
    text_y=getnrchannels(current_frame)*1.1;
    frame_number=getcurrentframenumber(current_frame);
    frame_time=getcurrentframestarttime(current_frame);
    text(text_x,text_y,sprintf('%3d  : %4.0fms',frame_number,frame_time*1000),'FontSize',8);
    %     text(text_x,text_y,sprintf('%d',frame_number),'FontSize',8);
end

% interval sum
rect=[-0.04 0 0.9 0.2];
rect(1:2)=caxes(1:2)+(rect(1:2).*caxes(3:4));
rect(3:4)=rect(3:4).*caxes(3:4);
mysubplot(1,1,1,rect, hint);
if options.oldhandle2~=0
    delete(options.oldhandle2);
end
options.oldhandle2=gca;

summe=getsum(current_frame);  % here it is calculated
axis off

srate=getsr(current_frame);
if is_log
    t=minimum_time_interval;
    if t<=0
        error('in logarithmic plots, the minimum time interval must be positiv!');
    end 
    ti=[t 2*t 4*t 8*t 16*t 32*t 64*t];
    tix=(ti)/1000*srate;  % there shell be the tix
    ti=(ti);
    ti=round(ti*100)/100;
    if getminimumtime(summe) <0
        psumme=getpart(summe,getminimumtime(summe),0);
    else
        psumme=getpart(summe,getminimumtime(summe),maximum_time_interval/1000);
    end
%     rsumme=reverse(psumme);
    rsumme=psumme;
    sumvalues=getvalues(rsumme);
    min_x_screen=minimum_time_interval/1000*srate; % thats the first point we want to see on the screen
    max_x_screen=maximum_time_interval/1000*srate; % thats the first point we want to see on the screen
else % its not logarithmic!
    frame_start_time=getminimumtime(current_frame);
    if maximum_time_interval>0
        summe=getpart(summe,(minimum_time_interval/1000+frame_start_time),maximum_time_interval/1000+frame_start_time);
    else
        summe=getpart(summe,(-maximum_time_interval/1000+frame_start_time),-minimum_time_interval/1000+frame_start_time);
    end
    nr_labels=8;
    xbis=getnrpoints(summe);
    tix=0:xbis/nr_labels:xbis;
    xstep=(maximum_time_interval-minimum_time_interval)*1000/nr_labels;   %works from -35 to 5
    xstep=round(xstep);
    ti=([minimum_time_interval*1000:xstep:maximum_time_interval*1000])/1000;
    ti=round(ti*10)/10;
%     sumvalues=getvalues(reverse(summe));
    sumvalues=getvalues(summe);
    
    min_x_screen=0;
    max_x_screen=(maximum_time_interval-minimum_time_interval)/1000*srate; % thats the first point we want to see on the screen
    
end

h=plot(sumvalues); hold on
if scale_summe==0
    axis([min_x_screen max_x_screen 0 1]);
else    
    axis([min_x_screen max_x_screen 0 scale_summe/time_profile_scale]);
end

% set(gca,'XDir','reverse')   % turn them around, because the higher values shell end on the right
if is_log
    set(gca,'XScale','log')
end

if time_reversed
    ti=ti(end:-1:1);
end
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);
set(gca,'YTickLabel',[]);
% 
if is_log
    text(max_x_screen*0.5,-scale_summe/5,'time interval (ms)');    % this is at a nice position
else
    text(500,-scale_summe/5,'time interval (ms)');    % this is at a nice position
end



% frequency sum
scale_frequency=getscalefrequency(current_frame);

hoehe=getnrchannels(current_frame)*channel_density;
if hoehe>1
    hoehe=1;
end

rect=[0.856 0.19 0.1 hoehe*0.81];
rect(1:2)=caxes(1:2)+(rect(1:2).*caxes(3:4));
rect(3:4)=rect(3:4).*caxes(3:4);
mysubplot(1,1,1,rect, hint);
if options.oldhandle3~=0
    delete(options.oldhandle3);
end
options.oldhandle3=gca;
fresumme=getfrequencysum(current_frame);  % here it is calculated
% fresumme=smooth(fresumme,1);% glätte die Summe

% fresumme=fresumme/frequency_profile_scale;

fresumme=setname(fresumme,'');
fresumme=setunit_x(fresumme,'');
fresumme=setunit_y(fresumme,'');

plot(fresumme,'r'); hold on
v=getvalues(fresumme);
axis([0 size(v,1)*47/42 0 scale_frequency/frequency_profile_scale]);
view(-90,90);
% make y-Ticks
nr_labels=8;
nr_channels=getnrpoints(fresumme);
xstep=(nr_channels-1)/(nr_labels-1);
tix=1:xstep:nr_channels;
cfs=getcf(current_frame);
ti=cfs(floor(tix))/1000;
ti=round(ti*10)/10;
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);
set(gca,'YTickLabel',[]);
set(gca,'XAxisLocation','top');

