% method of class @signal
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


function sig=rampamplitude(sig,rt,type);

if nargin < 3
    type='linear';
end
if nargin < 2
    rt=0.01;
end

if strcmp(type,'linear')
    first_bin=1;
    nr_point=time2bin(sig,rt);
    last_bin=nr_point;
%     l=linspace(0,1,(last_bin-first_bin)+1); %added +1 DRRS
    l=linspace(0,1,(last_bin-first_bin));
    sig=sig*l;
    
%     first_bin=getnrpoints(sig)-nr_point+1; %added +1 DRRS
%     start_time_hintere_rampe=bin2time(sig,first_bin+1); %added +1 DRRS
%     last_bin=time2bin(sig,getlength(sig)-1/getsr(sig)); %added -1/getsr(sig) DRRS
%     l=linspace(1,0,(last_bin-first_bin)+1); %added +1 DRRS
%     sig=mult(sig,l,start_time_hintere_rampe,rt);
    first_bin=getnrpoints(sig)-nr_point; 
    start_time_hintere_rampe=bin2time(sig,first_bin); 
    last_bin=time2bin(sig,getlength(sig));
    l=linspace(1,0,(last_bin-first_bin)); % build the ramp as 
    sig=mult(sig,l,start_time_hintere_rampe,rt);
  

end
