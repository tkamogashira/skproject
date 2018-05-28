function argout = get(P, propName)
% GET gets the value of a public property of the legendObject
%
% legendObject have a set of properties you can retrieve or adjust. The 'get' and
% 'set' functions are used for this purpose.
% 
% argout = get(P, propName)
% Returns the value of property propName. 
%
%          P: The legendObject instance.
%   propName: The property you want to get, this should be a member of the
%             'params' property of P.
%
% Properties for XYPlots: type 'help legendObject'.
%
% Example:
%  Suppose P is an legendObject instance, with property 
%   Color == {'r';'k'},
%  then:
%  >> get(P, 'Color')
%  ans = 
%      'r'
%      'k'

%% ---------------- CHANGELOG -----------------------
%  Tue Apr 19 2011  Abel   
%   Initial creation based on code of Kevin Spiritus


if nargin == 1
	argout = P.params.ML;
elseif nargin == 2
	if ~ischar(propName)
		error('Expected a property name as second parameter.');
	end
	argout = getLeaf(P.params, propName);
else
	error('Wrong arguments, expected: (legendObject, propName).');
end
