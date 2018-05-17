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


function usermodule=gendualprofile(sai,options)

% find out about scaling:
maxval=-inf;
maxfreval=-inf;
maxsumval=-inf;

nr_frames=length(sai);
for ii=1:nr_frames
	maxval=max([maxval getmaximumvalue(sai{ii})]);
	maxsumval=max([maxsumval getscalesumme(sai{ii})]);
	maxfreval=max([maxfreval getscalefrequency(sai{ii})]);
end

waithand = waitbar(0,'Generating dualprofile with peak detection');
for frame_number=1:nr_frames
    
    waitbar(frame_number/nr_frames, waithand);     
    
	current_frame = sai{frame_number};
	current_frame = setallmaxvalue(current_frame, maxval);
	current_frame = setscalesumme(current_frame, maxsumval);
	current_frame = setscalefrequency(current_frame, maxfreval);
	
    usermodule{frame_number}.interval_sum =  getsum(current_frame);      
    usermodule{frame_number}.frequency_sum = getfrequencysum(current_frame);      
    usermodule{frame_number}.channel_center_fq = getcf(sai{frame_number});
end
close(waithand);
