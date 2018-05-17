% demonstration file for 'aim-mat'
%
% (c) 2006-2008, University of Cambridge, Medical Research Council 
% Tom Walters (tcw24@cam.ac.uk)
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function str=get_graphics_options(handles,module_name)
% returns the graphic options, if they exist

str=[];
if isfield(handles.all_options.graphics,module_name)
	str=getfield(handles.all_options.graphics,module_name);
else
	% 	disp(sprintf('graphics part for module %s not found. Check version',module_name));
    % TCW AIM2006 changed 12 instances of 'opstr' to 'str' - bugfix - let's
    % hope so!
	switch handles.info.current_plot
		case {1,2,3,4,5}
			str.is_log=0;
			str.time_reversed=0;
			str.plotstyle='mesh';
			str.plotcolor='k';
			str.display_time=0;
		case {6}
			str.is_log=1;
			str.time_reversed=1;
			str.plotstyle='mesh';
			str.plotcolor='k';
			str.minimum_time=0.001;
			str.maximum_time=0.032;
			str.display_time=0;
	end
end
