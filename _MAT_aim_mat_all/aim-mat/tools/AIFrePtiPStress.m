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


function pitch=AIFrePtiPStress2(framestruct_a);
% plots the current frame (cframe) together with its sum of intervals
% and the sum of frequencies
% all relevant data must be in the frame-object
% the return value "pitch" is the result from the call to "calcresidualprobability"

if ~isstruct(framestruct_a)
    %     error('AIsum must be called with a structure');
    framestruct.current_frame=framestruct_a;
	current_frame_number=1;
else
    framestruct=framestruct_a;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Different Parameters
% if the label of the time should be shown in the upper left corner
if ~isfield(framestruct,'show_time');
    show_time=1;
else
    show_time=framestruct.show_time;
end 

% if any grafic should be displayed. Otherwise only the value is returned
if ~isfield(framestruct,'show_graphic');
    show_graphic=1;
else
    show_graphic=framestruct.show_graphic;
end 

% both profiles can be scaled to a higher value
if ~isfield(framestruct,'profile_scale');
    profile_scale=1;
else
    profile_scale=framestruct.profile_scale;
end 

% the picture can be scaled overall to a higher value
if ~isfield(framestruct,'plot_scale');
    plot_scale=1;
else
    plot_scale=framestruct.plot_scale;
end

% the minimum time interval (usually 1 ms) on the right
if ~isfield(framestruct,'minimum_time_interval');
    minimum_time_interval=1;
else
    minimum_time_interval=framestruct.minimum_time_interval;
end

% the maximum time interval (usually 35 ms) on the left
if ~isfield(framestruct,'maximum_time_interval');
    maximum_time_interval=35;
else
    maximum_time_interval=framestruct.maximum_time_interval;
end

% linear or logarithmic structure
if ~isfield(framestruct,'is_log');
    is_log=1;
else
    is_log=framestruct.is_log;;
end
current_frame=framestruct.current_frame;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter für die PitchBerechnung
dot_scaler=200;  % wie gross Punkte dargestellt werden sollen in Punkt
grafix=0;
% wie weit die Intervallsumme runterskaliert werden muss, damit die Zahlen vernünftigt werden
norm_intervalhight=1/1e4;
% wie weit die spektrale Summe runterskaliert werden muss, damit die Zahlen vernünftigt werden
norm_spektralhight=1.5/1e5;

% how big must the contrast of the envelope be to be recognised as one pitch
envcontrast_threshold=0.15;

% A single factor, that can vary between
% 0 = complete attention to temporal structure
% 1 = complete attention to spectral structure
spectral_attention_factor=0.5;

pitch_current_frame=current_frame;
% schmeisse die physikalisch nicht sinnvollen Bereiche raus!
current_frame=extractpitchregion(current_frame);

% berechne die pitches vom Orginal
parameters.norm_intervalhight=norm_intervalhight;
parameters.norm_spektralhight=norm_spektralhight;
parameters.graphix=grafix;
parameters.dot_scaler=dot_scaler;
parameters.spectral_attention_factor=spectral_attention_factor;
parameters.extract_pitch_region=1;      % schmeiss die Ecke unten rechts raus
parameters.use_whole_spektral_profile=1; % nimm das gesamte Profil zum mitteln!


% Berechnet den Pitch
pitch=calcresidualprobability(pitch_current_frame,parameters);
% if we dont need any graphic, than return here
if ~show_graphic
    return;
end

% start plotting:
clf;
rect=[-0.04 0.15 0.9 0.85];
hint=1; % this indicate that we dont want a title
mysubplot(1,1,1,rect, hint);
plot_struct.t_min=minimum_time_interval/1000;
plot_struct.t_max=maximum_time_interval/1000;
% current_frame=setdisplayminimumtime(current_frame,minimum_time_interval);
% current_frame=setdisplaymaximumtime(current_frame,maximum_time_interval);

plot_struct.has_axis=0;
plot_struct.is_log=is_log;
plot_struct.has_y_axis=0;

rethand=plot(current_frame,plot_struct);
set(gca,'zlim',[0 1/plot_scale]);

