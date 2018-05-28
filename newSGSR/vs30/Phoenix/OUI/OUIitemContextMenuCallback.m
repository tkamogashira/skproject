function OUIitemContextMenuCallback(keyword, varargin);
% OUIitemContextMenuCallback - callback function for context menu of OUI items
%   OUIitemContextMenuCallback is the callback of context menu items
%   of OUI items. Standard operations include the temporary disabling 
%   of an item in order to exclude them from a OUIdefaults file.
%
%   OUIitemContextMenuCallback('enableAll') re-enables all disabled
%   OUI items.
%
%   See also readOUI, OUIdefault, stimOUI.

persistent hDisabled

if nargin<1,  keyword = get(gcbo, 'tag'); end


if isempty(keyword), error(['Missing keyword or uicontrol tag.']); end
if ~ischar(keyword), error('Keyword must be char string.'); end

switch lower(keyword),
case lower('OUIcontrolDisableMenuItem'),
   hItem = gco; % handle to OUI item
   [isDisabled, idis, hDisabled] = localIsDisabled(hItem, hDisabled);
   if isDisabled, return; end % cannot disable the disabled
   % mark hItem as disabled and store its current, normal, background color
   bgc = get(hItem, 'backgroundcolor');
   hDisabled = [hDisabled; hItem, bgc]; % 1st col=handle; 2nd-4th col = background color
   set(hItem, 'backgroundcolor', [1 0.02 1], 'enable', 'off');
case lower('OUIcontrolEnableMenuItem'),
   hItem = gco % handle to OUI item
   [isDisabled, idis, hDisabled] = localIsDisabled(hItem, hDisabled);
   if ~isDisabled, return; end % only enable the disabled
   % restore background color
   set(hItem, 'backgroundcolor', hDisabled(idis, 2:4), 'enable', 'on');
   % remove from list
   hDisabled(idis,:) = [];
case lower('enableAll'),
   % purge hDisabled
   [isDisabled, idis, hDisabled] = localIsDisabled(0, hDisabled);
   for idis = 1:size(hDisabled,1),
      hItem = hDisabled(idis, 1);
      set(hItem, 'backgroundcolor', hDisabled(idis, 2:4), 'enable', 'on');
   end
   hDisabled = [];
otherwise,
   error(['Unknown keyword ''' keyword '''.']);
end % switch/case

%===============locals================
function [isda, I, hDisabled] = localIsDisabled(h, hDisabled);
if isempty(hDisabled), isda=0; I = []; return; end
% purge hDisabled vector
ihan = find(ishandle(hDisabled(:,1))); % first column are the handles
hDisabled = hDisabled(ihan, :);
I = find(h==hDisabled(:,1));
isda = ~isempty(I);






