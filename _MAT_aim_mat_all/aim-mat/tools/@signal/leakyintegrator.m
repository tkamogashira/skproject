
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

%

function nvals=leakyintegrator(sig,lowpass_cutoff_frequency,order)


time_constant=1/(2.*pi.*lowpass_cutoff_frequency);
sr=getsr(sig);
vals=getvalues(sig);
b=exp(-1/(sr.*time_constant));
gain=1./(1-b);


nvals=zeros(size(vals));
for dothis=1:order
	xn_1=0;
	yn_1=0;
    for i=1:length(vals)
        xn=vals(i);
        yn= xn + b*yn_1 ;
        xn_1=xn;
        yn_1=yn;
        nvals(i)=yn;
    end
    vals=nvals./gain;
end

nvals=vals;