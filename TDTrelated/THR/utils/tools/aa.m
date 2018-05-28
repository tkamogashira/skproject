function aa(Flag);
% AA - delete all figures with visible handles
%   AA deletes all visible figures except those whose userdata property
%   equals 'dontclose'.
% 
%   AA ALL or AAA deletes all figures, visible or not, but
%   againexculding those with 'dontclose'-valued userdata.
%
%   See also AAA, DD, FF.

if nargin<1, Flag=[]; end

if ~isempty(Flag), % make all handle visible
    shh = get(0,'showhiddenhand'); % store to restore
    set(0,'showhiddenhand', 'on')
end

h = findobj(0,'type','figure');

% don't close  figures whose userdata property equals 'dontclose'
ud=get(h, 'userdata');
if ~iscell(ud), ud = {ud}; end
for ii=1:length(ud),
    if isequal('dontclose', ud{ii}),
        h(ii) = nan;
    end
end
delete(denan(h));

if ~isempty(Flag), % restore visibility of hidden handles
    set(0,'showhiddenhand', shh);
end

