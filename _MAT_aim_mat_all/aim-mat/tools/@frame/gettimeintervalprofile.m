% method of class @frame
%
% enhanced verion of getsum
% 
%   INPUT VALUES:
%           
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/06/11 10:46:54 $
% $Revision: 1.1 $

function sumsig=gettimeintervalprofile(fr,options)

if nargin <2
	options=[];
end

if isfield(options,'resolved_harmonic_minimum')
	resolved_harmonics=options.resolved_harmonic_minimum;
	if resolved_harmonics>0
		has_resolved_harmonics=1;
	else
		has_resolved_harmonics=0;
	end
else
	has_resolved_harmonics=0;
end



if has_resolved_harmonics==0
	sumsig=getsum(fr);
	return
end


val=fr.values;
l=getlength(fr);
sr=getsr(fr);
nr_chan=getnrchannels(fr);
cfs=getcf(fr);
nr_len=getnrpoints(fr);
summe=zeros(1,nr_len);
if nr_chan > 1
	for ii=1:nr_chan
		current_cf=cfs(ii);
		resolved_time=1/(current_cf/resolved_harmonics);
% 		resolved_time=1/(current_cf/10);
		resolved_bin=floor(resolved_time*sr);
		relevant=val(ii,resolved_bin:end);
		missing=nr_len-size(relevant,2);
		relevant=[zeros(1,missing) relevant];
		summe=summe+relevant;
	end
	sumsig=signal(summe);
	sumsig=setsr(sumsig,sr);
	sumsig=setname(sumsig,sprintf('Sum of unresolved harmonics of frame: %s',getname(fr)));
	sumsig=setstarttime(sumsig,getminimumtime(fr));
else 
	sumsig=getsinglechannel(fr,1);
end    
