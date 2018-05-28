function panel = set(panel, varargin)
% SET sets a property of the Panel instance to a new value
%
% Panels have a set of properties you can retrieve or adjust. The 'get'
% and 'set' functions are used for this purpose.
%
% panel = set(panel, propName1, newValue1, propName2, newValue2, propName3, newValue3, ...)
% Sets the value of property propName.
%
%       panel: The Panel instance.
%    propName: The property you want to set.
%    newValue: The new value we give to the property.
%
% Properties for Panel: see 'help Panel'.
%
% Example:
%  Suppose panel is a Panel instance, with property Title == 'Figure 1',
%  then:
%  >> get(panel, 'Title')
%  ans =
%      'Figure 1'
%  >> panel = set(panel, 'Title', 'Experiment Results');
%  >> get(panel, 'Title')
%  ans =
%      'Experiment Results'

noredraw = 0;
if isequal('noredraw', lower(varargin{end}) )
    varargin = {varargin{1:end-1}};
    noredraw = 1;
end

panel.params = processParams(varargin, panel.params);
if ~noredraw
    panel = redraw(panel);
end