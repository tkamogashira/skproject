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


function [newsig,strobe_points,threshold]=adaptivthreshold(sig,options)

if nargin < 2
	options=[];
end

% the way, in which the strobes are calculated
if isfield(options,'strobe_decay_time')
	strobe_decay_time=options.strobe_decay_time;
else
	strobe_decay_time=0.04;
end

% the time constant of the strobe decay
if isfield(options,'strobe_decay_time')
	strobe_decay_time=options.strobe_decay_time;
else
	strobe_decay_time=0.04;
end

% the timeout, after that time a strobe must occure
if isfield(options,'timeout')
	timeout=options.timeout;
else
	strobe_decay_time=0.01;
end

% the strobe lag, ie the time that is waited for the next strobe to occure
if isfield(options,'strobe_lag')
	strobe_lag=options.strobe_lag;
else
	strobe_lag=0.005;
end

% the threshold of a strobe
if isfield(options,'threshold')
	threshold=options.threshold;
else
	threshold=0.04;
end

% if we want to start with a different threshold
if isfield(options,'startingthreshold')
	current_threshold=options.startingthreshold;
else
	current_threshold=0;
end

% if some graphic should be displayed during run
if isfield(options,'grafix')
	grafix=options.grafix;
else
	grafix=0; % 
end

% % if the result shell be filtered by this lowpass filter:
% if isfield(options,'lowpass') 
%     lowpassvalue=options.lowpass;
% else
%     lowpassvalue=-1; % 
% end

sr=getsr(sig);
newsig=sig;
newsig=setname(newsig,sprintf('adaptive threshold of %s',getname(sig)));
% newvals=getvalues(sig);
threshold=sig;
tresval=getvalues(sig);


sigvals=getvalues(sig);
options.current_threshold=current_threshold;
options.sr=sr;

switch options.strobe_criterion
	case 'parabola'
		[strobe_points,tresval,newvals]=doadaptivethresholdparabola(sigvals,options);
	case 'threshold'
	case 'peak'
		[strobe_points,tresval,newvals]=doadaptivethresholdpeak(sigvals,options);
	case 'peak_shadow+'
		[strobe_points,tresval,newvals]=doadaptivethresholdpeakshadowplus(sigvals,options);
	case 'peak_shadow-'
	case 'delta_gamma'
	case 'adaptive'
		[strobe_points,tresval,newvals]=doadaptivethresholdadaptive(sigvals,options);
	case 'bunt'
		[strobe_points,tresval,newvals]=doadaptivethresholdbunt(sigvals,options);
end

strobe_points=bin2time(sig,strobe_points);

newsig=setvalues(newsig,newvals);
threshold=setvalues(threshold,tresval);

% % do a low pass filtering of the result to smooth it
% if lowpassvalue > -1
%     if lowpassvalue > 2000
%         lowpassvalue=2000;
%     end  
%     newsig=lowpass(newsig,lowpassvalue);
%     newsig=halfwayrectify(newsig);
% end


if grafix
	clf
	plot(sig); hold on
	ax=axis;
	plot(newsig,'r');
	plot(threshold,'g');
	axis(ax);
end
return


function [strobe_points,tresval,newvals]=doadaptivethresholdparabola(sigvals,options)
% the threshold is calculated relativ to the hight of the last strobe
% the sample rate is needed for the calculation of the next thresholds
% for time_constant_alpha this is a linear decreasing function that goes
% from the maximum value to 0 in the time_constant

current_threshold=options.current_threshold;
sr=options.sr;
last_strobe=-inf;

tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(100,1);

%when the last strobe occured
% last_strobe=-inf;
last_threshold_value=0;

% copy options to save time
h=options.parabel_heigth;
w=options.parabel_width;
%     w=options.parabel_width_in_cycles*1/options.current_cf;
strobe_decay_time=options.strobe_decay_time;

