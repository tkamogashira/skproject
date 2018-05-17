% function [pitchstrength, dominant_time] = analyse_timeinterval_profile(ti_profile, peaks, a_priori, fqp_fq)
%
%   To analyse the time interval profile of the auditory image
%
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function result = analyse_timeinterval_profile(ti_profile,options)

if nargin < 2
	options=[];
end

if isfield(options,'target_frequency')
end

if ~isfield(options,'options')
	target_frequency=0;
end


% for debug resons
plot_switch = 1;


intsum = ti_profile;   
intsum_vals = getdata(intsum);
if plot_switch
    minimum_time_interval=0;  % in ms
    maximum_time_interval=100;
    figure(654654)
	clf
    tip = intsum_vals;
    tip_x = bin2time(ti_profile, 1:length(tip));  % Get the times
    tip_x = tip_x((tip_x>=(minimum_time_interval/1000)) & tip_x<=(maximum_time_interval/1000));  
    tip = tip(time2bin(ti_profile, tip_x(1)):time2bin(ti_profile, tip_x(end)));
    % tip_x is in ms. Change to Hz
    tip_x = 1./tip_x;
    plot(tip_x, tip, 'b');
    set(gca,'XScale','log'); 
	set(gca,'Ylim',	[min(intsum)-10 max(intsum)+10]);
	set(gca,'Xlim',	[30 1500]);
    hold on
end
if length(peaks)==0
    % If there is no peak than we just plot the function
    pitchstrength = 0;
    found_frequency = 0;
    return
end


sig=envelope(intsum)

% ++++++++++++ Part one: Peak finding ++++++++++
% Calculate the envelope (curve of the peaks)

% sort peaks from low time interval to a heigh one
% or from left to right
peaks_lr = sortstruct(peaks,'x');  % 

if plot_switch
    px=[];py=[];
    for i=1:length(peaks)
        px = [px tip_x(peaks{i}.x)];
        py = [py tip(peaks{i}.x)];
    end
    plot(px,py,'kx');
end

% Create envelope of peaks
peak_envX = [];
peak_envY = [];
for i=1:length(peaks_lr)
    peak_envX = [peak_envX peaks_lr{i}.x];
    peak_envY = [peak_envY peaks_lr{i}.y];
end

if plot_switch
     plot(tip_x(peak_envX),  peak_envY, ':k');
end


% Find Maxima of the envelope 
% create signal

sig=buildfrompoints(sig,xx,yy)


peak_envsig = signal(length(peak_envX), 1);
peak_envsig = setvalues(peak_envsig, peak_envY);
params = 0; 
peak_env_peaks = PeakPicker(peak_envsig, params);
% sort peaks of the envelope from low time interval to a heigh one
% or from left to right
peaks_env_peaks_lr = sortstruct(peak_env_peaks,'x');  % 

if plot_switch
	for i=2:length(peaks_env_peaks_lr) % construct all maxima
		fre=peaks_env_peaks_lr{i}.t;
		plot(fre,gettimevalue(ti_profile,1/fre),'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',5);
	end
end

% % Now make sure, that highest peak is not the first peak of envelope
% peak_oi = peaks{1};
% if (peak_oi.x == peak_envX(peaks_env_peaks_lr{1}.x))
%     % The first Peak is the heighest -> take second highest of envelope
%     if (length(peak_env_peaks)>=2)
%          poix = peak_envX(peak_env_peaks{2}.x);
%          poiy = peak_env_peaks{2}.y;
%          for i=1:length(peaks)
%              if poix==peaks{i}.x
%                 peak_oi = peaks{i};  
%              end
%          end
%      end
% end


% Stefans new method:
% Take the one with the highest contrast
if length(peaks_env_peaks_lr) > 1
	for i=2:length(peaks_env_peaks_lr) % construct all maxima
		maxpeak=peaks_env_peaks_lr{i}.y;
		minpeak1=peaks_env_peaks_lr{i}.left.y;
		minpeak2=peaks_env_peaks_lr{i}.right.y;
		minpeak=mean([minpeak1 minpeak2]);
		
		% the definition of pitch strength: Contrast
		% 	contrast(i)=maxpeak/(mean([minpeak1 minpeak2]));
		
		% the difference between both
		if maxpeak-minpeak > 0
			contrast(i)=(maxpeak-minpeak)/1000;
		else
			contrast(i)=0;
		end
		if plot_switch
			fre=1/peaks{i}.t;
			plot(fre,gettimevalue(ti_profile,1/fre),'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',5);
			text(fre,gettimevalue(ti_profile,1/fre)*1.1,sprintf('%2.2f',contrast(i)));
		end
	end
else	% there is only one peak
	maxpeak=peaks{1}.y;
	minpeak1=peaks{1}.left.y;
	minpeak2=peaks{1}.right.y;
	minpeak=mean([minpeak1 minpeak2]);
	if maxpeak-minpeak > 0
		contrast(1)=(maxpeak-minpeak)/1000;
	else
		contrast(1)=0;
	end
