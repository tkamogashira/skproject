function PP = set(PP, varargin)
% SET sets a property of the PatchPlot Object to a new value
%
% PatchPlots have a set of properties you can retrieve or adjust. The 'get' and
% 'set' functions are used for this purpose.
%
% PP = set(PP, propName1, newValue1, propName2, newValue2, propName3, newValue3, ...)
% Sets the value of property propName.
%
%          PP: The PatchPlotObject instance.
%    propName: The property you want to get, this should be a member of the
%             'params' property of PP.
%    newValue: The new value we give to the field.
%
% Properties for PatchPlotObject: type 'help PatchPlotObject'.
%
% Example:
%  Suppose PP is a PatchPlotObject instance, with property 
%   FaceColor == {'r';'k'},
%  then:
%  >> get(PP, 'FaceColor')
%  ans = 
%      'r'
%      'k'
%  >> P = set(PP, 'FaceColor', {'b';'k'});
%  >> get(PP, 'FaceColor')
%  ans = 
%      'b'
%      'k'

PP.params = processParams(varargin, PP.params);