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


function pitch=AIpitch(framestruct_a);
% plots the current frame (cframe) together with its sum
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


% schmeisse die physikalisch nicht sinnvollen Bereiche raus!
% current_frame=extractpitchregion(current_frame);

pitch=calcresidualprobability(current_frame,0);

% max_pitch_strength=pitch(1).pitchstrength;
% max_pitch_fre=pitch(1).fre;

scale_summe=getsumscale(current_frame);

% start plotting:
clf;
rect=[-0.04 0.15 0.9 0.85];
hint=1; % this indicate that we dont want a title
mysubplot(1,1,1,rect, hint);
plot_struct.t_min=minimum_time_interval/1000;
plot_struct.t_max=maximum_time_interval/1000;
plot_struct.has_axis=0;
plot_struct.is_log=is_log;
plot_struct.has_y_axis=0;

plot(current_frame,plot_struct);
set(gca,'zlim',[0 1/plot_scale]);

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
rect=[-0.04 0 0.9 0.2];
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
    summe=getpart(summe,-maximum_time_interval/1000,-minimum_time_interval/1000);
    
    nr_labels=8;
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

h=plot(sumvalues); hold on
axis([min_x_screen max_x_screen 0 scale_summe]);

% Ein roter Punkt dort, wo der pitch vermutet wird
% maximal n verschiedene Punkte
n=length(pitch.fre);
% pfre(1)=pitch.fre(1);   % das ist die höchtste
% 
% nr_res2=length(res);
% for i=1:nr_res2
%     if pitch(fre(i 
% end

for i=n:-1:1
    timex=-1/pitch.fre(i);
    hei=gettimevalue(summe,timex);
    bin=time2bin(summe,timex);
    if i==1
        radius=max(1,20*pitch.pitchstrength(i));
        if pitch.pitchstrength(i) > pitch.domfre(i)
            plot(max_x_screen-bin+2,hei,'r.','MarkerSize',radius);
        else
            plot(max_x_screen-bin+2,hei,'b.','MarkerSize',radius);
        end
        texthei=hei*1.2;
        if texthei>max(summe)/1.4
            texthei=max(summe)/1.4;
        end
        text((max_x_screen-bin)/1.06,texthei*1.2,sprintf('%3.0f Hz %5.3f',pitch.fre(1),pitch.pitchstrength(i)));    % this is at a nice position
    else
        radius=max(2,10*pitch.pitchstrength(i));
        plot(max_x_screen-bin+2,hei,'b.','MarkerSize',radius);
    end
end

set(gca,'XDir','reverse')   % turn them around, because the higher values shell end on the right
if is_log
    set(gca,'XScale','log')
end
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);
set(gca,'YTickLabel',[]);

if is_log
    text(min_x_screen*1.9,-scale_summe/5,'time interval (ms)');    % this is at a nice position
else
    text(120,-scale_summe/5,'time interval (ms)');    % this is at a nice position
end



% and the other sum on the y-axis
rect=[0.856 0.19 0.1 0.81];
mysubplot(1,1,1,rect, hint);
fresumme=sumfresig(current_frame);  % here it is calculated
fresumme=smooth(fresumme,1);% glätte die Summe

fresumme=setname(fresumme,'');
fresumme=setunit_x(fresumme,'');
fresumme=setunit_y(fresumme,'');

plot(fresumme); hold on
v=getvalues(fresumme);
x1=0;
x2=size(v,1)*47/42;
y1=0;
y2=100000;
axis([x1 x2 y1 y2]);
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

% [fremins,fremaxs,frewomin,frewomax]=getminmax(fresumme,0.0);
fremins=pitch.fresum.fremins;
fremaxs=pitch.fresum.fremaxs;
frewomin=pitch.fresum.frewomins;
frewomax=pitch.fresum.frewomaxs;
contrasts=pitch.fresum.contrasts;

nr=size(fremaxs,2);
for i=1:nr
    x1=time2bin(fresumme,frewomax(i));
    y1=fremaxs(i);
    %     plot(x1,y1,'r.','MarkerSize',contr);
    
    radius=max(1,10*pitch.fresum.spektralpitch(i));
%     if pitch.pitchstrength(1) < pitch.fresum.spektralpitch(i)
        plot(x1,y1,'r.','MarkerSize',radius);
        text(x1-2,y1,sprintf('%5.3f',pitch.fresum.spektralpitch(i)));    % this is at a nice position

%     else
%         plot(x1,y1,'b.','MarkerSize',radius);
%     end
    
end
nr=size(fremins,2);
for i=1:nr
    x2=time2bin(fresumme,frewomin(i));
    y2=fremins(i);
    plot(x2,y2,'g.','MarkerSize',5);
end
hold off