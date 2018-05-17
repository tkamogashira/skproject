% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function ret_spikes=sim_spikes(sig,nr_sweeps,params)
% simulates the response to a signal

% parameters of the recovery function
mu=params.mu;
beta=params.beta;

% other parameters
if isfield(params,'spont_rate')
    spont_rate=params.spont_rate;
else
    spont_rate=0;
end
if isfield(params,'latency')
    latency=params.latency;
else
    latency=4;
end
% if isfield(params,'first_spike_boost')
%     first_spike_boost=params.first_spike_boost;
% else
%     first_spike_boost=2;
% end
% if isfield(params,'start_boost_beta_length')
%     start_boost_beta_length=params.start_boost_beta_length;
% else
%     start_boost_beta_length=15;
% end
% if isfield(params,'start_boost_beta_val')
%     start_boost_beta_val=params.start_boost_beta_val;
% else
%     start_boost_beta_val=2;
% end
if isfield(params,'jitter')
    jitter_time=params.jitter;
else
    jitter_time=0.2;
end


% calcualates an artificail spiketrain with so many sweeps
% the important parameter are mu (the location) and beta (the scale) of the
% distribution

% changing some parameters so that the result looks good
%jitter to reduce some effect that the odd (or even?) multiples
%of the sr have significant and repeatable higher nr intervals
%then the others. Cant work out why. solution: let the interval
%jitter around the peak a bit

% calculate the x values of the distribution
% take a length of the distribution up to the point where it it 99.9 %
% that saves a lot of time
maxpoint=0.999;
tlength=mu-beta*log(-log(maxpoint));

% set the random number generator to a new value
% rand('state', sum(100*clock));
% dont do that because the values are too close to each other and actually
% not random at all!

binwidth=getsr(sig);
sig_len=getlength(sig);
nr_steps=sig_len/binwidth;
x2=binwidth:binwidth:tlength;

spike_prob_function=hazard_function(x2,mu,beta); % for the full signal length
spike_prob_function2=hazard_function(x2,mu,beta/start_boost_beta_val); % for the first 20 ms


% build a "test signal" out of zeros and ones
test_sig=zeros(nr_steps,1);
test_sig(1:50/sig_sr)=1;  % the first 50 ms are ones
% build a ramp...
test_sig(1:2/sig_sr)=linspace(0,1,length(5/sig_sr));


for i=1:nr_sweeps
    spikes=[];
    last_spike=-1; % inital condition: how long ago was the last spike
    spikecounter=1; % spikecounter    
    for j=1:nr_steps
        time_now=j*binwidth; % thats the global time counter
        % implementation of a simple solution for the first spike problem: if the spike is the first then assume a very high probability
        if spikecounter==1 % yes, its the first
            if rand<binwidth*first_spike_boost % if a random number is smaller, then ...
                jitter=randfloat(-jitter_time,jitter_time);
                last_spike=time_now+jitter; % yes, a spike has happend now!
                spikes(spikecounter)=last_spike+latency; % save and add the latency
                spikecounter=spikecounter+1; %remember the spike, when it happens
            end
        else % its a follow up spike
            difft=time_now-last_spike;    % how long ago is the last spike?
            sindx=ceil(difft/binwidth);    sindx=max(1,sindx);    sindx=min(length(spike_prob_function),sindx);
            if time_now<start_boost_beta_length
                spike_prob=spike_prob_function2(sindx);
            else
                spike_prob=spike_prob_function(sindx);
            end
            spike_prob=spike_prob*test_sig(j)+spont_rate; %    % modulate the probability with the height of the signal
            spike_prob=spike_prob/(1.2+binwidth/2); %correction factor
            if rand<spike_prob % if a random number is smaller, then ...
                jitter=randfloat(-jitter_time,jitter_time);
                last_spike=time_now+jitter; % yes, a spike has happend now!
                % make sure that it is not too close to the last one (as a result of the jitter)
                if last_spike<spikes(spikecounter-1)+0.1;
                    last_spike=time_now;
                end
                spikes(spikecounter)=last_spike+latency; % save and add the latency
                spikecounter=spikecounter+1; %remember the spike, when it happens
            end
        end
    end
    ret_spikes{i}=spikes;
end