% if show_time
%     srate=getsr(current_frame);
%     text_x=0.9*maximum_time_interval*srate/1000;
%     text_y=getnrchannels(current_frame)+5;
%     str=getstructure(current_frame);
%     if ~isfield(str,'current_frame_start_time')
%         str.current_frame_start_time=0.0;
%     end
%     frame_number=str.current_frame_number;
%     frame_time=str.current_frame_start_time*1000;
%     text(text_x,text_y,sprintf('%d  : %4.0fms',frame_number,frame_time),'FontSize',8);
%     %     text(text_x,text_y,sprintf('%d',frame_number),'FontSize',8);
% end

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
    
    psumme=getpart(summe,getminimumtime(summe),getmaximumtime(summe));
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

% alle Werte sind auf empirische Werte genormt, so dass sie immer gleich hoch sind
sumvalues=sumvalues*norm_intervalhight;
% alle Werte auf die Benutzerscalierung scalen
sumvalues=sumvalues*profile_scale;

summe=setvalues(summe,sumvalues,floor(min_x_screen));
h=plot(sumvalues); hold on

axis([min_x_screen max_x_screen 0 1]);
sr=getsr(current_frame);

% % Ein roter Punkt dort, wo der pitch vermutet wird
n=length(pitch);
for i=n:-1:1
    peak=pitch{i};
    timex=peak.interval_profile.time;
    
%     binx=displaytime2bin(current_frame,timex)-2;
    binx=time2bin(timex,sr)-2;
    hei=getbinvalue(summe,max_x_screen-binx+min_x_screen);  
    %     hei=gettimevalue(summe,getminimumtime(summe)-timex);
    %     bin=time2bin(summe,timex);
    if i==1
        radius=max(5,dot_scaler*peak.residuumpitchstrength);
        plot(max_x_screen-binx,hei,'r.','MarkerSize',radius);
        texthei=hei*1.2;
        if texthei>max(summe)/1.4
            texthei=max(summe)/1.4;
        end
        if peak.interval_profile.envcontrast > envcontrast_threshold
            %         text(binx/1.06,texthei*1.2,sprintf('%3.0f Hz %5.3f',peak.fre,peak.pitchstrength));    % this is at a nice position
            text((max_x_screen-binx)/1.06,texthei*1.2,sprintf('%3.0f Hz',peak.interval_profile.fre));    % this is at a nice position
        end
    else
        radius=max(5,dot_scaler*peak.residuumpitchstrength);
        plot(max_x_screen-binx,hei,'b.','MarkerSize',radius);
    end
end
% 
set(gca,'XDir','reverse')   % turn them around, because the higher values shell end on the right
if is_log
    set(gca,'XScale','log')
end
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);
set(gca,'YTickLabel',[]);
% 
% if is_log
%     scale_summe=getfrequencysum(current_frame);
%     text(min_x_screen*1.9,-scale_summe/5,'time interval (ms)');    % this is at a nice position
% else
%     text(120,-scale_summe/5,'time interval (ms)');    % this is at a nice position
% end



% and the other sum on the y-axis
rect=[0.857 0.2 0.10 0.75];
mysubplot(1,1,1,rect, hint);
fresumme=getfrequencysum(current_frame);  % here it is calculated
% fresumme=smooth(fresumme,1);% glätte die Summe

% alle Werte auf den empirischen Wert skalieren und auf den Benutzerwert
fresumme=fresumme*norm_spektralhight;
fresumme=fresumme*profile_scale;

fresumme=setname(fresumme,'');
fresumme=setunit_x(fresumme,'');
fresumme=setunit_y(fresumme,'');

plot(fresumme,'r'); hold on
v=getvalues(fresumme);
x1=0;
x2=size(v,1)*47/42;
y1=0;
y2=1;
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

n=length(pitch);
for i=n:-1:1
    peak=pitch{i};
    x=peak.spektral_profile.position;
    hei=peak.spektral_profile.hight/2;
    radius=max(5,dot_scaler*hei);
    y=getbinvalue(fresumme,x);
    plot(x,y,'r.','MarkerSize',radius);
end

% Special Effect: Make Region cool!
n=length(pitch);
cdat=get(rethand,'cdata');
cdat=zeros(size(cdat));

bereich=n:-1:1;
% bereich=1;
for i=bereich
    peak=pitch{i};
    cdat=coolregion(current_frame,cdat,peak);
end

set(rethand,'cdata',cdat);
% erzeuge eine Colormap, die genausoviel Farben hat, wie wir Quellen
colmap=hsv(n+1);
colmap(1,:)=0.85;
colormap(colmap);