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

nr_frames=length(sai);

target_frequency=options.target_frequency;

% if only one frequency range is important, then find out, which
% channels are important and which not
nr_channels=getnrchannels(sai{1});

% find out about scaling:
maxval=-inf;
maxfreval=-inf;
maxsumval=-inf;

for ii=1:nr_frames
	maxval=max([maxval getmaximumvalue(sai{ii})]);
	maxsumval=max([maxsumval getscalesumme(sai{ii})]);
	maxfreval=max([maxfreval getscalefrequency(sai{ii})]);
end


for frame_number=1:nr_frames
	current_frame = sai{frame_number};
	frame_start_time(frame_number)=getcurrentframestarttime(current_frame);
	tip(frame_number)=gettimeintervalprofile(current_frame,options);
	freqp(frame_number)=getfrequencyprofile(current_frame);
    
%     figure(234324)
%     clf
%     plot(tip(frame_number));
end
frame_duration=frame_start_time(2)-frame_start_time(1);

% calculate the averaged tips
% the first frames are not average, since not long enough time has
% passed. After that, the relevant last frames are averaged
tip_time=options.tip_average_time;
% time for pitch to drop to 1/2 (6dB) --in seconds
% this means so much per frame
ps_decay_constant=1-log(2)/(tip_time/frame_duration);

start_frame=1;
histo=mute(tip(1));
% mache ein Histogramm für jede Frequenz mit allem Maxima:
nr_points=getnrpoints(sai{1});

waithand = waitbar(0,'Generating pitch strength');

for frame_number=start_frame:nr_frames
% for frame_number=nr_frames:nr_frames
	
	waitbar(frame_number/nr_frames, waithand);     
	
	current_frame = sai{frame_number};
	current_frame = setallmaxvalue(current_frame, maxval);
	current_frame = setscalesumme(current_frame, maxsumval);
	current_frame = setscalefrequency(current_frame, maxfreval);
	
	interval_sig =  tip(frame_number);
    % Normalisation
 	interval_sig =  interval_sig/nr_channels;
	
	% sum the interval sum to the floating average:
	histo=histo+interval_sig;
	% dynamic decrease of all pitch strengthes
	histo=histo*ps_decay_constant; 
% 
%         figure(234324)
%     clf
%     plot(histo);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Peak Picker for IntervalProfile
	opts.ps_options=options;
	opts.current_time=getcurrentframestarttime(current_frame);
	ti_result=find_pitches(histo,opts);
	ps_result{frame_number}.ti_result=ti_result;
    ps_result{frame_number}.ti_result.ti_profile=interval_sig;
    ps_result{frame_number}.ti_result.averaged_signal=histo;
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Peak Picker for FrequencyProfile
    frequency_sig=freqp(frame_number);
    % Normalisation
    frequency_sig=frequency_sig/getnrpoints(interval_sig);
    
 	ps_result{frame_number}.channel_center_fq = getcf(sai{frame_number});

    % Analyse the dualprofile
    options.nap=sai{end}; % just for the frequency information
    f_result= analyse_frequency_profile(frequency_sig,options);
	ps_result{frame_number}.f_result=f_result;

end

close(waithand);

return
