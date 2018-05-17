% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function combi=slidereditcontrol_set_raweditvalue(combi,value)
% set the edit value eg. by typing a text in the edit control
% a slidereditcontrol consists of a slider and an edit object, that are 
% related. When one value changes, the other also changes.
% The combination has the following variables:
% sliderhandle - the handle of the slider control
% edithandle - the handle of the edit control
% minvalue - the minimum value allowed
% maxvalue - the maximum allowed value
% (current_value - the current value)
% is_log - whether the slider reponds logarithmically
% editscaler - a number, that is multiplied to the edit control (to make ms of secs)
% nreditdigits - the number of digits in the edit control

% the slider gets the raw value back:
if ~isempty(value)
	set(combi.edithandle,'String',num2str(value));
else % set back to old value
	set(combi.edithandle,'String',num2str(combi.current_value*combi.editscaler));
	return
end

% the real value must be translated
realval=value/combi.editscaler;
realval=max(realval,combi.minvalue);
realval=min(realval,combi.maxvalue);

if combi.is_log==1
	sliderval=f2f(realval,combi.minvalue,combi.maxvalue,0,1,'loglin');
else
	sliderval=f2f(realval,combi.minvalue,combi.maxvalue,0,1,'linlin');
end

sliderval=min(1,sliderval);
sliderval=max(0,sliderval);

set(combi.sliderhandle,'Value',sliderval);
val=realval*combi.editscaler;
editval=fround(val,combi.nreditdigits);
set(combi.edithandle,'String',num2str(editval));

combi.current_value=realval;