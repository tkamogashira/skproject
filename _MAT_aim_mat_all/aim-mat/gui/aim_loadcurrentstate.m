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




function handles=aim_loadcurrentstate(handles)
% save some crucial information to a file

% standart setting, that prevent followup errors:
handles.info.init.start_time=0;
handles.info.init.duration=0.04;
handles.info.init.scale=1;
handles.info.current_figure=1;
handles.info.current_plot=1;
handles.info.init.hastime=0;
handles.info.init.hasfreq=0;
handles.info.init.hassignal=0;

if isfield(handles.info,'projectfilename')
	projectfilename=handles.info.projectfilename;
	if exist(projectfilename)==2
		olddir=pwd;
		cd(handles.info.directoryname);
		[pathstr,name,ext] = fileparts(projectfilename);
		eval(name);
		cd(olddir);
		
		try
			% test if the current plot can be presented, or if it was maybe
			% deleted in between. In this case set the current_plot to
			% something resonable
			if current_plot >6 && ~handles.info.usermodule_loaded
				current_plot=6;	start_time=0;
			end
			if current_plot > 5 && ~handles.info.sai_loaded
				current_plot=5;	start_time=0;
			end
			if current_plot > 4 && ~handles.info.strobes_loaded
				current_plot=4;	start_time=0;
			end
			if current_plot > 3 && ~handles.info.nap_loaded
				current_plot=3;	start_time=0;
			end
			if current_plot > 2 && ~handles.info.bmm_loaded
				current_plot=2;	start_time=0;
			end
			handles.info.current_plot=current_plot;
			
			handles.info.init.start_time=start_time;
			handles.info.init.duration=duration;
			handles.info.init.scale=scale;
			
			oldsize=get(handles.figure1,'Position');
			pos(1)=winx;
			pos(2)=winy;
			pos(3)=oldsize(3);
			pos(4)=oldsize(4);
			set(handles.figure1,'Position',pos);
			
			gpos(1)=grafixwinx;
			gpos(2)=grafixwiny;
			gpos(3)=grafixwinb;
			gpos(4)=grafixwinh;
			gnr=grafixwinnr;
			figure(gnr);
			clf;
			set(gnr,'Position',gpos);
			handles.info.current_figure=gnr;
			

			if exist('hastime','var')
				handles.info.init.hastime=hastime; 
			else
				handles.info.init.hastime=0;
			end
			if exist('hasfreq','var')
				handles.info.init.hasfreq=hasfreq;
			else
				handles.info.init.hasfreq=0;
			end
			if exist('hassignal','var')
				handles.info.init.hassignal=hassignal;
			else
				handles.info.init.hassignal=0;
			end
		catch
			disp('non fatal problem in reading the project file. Continue...');	
		end
	end
end
