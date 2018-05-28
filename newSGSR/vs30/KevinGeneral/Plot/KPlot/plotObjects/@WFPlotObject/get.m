function argout = get(P, propName)
% GET gets the value of a public property of the WFPlotObject
%
% WFPlots have a set of properties you can retrieve or adjust. The 'get' and
% 'set' functions are used for this purpose.
% 
% argout = get(P, propName)
% Returns the value of property propName. 
%
%          P: The WFPlotObject instance.
%   propName: The property you want to get, this should be a member of the
%             'params' property of P.
%
% Properties for WFPlots: type 'help WFPlotObject'.
%
% Example:
%  Suppose P is an WFPlotObject instance, with property 
%   Color == {'r';'k'},
%  then:
%  >> get(P, 'Color')
%  ans = 
%      'r'
%      'k'

if ~isequal(2, nargin)
    error('Expected 2 arguments.');
end

if ~ischar(propName)
    error('Expected a property name as second parameter.');
end

argout = getLeaf(P.params, propName);