% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function [loadobject,type,options]=aim_loadfile(name)
% load the nap and its options


load(name);
whodir=who;
loadobject=[];
for i=1:length(whodir)
	if ~strcmp(whodir(i),'name')
		eval(sprintf('classstruct=%s.data;',whodir{i}));
		eval(sprintf('options=%s.options;',whodir{i}));
		try
			eval(sprintf('type=%s.type;',whodir{i}));
		catch
			type=[];
		end
		if strcmp(whodir(i),'strobes') | strcmp(whodir(i),'strobestruct') | strcmp(whodir(i),'usermodule')
			loadobject=classstruct;
		else
			% construct the frame from whatever (sometimes the object is not recognised
			% as object due to the version ??)
			if isobject(classstruct)
				loadobject=classstruct;
			else
				nr=length(classstruct);
				if nr==1
					switch type
						case 'sai'
							loadobject=frame(classstruct);
						case 'frame'
							loadobject=frame(classstruct);
						case 'spiral'
							loadobject=spiral(classstruct);
						otherwise
							loadobject=classstruct;
					end
				else
					for i=1:nr
						switch type
							case 'sai'
								loadobject{i}=frame(classstruct{i});
							case 'frame'
								loadobject{i}=frame(classstruct{i});
							case 'spiral'
								loadobject{i}=spiral(classstruct{i});
							otherwise
								loadobject{i}=classstruct{i};
						end
					end
				end
			end
		end         
	end
end



