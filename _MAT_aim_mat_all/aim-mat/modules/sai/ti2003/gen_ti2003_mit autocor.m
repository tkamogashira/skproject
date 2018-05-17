% generating function for 'aim-mat'
%function returnframes=gen_ti2003(nap,strobes,options)
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% time integration
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function returnframes=gen_ti2003(nap,strobes,options)
% calculates the stablized image from the data given in options


if isfield(options,'do_click_reduction');
	do_click_reduction=options.do_click_reduction;
	if do_click_reduction
		try
			load(options.click_reduction_sai);
		catch
			error('cant load file for click reduction. Generate it with ''generate_clicktrain_normal''');
		end
		% 	load click_frame;
	end
else
	do_click_reduction=0;
end

if isfield(options,'single_channel_do')
	single_channel_do=logical(options.single_channel_do);
else
	single_channel_do=logical(false);
end
if isfield(options,'single_channel_channel_nr')
	single_channel_channel_nr=options.single_channel_channel_nr;
else
	single_channel_channel_nr=0;
end
if isfield(options,'single_channel_time_step')
	single_channel_time_step=options.single_channel_time_step;
	graphic_times=single_channel_time_step:single_channel_time_step:getlength(nap);	% each ms
	next_graphic=graphic_times(1);
	current_graphic=1;
else
	next_graphic=[];
	current_graphic=0;
	graphic_times=[];
end


if isfield(options,'select_channel_center_frequency')
	% center frequency for the selection (off, if 0)
	select_channel_center_frequency=options.select_channel_center_frequency;
	if select_channel_center_frequency > 0
		select_certain_channels=1;
		% upper and lower bound of selection in octaves
		select_channel_frequency_above=options.select_channel_frequency_range_above;
		select_channel_frequency_below=options.select_channel_frequency_range_below;
		
		% calculate, which channels are wanted, and wich are not
		min_selected_frequency=select_channel_center_frequency/power(2,select_channel_frequency_below);
		max_selected_frequency=select_channel_center_frequency*power(2,select_channel_frequency_above);
		
		%if 1, then all are calculated, and selected are plotted in other color
		if options.select_channel_calculate_all==1; 
			select_certain_channels=0;
		end
	else
		select_certain_channels=0;
	end
else
	select_certain_channels=0;
end



%%%%%%%%%%%%%%%%%%%%%%%%
%%% init some local variables:

returnframes=[];	% the return frames
maxdelay=options.maxdelay;
% the weight of a strobe is determined by the time since the last strobe
% adjusted by the following constant: (decay from 100% to 0%)
% delay_time_strobe_weight_decay=options.delay_time_strobe_weight_decay;
len=getlength(nap);	% the length in seconds
fps=options.frames_per_second;
output_times=0:1/fps:len;
output_times=output_times+getminimumtime(nap);
nr_output_times=length(output_times); % so many pictures in the end
output_counter=1;
% construct the starting SAI with zeros
sr=getsr(nap);
sampletime=1/sr;
nrdots_insai=round(options.maxdelay*sr);
const_memory_decay=power(0.5,1/(options.buffer_memory_decay*sr)); % the amount per sampletime
signal_start_time=getminimumtime(nap);
nr_channels=getnrchannels(nap);

% calculate the initial strobe times in the past
for ii=1:nr_channels
	if length(strobes{ii}.strobes) > 0
		next_strobe(ii)=strobes{ii}.strobes(1);    % the next strobe in line
	else
		next_strobe(ii)=inf; % no strobe
	end
	last_strobe(ii)=-inf;   % the last strobe in this channel
	current_strobe_nr(ii)=1;    % the current number of the strobe which is processed
	nr_active_strobes(ii)=0;    % the number of active strobes in memory
	last_strobe(ii)=-inf;	% the last strobe was long ago
	strobe_adjust_phase(ii)=inf; % the next update of weights
	was_adjusted(ii)=0;
end

nr_maximal_strobes=100;	% there should never be more then 100 strobe processes active at the same time
% remember all strobe process times
stropo_time=zeros(nr_channels,nr_maximal_strobes); % no active strobes in queue
% remember the current weights of all strobes:
stropo_weight=zeros(nr_channels,nr_maximal_strobes); % no active strobes in queue
% remember the original weights of all strobes:
stropo_org_weight=zeros(nr_channels,nr_maximal_strobes); % the weight of each strobe at generation point

% calculate the inital strobe settings in one variable (acceleration)
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
end

