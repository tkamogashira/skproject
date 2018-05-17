% generating function for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% the old temporal integration module. Puts add every strobe point a copy
% of the past signal in the buffer
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function returnframes=gen_ti1992(nap,strobes,options)
% calculates the stablized image from the data given in options


returnframes=[];

% option, how long the whole auditory image is:
if isfield(options,'maxdelay')
	maxdelay=options.maxdelay;
else
	maxdelay=0.035;
end

% how fast the values decay by themself
if isfield(options,'buffer_memory_decay')
	buffer_memory_decay=options.buffer_memory_decay;
else
	buffer_memory_decay=0.03;
end

% how the values are weighted by their time before they are added in the
% buffer.
if isfield(options,'buffer_tilt_time')
	buffer_tilt_time=options.buffer_tilt_time;
else
	buffer_tilt_time=0.04; % 40 ms standart
end

% how often a current frame buffer is saved
if isfield(options,'frames_per_second')
	frames_per_second=options.frames_per_second;
else
	frames_per_second=100;
end

len=getlength(nap);
output_times=0:1/frames_per_second:len;
nr_output_times=length(output_times); % so many pictures in the end


% construct the starting SAI with zeros
sr=getsr(nap);
sampletime=1/sr;
nrdots_insai=round(options.maxdelay*sr);

const_memory_decay=power(0.5,1/(options.buffer_memory_decay*sr)); % the amount per sampletime
signal_start_time=getminimumtime(nap);



% helping variables to speed things up
nr_channels=getnrchannels(nap);
for ii=1:nr_channels
	if length(strobes{ii}.strobes) > 0
		next_strobe(ii)=strobes{ii}.strobes(1);    % the next strobe in line
	else
		next_strobe(ii)=inf; % no strobe
	end
	last_strobe(ii)=-inf;   % the last strobe in this channel
	current_strobe_nr(ii)=1;    % the current number of the strobe which is processed
	nr_active_strobes(ii)=0;    % the number of active strobes in memory
	strobe_adjust_phase(ii)=inf; % the next update of weights
	was_adjusted(ii)=0;
end
nr_maximal_strobes=20;
stropo_time=zeros(nr_channels,nr_maximal_strobes); % no active strobes in queue
copy_stropo_time=stropo_time;
stropo_weight=zeros(nr_channels,nr_maximal_strobes); % no active strobes in queue

maxst=0;
for ii=1:nr_channels    % make strobes faster
	maxstg=length(strobes{ii}.strobes);
	maxst=max(maxst,maxstg);
end
allstrobes=zeros(nr_channels,maxst);
for ii=1:nr_channels    % make strobes faster
	nr_str_total=length(strobes{ii}.strobes);
	allstrobes(ii,1:nr_str_total)=strobes{ii}.strobes;
	allstrobesval(ii,1:nr_str_total)=strobes{ii}.strobe_vals;
	nrstrobes(ii)=nr_str_total;
	%     allchannelallstrobes(ii)=allstrobes(ii,1:nr_str_total); % all the strobes in this channel
end

output_counter=1;
nr_dots=getnrpoints(nap);
current_time=signal_start_time;
times_per_ms=round(sr*0.002);
cfs=getcf(nap);
napvalues=getvalues(nap);
count=0;
tic;

saibuffer=zeros(nr_channels,nrdots_insai);
waithand=waitbar(0,'generating SAI');

% and go!
for bintime=1:nr_dots
	if mod(bintime,times_per_ms)==0
		waitbar(bintime/nr_dots);
	end
	current_time=current_time+sampletime;
	
	for channel_nr=1:nr_channels
% 	for channel_nr=25
		current_cf=cfs(channel_nr);
		nr_str_total=nrstrobes(channel_nr);
		% find out, if a new strobe arrived 
		this_strobe_time=next_strobe(channel_nr); % here is the next strobe
        nr_current_str=current_strobe_nr(channel_nr);
        channelallstrobes=allstrobes(channel_nr,1:nr_str_total); % all the strobes in this channel

		if current_time > this_strobe_time % if we are beyond the next strpbe

			% calculate the time of the next strobe
			if nr_current_str < nrstrobes(channel_nr)    % define the next strobe
				next_strobe(channel_nr) =channelallstrobes(nr_current_str + 1);
			else
				next_strobe(channel_nr)=inf; % if no more strobes we will never get here any more
			end
			nr_current_str=nr_current_str+1;
			current_strobe_nr(channel_nr)=nr_current_str;
			
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% copy the whole signal from the past in the buffer
			current_time_int=floor((current_time-signal_start_time)/sampletime);
			start_time_int=current_time_int-nrdots_insai+1;
			if start_time_int > 0 % if bejond 35 ms 
				% the signal, that we want to add to the buffer
				addsig=napvalues(channel_nr,start_time_int:current_time_int);
			else % not enough signal yet! Pat with zeros
				zerosig=zeros(1,-start_time_int+1);
				len=current_time_int; % copy this number
				start_time_int=1;
				addsigval=napvalues(channel_nr,start_time_int:len);
				addsig=[zerosig addsigval]; % append them
			end
			% now in addsig is the complete signal before the strobe	
			% that is tilted with time:
			
			dt=buffer_tilt_time*sr-nrdots_insai; % übrige Zeit, die links aus dem Bild rausgeht
			dnull=dt/nrdots_insai;
			ti=linspace(dnull,1,nrdots_insai);
			addsig=addsig.*ti;
			addsig=addsig(end:-1:1);

			% build in 
			saibuffer(channel_nr,:)=saibuffer(channel_nr,:)+addsig;
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			
			
		end
	end

	saibuffer=saibuffer*const_memory_decay;
	
	% output finished frames at the appropriate times
	if current_time >= output_times(output_counter)
		resframes{output_counter}=saibuffer;
		output_counter=output_counter+1;
		if output_counter >nr_output_times
			break; % no need to go on!
		end
	end
end

% translate the arrays from data to frames
nrfrms=length(resframes);
start_time=getminimumtime(nap);	% start time of first frame
if nrfrms>1
	interval=output_times(2)-output_times(1);
else
	interval=0; % doesnt matter...
end
maxval=-inf;
maxsumval=-inf;
maxfreval=-inf;
cfs=getcf(nap);

if nr_channels>1
	for ii=1:nrfrms
		cfr=frame(resframes{ii});
		maxv=getmaximumvalue(cfr);
		maxval=max([maxv maxval]);
		maxs=max(getsum(cfr));
		maxsumval=max([maxs maxsumval]);
		maxf=max(getfrequencysum(cfr));
		maxfreval=max([maxf maxfreval]);
	end
else
	maxfreval=1;
	maxsumval=1;
	maxval=max(resframes{nrfrms});
	minval=0;
end

for ii=1:nrfrms
	cfr=frame(resframes{ii});
	cfr=setsr(cfr,sr);
	cfr=setcurrentframenumber(cfr,ii);
	cfr=setcurrentframestarttime(cfr,start_time);
	cfr=setcf(cfr,cfs);
	start_time=start_time+interval;
	cfr=setscalesumme(cfr,maxsumval);
	cfr=setallmaxvalue(cfr,maxval);
	cfr=setallminvalue(cfr,0);
	cfr=setscalefrequency(cfr,maxfreval);
	returnframes{ii}=cfr;
end

close(waithand);