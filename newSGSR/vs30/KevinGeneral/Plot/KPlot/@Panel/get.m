function argout = get(panel, propName)
% GET gets the value of a public property of the Panel instance
%
% Panel have a set of properties you can retrieve or adjust. The 
% 'get' and 'set' functions are used for this purpose.
% 
% argout = get(panel, propName)
% Returns the value of property propName. 
%
%      panel: The Panel instance.
%   propName: The property you want to get, this should be a member of the
%             'params' property of panel.
%
% Properties for Panels: type 'help Panel'.
%
% Example:
%  Suppose panel is an Panel instance, with property 
%  Title == 'Experimental results', then:
%  >> get(panel, 'Title')
%  ans = 
%      'Experimental results'

%% ---------------- CHANGELOG -----------------------
%  Fri Apr 15 2011  Abel   
%   Added option to return all parameters (cfr matlab objects)

if nargin == 1
	argout = panel.params;
elseif nargin == 2
	if ~ischar(propName)
		error('Expected a property name as second parameter.');
	end
	argout = getLeaf(panel.params, propName);
else
	error('Wrong arguments, expected: (panel, propName).');
end


