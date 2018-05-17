% function  result = analyse_aim_profiles(ti_profile, fq_profile, peaks_tip, peaks_fqp, channel_center_fq)
%
%   To analyse the time interval and frequency profile of the auditory image
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

function result = analyse_aim_profiles(ti_profile, fq_profile, peaks_tip, peaks_fqp, channel_center_fq )


[fqp_result, fqp_fq] = analyse_frequency_profile(fq_profile, peaks_fqp);
if fqp_result==1
    [tip_result, dominant_ti] = analyse_timeinterval_profile(ti_profile, peaks_tip, fqp_result, fqp_fq); 
else
    [tip_result, dominant_ti] = analyse_timeinterval_profile(ti_profile, peaks_tip);
end

% return results
if fqp_fq==0
    cfq = 0;
else
    cfq =  channel_center_fq(fqp_fq);
end
if dominant_ti==0
    dti = 0;
else
    dti = 1/dominant_ti;
end
result.tip = tip_result;
result.dti = dti;
result.fqp = fqp_result;
result.dfq = cfq;



%--------------- subfunction -----------------------
