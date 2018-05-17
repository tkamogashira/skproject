% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function sig=toshio_lowpass(sig,cutoff,order)

%variable: order, is not used,
% a 2nd order filter is assumed,
% taken from Irino code: CalNAPghll.m


if nargin<2
    order=1;
end


sr=getsr(sig);
vals=getvalues(sig);

[bzLP apLP] = butter(1,cutoff/(sr/2));
bzLP2 = [bzLP(1)^2,  2*bzLP(1)*bzLP(2), bzLP(2)^2]; 
apLP2 = [apLP(1)^2,  2*apLP(1)*apLP(2), apLP(2)^2]; 

sig_len = length(vals);

filt_vals(1:sig_len) = filter(bzLP2,apLP2,vals);
vals=filt_vals;



sig=setvalues(sig,vals);

