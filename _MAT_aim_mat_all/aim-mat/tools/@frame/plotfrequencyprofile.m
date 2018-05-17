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
% $Date: 2003/10/21 14:14:02 $
% $Revision: 1.9 $

function  hand=plotfrequencyprofile(current_frame,options,ax)

if nargin<3
    ax=gca;
end
if nargin<2
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

if isfield(options,'frequency_profile_scale');
    frequency_profile_scale=options.frequency_profile_scale;
else
    frequency_profile_scale=1;
end

%shrink_range indicates, if the axis should not occupy the whole space
if isfield(options,'shrink_range');
    shrink_range=options.shrink_range;
else
    shrink_range=1;
end

if ~isfield(options,'minimum_time_interval');
    minimum_time_interval=0;
else
    minimum_time_interval=options.minimum_time_interval;
end

if ~isfield(options,'maximum_time_interval');
    maximum_time_interval=0.035;
else
    maximum_time_interval=options.maximum_time_interval;
end

if maximum_time_interval>getmaximumtime(current_frame)
    maximum_time_interval=getmaximumtime(current_frame);
end


if ~isfield(options,'turn_axis_vertically');
    turn_axis_vertically=1;
else
    turn_axis_vertically=options.turn_axis_vertically;
end

    
% frequency sum
scale_frequency=getscalefrequency(current_frame);

% channel_density=0.015; % passt für 76 channels von 100 bis 6000
% hoehe=getnrchannels(current_frame)*channel_density;
% if hoehe>1
%     hoehe=1;
% end
% 
% rect=[0.856 0.19 0.1 hoehe*0.81];
% rect(1:2)=caxes(1:2)+(rect(1:2).*caxes(3:4));
% rect(3:4)=rect(3:4).*caxes(3:4);
% mysubplot(1,1,1,rect, hint);

part_current_frame=getpart(current_frame,minimum_time_interval,maximum_time_interval);
% if getxaxis(current_frame)=='0'
%     h_cutoff=3;
%     h_width=20;
%     aa=getvalues(part_current_frame);
%     aa=aa(1:601,h_cutoff*h_width:121);
%     part_current_frame=frame(aa/100);
% end;

fresumme=getfrequencysum(part_current_frame);  % here it is calculated
% fresumme=smooth(fresumme,1);% glätte die Summe
if getxaxis(current_frame)=='0'
   [band_location band_height]=getlocalmaxima(fresumme);
   band_location=(band_location/601)*30;
   band_information(:,1)=band_location';
   band_information(:,2)=band_height';
%    disp('maxima');
%    disp('    h val   height');
%    disp(band_information);
   [min_posit min_height]=getlocalminima(fresumme);
   min_posit=(min_posit/601)*30;
   band_information2(:,1)=min_posit';
   band_information2(:,2)=min_height';
%    disp('minima');
%    disp('    h val   height');
%    disp(band_information2);
end;


if frequency_profile_scale < 0
    mscal=max(fresumme);
    if mscal~=0
        frequency_profile_scale=scale_frequency/mscal*0.9;
    else
        frequency_profile_scale=1;
    end
end

fresumme=setname(fresumme,'');
fresumme=setunit_x(fresumme,'');
fresumme=setunit_y(fresumme,'');

% hand=plot(fresumme,'r'); hold on
v=getvalues(fresumme);
hand=plot(ax,v,'r'); hold on

maxy=scale_frequency/frequency_profile_scale;
if maxy==0
    maxy=1;
end
nr=size(v,1);
if nr==0
    nr=1;
end
set(ax,'xlim',[0 nr *shrink_range]);
set(ax,'ylim',[0 maxy]);

% axis([0 nr *shrink_range 0 maxy]);

if turn_axis_vertically==1
    view(ax,-90,90);
end


% make y-Ticks
cfs=getcf(current_frame);
if length(cfs) > 1
    nr_labels=8;
    nr_channels=getnrpoints(fresumme);
    xstep=(nr_channels-1)/(nr_labels-1);
    tix=1:xstep:nr_channels;
    ti=cfs(floor(tix))/1000;
else
    ti=cfs;
    tix=0.5;
end
ti=round(ti*10)/10;

if getxaxis(current_frame)=='0'
    d=size(cfs);
    ti = [0:5:30];
    step=(d(2)/6);
    tix = [0:step:d(2)];
end;

set(ax,'XTick',tix);
set(ax,'XTickLabel',ti);
if turn_axis_vertically==1
    set(ax,'YTickLabel',[]);
    set(ax,'XAxisLocation','top');
end

