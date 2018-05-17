% generating function for 'aim-mat'
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


function nap=gen_hcl(bmm,options)

waithand=waitbar(0,'generating NAP');

compression=options.compression;
switch compression
    case 'sqrt'
        nap=halfwayrectify(bmm);
        nap=sqrt(nap);
    case 'log'
        nap=logcompress(bmm,options);
end
%save bmm.mat bmm;
%save nap.mat nap;

% lowpassfiltering in the end
if isfield(options,'do_lowpassfiltering') % this is multiplied to the threshold_time_const
    do_lowpassfiltering=options.do_lowpassfiltering;
else
    do_lowpassfiltering=1;
end

% cut off frequency lowpassfiltering in the end
if isfield(options,'lowpass_cutoff_frequency') % this is multiplied to the threshold_time_const
    lowpass_cutoff_frequency=options.lowpass_cutoff_frequency;
else
    lowpass_cutoff_frequency=1200;
end



% order of the lowpassfiltering in the end
if isfield(options,'lowpass_order') % this is multiplied to the threshold_time_const
    lowpass_order=options.lowpass_order;
else
    lowpass_order=2;
end


nr_chan=getnrchannels(nap);
if options.do_lowpassfiltering==1
    for ii=1:nr_chan  % through all channels: prepare working variable
		if mod(ii,10)==0
			waitbar(ii/nr_chan);
		end
        sig=getsinglechannel(nap,ii);
        newsig=leakyintegrator(sig,lowpass_cutoff_frequency,lowpass_order);
        nap=setsinglechannel(nap,ii,newsig);
    end
end



timesum=getsum(nap);
maxt=max(timesum);
nap=setscalesumme(nap,maxt);
%save nap1.mat nap;
close(waithand);


