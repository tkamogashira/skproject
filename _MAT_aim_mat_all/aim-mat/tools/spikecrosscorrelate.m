% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function cor=spikecrosscorrelate(data1,data2,sr,window_start,window_stop)
% calculate the autocorrelation (all interval histogram)
% for the data in data with the samplerate in sr, but only the time
% window given my window

nr_dat1=length(data1);
nr_dat2=length(data2);

if nr_dat1<2 || nr_dat2<2
	cor=[];
	return
end

cor=zeros(1,round((window_stop-window_start)*sr));
zeroindx=window_stop*sr;
for ii=1:nr_dat1
	dat1=data1(ii);
	for jj=1:nr_dat2
		dat2=data2(jj);
		len=(dat2-dat1)*sr;
		indx=round(len);
		if indx < window_stop*sr && indx > window_start*sr
    		cor(indx+zeroindx)=cor(indx+zeroindx)+1;
		end
	end			
end