nr_dots=getnrpoints(nap);	% so many points in time must be calculated
times_per_ms=round(sr*0.005); % how often the bar should be updated
cfs=getcf(nap);	% the center frequencies
napvalues=getvalues(nap);	% the values of the neural activity pattern

% copy some variables from the struct to real variables (speed!!)
weight_threshold=options.weight_threshold;
strobe_weight_alpha=options.strobe_weight_alpha;
delay_weight_change=options.delay_weight_change;
% criterion=options.criterion;
do_adjust_weights=options.do_adjust_weights;
do_normalize=options.do_normalize;	% if weights are do_normalized
% donapheight=options.do_times_nap_height;	% if the strobe height has an influence

% each strobe induces strobes in neighboring channels in this
% vicinity:
if isfield(options,'erb_frequency_integration')
	erb_strobe_width=options.erb_frequency_integration;
	erbdensity=erbdensity(nap);
	nrintegrate=round(erbdensity*erb_strobe_width);
	do_interchannel_interaction=1;
else
	do_interchannel_interaction=0;
	nrintegrate=0;
end
% if strcmp(criterion,'integrate_erbs')
% 	% define the integration area for each channel in frequency and time
% 	erbsearchwidth=options.erb_frequency_integration;
% 	erbdensity=erbdensity(nap);
% 	nrintegrate=round(erbdensity*erbsearchwidth);
% 	
% 	for ii=1:nr_channels
% 		% the frequency window
% 		a=ii+(-nrintegrate:nrintegrate);
% 		a(find(a<0))=0;
% 		a(find(a>nr_channels))=0;
% 		a(find(a==ii))=0; % dont search in the identical channel
% 		
% 		neighboring_channels(ii,:)=a;
% 		
% 		% the time window
% 		current_cf=cfs(ii);
% 		timewindow_start(ii)=-1/current_cf;
% 		timewindow_stop(ii)=1/current_cf;
% 	end
% end
% 

% Beschleunigung der Berechnung durch vorziehen der Schleife:
% der Einfluß der Zeit: je mehr Strobes da sind,
% umso unwichtiger werden die älteren:
% adapt the weights of all the old strobes
weighfactor=ones(nr_maximal_strobes);
if do_adjust_weights	%only if wanted
	for ii=1:nr_maximal_strobes
		for jj=1:ii
			wfactor=power(1/(ii-jj+1),strobe_weight_alpha);
			weighfactor(ii,jj)=wfactor;
		end
	end
end


if single_channel_do==1
	oldfigure=gcf;
	onechannelfigure=figure(1954211404);	% some strange number that should not be an existing figure
	set(onechannelfigure,'name','Dynamic single channel');
	set(onechannelfigure,'numbertitle','off');
end

saibuffer=zeros(nr_channels,nrdots_insai);
if nr_channels>1
	waithand=waitbar(0,'generating SAI');
end




% calculate the repetition rate of the signal by the strobes alone
strobe_window=0.025;
current_time=0;
real_strobes=zeros(nr_channels,100);
acs=zeros(nr_channels,round(sr*strobe_window));
stepss=round(0.001*sr); % one result per ms
nr_do=round(nr_dots/stepss);
saveacs=zeros(nr_do,round(sr*strobe_window));
current_estimated_pitch=zeros(1,nr_do);
count=1;
for ii=1:stepss:nr_dots
	for jj=1:nr_channels
		current_time=ii/sr;
		strobes=allstrobes(jj,:); % all strobes here
		% find the strobes in the last 50 ms:
		selected_strobes=find(strobes > current_time-strobe_window & strobes <= current_time & strobes > 0);
		nr_str=length(selected_strobes);
		if nr_str>2
 			rs=strobes(selected_strobes);
% 			real_strobes(jj,1:nr_str)=strobes(selected_strobes);
% 			real_strobes(jj,nr_str+1:end)=0;
			autoc=myautocorr(rs,sr,strobe_window); % my own autorcor w/o fft
			acs(jj,:)=autoc;
		end
	end
	% now sum all autocorrelations togehter
	sumautoc=sum(acs);
	saveacs(count,:)=sumautoc;
	% find the maximum in this summarized correlation
	[val,max_peak]=max(sumautoc);
	current_estimated_pitch(count)=max_peak;
	count=count+1;
end