counter=1;
for ii=1:nr
	current_val=sigvals(ii);
	current_time=ii/sr;
	
	if current_val>current_threshold
		new_val=current_val-current_threshold;
		current_threshold=current_val;
		strobe_points(counter)=ii;
		counter=counter+1;
		last_strobe=ii;
		last_threshold_value=current_threshold;
	else
		new_val=0;
	end
	tresval(ii)=current_threshold;
	
	time_since_last_strobe=(ii-last_strobe)/sr;
	if time_since_last_strobe > w % linear falling threshold
		const_decay=last_threshold_value/sr/strobe_decay_time;
		current_threshold=current_threshold-const_decay;
		current_threshold=max(0,current_threshold);
	else    % parabel for the first time y=a(x+b)^2+c
		a=4*(1-h)/(w*w);
		b=-w/2;
		c=h;
		factor=a*(time_since_last_strobe + b) ^2+c;
		current_threshold=last_threshold_value*factor;
	end    
	
	current_threshold=max(0,current_threshold);     % cant be smaller then 0
	
	newvals(ii)=new_val;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval,newvals]=doadaptivethresholdpeak(sigvals,options)
% finds every single local maximum
sr=options.sr;
tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
strobe_points=zeros(100,1);
sig=signal(sigvals);
sig=setsr(sig,sr);
[t,h]=getlocalmaxima(sig);
strobe_points=t*sr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strobe_points,tresval,newvals]=doadaptivethresholdpeakshadowplus(sigvals,options)
% finds every single peak and starts from that an falling threshold

current_threshold=options.current_threshold;
sr=options.sr;
tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(100,1);
strobe_decay_time=options.strobe_decay_time;
last_strobe=-inf;
counter=1;
last_threshold_value=0;

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


function [strobe_points,tresval,newvals]=doadaptivethresholdadaptive(sigvals,options)
% the threshold is calculated relativ to the hight of the last strobe
% the sample rate is needed for the calculation of the next thresholds
% for time_constant_alpha this is a linear decreasing function that goes
% from the maximum value to 0 in the time_constant

current_threshold=options.current_threshold;
sr=options.sr;
last_strobe=-inf;

tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(100,1);

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% BUNT
function [strobe_points,tresval,newvals]=doadaptivethresholdbunt(sigvals,options)
% the bunt is relative to the last peak hight

current_threshold=options.current_threshold;
sr=options.sr;
last_strobe=-inf;

tresval=zeros(size(sigvals));
newvals=zeros(size(sigvals));
nr=length(sigvals);
strobe_points=zeros(100,1);

%when the last strobe occured
last_strobe_time=-inf;
last_threshold_value=0;

% copy options to save time
strobe_decay_time=options.strobe_decay_time;

% wait that many cycles to confirm a strobe
wait_time=options.wait_cycles/options.cf;

% if waited for too long, then strobe anyhow after some passed candidates:
wait_candidate_max=options.nr_strobe_candidates;
current_jumped_candidates=1;


bunt=options.bunt;

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
			if (counter>1 && current_time-strobe_time(counter-1)<wait_time) %&& current_threshold >last_threshold_value
				% if its too long in the past, fire anyway
				if current_jumped_candidates > wait_candidate_max	
					current_jumped_candidates=1;	% reset counter
				else
					current_jumped_candidates=current_jumped_candidates+1;
					counter=counter-1;	% delete the last one
				end
			else
				current_jumped_candidates=current_jumped_candidates+1;
			end				
			
				
			% take this one as a new one
			strobe_points(counter)=ii;
			strobe_time(counter)=ii/sr;
			counter=counter+1;	% strobecounter
			current_threshold=current_threshold*options.bunt;	%increase threshold
			
			last_strobe_time=ii/sr; % anyhow, its a candidate
			last_threshold_value=current_threshold;
			
		end
	end
	tresval(ii)=current_threshold;
	
	const_decay=last_threshold_value/sr/strobe_decay_time;
	current_threshold=current_threshold-const_decay;
	
	current_threshold=max(current_threshold,0);
	last_val=current_val;
end

