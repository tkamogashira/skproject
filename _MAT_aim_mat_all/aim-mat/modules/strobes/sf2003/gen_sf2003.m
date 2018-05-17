% generating function for 'aim-mat'
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



function [allstrobeprocesses,allthresholds]=gen_sf2003(nap,strobeoptions)

% find in each channel each strobe and gives it back as an list of
% structures of strobes

% possible values of strobe_criterion:
% switch strobeoptions.strobe_criterion
% 	case 'threshold'
% 	case 'peak'
% 	case 'temporal_shadow'
% 	case 'local_maximum'
% 	case 'delta_gamma'
% 	case 'parabola'
% 	case 'bunt'
% 	case 'adaptive'
% end

if strcmp(strobeoptions.strobe_criterion,'interparabola')
	[allstrobeprocesses,allthresholds]=do_interparabola(nap,strobeoptions);
	return
end

% non interchannel methods:
% buffer for all thrsholds afterwards. Exact copy of the signal:
allthresholds=nap;
cfs=getcf(nap);

waithand=waitbar(0,'generating strobes');
nr_channels=getnrchannels(nap);
for ii=1:nr_channels
	waitbar(ii/nr_channels);
	single_channel=getsinglechannel(nap,ii);   
	current_cf=cfs(ii);
	strobeoptions.current_cf=current_cf;
	
	% here they are calculated:
	[strobe_points,threshold]=findstrobes(single_channel,strobeoptions);
	
	% return values: strobes in sec
	% threshold= signal indicating the adaptive threshold
	
	strobe_points=strobe_points(find(strobe_points>0));
	strobe_vals=gettimevalue(single_channel,strobe_points);
	
	thresvals=getvalues(threshold);
	
	% make shure, they are in one column
	if size(strobe_points,1) > size(strobe_points,2)
		strobe_points=strobe_points';
		strobe_vals=strobe_vals';
	end
	allstrobeprocesses{ii}.strobes=strobe_points;
	allstrobeprocesses{ii}.strobe_vals=strobe_vals;
	allthresholds=setsinglechannel(allthresholds,ii,thresvals);
end
close(waithand);
return


% interchannel methods:
function [all_processes,thresholds]=do_interparabola(nap,options)
% the threshold is calculated relativ to the hight of the last strobe
% the sample rate is needed for the calculation of the next thresholds
% for time_constant_alpha this is a linear decreasing function that goes
% from the maximum value to 0 in the time_constant
%
% with interchannel interaction: A strobe in one channel reduces the
% threshold in the neighbouring channels

nr_channels=getnrchannels(nap);

current_threshold=zeros(nr_channels,1);
sr=getsr(nap);
last_strobe=ones(nr_channels,1)* -inf;

napvals=getvalues(nap);
tresval=zeros(size(napvals));
nr_dots=length(napvals);

strobe_points=zeros(nr_channels,1000); % makes things faster
strobe_times=zeros(size(strobe_points)); % makes things faster

%when the last strobe occured
last_strobe_time=ones(nr_channels,1)* -inf;
last_threshold_value=zeros(nr_channels,1);
last_val=napvals(:,1);

cfs=getcf(nap);
% copy options to save time
h=options.parabel_heigth;
wnull=options.parabel_width_in_cycles*1./cfs;
w_variabel=wnull;

strobe_decay_time=options.strobe_decay_time;
times_per_ms=round(sr*0.005); % how often the bar should be updated
counter=ones(nr_channels,1);

waithand=waitbar(0,'generating Interchannel Strobes');

for ii=2:nr_dots-1
	current_time=ii/sr;
	if mod(ii,times_per_ms)==0
		waitbar(ii/nr_dots);
	end

	for jj=1:nr_channels
		current_val=napvals(jj,ii);
		next_val=napvals(jj,ii+1);
		
		if current_val>=current_threshold(jj)  % above threshold -> criterium for strobe
			current_threshold(jj)=current_val;
			if current_val > last_val(jj) && current_val > next_val  % only strobe on local maxima
				% take this one as a new one
				strobe_points(jj,counter(jj))=ii;
				strobe_time(jj,counter(jj))=ii/sr;
				counter(jj)=counter(jj)+1;	% strobecounter
				
				last_strobe_time(jj)=ii/sr; % anyhow, its a candidate
				last_threshold_value(jj)=current_threshold(jj);
				a=4*(1-h)/(wnull(jj)*wnull(jj));
				b=-wnull(jj)/2;
				w_variabel(jj)=wnull(jj)-(current_threshold(jj)-2*a*b)/(2*a);
				
			% the interchannel action: reduce the threshold in adjacent channel
				if jj>1
					current_threshold(jj-1)=current_threshold(jj-1)/1.2;
					last_threshold_value(jj-1)=last_threshold_value(jj-1)/1.2;
				end
				
			end
		end
		tresval(jj,ii)=current_threshold(jj);
		
		time_since_last_strobe(jj)=current_time-last_strobe_time(jj);
		if time_since_last_strobe(jj) > w_variabel(jj) % linear falling threshold
			const_decay=last_threshold_value(jj)/sr/strobe_decay_time;
			current_threshold(jj)=current_threshold(jj)-const_decay;
			current_threshold(jj)=max(0,current_threshold(jj));
		else    % parabel for the first time y=a(x+b)^2+c
			a=4*(1-h)/(wnull(jj)*wnull(jj));
			b=-wnull(jj)/2;
			c=h;
			factor=a*(time_since_last_strobe(jj) + b) ^2+c;
			current_threshold(jj)=last_threshold_value(jj)*factor;
		end    
		
		current_threshold(jj)=max(0,current_threshold(jj));     % cant be smaller then 0
		last_val(jj)=current_val;
	end
end

	% give back only the strobes, that really occured:
for jj=1:nr_channels
	if counter(jj)>1
		real_strobe_points=strobe_points(jj,1:counter(jj)-1);
		strobe_vals=napvals(jj,real_strobe_points);
		all_processes{jj}.strobe_vals=strobe_vals;
		real_strobe_points=bin2time(nap,real_strobe_points);
		all_processes{jj}.strobes=real_strobe_points;
	else
		all_processes{jj}.strobe_vals=[];
		all_processes{jj}.strobes=[];
	end
end

thresholds=nap;
thresholds=setvalues(thresholds,tresval);

close(waithand);
return