function argout = get(P, propName)
% GET gets the value of a public property of the XYPlotObject
%
% XYPlotObject have a set of properties you can retrieve or adjust. The 'get' and
% 'set' functions are used for this purpose.
% 
% argout = get(P, propName)
% Returns the value of property propName. 
%
%          P: The XYPlotObject instance.
%   propName: The property you want to get, this should be a member of the
%             'params' property of P.
%
% Properties for XYPlots: type 'help XYPlotObject'.
%
% Example:
%  Suppose P is an XYPlotObject instance, with property 
%   Color == {'r';'k'},
%  then:
%  >> get(P, 'Color')
%  ans = 
%      'r'
%      'k'

%% ---------------- CHANGELOG -----------------------
%  Fri Apr 15 2011  Abel   
%   Added option to return all parameters (cfr matlab objects)

if nargin == 1
	argout = P.params.ML;
elseif nargin == 2
	if ~ischar(propName)
		error('Expected a property name as second parameter.');
	end
	argout = getLeaf(P.params, propName);
else
	error('Wrong arguments, expected: (XYPlotObject, propName).');
end