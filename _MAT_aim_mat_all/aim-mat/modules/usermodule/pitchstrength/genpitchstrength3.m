% generating function for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Christoph Lindner
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ps_result=genpitchstrength(sai,options)

plot_switch=0;

target_frequency=options.target_frequency;

if target_frequency > 0
	look_for_target_frequency=1;
	minimum_allowed_frequency=target_frequency/options.allowed_frequency_deviation;
	maximum_allowed_frequency=target_frequency*options.allowed_frequency_deviation;
else
	look_for_target_frequency=0;
end


% find out about scaling:
maxval=-inf;
maxfreval=-inf;
maxsumval=-inf;

nr_frames=length(sai);
for ii=1:nr_frames
	maxval=max([maxval getmaximumvalue(sai{ii})]);
	maxsumval=max([maxsumval getscalesumme(sai{ii})]);
	maxfreval=max([maxfreval getscalefrequency(sai{ii})]);
end


for frame_number=1:nr_frames
	current_frame = sai{frame_number};
	% 	current_frame = setallmaxvalue(current_frame, maxval);
	frame_start_time(frame_number)=getcurrentframestarttime(current_frame);
	tip(frame_number)=getsum(current_frame);
end
frame_duration=frame_start_time(2)-frame_start_time(1);

% calculate the averaged tips
% the first frames are not average, since not long enough time has
% passed. After that, the relevant last frames are averaged
tip_time=options.tip_average_time;
% time for pitch to drop to 1/2 (6dB) --in seconds
% this means so much per frame
ps_decay_constant=1-log(2)/(tip_time/frame_duration);


% % and again to sum them up
% for frame_number=1:nr_frames
% 	thisav=mute(tip(frame_number)); % take a copy of the original one
% 	figure(1243234)
% 	clf
% 	hold on
% 	count=0;
% 	for recent_frames_nr=frame_number-nr_frames_to_average:frame_number
% 		if recent_frames_nr > 0
% 			thisav=thisav+tip(recent_frames_nr);
% 			count=count+1;
% 			plot(tip(recent_frames_nr),'g');
% 		end
% 	end
% 	thisav=thisav/count;	% the average
% 	plot(thisav,'r');
% 	average_tip(frame_number)=thisav;
% end

% is it necessary to calculate all, or can we start right at the end?
% if options.return_only_last==1
% 	start_frame=length(sai);
% else	% no we 
start_frame=1;
% end


tip_average=mute(tip(1)); % take a copy of the original one

% mache ein Histogramm für jede Frequenz mit allem Maxima:
% nr_points=getnrpoints(sai{1});
% histo=zeros(1,nr_points);

waithand = waitbar(0,'Generating pitch strength');
for frame_number=start_frame:nr_frames
	
	waitbar(frame_number/nr_frames, waithand);     
	
	current_frame = sai{frame_number};
	current_frame = setallmaxvalue(current_frame, maxval);
	current_frame = setscalesumme(current_frame, maxsumval);
	current_frame = setscalefrequency(current_frame, maxfreval);
	
	interval_sig =  tip(frame_number);
	% 	interval_sig =  average_tip(frame_number);      
	ps_result{frame_number}.frequency_sum = getfrequencysum(current_frame);      
	% Normalisation
	interval_sig =  interval_sig/getnrpoints( ps_result{frame_number}.frequency_sum);
	ps_result{frame_number}.frequency_sum = ps_result{frame_number}.frequency_sum/getnrpoints(interval_sig)*options.scalefactor;
	
	opts.ps_options=options;
	% do all relevant pitch calculations for this frame


	% add the profile to the average
	tip_average=tip_average+tip(frame_number);
	result=find_pitches(tip_average,opts);
	tip_average=tip_average*ps_decay_constant; 

	
	% sum all pitches for a histogram
	peaks=result.peaks;
	nr_peaks=length(peaks);
	if nr_peaks>0
% 		for current_peak=1:nr_peaks
% 			peak_time=peaks{current_peak}.t;
% 			peak_x=peaks{current_peak}.x;
% 			peak_height=peaks{current_peak}.y;
% 			int_x=round(peak_x);
% 			histo(int_x)=histo(int_x)+peak_height;
% 		end
		
% 		shist=signal(histo,getsr(interval_sig));
% 		shistl=lowpass(shist,400);
% 		peaks=IPeakPicker(shistl);
 		speaks=sortstruct(peaks,'y');
		
		pitchstrength=speaks{1}.y/1000000;
		final_dominant_frequency=1/speaks{1}.t;
		
% 						if mod(frame_number,20)==0
% 							% 		plot(shist);
% 							% 		ax=axis;
% 							figure(43242)
% 							plot(shistl,'r'); hold on
% 							% 		axis(ax);
% 							for i=1:1%length(speaks)
% 								fre=1/speaks{i}.t;
% 								plot(speaks{i}.x,speaks{i}.y,'o','MarkerFaceColor','g','MarkerEdgeColor','g')
% 								text(speaks{i}.x,speaks{i}.y,sprintf('%2.2fHz %2.2f',fre,speaks{i}.y))
% 							end
% 							time=frame_number*5;
% 							text(speaks{1}.x+200,speaks{1}.y,sprintf('Time: %3.0fms',time));
% 							o=0;
% 						end
		
		
		ps_result{frame_number}.peaks = speaks;
		ps_result{frame_number}.interval_sum = result.smoothed_signal;
		
		if look_for_target_frequency
			count=0;
			for ii=1:length(speaks) % construct all maxima
				fre=1/speaks{ii}.t;
				dist(ii)=abs(target_frequency-fre);
				if fre< minimum_allowed_frequency || fre > maximum_allowed_frequency
					count=count+1;
					allowednumber(count)=ii;
					allowedheights(count)=speaks{ii}.y;
				end
			end
% 			[minfredif,nearest_peak_number]=min(dist);
% 			fre=1/speaks{nearest_peak_number}.t;
			% is the frequency allowed?
			if count>0
% 			if fre< minimum_allowed_frequency || fre > maximum_allowed_frequency
				[highest_ps,best_number]=max(allowedheights);
				best_peak_number=allowednumber(best_number);
				
				ps_result{frame_number}.pitchstrength=speaks{best_peak_number}.y/1000;
				ps_result{frame_number}.dominant_frequency=1/speaks{best_peak_number}.t;
			else % no, nothing there
				ps_result{frame_number}.interval_sum = result.smoothed_signal;
				ps_result{frame_number}.peaks = [];
				ps_result{frame_number}.dominant_frequency=0;
				ps_result{frame_number}.pitchstrength=0;
			end % frequency allowance
		else % free search was already done!
			ps_result{frame_number}.dominant_frequency=final_dominant_frequency;
			ps_result{frame_number}.pitchstrength=pitchstrength;
		end % look for target frequency
	else % no peaks found
		ps_result{frame_number}.interval_sum = result.smoothed_signal;
		ps_result{frame_number}.peaks = [];
		ps_result{frame_number}.dominant_frequency=0;
		ps_result{frame_number}.pitchstrength=0;
	end
	
	
	% Peak Picker for FrequencyProfile
	p.dyn_thresh = options.dynamic_threshold_FP;
	p.smooth_sigma = options.smooth_sigma_FP;
	ps_result{frame_number}.peaks_frequency_sum = FPeakPicker(ps_result{frame_number}.frequency_sum, p);
	% 	ps_result{frame_number}.channel_center_fq = getcf(sai{frame_number});
	ps_result{frame_number}.channel_center_fq = getcf(sai{frame_number});
	
end
close(waithand);




