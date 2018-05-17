% main procedure for aim
% 
%   INPUT VALUES: either a wave-file, a m-file or nothing
%  
%   RETURN VALUE:
%		for the nongraphic version, the result, otherwise non
%
% load the signal file and all files, that are in this directory
% set the project variables accordingly.
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function result=aim(varargin)

nrparams=length(varargin);
switch nrparams
	case 0 % no argument, load a wave file and go to graphic version
		[signame,dirname]=uigetfile('*.wav');
		if isnumeric(signame)
			return		
		end
		cd(dirname);
		aim_gui(signame);
		return
	case 1 % only one parameter, this can be the structure of parameters, or a wavefile
		cname=varargin{1};
		if isstruct(cname);	% called with an struct
% 			result=aim_gui(cname);
			result=aim_ng(cname);
			return
		end
		
		% calling with a wavefile - open the graphic version
		[pathstr,filename,ext] = fileparts(cname); %#ok
		if strcmp(ext,'.wav') % 
			if fexist(cname)	% yes, the wavefile is there! Is there also a directory?
				aim_gui(cname);
				return
			else 
				str=sprintf('The wave-file %s does not exist in the current working directory %s',cname,pwd);
				er=errordlg(str,'File Error');
				set(er,'WindowStyle','modal');
				return
			end
		else % called with a m-file
			if strcmp(ext,'.m') % calling with a m-file?
				if fexist(cname)	% yes, the m-file is there, we call the nographic version:
					result=aim_ng(cname);
					return
				else
					str=sprintf('file %s does not exist in the current working directory %s',cname,pwd);
					er=errordlg(str,'File Error');
					set(er,'WindowStyle','modal');
					return
				end
			end
		end
end

disp('call ''aim'' with with a sound file or a m-parameter file');
