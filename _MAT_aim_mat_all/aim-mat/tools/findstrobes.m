% tool for aim
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function [strobe_points,threshold]=adaptivthreshold(sig,options)


sr=getsr(sig);
newsig=sig;
newsig=setname(newsig,sprintf('adaptive threshold of %s',getname(sig)));
threshold=sig;
tresval=getvalues(sig);

% for speed reasons (matlab cant accelerate classes) all signals are
% passed as their values
sigvals=getvalues(sig);
options.sr=sr;

switch options.strobe_criterion
	case 'parabola'
		[strobe_points,tresval]=do_parabola(sigvals,options);
	case 'threshold'
	case 'peak'
		[strobe_points,tresval]=do_peak(sigvals,options);
	case 'temporal_shadow_plus'
		[strobe_points,tresval]=do_peakshadowplus(sigvals,options);
	case 'local_maximum'
		[strobe_points,tresval]=do_local_maximum(sigvals,options);
    case 'constrained_local_maximum'
		[strobe_points,tresval]=do_constrained_local_maximum(sigvals,options);
	case 'temporal_shadow'
		[strobe_points,tresval]=do_peakshadow(sigvals,options);
	case 'delta_gamma'
	case 'adaptive'
		[strobe_points,tresval]=do_adaptive(sigvals,options);
	case 'bunt'
		[strobe_points,tresval]=do_bunt(sigvals,options);
	otherwise
		error(sprintf('findstrobes: Sorry, I dont know the strobe criterium %s',options.strobe_criterion));
		
end

strobe_points=bin2time(sig,strobe_points);

threshold=setvalues(threshold,tresval);

return



function [strobe_points,tresval]=do_parabola(sigvals,options)
% the threshold is calculated relativ to the hight of the last strobe
% the sample rate is needed for the calculation of the next thresholds
% for time_constant_alpha this is a linear decreasing function that goes
% from the maximum value to 0 in the time_constant

current_threshold=0;
sr=options.sr;
last_strobe=-inf;

tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1); % makes things faster

%when the last strobe occured
last_strobe_time=-inf;
last_threshold_value=0;
last_val=sigvals(1);

% copy options to save time
h=options.parabel_heigth;
wnull=options.parabel_width_in_cycles*1/options.current_cf;
w_variabel=wnull;

strobe_decay_time=options.strobe_decay_time;

counter=1;
for ii=2:nr-1
	current_val=sigvals(ii);
	current_time=ii/sr;
	next_val=sigvals(ii+1);
	
	if current_val>=current_threshold  % above threshold -> criterium for strobe
		current_threshold=current_val;
		if current_val > last_val && current_val > next_val  % only strobe on local maxima
			% take this one as a new one
			strobe_points(counter)=ii;
			strobe_time(counter)=ii/sr;
			counter=counter+1;	% strobecounter
			
			last_strobe_time=ii/sr; % anyhow, its a candidate
			last_threshold_value=current_threshold;
			a=4*(1-h)/(wnull*wnull);
			b=-wnull/2;
			w_variabel=wnull-(current_threshold-2*a*b)/(2*a);
		end
	end
	tresval(ii)=current_threshold;
	
	time_since_last_strobe=current_time-last_strobe_time;
	if time_since_last_strobe > w_variabel % linear falling threshold
		const_decay=last_threshold_value/sr/strobe_decay_time;
		current_threshold=current_threshold-const_decay;
		current_threshold=max(0,current_threshold);
	else    % parabel for the first time y=a(x+b)^2+c
		a=4*(1-h)/(wnull*wnull);
		b=-wnull/2;
		c=h;
		factor=a*(time_since_last_strobe + b) ^2+c;
		current_threshold=last_threshold_value*factor;
	end    
	
	current_threshold=max(0,current_threshold);     % cant be smaller then 0
	last_val=current_val;
end
% give back only the strobes, that really occured:
if counter>1
	strobe_points=strobe_points(1:counter-1);
else
	strobe_points=[];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval]=do_peak(sigvals,options)
% finds every single local maximum
sr=options.sr;
tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
sig=signal(sigvals);
sig=setsr(sig,sr);
[t,h]=getlocalmaxima(sig);
strobe_points=t*sr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval]=do_peakshadow(sigvals,options)
% finds every single peak and starts from that an falling threshold

