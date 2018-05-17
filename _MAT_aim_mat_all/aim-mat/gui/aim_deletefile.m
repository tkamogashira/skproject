% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%       handles: 
%   RETURN VALUE:
%
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function handles=aim_deletefile(handles,type)
% deletes the file, if it is there

switch type
	case 'bmm'
		todelete=handles.info.bmmname;
		handles.info.bmm_loaded=0;
	case 'nap'
		todelete=handles.info.napname;
		handles.info.nap_loaded=0;
	case 'strobes'
		todelete=handles.info.strobesname;
		handles.info.strobes_loaded=0;
	case 'sai'
		todelete=handles.info.sainame;
		handles.info.sai_loaded=0;
    case 'pitch_image'
        todelete=handles.info.pitch_imagename;
		handles.info.pitch_image_loaded=0;
	case 'usermodule'
		todelete=handles.info.usermodulename;
		handles.info.usermodule_loaded=0;
	case 'movie'
		handles.info.movie_loaded=0;
		mnames=handles.info.moviename;
		for i=1:length(mnames)
			todelete=handles.info.moviename{i};
			if ~fexist(todelete)
				return
			end
			delete(todelete);
		end
		return
    %otherwise 
    %    todelete=''; % Stops it crashing if given junk, left out as this
    %    is a good indicator that there's something wrong.
end        

if ~fexist(todelete)
	return
end

delete(todelete);
