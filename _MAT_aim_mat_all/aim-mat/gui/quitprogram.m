% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% my close function 
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function quitprogram(obj,eventdata,handles)
% selection = questdlg('Close AIM?',...
% 	'Close Request Function',...
% 	'Yes','No','Yes');
% switch selection,
% 	case 'Yes',
		try
			% first delete possible children
			if isfield(handles.info,'children')
				single_channel_gui('close');
				delete(handles.info.children.single_channel.windowhandle)
			end
			% then delete all graphic windows associated:
			try 
				close(handles.info.current_figure);
			end
			
			% the standart closing routine (first show window)
			shh = get(0,'ShowHiddenHandles');
			set(0,'ShowHiddenHandles','on');
			currFig = get(0,'CurrentFigure');
			set(0,'ShowHiddenHandles',shh);
			delete(currFig);
			% delete(gcf);
% 			close(handles.info.current_figure);
		end
% 	case 'No'
% 		return
% end