current_threshold=0;last_threshold_value=0;last_strobe=-inf;counter=1;
sr=options.sr;
tresval=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1);
strobe_decay_time=options.strobe_decay_time;
for ii=2:nr-1
	current_val=sigvals(ii);
	current_time=ii/sr;
	if current_val>current_threshold
		if sigvals(ii) > sigvals(ii-1) && sigvals(ii) > sigvals(ii+1)
			new_val=current_val-current_threshold;
			current_threshold=current_val;
			strobe_points(counter)=ii;
			counter=counter+1;
			last_strobe=ii;
			last_threshold_value=current_threshold;
		end
	end
	const_decay=last_threshold_value/sr/strobe_decay_time;
	current_threshold=current_threshold-const_decay;
	current_threshold=max(0,current_threshold);
	tresval(ii)=current_threshold;
end
% give back only the strobes, that really occured:
strobe_points=strobe_points(1:counter);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval]=do_peakshadowplus(sigvals,options)
% finds each local maximum. The next peak must be further away then
% strobe_lag. But after timeout a strobe must occure

strobe_lag=options.strobe_lag;
timeout=options.timeout;

current_threshold=0;
sr=options.sr;
tresval=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1);
strobe_decay_time=options.strobe_decay_time;
last_strobe=-inf;last_strobe_time=-inf;
counter=1;
last_threshold_value=0;

for ii=2:nr-1
	current_val=sigvals(ii);
	current_time=ii/sr;
	
	if current_val>current_threshold
		if sigvals(ii) > sigvals(ii-1) && sigvals(ii) > sigvals(ii+1)
			if current_time > last_strobe_time+strobe_lag || ... % not in these 5 ms
				current_time > last_strobe_time + timeout  % but after 10 ms again
				new_val=current_val-current_threshold;
				current_threshold=current_val;
				strobe_points(counter)=ii;
				counter=counter+1;
				last_strobe_time=ii/sr;
				last_strobe=ii;
				last_threshold_value=current_threshold;
			end
		end
	end
	const_decay=last_threshold_value/sr/strobe_decay_time;
	current_threshold=current_threshold-const_decay;
	current_threshold=max(0,current_threshold);
	tresval(ii)=current_threshold;
end
% give back only the strobes, that really occured:
strobe_points=strobe_points(1:counter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval]=do_constrained_local_maximum(sigvals,options)
% finds each local maximum. The next peak must be further away then
% strobe_lag. But after timeout a strobe must occur. This version has
% the added constraint that the timeout and decay constant are calculated
% on a per-channel basis.


% set strobe_lag to the rise time of the filter in this channel
% For now, this assumes a gammatone filterbank with standard parameters.
% Todo: update this.
n=4; b=1.019; %! hard-coded - fix!!
fc=options.current_cf;
strobe_lag=(n-1)./(2.*pi.*b.*(24.7+0.108.*fc));% value in seconds

% The decay time is set according to the channel's centre frequency
strobe_decay_time=1/options.current_cf; % value in seconds

current_threshold=0;
sr=options.sr;
tresval=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1);

% last_strobe=-inf;
last_strobe_time=-inf;
counter=1;
last_threshold_value=0;

for ii=2:nr-1
	current_val=sigvals(ii);
	current_time=ii/sr;
	if current_val>current_threshold
		if sigvals(ii) > sigvals(ii-1) && sigvals(ii) > sigvals(ii+1)
			current_threshold=current_val;
			if current_time > last_strobe_time+strobe_lag || ... % not in these 5 ms
					current_time > last_strobe_time + timeout  % but after 10 ms again
				strobe_points(counter)=ii;
				counter=counter+1;
				last_strobe_time=ii/sr;
% 				last_strobe=ii;
			end
		end
		last_threshold_value=current_threshold;
	end
	const_decay=last_threshold_value/sr/strobe_decay_time;
	current_threshold=current_threshold-const_decay;
	current_threshold=max(0,current_threshold);
	tresval(ii)=current_threshold;
end
% give back only the strobes, that really occured:
strobe_points=strobe_points(1:counter);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval]=do_local_maximum(sigvals,options)
% finds each local maximum. The next peak must be further away then
% strobe_lag. But after timeout a strobe must occure

unit=options.unit;

if strcmp(unit,'cycles')
	strobe_lag=1/options.current_cf*options.strobe_lag;
	timeout=1/options.current_cf*options.timeout;
elseif strcmp(unit,'sec')
	strobe_lag=options.strobe_lag;
	timeout=options.timeout;
elseif strcmp(unit,'ms')
	strobe_lag=options.strobe_lag/1000;
	timeout=options.timeout/1000;
