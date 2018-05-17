% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function ret_spikes=sim_spikes(sig,nr_sweeps,params)
% simulates the response to a signal

% parameters of the recovery function
p=params.int;


% the 'zero' eta determines the spontaneous activity
% p1_null=50;

% % other parameters
if isfield(params,'latency')
    latency=params.latency;
else
    latency=4;
end
if isfield(params,'first_spike_boost')
    first_spike_boost=params.first_spike_boost;
else
    first_spike_boost=2;
end
if isfield(params,'threshold')
    threshold=params.threshold;
else
    threshold=0; % in dB
end
if isfield(params,'dynamic_range')
    dynamic_range=params.dynamic_range;
else
    dynamic_range=20; % in dB
end
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
% if isfield(params,'jitter')
%     jitter_time=params.jitter;
% else
%     jitter_time=0.2;
% end


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
% maxpoint=0.999;
% tlength=mu-beta*log(-log(maxpoint));

% set the random number generator to a new value
% rand('state', sum(100*clock));
% dont do that because the values are too close to each other and actually
% not random at all!

binwidth=1/getsr(sig)*1000;
sig_len=getlength(sig);
nr_steps=getnrpoints(sig);


% % x2=binwidth:binwidth:tlength;
% 
% % spike_prob_function=hazard_function(x2,mu,beta); % for the full signal length
% % spike_prob_function2=hazard_function(x2,mu,beta/start_boost_beta_val); % for the first 20 ms
% 
% test_sig=getvalues(sig);
% test_sig=test_sig+60; % shift it upwards
% 
% 
% for i=1:nr_sweeps
%     spikes=[];
%     last_spike=-1; % inital condition: how long ago was the last spike
%     spikecounter=1; % spikecounter    
%     for j=1:nr_steps
%         time_now=j*binwidth; % thats the global time counter
%             difft=time_now-last_spike;    % how long ago is the last spike?
%             if difft<1, continue,  end
%             
% %             % modify eta by the amplitude:
% %             cur_amp=test_sig(j)-threshold; % in dB above threshold
% %             if cur_amp>dynamic_range % in saturation
% %                 cur_eta=eta;
% %             else
% %                 cur_eta=(eta-eta_null)/dynamic_range*cur_amp+eta_null;
% % %                 cur_eta=f2f(cur_amp,0,dynamic_range,eta_null,eta);
% %             end
% 
% %             z = (log(difft) - p1) ./ p2;
% %             spike_prob = exp(p3 - exp(p3)) ./ p2;
%             spike_prob = gevpdf(log(difft),p3,p2,p1);
%             
% %             weibull function
% %             spike_prob=(beta/cur_eta)*power(log(difft)/cur_eta,beta-1);
%             
% %             spike_prob=spike_prob*test_sig(j)+spont_rate; %    % modulate the probability with the height of the signal
% %             spike_prob=spike_prob/(1.2+binwidth/2); %correction factor
%             if rand<spike_prob % if a random number is smaller, then ...
% %                 jitter=randfloat(-jitter_time,jitter_time);
% %                 last_spike=time_now+jitter; % yes, a spike has happend now!
%                 last_spike=time_now; % yes, a spike has happend now!
%                 spikes(spikecounter)=last_spike+latency; % save and add the latency
%                 spikecounter=spikecounter+1; %remember the spike, when it happens
%             end
%         end
% %     end
%     ret_spikes{i}=spikes;
% end

x2=getxvalues(sig).*1000;
x2=x2(x2>0);
x2=[x2; x2(end)+binwidth];
% figure(43)
% cla
% hold on
for i=1:2
    p1=p{10}.k;
    p2=log(p{10}.x);
    p3=p{10}.y;
    if i==1
    end
    %         plot3(p1,p2,p3,'o')
    pdf=gevpdf(log(x2),p1,p2,p3);
    cdf=gevcdf(log(x2),p1,p2,p3);
    spike_prob_function{i}=ones(size(x2))*inf;
    for j=1:length(x2)
        if cdf(j)<1
            spike_prob_function{i}(j)=pdf(j)/(1-cdf(j));
        end
    end
end


times=[20];


% spike_prob_function2=gevpdf(x2,p3,p2/start_boost_beta_val,p1); % for the first 20 ms

jitter_time=0;
latency=0;

start_boost_beta_length=20;
test_sig=zeros(length(x2),1);
test_sig(1:55/binwidth)=1;
spont_rate=0;

for i=1:nr_sweeps
    spikes=[];
    last_spike=-1; % inital condition: how long ago was the last spike
    spikecounter=1; % spikecounter    
    swapc=2;
    next_swap=times(swapc);
    c_function=spike_prob_function{swapc};

    for j=1:nr_steps
        time_now=j*binwidth; % thats the global time counter
        if time_now>next_swap
            swapc=swapc+1;
            next_swap=times(swapc);
            c_function=spike_prob_function{swapc};
        end
        % implementation of a simple solution for the first spike problem: if the spike is the first then assume a very high probability
        if spikecounter==1 % yes, its the first
%             if rand<binwidth*first_spike_boost % if a random number is smaller, then ...
%                 jitter=randfloat(-jitter_time,jitter_time);
%                 last_spike=time_now+jitter; % yes, a spike has happend now!
%                 spikes(spikecounter)=last_spike+latency; % save and add the latency
%                 spikecounter=spikecounter+1; %remember the spike, when it happens
%             end

            % follow the first spike prob
             spike_prob=spike_prob_function{1}(j);
             if rand<spike_prob% if a random number is smaller, then ...
                 jitter=randfloat(-jitter_time,jitter_time);
                 last_spike=time_now+jitter; % yes, a spike has happend now!
                 spikes(spikecounter)=last_spike+latency; % save and add the latency
                 spikecounter=spikecounter+1; %remember the spike, when it happens
             end
            

        else % its a follow up spike
            difft=time_now-last_spike;    % how long ago is the last spike?
            sindx=round(difft/binwidth);    sindx=max(1,sindx);    sindx=min(350,sindx);
            
            spike_prob=c_function(sindx);
            %timefound=find(difft<times,1,'first');
            %spike_prob=spike_prob_function{timefound}(sindx);
            
            spike_prob=spike_prob*test_sig(j)+spont_rate; %    % modulate the probability with the height of the signal
%             spike_prob=spike_prob/(1.2+binwidth/2); %correction factor
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

