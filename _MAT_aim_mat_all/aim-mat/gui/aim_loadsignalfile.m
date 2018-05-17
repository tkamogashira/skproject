% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% load the signal file and all files, that are in this directory
% set the project variables accordingly.
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=aim_loadsignalfile(handles,signalwavename)

% load the signal file (we know, that it is there
sig=loadwavefile(signal,signalwavename);

% first save the original signal as a copy
savewave(sig,handles.info.originalwavename,0);


len=getlength(sig);
if len<0.04
	disp('Signal is too short (<40ms)! padding it with zeros automatically');
	sig=expand(sig,0.04,0)
end


handles.info.signal_loaded=1;	% it is now loaded!

if handles.autorun==0 % only, when not called with a data structure
	% we add these parameters to the parameter file
	handles.all_options.signal.signal_filename=handles.info.oldsignalwavename;
	handles.all_options.signal.start_time=0;
	handles.all_options.signal.duration=getlength(sig);
	handles.all_options.signal.samplerate=getsr(sig);
	
% 	% prevent user to choose too long singals, because they are too slow
% 	% usually we only want a part of the signal
% 	max_allowed_duration=0.2;
% 	if getlength(sig) > max_allowed_duration
% 		text{1}='The signal is longer then 200 ms';
% 		text{2}='So the model will run rather slowly.';
% 		current_start=0;
% 		current_duration=getlength(sig);
% 		allowed_duration=getlength(sig);
% 		[new_start_time,new_duration]=length_questionbox(current_start,current_duration,allowed_duration,text);
% 		if new_start_time~=0;
% 			handles.all_options.signal.start_time=new_start_time;
% 		end
% 		if new_duration~=getlength(sig);
% 			handles.all_options.signal.duration=new_duration;
% 		end		
% 	end
% 	
	
	handles.all_options.signal.original_start_time=0;
	handles.all_options.signal.original_duration=getlength(sig);
	handles.all_options.signal.original_samplerate=getsr(sig);
	
end

% save it to the data structure
name=handles.info.signalname;
aim_savefile(handles,sig,name,'signal','signal',handles.all_options.signal,handles.all_options)
handles.data.original_signal=sig;
handles.data.signal=sig;


if handles.autorun==0 % only, when not called with a data structure
	% if the samplerate is too high, sample it down per default
	max_allowed_sr=25000;
	if getsr(sig) > max_allowed_sr
		new_sr=sr_questionbox(getsr(sig));
		if new_sr~=getsr(sig);
			sig=changesr(sig,new_sr); % this does the resampling
			handles.all_options.signal.samplerate=new_sr;
			signalstruct.data=sig;
			handles.data.original_signal=sig;
			handles.data.signal=sig;
		end		
		
		% % 	ask user if he wants that hi sample rate
		% 	srneu=input('The samplerate of the specified signal \nis higher then 22050 Hz. \nPlease insert a smaller samperate \n(or return for keeping the old one): ');
		% 	if ~isempty(srneu)
		% 	end
	end
end

% the signal must not be changed at the moment
handles.info.calculate_signal=0;

% and save the signal in the new directory
savewave(sig,handles.info.signalwavename,0);