% figure(11);
% plot(current_estimated_pitch);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start of big loop
current_time=signal_start_time;	% start time for calculation
for bintime=1:nr_dots
	if nr_channels>1
		if mod(bintime,times_per_ms)==0
			waitbar(bintime/nr_dots);
		end
	end
	
	current_time=current_time+sampletime;

	for channel_nr=1:nr_channels
		% 	for channel_nr=25
		current_cf=cfs(channel_nr);
		
		if select_certain_channels
			if current_cf < min_selected_frequency || current_cf > max_selected_frequency
				continue;	% outside wanted range, no need to calculate!
			end
		end
		
		nr_str_total=nrstrobes(channel_nr);
		channelallstrobes=allstrobes(channel_nr,1:nr_str_total); % all the strobes in this channel
		nr_active_str=nr_active_strobes(channel_nr);
		nr_current_str=current_strobe_nr(channel_nr);
		
		% find out, if a new strobe arrived 
		this_strobe_time=next_strobe(channel_nr); % here is the next strobe
		if current_time > this_strobe_time % if we are beyond the next strpbe
			
			if nr_current_str < nrstrobes(channel_nr)    % define the next strobe
				next_strobe(channel_nr) =channelallstrobes(nr_current_str + 1);
			else
				next_strobe(channel_nr)=inf; % if no more strobes we will never get here any more
			end
			nr_current_str=nr_current_str+1;
			
			% 			if strcmp(criterion,'integrate_erbs')
			% 				% find out, which weight this strobe has by integration over
			% 				% time and frequency of the neighbouring strobes
			% 				t1=timewindow_start(channel_nr)+current_time;
			% 				t2=timewindow_stop(channel_nr)+current_time;
			% 				strobeweight=zeros(nr_channels,1);
			% 				normalizer=0;
			% 				for chn=neighboring_channels(channel_nr,:);
			% 					if chn>0
			% 						nrstr=nrstrobes(chn);
			% 						chstr=allstrobes(chn,1:nrstr); % all strobes in this channel
			% 						neistrobes=find(chstr>t1 & chstr<t2); % these are all strobes in this channel in the window
			% 						nr=length(neistrobes); % so many
			% 						dist=abs(channel_nr-chn);
			% 						weight=(1+nrintegrate-dist)/nrintegrate;	% its influence depends on the distance
			% 						strobeweight(chn)=nr*weight;
			% 						normalizer=normalizer+weight;
			% 					end
			% 				end
			% 				new_strobe_weight=sum(strobeweight)/normalizer;
			% 			end
			
			nr_active_str=nr_active_str+1;
			stropo_time(channel_nr,nr_active_str)=this_strobe_time;
			% calculate the weight from the time, the last strobe was away: 
			new_weight=(this_strobe_time-last_strobe(channel_nr))*current_cf/10;
			new_weight=min(1,new_weight);
			stropo_org_weight(channel_nr,nr_active_str)=new_weight;
			
			% the new strobe is there, but it is not effective jet! It will
			% become effective after:
			phasetime=current_time+1/current_cf*delay_weight_change;
			strobe_adjust_phase(channel_nr)=phasetime;
			was_adjusted(channel_nr)=0;

			% the very last thing:  remember time of last strobe
			last_strobe(channel_nr)=this_strobe_time;   
			
		end % a new strobe is in the line, but its not active yet!
		
		
		% is it time to make a new strobe active and adjust weights?
		logi1=logical(current_time >= strobe_adjust_phase(channel_nr));
		logi2=~logical(was_adjusted(channel_nr)); % ugly, but accelerated
		if logi1 && logi2
			
			% jetzt ist Zeit zum Adjusten, erst mal alle auf das
			% Orginalgewicht (Zahl der Zyclen)
			
			% 			% jetzt der Einfluß der Zeit: je mehr Strobes da sind,
			% 			% umso unwichtiger werden die älteren:
			% 			% adapt the weights of all the old strobes
			% 			weighfactor=ones(length(nr_active_str),1);
			%  			if do_adjust_weights	%only if wanted
			% 				for ii=1:nr_active_str
			% 					wfactor=power(1/(nr_active_str-ii+1),strobe_weight_alpha);
			% 					weighfactor(ii)=wfactor;
			% 				end
			% 			else
			% 				stropo_weight=stropo_org_weight;
			% 			end
			
			if do_adjust_weights	%only if wanted
				if nr_active_str>0
					wfactor=weighfactor(nr_active_str,:);
				end
			else
				wfactor=ones(1,nr_active_str);
			end
			
			
			% und dann alle Strobes in diesem Kanal auf eins
			% normieren, damit die Summe über alle Aktivität in jedem
			% Channel immer gleich der Summe im Nap ist.
			%  normalise them to 1
			if do_normalize==1
				if nr_active_str>1
					sumweight=0;
					for ii=1:nr_active_str
						sumweight=sumweight+stropo_org_weight(channel_nr,ii)*wfactor(ii);
					end
					for ii=1:nr_active_str
						tmp=stropo_org_weight(channel_nr,ii)*wfactor(ii);
						tmp=tmp/sumweight;
						stropo_weight(channel_nr,ii)=tmp;
					end
				end
			else
				stropo_weight=stropo_org_weight;
			end % do_normalize
			was_adjusted(channel_nr)=1;
		end % strobe has arrived
		
		% delete old strobe processes
		nr_deleted=0;
		for ii=1:nr_active_str-nr_deleted
			time_strobe=stropo_time(channel_nr,ii-nr_deleted);
			delay=current_time-time_strobe;
			weight=stropo_weight(channel_nr,ii-nr_deleted);

			cur_time_ms=round(current_time*1000);
			if cur_time_ms>0
				maxdelay=current_estimated_pitch(cur_time_ms)/sr;
			else
				maxdelay=0.034;
			end
			maxdelay=maxdelay-0.001;
 			if delay > maxdelay || weight < weight_threshold   % forget this strobe
			
			
