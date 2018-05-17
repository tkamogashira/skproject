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


function AIsum(framestruct_a);
% plots the current frame (cframe) together with its sum
% all relevant data must be in the frame-object

%         framestruct.current_frame = current_frame;
%         framestruct.maximum_time_interval = maximum_time_interval; in ms!!!!
%         framestruct.minimum_time_interval= minimum_time_interval;in ms!!!!
%         framestruct.is_log='log' or 'linear';

if ~isstruct(framestruct_a)
    %     error('AIsum must be called with a structure');
    framestruct.current_frame=framestruct_a;
else
    framestruct=framestruct_a;
end

if ~isfield(framestruct,'show_time');
    show_time=0;
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

if ~isfield(framestruct,'maximum_time_interval');
    maximum_time_interval=35;
else
    maximum_time_interval=framestruct.maximum_time_interval;
end

if ~isfield(framestruct,'is_log');
    is_log=1;
else
    is_log=framestruct.is_log;;
end
current_frame=framestruct.current_frame;

scale_summe=getsumscale(current_frame);

% start plotting:
clf;
rect=[-0.04 0.15 0.97 0.85];
hint=1; % this indicate that we dont want a title
mysubplot(1,1,1,rect, hint);
plot_struct.t_min=minimum_time_interval/1000;
plot_struct.t_max=maximum_time_interval/1000;
plot_struct.has_axis=0;
plot_struct.is_log=is_log;

cax=plot(current_frame,plot_struct);
set(gca,'zlim',[0 1/plot_scale]);

% xaxisxticklabel=get(gca,'XTickLabel');
% xaxisxtick=get(gca,'XTick');

set(gca,'XTickLabel',[]);

if show_time
    srate=getsr(current_frame);
    text_x=0.9*maximum_time_interval*srate/1000;
    text_y=getnrchannels(current_frame)+5;
    str=getstructure(current_frame);
    if ~isfield(str,'current_frame_start_time')
        str.current_frame_start_time=0.0;
    end
    frame_number=str.current_frame_number;
    frame_time=str.current_frame_start_time*1000;
    text(text_x,text_y,sprintf('%d  : %4.0fms',frame_number,frame_time),'FontSize',8);
    %     text(text_x,text_y,sprintf('%d',frame_number),'FontSize',8);
end

% and the sum
rect=[-0.04 0 0.97 0.2];
mysubplot(1,1,1,rect, hint);
summe=getsum(current_frame);  % here it is calculated

srate=getsr(current_frame);
if is_log
    t=minimum_time_interval;
    ti=[t 2*t 4*t 8*t 16*t 32*t 64*t];
    tix=(ti)/1000*srate;  % there shell be the tix
    ti=(ti);
    ti=round(ti*100)/100;
    psumme=getpart(summe,getminimumtime(summe),0);
    rsumme=reverse(psumme);
    sumvalues=getvalues(rsumme);
    min_x_screen=minimum_time_interval/1000*srate; % thats the first point we want to see on the screen
    max_x_screen=maximum_time_interval/1000*srate; % thats the first point we want to see on the screen
else % its not logarithmic!
    logstruc=getstructure(current_frame);
    if isfield(logstruc,'samplerate')
        if logstruc.samplerate==-1 % special case for logarithmic frames
            scale_summe=max(summe);
        else
            summe=getpart(summe,-maximum_time_interval/1000,-minimum_time_interval/1000);
        end
    else
%         summe=getpart(summe,-maximum_time_interval/1000,-minimum_time_interval/1000);
    end
    nr_labels=7;
    xbis=getnrpoints(summe);
    tix=0:xbis/nr_labels:xbis;
    xstep=(maximum_time_interval-minimum_time_interval)*1000/nr_labels;   %works from -35 to 5
    xstep=round(xstep);
    ti=([minimum_time_interval*1000:xstep:maximum_time_interval*1000])/1000;
    ti=round(ti*10)/10;
    sumvalues=getvalues(reverse(summe));
    
    min_x_screen=0;
    max_x_screen=(maximum_time_interval-minimum_time_interval)/1000*srate; % thats the first point we want to see on the screen
    
end


h=plot(sumvalues);
% set(h,'LineWidth',1);

axis([min_x_screen max_x_screen 0 scale_summe]);

set(gca,'XDir','reverse')   % turn them around, because the higher values shell end on the right
if is_log
    set(gca,'XScale','log')
end

if isstruct('logstruct')
    if logstruct.samplerate==-1 % special case for logarithmic frames
        nr_labels=6;
        tix=0:max_x_screen/(nr_labels-1):max_x_screen;
        tix(1)=1;
        min_time=(logstruct.min_time*1000);
        max_time=abs(logstruct.max_time*1000);
        ti=distributelogarithmic(min_time,max_time,nr_labels);
        text(30,-scale_summe/5,'time interval (ms)');    % this is at a nice position
    end
else
    if is_log
        text(min_x_screen*1.9,-scale_summe/5,'time interval (ms)');    % this is at a nice position
    else
        text(120,-scale_summe/5,'time interval (ms)');    % this is at a nice position
    end   
end
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);

% set(gca,'XTick',xaxisxtick);
% set(gca,'XTickLabel',xaxisxticklabel);
set(gca,'YTickLabel',[]);