end

[maxcontrast,wheremax]=max(contrast);

peak_oi=peaks{wheremax};

pitchstrength= contrast(wheremax);
found_frequency = 1/peak_oi.t;

if plot_switch
	fre=found_frequency;
	plot(fre,gettimevalue(ti_profile,1/fre),'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',pitchstrength*10);
	text(fre*1.1,gettimevalue(ti_profile,1/fre)+5, ['highest pitchstrength found at ' num2str(round(fre)) 'Hz: ' num2str(fround(pitchstrength,2)) ],'VerticalAlignment','bottom','HorizontalAlignment','center','color','g','Fontsize',12);
end

return




% maxpeak=maxstruct(peaks,'y');

if length(peaks_env_peaks_lr)>1
    for i=1:length(peaks)
        % If second highes peak==peak with smallest time intervall -> take
        % third highest !!
        if peak_env_peaks{2}.x == peaks_env_peaks_lr{1}.x
          poix = peak_envX(peak_env_peaks{3}.x);
        else
          poix = peak_envX(peak_env_peaks{2}.x);
        end
        if peaks{i}.x==poix
            peak_oi = peaks{i};
        end
    end
else
    % pure sinusoid ???
    dominant_time = 0
    pitchstrength = 0.001;
    return
end



% Stefan's method on HCL
% Take second peak of envelope from short time intervals
if length(peaks_env_peaks_lr)>1
    for i=1:length(peaks)
        % If second highes peak==peak with smallest time intervall -> take
        % third highest !!
        if peak_env_peaks{2}.x == peaks_env_peaks_lr{1}.x
          poix = peak_envX(peak_env_peaks{3}.x);
        else
          poix = peak_envX(peak_env_peaks{2}.x);
        end
        if peaks{i}.x==poix
            peak_oi = peaks{i};
        end
    end
else
    % pure sinusoid ???
    dominant_time = 0
    pitchstrength = 0.001;
    return
end

if plot_switch
    plot(tip_x(peak_oi.x), peak_oi.y, 'ro');
end





% peak_oi contains the peak for quantification


% ++++++++++++ Part two: Quantification ++++++++++

% **** First method
% pitchstrength is mean of sum / mean of peaks
% psum = 0;
% for i = 1:length(peaks)
%     psum = psum+peaks{i}.y;
% end
% psum = psum / length(peaks);
% pitchstrength = psum/peaks{1}.y;
% dominant_time = peaks{1}.x /getsr(ti_profile);
% if plot_switch
%     hold off
%     plot(ti_profile);
%     hold on;
%     plot(peaks{1}.x, peaks{1}.y, 'ko');
% end

% % ***** Second method
% % Heigh of neighbour peak / highest peak
% % First Peaks is the highest as pitchstrength of Peak Picker
% % Find lower neighbour (with shorter time interval)
% ioi=1;  % index of interest
% dist = inf;
% for i=1:length(peaks)
%     d = peak_oi.x - peaks{i}.x;
%     if ((d<dist)&(d>0))
%         ioi = i;
%         dist = d;
%     end
% end
% pitchstrength = peaks{ioi}.y/ peak_oi.y;
% dominant_time = peak_oi.x /getsr(ti_profile);
% if plot_switch
%     hold on;
%     plot(peak_oi.x , peak_oi.y , 'ko');
%     plot(peaks{ioi}.x, peaks{ioi}.y, 'go');
% end

% % Third Method:
% Peak to mean valley ration - good with HCL
pitchstrength= mean([peak_oi.left.y peak_oi.right.y])/peak_oi.y;
dominant_time = peak_oi.x /getsr(ti_profile);

% Adaptation
%pitchstrength = 1-pitchstrength;

% +++++++++++++ Histogram of distances between two peaks ++++++++++

%
max_thresh = 1; %0.98;
% The linear TIP 

% Test if all other Peaks ar multiple of the highest peak

% Start with the first peak
% Test how many peaks are mutiple of the first peak
%---x---x---x---x---x---x
% Take first peak of envelope.
poix = peak_envX(peak_env_peaks{1}.x);
for i=1:length(peaks_lr)
    if peaks_lr {i}.x==poix
        peak_first = peaks_lr{i};
        first_i=i;
    end
end
nomult = 0; % Number of multible
max_delta = 0.1;   % 
for i=first_i:length(peaks_lr)
    f = peaks_lr{i}.t / peak_first.t;
    if abs(round(f)-f)<max_delta
        nomult=nomult+1;
    end
end
nomult;

if plot_switch
    figure(savecf)
end

%---x---x---x---x---x---x

% is there is a priori information? 
% if (nargin>2)
%     dominant_time = mb(h_index) / getsr(ti_profile);
%     pitchstrength = 0; 
%     return
% end



% ------------ subfunctions ---------------------

% turns a vector (row) upside down
function y=upsidedown(x)
y=[];
for i=length(x):-1:1
    y=[y x(i)];
end