% 			if delay > maxdelay || weight < weight_threshold   % forget this strobe
				stropo_time(channel_nr,ii-nr_deleted:end-1)=stropo_time(channel_nr,ii-nr_deleted+1:end);
				stropo_weight(channel_nr,ii-nr_deleted:end-1)=stropo_weight(channel_nr,ii-nr_deleted+1:end);
				stropo_org_weight(channel_nr,ii-nr_deleted:end-1)=stropo_org_weight(channel_nr,ii-nr_deleted+1:end);
				nr_deleted=nr_deleted+1;
			end		
		end
		nr_active_str=nr_active_str-nr_deleted;
		
		
		% process all strobes
		for ii=1:nr_active_str
			time_strobe=stropo_time(channel_nr,ii);
			delay=current_time-time_strobe;
			%  			if delay >= sampletime
			if delay >= 0.0001
				%   			if delay > 0.0
				current_time_int=floor((current_time-signal_start_time)/sampletime);
				delayint=round(delay/sampletime);
				weight=stropo_weight(channel_nr,ii);
				% 				if donapheight==1 % if the strobe heigt has influence
				% 					weight=weight*allstrobesval(channel_nr,ii);
				% 				end			
				oldval=saibuffer(channel_nr,delayint);
				newval=oldval+weight*napvalues(channel_nr,current_time_int);
				saibuffer(channel_nr,delayint)=newval;        % put the new value in the buffer at the correct position
				
				% interchannel interaction
				if do_interchannel_interaction
					for jj=channel_nr-nrintegrate:channel_nr+nrintegrate
						if jj==ii || jj<1 || jj>nr_channels
							continue
						end
						oldval=saibuffer(jj,delayint);
						adjacent_weight=weight*(1-abs(jj-channel_nr)/(nrintegrate+1));
						newval=oldval+adjacent_weight*napvalues(jj,current_time_int);
						saibuffer(jj,delayint)=newval;        % put the new value in the buffer at the correct position
					end
				end
				
			end
		end
		
		% save for the next run
		current_strobe_nr(channel_nr)=nr_current_str; % strobe counter
		nr_active_strobes(channel_nr)=nr_active_str;  % active strobe counter
		
		% special graphics, when only one channel: display signal,
		% threshold and strobe weights 
		if single_channel_do && channel_nr==single_channel_channel_nr
			if current_time>=next_graphic
				if current_graphic<length(graphic_times)
					next_graphic=graphic_times(current_graphic+1);
					current_graphic=current_graphic+1;
				end
				extraplot(onechannelfigure,napvalues,sr,current_time,maxdelay,options,bintime,nr_active_str,saibuffer,stropo_time,stropo_weight,single_channel_channel_nr)
			end
		end
		
	end % nr channels
	
	% decay of the whole buffer:
	saibuffer=saibuffer*const_memory_decay;
	
	% output finished frames at the appropriate times
	if current_time >= output_times(output_counter)
		if do_click_reduction
			reduced_saibuffer=saibuffer;
			for channel_nr=1:nr_channels
				org_channel=saibuffer(channel_nr,:);
				org_sig=signal(org_channel);
				org_sig=setsr(org_sig,sr);
				
				clickvals_sig=getsinglechannel(click_frame,channel_nr);
				
				relevant_click_time=0.035;
				clicksig=getpart(clickvals_sig,0,relevant_click_time);
				% 				clicksig=changesr(clicksig,sr);
				org_sig_part=getpart(org_sig,0,relevant_click_time);
				maxval=max(org_sig);
				clicksig=scaletomaxvalue(clicksig,maxval);
				new_sig=org_sig-clicksig;
				new_sig=halfwayrectify(new_sig);
				
				grafix=0;
				if grafix==1
					figure(324234)
					clf
					hold on
					plot(clicksig,'m');
					plot(org_sig,'b');
					plot(new_sig,'r');
				end
				newvals=getvalues(new_sig);
				reduced_saibuffer(channel_nr,:)=newvals';
			end
			resframes{output_counter}=reduced_saibuffer;
		else
			resframes{output_counter}=saibuffer;
		end
		output_counter=output_counter+1;
		if output_counter >nr_output_times
			break; % no need to go on!
		end
		
	end