else
	error(sprintf('findstobes: dont know unit %s',unit));
end

current_threshold=0;
sr=options.sr;
tresval=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1);
strobe_decay_time=options.strobe_decay_time;
% last_strobe=-inf;
last_strobe_time=-inf;
counter=1;
last_threshold_value=0;

if options.current_cf>300
	a=0;
end
for ii=2:nr-1
	current_val=sigvals(ii);
	current_time=ii/sr;
	if current_val>current_threshold
		if sigvals(ii) > sigvals(ii-1) && sigvals(ii) > sigvals(ii+1)
			current_threshold=current_val;
			if current_time > last_strobe_time+strobe_lag || ... % not in these 5 ms
					current_time > last_strobe_time + timeout  % but after 10 ms again
				strobe_points(counter)=ii;
				counter=counter+1;
				last_strobe_time=ii/sr;
% 				last_strobe=ii;
			end
		end
		last_threshold_value=current_threshold;
	end
	const_decay=last_threshold_value/sr/strobe_decay_time;
	current_threshold=current_threshold-const_decay;
	current_threshold=max(0,current_threshold);
	tresval(ii)=current_threshold;
end
% give back only the strobes, that really occured:
strobe_points=strobe_points(1:counter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval]=do_adaptive(sigvals,options)
% the threshold is calculated relativ to the hight of the last strobe
% the sample rate is needed for the calculation of the next thresholds
% for time_constant_alpha this is a linear decreasing function that goes
% from the maximum value to 0 in the time_constant

current_threshold=0;
sr=options.sr;
last_strobe=-inf;

tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1);

%when the last strobe occured
% last_strobe=-inf;
last_threshold_value=0;

% copy options to save time
strobe_decay_time=options.strobe_decay_time;

bunt=0.5;

% decay_time=options.strobe_decay_time;
% threshold_decay_constant=power(0.5,1./(options.strobe_decay_time*sr));

slope_coefficient=options.slope_coefficient;
slope_coefficient=0.0005;
minoffset=0.2;

threshold_decay_offset=-1/(options.strobe_decay_time*sr);
default_threshold_decay_offset=threshold_decay_offset;

counter=1;
for ii=1:nr
	current_val=sigvals(ii);
	current_time=ii/sr;
	
	if current_val>current_threshold
		new_val=current_val-current_threshold;
		current_threshold=current_val;
		strobe_points(counter)=ii;
		counter=counter+1;
		time_offset=ii-last_strobe;	% time since last strobe
		last_strobe=ii;
		
		amplitude_offset=current_threshold-last_threshold_value;
		
		last_threshold_value=current_threshold;
		
		current_bunt=0;
		% 		if amplitude_offset>0
		% 			current_bunt=amplitude_offset/1;
		% 		else
		% 			current_bunt=0;
		% 		end			
		current_threshold=current_threshold+current_bunt+minoffset;
		
		offset=amplitude_offset/time_offset*slope_coefficient;
		
		threshold_decay_offset=threshold_decay_offset+offset;
		% 		threshold_decay_constant=power(0.5,1./(decay_time*sr));
	else
		new_val=0;
	end
	tresval(ii)=current_threshold;
	time_since_last_strobe=(ii-last_strobe)/sr;
	
	
	% 	current_threshold=current_threshold*threshold_decay_constant;
	current_threshold=current_threshold+threshold_decay_offset;
	current_threshold=max(current_threshold,0);
	
	if time_since_last_strobe>0.035
		current_threshold=0;
		threshold_decay_offset=default_threshold_decay_offset;
	end
	
	newvals(ii)=new_val;
end
% give back only the strobes, that really occured:
strobe_points=strobe_points(1:counter);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% BUNT
function [strobe_points,tresval]=do_bunt(sigvals,options)
% the bunt is relative to the last peak hight

current_threshold=0;
sr=options.sr;
last_strobe=-inf;

tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(1000,1);

%when the last strobe occured
last_strobe_time=-inf;
last_threshold_value=0;
% last_was_depressed_time=-inf;	% time, when last strobe was thown out

% copy options to save time
strobe_decay_time=options.strobe_decay_time;

% wait that many cycles to confirm a strobe
wait_time=options.wait_cycles/options.current_cf;

% if waited for too long, then strobe anyhow after some passed candidates:
wait_timeout=options.wait_timeout_ms/1000;


bunt_height=options.bunt;

strobe_decay_time=options.strobe_decay_time;
last_val=sigvals(1);

