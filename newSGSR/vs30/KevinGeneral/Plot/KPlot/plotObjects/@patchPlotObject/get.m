function argout = get(P, propName)
% GET gets the value of a public property of the PatchPlot Object
%
% PatchPlot Objects have a set of properties you can retrieve or adjust. The 'get' 
% and 'set' functions are used for this purpose.
% 
% argout = get(P, propName)
% Returns the value of property propName. 
%
%          P: The PatchPlotObject instance.
%   propName: The property you want to get, this should be a member of the
%             'params' property of P.
%
% Properties for XYPlots: type 'help XYPlotObject'.
%
% Example:
%  Suppose P is a PatchPlotObject instance, with property 
%   FaceColor == {'r';'k'},
%  then:
%  >> get(P, 'FaceColor')
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