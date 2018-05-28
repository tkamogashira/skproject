function P = set(P, varargin)
% SET sets a property of the XYPlotObject to a new value
%
% XYPlots have a set of properties you can retrieve or adjust. The 'get' and
% 'set' functions are used for this purpose.
%
% P = set(P, propName1, newValue1, propName2, newValue2, propName3, newValue3, ...)
% Sets the value of property propName.
%
%           P: The XYPlotObject instance.
%    propName: The property you want to get, this should be a member of the
%             'params' property of P.
%    newValue: The new value we give to the field.
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
%  >> P = set(P, 'Color', {'b';'k'});
%  >> get(P, 'Color')
%  ans = 
%      'b'
%      'k'

P.params = processParams(varargin, P.params);