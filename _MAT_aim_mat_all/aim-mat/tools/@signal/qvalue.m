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


function [val,hoch,breit,widthvals]=qvalue(sig,where,howmuch)
% usage: val=qvalue(sig,where,howmuch)
% calculates the q-value, that is the hight divided by the width
% of the signal at a point given by where (in seconds!)
% howmuch is the indicator, how much the signal must be dropped 0.5 or such
% returns the width in seconds, or 0, when the signal does not reach the value
% widthvals has two x-values: where the width hits the signal

vals=sig.werte;
nr_bin=time2bin(sig,where);
nr_values=getnrpoints(sig);
howmuchdecrease=vals(nr_bin)*(1-howmuch);   % value at the desired point
val=0;
hoch=0;
breit=0;
widthvals(1)=-inf;
widthvals(2)=inf;

int_time_up=nr_values+1;
for i=nr_bin:nr_values
    if vals(i)< howmuchdecrease
        int_time_up=i;
		widthvals(1)=i;
        break;
    end
end

int_time_down=0;
for i=nr_bin:-1:1
    if vals(i)< howmuchdecrease
        int_time_down=i;
		widthvals(2)=i;
        break;
    end
end

if int_time_down==0 | int_time_up==nr_values
    hoch=vals(nr_bin);
    breit=1000000;
    val=hoch/breit;
	widthvals(1)=0;	widthvals(2)=0;
    return;
end

time_up=bin2time(sig,int_time_up);
time_down=bin2time(sig,int_time_down);

hoch=vals(nr_bin);
breit=time_up-time_down;
if breit>0
	val=hoch/breit;	
else
	vals=0;
end




