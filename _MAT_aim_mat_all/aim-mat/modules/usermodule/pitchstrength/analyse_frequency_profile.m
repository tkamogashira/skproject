% function [result, center_c] = analyse_frequency_profiletunedDP(fq_profile, peaks, apFQP)
% 
%   To analyse the time frequency profile of the auditory image
%   Returns value between 0 and 1 discribing the strength of the spectral
%   pitch. Used for quantitative analysis of ramped and damped sinusoids
%   and for sinusoidally amplitude modulated sinusoids
%
%
%   INPUT VALUES:
%       fq_profile      frequency profile (signal class)
%       peaks           output of peakpicker
%       apFQP           a priori information where to find the peak
%  
%   RETURN VALUE:
%       result      all relevant information 
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function result = analyse_frequency_profile(fq_profile, options)

% for debug reasons -
plot_switch = 0;


% these finally are the results, that we want back: 
% 1:the hight at the highest point
result.free.highest_peak_hight=0;
result.free.highest_peak_frequency=0;
% hight to the region below value
result.free.height_width_ratio=0;

% now all these at a fixed frequency:
result.fixed.highest_peak_hight=0;
result.fixed.highest_peak_frequency=0;
result.fixed.height_width_ratio=0;

% other things useful for plotting
result.smoothed_signal=fq_profile; % no smoothing used here
result.peaks = [];


% first find the peaks of the frequency profile
peaks = PeakPicker(fq_profile);

% translate the time in the peaks back to a frequency
nap=options.nap;    % ugly, but we need the frequency informatin somewhere
for i=1:length(peaks)
    peaks{i}.t=1/chan2fre(nap,peaks{i}.x);
end

result.peaks = peaks;

fq_profile_vals = getdata(fq_profile);
if plot_switch
    cf_save = gcf;
    figure(13)
    cla;
    plot(fq_profile_vals,'r-');
    hold on
    axis auto
end
% stop if there are no peaks, e.g. in the first frames
if length(peaks)<1
    return
end

% Peak of interest is highest peak of the profile
peaks_oi = peaks{1};

apFQP=options.target_frequency;
if apFQP>0
    % no peak finding - peak is given a priori
    % take nearest peak to a apriori frequency
    dist=+inf;
    indexOI = 1;
    for p=1:length(peaks)
        d=abs(apFQP-peaks{p}.t);
        if d<dist
            indexOI=p;     
            dist=d;
        end
    end %p
    peak_oi = peaks{indexOI};
end


% %%  Method --- works with SAM sounds
% %%  Highest peak / number of neighbourgh channels which are bigger than -xdB
% max_attenuation_dB = -6;
% atten_fac = 10^(max_attenuation_dB/20);  % attenuation as factor
% % Take highest Peak
% %poi = peaks2{1};
% %poi = peaks{1};
% poi = peaks_oi;
% 
% fq_profile_vals = fq_profile_vals./poi.y;
% maxy =1;
% % maxy = poi.y;
% pwidth = 0;
% x = poi.x;
% while (x<=length(fq_profile_vals))&&(fq_profile_vals(x)>maxy*atten_fac)
%     pwidth=pwidth+1; % one more channel
%     x=x+1;
% end
% if plot_switch
%   line([x x],[0 peaks_oi.y]);
% end
% 
% x = poi.x-1;
% while (x>=1)&&(fq_profile_vals(x)>maxy*atten_fac)
%     pwidth=pwidth+1; % one more channel
%     x=x-1;
% end
% if plot_switch
%   line([x x],[0 peaks_oi.y]);
% end
% result_width =  1-(pwidth/length(fq_profile_vals));
% 

% ----------------------------
% Method developed with Roy 13/06
% Calculate the mean of the Channels in a 20 to 80 percent
% range left of the main peak

start_frequency_integration=options.start_frequency_integration;
stop_frequency_integration=options.stop_frequency_integration;

startx=floor(start_frequency_integration*peaks_oi.x);
if startx<=0
    startx=1;
end
stopx=floor(stop_frequency_integration*peaks_oi.x);
ps_result = 1 - mean(fq_profile_vals(startx:stopx))/fq_profile_vals(peaks_oi.x);

center_c = peaks_oi.x;

if plot_switch
  plot(peaks_oi.x,peaks_oi.y,'r.');
  plot(startx,fq_profile_vals(startx),'bx');
  line([startx startx],[0 fq_profile_vals(startx)])
  plot(stopx,fq_profile_vals(stopx),'bx');
  line([stopx stopx],[0 fq_profile_vals(stopx)])
  figure(cf_save);
end

% % % For debug plot minima
% for i=1:nops
%     plot(peaks{i}.left.x, peaks{i}.left.y, 'ob');
%     plot(peaks{i}.right.x, peaks{i}.right.y, 'xb');
% end


% finally define the return values 
result.free.highest_peak_hight=peaks_oi.y; % height of the first peak
result.free.highest_peak_frequency=chan2fre(nap,peaks_oi.x);

% hight to the region below value
result.free.height_width_ratio=ps_result;

% now all these at a fixed frequency:
result.fixed.highest_peak_hight=0;
result.fixed.highest_peak_frequency=0;
result.fixed.height_width_ratio=0;


