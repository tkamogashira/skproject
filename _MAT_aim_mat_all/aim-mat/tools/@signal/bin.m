% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

% calculate the binned version of the signal
function retsig=bin(sig,binwidth)


new_sr=1/binwidth; % the sr of the binned signal        
old_sr=getsr(sig);

cvals=getvalues(sig);
nrbinspro=old_sr/new_sr;
nr_bins=round(getlength(sig)/binwidth);
new_val=zeros(nr_bins,1);

for k=1:nr_bins
    start_bin=round((k-1)*nrbinspro+1);
    stop_bin=round(k*nrbinspro);
    stop_bin=min(stop_bin,length(cvals));
    new_val(k)=sum(cvals(start_bin:stop_bin));
end
retsig=signal(new_val);
retsig=setsr(retsig,new_sr);
retsig=setname(retsig,sprintf('binned signal %s with binwidth %3.2fms',getname(sig),binwidth*1000));