counter=1;
for ii=2:nr-1
	current_val=sigvals(ii);
	next_val=sigvals(ii+1);
	current_time=ii/sr;
	if current_val>=current_threshold  % above threshold -> criterium for strobe
		current_threshold=current_val;
		if current_val > last_val && current_val > next_val  % only strobe on local maxima
			
			% so far its a candidate, but is it a real strobe?
			% look if there was a strobe in the past, that is deleted
 			if (current_time-last_strobe_time<wait_time && counter>1 )
				% if its too long in the past, fire anyway
				timediff=current_time-last_strobe_time;
				prob=f2f(timediff,0,wait_timeout,0,1);
				
% 				if timediff>wait_timeout %&& current_time-last_was_depressed_time<wait_timeout
 				if prob>rand(1);
					is_valid=1;	
				else % this one was not a good one, 
					counter=counter-1;	% delete the last one
% 					last_was_depressed_time=current_time;
					is_valid=0;
				end
			else
 				is_valid=1;
			end

			% take this one as a new one
			strobe_points(counter)=ii;
			strobe_time(counter)=ii/sr;
			counter=counter+1;	% strobecounter
			
			% increase the threshold by an amount
			current_threshold=current_threshold*bunt_height;	%increase threshold
			last_threshold_value=current_threshold;
% 			if is_valid==1
				last_strobe_time=ii/sr; % anyhow, its a candidate
% 			end				
			
			
		end
	end
	tresval(ii)=current_threshold;
	
	const_decay=last_threshold_value/sr/strobe_decay_time;
	current_threshold=current_threshold-const_decay;
	
	current_threshold=max(current_threshold,0);
	last_val=current_val;
end
% give back only the strobes, that really occured:
strobe_points=strobe_points(1:counter);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% BUNT
% function [strobe_points,tresval]=do_bunt(sigvals,options)
% % the bunt is relative to the last peak hight
% 
% current_threshold=0;
% sr=options.sr;
% last_strobe=-inf;
% 
% tresval=zeros(size(sigvals));
% newvals=zeros(size(sigvals));
% nr=length(sigvals);
% strobe_points=zeros(100,1);
% 
% %when the last strobe occured
% last_strobe_time=-inf;
% last_threshold_value=0;
% 
% % copy options to save time
% strobe_decay_time=options.strobe_decay_time;
% 
% % wait that many cycles to confirm a strobe
% wait_time=options.wait_cycles/options.current_cf;
% 
% % if waited for too long, then strobe anyhow after some passed candidates:
% wait_candidate_max=options.nr_strobe_candidates;
% current_jumped_candidates=1;
% 
% 
% bunt=options.bunt;
% 
% strobe_decay_time=options.strobe_decay_time;
% last_val=sigvals(1);
% 
% counter=1;
% for ii=2:nr-1
% 	current_val=sigvals(ii);
% 	next_val=sigvals(ii+1);
% 	current_time=ii/sr;
% 	if current_val>=current_threshold  % above threshold -> criterium for strobe
% 		current_threshold=current_val;
% 		if current_val > last_val && current_val > next_val  % only strobe on local maxima
% 
% 			% so far its a candidate, but is it a real strobe?
% 			% look if there was a strobe in the past, that is deleted
% 			if (counter>1 && current_time-strobe_time(counter-1)<wait_time) %&& current_threshold >last_threshold_value
% 				% if its too long in the past, fire anyway
% 				if current_jumped_candidates > wait_candidate_max	
% 					current_jumped_candidates=1;	% reset counter
% 				else
% 					current_jumped_candidates=current_jumped_candidates+1;
% 					counter=counter-1;	% delete the last one
% 				end
% 			else
% 				current_jumped_candidates=1;
% 			end				
% 			
% 				
% 			% take this one as a new one
% 			strobe_points(counter)=ii;
% 			strobe_time(counter)=ii/sr;
% 			counter=counter+1;	% strobecounter
% 			current_threshold=current_threshold*options.bunt;	%increase threshold
% 			
% 			last_strobe_time=ii/sr; % anyhow, its a candidate
% 			last_threshold_value=current_threshold;
% 			
% 		end
% 	end
% 	tresval(ii)=current_threshold;
% 	
% 	const_decay=last_threshold_value/sr/strobe_decay_time;
% 	current_threshold=current_threshold-const_decay;
% 	
% 	current_threshold=max(current_threshold,0);
% 	last_val=current_val;
% end
% 
