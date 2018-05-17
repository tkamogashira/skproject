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




function ret=gen_twoDat2003(bmm,options)
% two D adaptive thresholding

% first do the normal nap:
nap=gen_hcl(bmm,options.nap);

if nargin < 2
    options=[];
end


vals=getvalues(nap);



%%%normalise to 0-60dB range
%max_nap=max(max(vals));
%nap_norm=60./max_nap;
%vals=vals*nap_norm;
%save vals.mat vals;

new_vals=zeros(size(vals));
nr_chan=size(vals,1);
nr_dots=size(vals,2);
sr=getsr(nap);
cfs=getcf(nap);
load bmm.mat;


% the delays can be set by an option
if isfield(options,'time_constant_factor') % this is multiplied to the threshold_time_const
    time_constant_factor=options.time_constant_factor;
else
    time_constant_factor=0.8;
end

if isfield(options,'frequency_constant_factor') % the influence of the left and the right channel
    frequency_constant_factor=options.frequency_constant_factor;
else
    frequency_constant_factor=0.9;
end


if isfield(options,'threshold_rise_constant') % the rate at which the threshold may rise
    threshold_rise_constant=options.threshold_rise_constant;
else
    threshold_rise_constant=1;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the following calculates the envelope of nap response
%out_li=zeros(nr_chan,nr_dots);
%for chan=1:nr_chan
%out_li(chan,:)=standard_leaky_integrator(vals(chan,:),0.003,1,16000);
%out_li_scale=max(vals(chan,:))./max(out_li(chan,:));
%out_li(chan,:)=out_li(chan,:).*out_li_scale;
%end
%[ERB_no, dummy] = Freq2ERB(cfs);
%for chan=1:nr_chan
%out_li(chan,:)=standard_leaky_integrator(vals(chan,:),0.003,1,16000);
%out_li_scale=max(vals(chan,:))./max(out_li(chan,:));
%out_li(chan,:)=out_li(chan,:).*out_li_scale;
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save cfs.mat cfs;
order = 4;
[rate ERB] = Freq2ERB(cfs);
B=1.019.*ERB;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%note: decay of gammatone is described by: exp(-2*pi*B*t)
% time to drop to 1/2 (6dB) --in seconds
%i.e. exp(-2*pi*B*t)=0.5
drop6dbtime=-log(0.5)./(2*pi.*B);

% this means so many per samplepoint
threshold_decay_constant=-log10(2)*20./(drop6dbtime*sr);
threshold_decay_constant=threshold_decay_constant./time_constant_factor;




threshold_rise=(100.*B.^0.9)./sr; 
threshold_rise=threshold_rise.*threshold_rise_constant;
%threshold_rise=zeros(nr_chan);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calc frequency slope values
if nr_chan>1
    %frequency_slope_c=calcfreqslope(cfs(2),cfs(1));
    %frequency_slope_a=calcfreqslope(cfs(1),cfs(2));
    
    %c is effect from channel above but we must input
    %the higher frequency (2) as the adjacent band and
    %the channel in which we want the level (1)as 
    %the centre freq
    frequency_slope_c=calcfreqslope(cfs(1),cfs(2));
    
    %a is effect from channel below but we must input
    %the lower frequency (1) as the adjacent band and
    %the channel in which we want the level (2) as 
    %the centre freq
    frequency_slope_a=calcfreqslope(cfs(2),cfs(1));
    
else
    frequency_slope_c=0;
    frequency_slope_a=0;
end

%we divide by the frequency_constant_factor because we want a
%frequency_constant_factor of 1 to mean we use the actual
%frequency slope and a frequency_constant_factor of 0.5
%to mean that the frequency slope falls away at twice the rate
%i.e. less effect
frequency_slope_c=frequency_slope_c./frequency_constant_factor;
frequency_slope_a=frequency_slope_a./frequency_constant_factor;




oldfigure=gcf;
if nr_chan==1
	onechannelfigure=figure(3);	% assuming, the other one is 1
end

% channel_select=1:nr_chan;
times_per_ms=round(sr*0.01);
if nr_chan>1
	waithand=waitbar(0,'generating 2dat');
end



val_e=zeros(nr_chan,nr_dots);
val_inp=zeros(nr_chan,nr_dots);
val_thres=zeros(nr_chan,nr_dots);




% a is the decayed working variable from the channel above
% b is the range limit
% c is the decayed working variable from the channel below
% d is the delayed and decayed nap signal from on-channel
% e is the maximum of [a b c d]
% threshold is the working variable
% thresholdlast is the working variable in the last round
% inp is the current input


thresholdlast=zeros(nr_chan,1);
threshold=zeros(nr_chan,1);
a=0;b=1;c=0;d=0;e=0;



for ii=1:nr_dots % through the time
	if nr_chan>1
		if mod(ii,times_per_ms)==0
			waitbar(ii/nr_dots);
		end
	end
    
    for jj=1:nr_chan  % through all channels: prepare working variable
        inp=vals(jj,ii);% current input
        
        if jj< nr_chan          
            chan_above=thresholdlast(jj+1);
            a=chan_above+frequency_slope_a;
        else
            a=0;
        end
        if jj>1
            chan_below=thresholdlast(jj-1);
            c=chan_below+frequency_slope_c;
        else
            c=0;
        end
             
        %a=0;
        %c=0;
        
       
        
        
        d=max(thresholdlast(jj)+threshold_decay_constant(jj),0);
        
        
        e1=max(a,b);   
        e2=max(c,d);
        e=max(e1,e2);   
        
        
               
        
        if inp>e   %threshold is exceeded
            
           threshold(jj)=min(thresholdlast(jj)+threshold_rise(jj),inp);
           %threshold(jj)=inp; 
           
            %new_vals(jj,ii)=threshold(jj)-e;
           new_vals(jj,ii)=inp-threshold(jj);
            %    % else threshold decays
            else
            threshold(jj)=e; 
            new_vals(jj,ii)=0;  
        end
    
             
        
         val_e(jj,ii)=e;
         val_inp(jj,ii)=inp;
         val_thres(jj,ii)=threshold(jj);
        
                               
    end
    
    
    
    
    
    % prepare next round 
    if ii< nr_dots                   
    thresholdlast=threshold;
    end
    
    if nr_chan==1
        tvals(ii)=thresholdlast;
    end
    
    
end





if nr_chan==1
    figure(onechannelfigure);
    plot(nap);
    hold on
    a=plot(tvals,'r');
    set(a,'LineWidth',1.5);
end


nap=setvalues(nap,new_vals);
%save nap.mat nap;

vals=getvalues(nap);
nap=setallmaxvalue(nap,max(max(vals))*2);
nap=setallminvalue(nap,min(min(vals)));



%save val_e.mat val_e;
%save new_vals.mat new_vals;
%save val_inp.mat val_inp;
%save val_thres.mat val_thres;







ret=nap;
if nr_chan>1
	close(waithand);
end

figure(oldfigure);