function P = set(P, varargin)
% SET sets a property of the Header Object to a new value
%
% Headers have a set of properties you can retrieve or adjust. The 'get' 
% and 'set' functions are used for this purpose.
%
% P = set(P, propName1, newValue1, propName2, newValue2, propName3, newValue3, ...)
% Sets the value of property propName.
%
%           P: The HeaderObject instance.
%    propName: The property you want to get, this should be a member of the
%             'params' property of P.
%    newValue: The new value we give to the field.
%
% Properties for HeaderObject: see 'help HeaderObject'.
%
% Example:
%  Suppose P is a HeaderObject instance, with property 
%   Color == 'r',
%  then:
%  >> get(P, 'Color')
%  ans = 
%      'r'
%  >> P = set(P, 'Color', 'k');
%  >> get(P, 'Color')
%  ans = 
%      'k'

P.params = processParams(varargin, P.params);