end % time loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if single_channel_do==1
	figure(oldfigure);
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
	maxval=1;
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

if nr_channels>1
	close(waithand);
end



% function for one channel: Plot some nice graphic
function extraplot(onechannelfigure,napvalues,sr,current_time,maxdelay,options,bintime,nr_active_str,saibuffer,stropo_time,stropo_weight,channel_nr)

persistent maxamp;	% how big the biggest amplitude was so far
if isempty(maxamp)
	maxamp=0;
end
figure(onechannelfigure);
subplot(2,1,1); % the signal, threshold and strobes:
cla
single_channel= signal(napvalues(channel_nr,:),sr);
maxval=max(single_channel);
siglen=getlength(single_channel);
threshold=getsinglechannel(options.thresholds,channel_nr);
if current_time < maxdelay
	single_channel=getpart(single_channel,0,maxdelay);
	threshold=getpart(threshold,0,maxdelay);
else
	% 	try
	single_channel=getpart(single_channel,current_time-maxdelay,current_time);
	% 	catch
	% 		a=0;
	% 	end
	threshold=getpart(threshold,current_time-maxdelay,current_time);
end
plot(single_channel,'-');hold on
ax=axis;
ax(4)=maxval*1.3;
axis(ax);
line([time2bin(single_channel,current_time) time2bin(single_channel,current_time)],[0 1],'Color','red');
title('nap, threshold and strobes');
thresholdvals=getvalues(threshold);
if current_time<getlength(threshold)
	plotthtesbins=bintime;
else
	plotthtesbins=getnrpoints(threshold);
end
plot(1:plotthtesbins,thresholdvals(1:plotthtesbins),'.-g','MarkerSize',1);
for ii=1:nr_active_str
	time_strobe=stropo_time(channel_nr,ii);
	weight=stropo_weight(channel_nr,ii);
	x=time2bin(single_channel,time_strobe);
	y=gettimevalue(single_channel,time_strobe);
	gc=plot(x,y,'.r');
	suze=log(2000*weight)*5;
	suze=max(suze,5);
	set(gc,'MarkerSize',suze);
	wei=sprintf('%2.0f',weight*100);
	text(x,y,wei,'HorizontalAlignment','center','FontSize',8);
end


subplot(2,1,2);	% the saibuffer so far:
buffer=signal(saibuffer(channel_nr,:),sr);
buffer=reverse(buffer);
maximum_time_interval=getmaximumtime(buffer);
minimum_time_interval=getminimumtime(buffer);
nrx=getnrpoints(buffer);
plot(buffer);

if max(buffer)>maxamp
	maxamp=max(buffer);
end
set(gca,'Ylim',[-0.00001 maxamp*1.1]);

nr_labels=8;
tix=1:(nrx-1)/nr_labels:nrx;
xstep=(maximum_time_interval-minimum_time_interval)*1000/(nr_labels);   %works from -35 to 5
ti=([minimum_time_interval*1000:xstep:maximum_time_interval*1000+1]);
ti=ti(end:-1:1);
ti=round(ti*10)/10;
set(gca,'XScale','linear')
set(gca,'XTick',tix);
set(gca,'XTickLabel',ti);
xlabel('delay (ms)');
title('buffer');

drawnow;
return
