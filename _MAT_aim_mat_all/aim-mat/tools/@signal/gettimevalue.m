% method of class @signal
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function val=gettimevalue(sig,times)
% usage: val=gettimevalue(sig,time)
% returns the value at this point in time

val=zeros(size(times));
if isempty(times)
	return
end

sr=1/getsr(sig);

threshold=sr/100;
nr_points=getnrpoints(sig);
start=getminimumtime(sig);
stop=getmaximumtime(sig);
x=start+sr:sr:stop;
Y=sig.werte;
method='linear';


for ii=1:length(times);
	time=times(ii)-sig.start_time;
	
	nrint=round(time/sr);
	rint=time/sr;
	
	if (nrint-rint)<threshold
		if nrint>0 && nrint <= length(sig.werte)
			val(ii)=sig.werte(nrint);
		end
	else
		xi=times(ii);
		val(ii)=interp1(x,Y,xi,method);
	end
end


