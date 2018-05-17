% method of class @signal
% function sig=changesr(sig,sr_neu)
% changes the sample rate of the signal to the new samplerate. 
% the number of points of the signal change!
% new values are interpolated
%
%   INPUT VALUES:
%       sig1:       first @signal
%       sr_new: new samplerate
%
%   RETURN VALUE:
%       sigresult:  @signal `
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=changesr(a,sr_neu)

sr_alt=a.samplerate;
if fround(sr_alt,5)==fround(sr_neu,5)   %nichts zu tun
    sig=a;
    return;
end


if sr_neu > sr_alt
    r=round(sr_neu/sr_alt);
%     r=sr_neu/sr_alt;
%     y = interp(a.werte,r);
    x_val_new = a.start_time+1/sr_neu:1/sr_neu:getlength(a);
    x_val_old = a.start_time+1/sr_alt:1/sr_alt:getlength(a);
    y = interp1(x_val_old, a.werte, x_val_new, 'cubic');
else
    p=sr_neu;
    q=sr_alt;
    y = resample(a.werte,p,q);
end

sig=signal(y);
sig.samplerate=sr_neu;
sig.name=a.name;
sig.unit_x=a.unit_x;
sig.unit_y=a.unit_y;
sig.start_time=a.start_time;
sig.nr_x_ticks=a.nr_x_ticks;
sig.x_tick_labels=a.x_tick_labels;