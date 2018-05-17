% function [pitchstrength, dominant_time] = find_pitches(profile, , a_priori, fqp_fq)
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

function result = find_pitches(profile,options)

plot_switch =0;

if nargin < 2
	options=[];
end
% 

% peaks must be higher then this of the maximum to be recognised
ps_threshold=0.1;	
heighttowidthminimum=0.3;	% height of peak, where the width is measured
octave_variability=0.35;	% in percent, when the octave is acepted as such



% preliminary return values.
result.final_pitchstrength=0;
result.final_dominant_frequency=0;
result.final_dominant_time=0;
result.smoothed_signal=[];
result.peaks = [];

% change the scaling to logarithm, before doing anything else:
log_profile=logsigx(profile,0.001,0.035);


peak_found=0;
current_lowpass_frequency=500;

while ~peak_found
	
	smooth_sig=lowpass(log_profile,current_lowpass_frequency);
	envpeaks = IPeakPicker(smooth_sig,0.01);
	
	if isempty(envpeaks) % only, when there is no signal
		return
	end
	
	% finde den peak mit der höchsten Pitschstrength
	for i=1:length(envpeaks) % construct all maxima
		where=bin2time(smooth_sig,envpeaks{i}.x);
		[dummy,height,breit,where_widths]=qvalue(smooth_sig,where,heighttowidthminimum);
		width=time2bin(smooth_sig,breit);
		if width>0
			envpeaks{i}.pitchstrength=height/width;
		else
			envpeaks{i}.pitchstrength=0;
		end
		envpeaks{i}.width=width;
		envpeaks{i}.where_widths=where_widths;
		envpeaks{i}.peak_base_height_y=height*(1-heighttowidthminimum);
	end
	
	% sort all for the highest first!
	% 	envpeaks=sortstruct(envpeaks,'pitchstrength');
	envpeaks=sortstruct(envpeaks,'y');
	
	if plot_switch
		figure(2134)
		clf
		hold on
		plot(log_profile,'b')
		plot(smooth_sig,'g')
		for i=1:length(envpeaks)
			time=envpeaks{i}.t;
			x=envpeaks{i}.x;
			y=envpeaks{i}.y;
			plot(x,y,'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',2);
			time_left=envpeaks{i}.left.t;
			x_left=envpeaks{i}.left.x;
			y_left=envpeaks{i}.left.y;
			time_right=envpeaks{i}.right.t;
			x_right=envpeaks{i}.right.x;
			y_right=envpeaks{i}.right.y;
			plot(x_left,y_left,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
			plot(x_right,y_right,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
		end
		current_time=options.current_time*1000;
		y=get(gca,'ylim');
		y=y(2);
		text(700,y,sprintf('%3.0f ms',current_time),'verticalalignment','top');
		
		for i=1:length(envpeaks)
			pitchstrength=envpeaks{i}.pitchstrength;
			if i <4
				line([envpeaks{i}.x envpeaks{i}.x],[envpeaks{i}.y envpeaks{i}.y*(1-heighttowidthminimum)],'Color','r');
				line([envpeaks{i}.where_widths(1) envpeaks{i}.where_widths(2)],[envpeaks{i}.y*(1-heighttowidthminimum) envpeaks{i}.y*(1-heighttowidthminimum)],'Color','r');
				x=envpeaks{i}.x;
				fre=envpeaks{i}.fre;
				y=envpeaks{i}.y;
				text(x,y*1.05,sprintf('%3.0fHz: %2.2f',fre,pitchstrength),'HorizontalAlignment','center');
			end
		end
	end
	
	% kucke, ob sich das erste Maxima überlappt. Falls ja, nochmal
	% berechnen mit niedriger Lowpass frequenz
	nr_peaks=length(envpeaks);
	if 	nr_peaks==1
		peak_found=1;
		continue
	end
	xleft=envpeaks{1}.where_widths(1);
	xright=envpeaks{1}.where_widths(2);
	for i=2:nr_peaks %
		xnull=envpeaks{i}.x;
		if xnull < xleft  && xnull > xright
			peak_found=0;
			current_lowpass_frequency=current_lowpass_frequency/2;
			if current_lowpass_frequency<62.5
				return
			end
			break
		end
		% wenn noch hier, dann ist alles ok
		peak_found=1;
	end
end


% reduce the peaks to the relevant ones:
% through out all with pitchstrength smaller then threshold
count=1;
min_ps=ps_threshold*envpeaks{1}.pitchstrength;
for i=1:length(envpeaks)
	if envpeaks{i}.pitchstrength>min_ps
		rpeaks{count}=envpeaks{i};
		count=count+1;
	end
end


% final result for the full set
result.final_pitchstrength=rpeaks{1}.pitchstrength;
result.final_dominant_frequency=rpeaks{1}.fre;
result.final_dominant_time=rpeaks{1}.t;
result.smoothed_signal=smooth_sig;
result.peaks=rpeaks;
% return

% Neuberechnung der Pitchstrength für peaks, die das Kriterium der 
% Höhe zu Breite nicht erfüllen
for i=1:length(rpeaks) % construct all maxima
	where=bin2time(smooth_sig,rpeaks{i}.x);
	[dummy,height,breit,where_widths]=qvalue(smooth_sig,where,heighttowidthminimum);
	width=time2bin(smooth_sig,breit);
	
	xleft=where_widths(2);
	xright=where_widths(1);
	left_peak=rpeaks{i}.left;
	right_peak=rpeaks{i}.right;
	
	
	xnull=rpeaks{i}.x;
	if xleft<left_peak.x || xright>right_peak.x
		t_xnull=bin2time(smooth_sig,xnull);
		[val,height,breit,widthvals,base_peak_y]=qvalue2(smooth_sig,t_xnull);
		width=time2bin(smooth_sig,breit);
		if width>0
			rpeaks{i}.pitchstrength=height/width;
		else
			rpeaks{i}.pitchstrength=0;
		end
		rpeaks{i}.where_widths=time2bin(smooth_sig,widthvals);
		rpeaks{i}.width=width;
		rpeaks{i}.peak_base_height_y=base_peak_y;
	end
end

% sort again all for the highest first!
% rpeaks=sortstruct(rpeaks,'pitchstrength');

% return
%%%%%%  look for octave relationships
% 
% 
for i=1:length(rpeaks) % construct all maxima
	% look, if the octave of the pitch is also present.
	fre=rpeaks{i}.fre;
	has_octave=0;
	for j=1:length(rpeaks)
		oct_fre=rpeaks{j}.fre;
		% is the octave there?
		if oct_fre > (2-octave_variability)*fre && oct_fre < (2+octave_variability)*fre
			rpeaks{i}.has_octave=oct_fre;
			rpeaks{i}.octave_peak_nr=j;
				
			% add the pss
% 			rpeaks{j}.pitchstrength=rpeaks{i}.pitchstrength+rpeaks{j}.pitchstrength;

			ps_real=rpeaks{j}.pitchstrength;
			ps_oct=rpeaks{i}.pitchstrength;
			hight_oct=rpeaks{j}.y;
			hight_real=rpeaks{i}.y;
			
% 			if ps_oct>ps_real && hight_oct > hight_real
% 				rpeaks{i}.pitchstrength=ps_real-1;	% artificially drop down
% 			end

			has_octave=1;
			break
		end
		if ~has_octave
			rpeaks{i}.has_octave=0;
			rpeaks{i}.octave_peak_nr=0;
		end
	end
end

if plot_switch
	figure(2134)
	clf
	hold on
	plot(log_profile,'b')
	plot(smooth_sig,'g')
	for i=1:length(rpeaks)
		time=rpeaks{i}.t;
		x=rpeaks{i}.x;
		y=rpeaks{i}.y;
		plot(x,y,'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',2);
		time_left=rpeaks{i}.left.t;
		x_left=rpeaks{i}.left.x;
		y_left=rpeaks{i}.left.y;
		time_right=rpeaks{i}.right.t;
		x_right=rpeaks{i}.right.x;
		y_right=rpeaks{i}.right.y;
		plot(x_left,y_left,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
		plot(x_right,y_right,'Marker','o','Markerfacecolor','r','MarkeredgeColor','r','MarkerSize',2);
	end
	current_time=options.current_time*1000;
	y=get(gca,'ylim');
	y=y(2);
	text(700,y,sprintf('%3.0f ms',current_time),'verticalalignment','top');
	
	for i=1:length(rpeaks)
		pitchstrength=rpeaks{i}.pitchstrength;
		if i <10
			line([rpeaks{i}.x rpeaks{i}.x],[rpeaks{i}.y rpeaks{i}.peak_base_height_y],'Color','m');
			line([rpeaks{i}.where_widths(1) rpeaks{i}.where_widths(2)],[rpeaks{i}.peak_base_height_y rpeaks{i}.peak_base_height_y],'Color','m');
			x=rpeaks{i}.x;
			fre=rpeaks{i}.fre;
			y=rpeaks{i}.y;
			text(x,y*1.05,sprintf('%3.0fHz: %2.2f',fre,pitchstrength),'HorizontalAlignment','center');
		end
	end
end
if plot_switch==1
	for i=1:length(rpeaks)
		x=rpeaks{i}.x;
		y=rpeaks{i}.y;
		plot(x,y,'Marker','o','Markerfacecolor','g','MarkeredgeColor','g','MarkerSize',6);
		
		% plot the octaves as green lines
		octave=rpeaks{i}.has_octave;
		fre=rpeaks{i}.fre;
		if octave>0
			oct_nr=rpeaks{i}.octave_peak_nr;
			oct_fre=rpeaks{oct_nr}.fre;
			
			x=rpeaks{i}.x;
			oct_x=rpeaks{oct_nr}.x;
			y=rpeaks{i}.y;
			oct_y=rpeaks{oct_nr}.y;
			line([x oct_x],[y oct_y],'Color','g','LineStyle','--');
		end
	end
end

% rpeaks=sortstruct(rpeaks,'pitchstrength');
rpeaks=sortstruct(rpeaks,'y');

% final result for the full set
result.final_pitchstrength=rpeaks{1}.pitchstrength;
result.final_dominant_frequency=rpeaks{1}.fre;
result.final_dominant_time=rpeaks{1}.t;
result.smoothed_signal=smooth_sig;
result.peaks=rpeaks;




function fre=x2fre(sig,x)
t_log = bin2time(sig,x);
t=f2f(t_log,0,0.035,0.001,0.035,'linlog');
fre=1/t;
