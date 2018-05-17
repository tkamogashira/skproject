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


function AIsurface(framestruct_a);
% plots the current frame (cframe)
% all relevant data must be in the frame-object

%         framestruct.current_frame = current_frame;
%         framestruct.scale_summe = scale_summe;
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
    show_time=1;
else
    show_time=framestruct.show_time;
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

srate=getsr(current_frame);
if is_log
    
    t=minimum_time_interval;
    ti=[t 2*t 4*t 8*t 16*t 32*t 64*t];
    tix=(ti)/1000*srate;  % there shell be the tix
    
    ti=(ti);
    ti=round(ti*100)/100;
    
    
    min_x_screen=minimum_time_interval/1000*srate; % thats the first point we want to see on the screen
    max_x_screen=maximum_time_interval/1000*srate; % thats the first point we want to see on the screen
    
else % its not logarithmic!
    nr_labels=8;
    xbis=getnrpoints(summe);
    tix=0:xbis/nr_labels:xbis;
    xstep=(maximum_time_interval-minimum_time_interval)*1000/nr_labels;   %works from -35 to 5
    xstep=round(xstep);
    ti=([minimum_time_interval*1000:xstep:maximum_time_interval*1000]);
    ti=round(ti*10)/10;
    
    min_x_screen=0;
    max_x_screen=maximum_time_interval/1000*srate; % thats the first point we want to see on the screen
    
end
% start plotting:
clf;
vals=getvalues(current_frame);
rvals=vals(:,end:-1:1);

h=surf(rvals,'LineStyle','none');
view([0 90]);
shading interp
% set the position of the axis so that it looks nice
set(gca,'Position',[0 0.06 0.92 0.96]);
set(gca,'YAxisLocation','right');

nr_channels=getnrchannels(current_frame);
axis([ min_x_screen max_x_screen 1 nr_channels ]);

% axis([min_x_screen max_x_screen 0 scale_summe]);

set(gca,'XDir','reverse')   % turn them around, because the higher values shell end on the right
if is_log
    set(gca,'XScale','log')
end
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);
set(gca,'YTickLabel',[]);
if is_log
    text(min_x_screen*1.9,-200/5,'time interval (ms)');    % this is at a nice position
else
    text(120,-200/5,'time interval (ms)');    % this is at a nice position
end    

% make y-Ticks
nr_labels=8;
ystep=(nr_channels-1)/(nr_labels-1);
tiy=1:ystep:nr_channels;
cfs=getcf(current_frame);
ti=cfs(floor(tiy))/1000;
ti=round(ti*10)/10;
set(gca,'YTick',tiy);
set(gca,'YTickLabel',ti);

text(30,-2,'time interval (ms)');    % this is at a nice position
