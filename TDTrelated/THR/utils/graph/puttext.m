function h = puttext(Location, str, varargin)
% puttext - put text in current axes in specified location (compass-naming)
%
%   h = puttext(Location, str) places the the string str in the specified
%   location of the current axes. Options for Location are:
%
%   'NorthEast' --> upper right corner
%   'NorthWest' --> upper left corner
%   'SouthEast' --> lower right corner
%   'SouthWest' --> lower left corner
%
%    These may be uniquely abbreviated and are case-insensitive.
%
%    h = puttext(Location, str, ....) accepts additional property/value 
%    pairs which are passed to TEXT.
%
%    h is the handle to the text. Empty when no text was placed
%
%    EXAMPLES:
%
%    h = puttext('northeast','test text');
%    h = puttext('northwest','test text','fontsize', 14, 'color', 'r');
%
%    NOTE: rotations of the text are not handled correctly! They are removed &
%    a warning is given to the user.
%
%    NOTE II: rescaling the axes/figure after placing the text may result in a
%    shift of the text's location.
%
%
%   See also TEXT, LEGEND.

h = [];
offset = .02; %added to position (norm. units) such as not to "hug" the axes with text.
allLocs = {'northeast' 'northwest' 'southeast' 'southwest'};

if isempty(str), return; end %no text to place...

%find/check specified text location
[Location, Mess] = keywordmatch(Location, allLocs); error(Mess);

%set axes units temporarily to normalized; remember original units
orgUnit = get(gca, 'Units');
set(gca,'Units','normalized');

%determine vertical alignment of text
VertAlign = 'top';
if strncmp(Location,'south', 5),
    VertAlign = 'bottom';
end

%process extra (propname, propval) arguments when specified
N = nargin -2;
if rem(N,2),
    error('Extra inputs must be provided as propname/propval-pairs.');
end

for ii = 1:2:N,
    tmp = keywordmatch(varargin{ii},{'rotation'});
    if ~isempty(tmp) & rem(varargin{ii+1}, 360) ~= 0,
        warning('text rotation specified. Not properly implemented & thus removed.');
        varargin{ii+1} = 0;
    end
end

%add some extra settings to varargin necessary for text-positioning
varargin(N+1) = {'units'}; varargin(N+2) = {'normalized'};
varargin(N+3) = {'HorizontalAlignment'}; varargin(N+4) = {'left'};
varargin(N+5) = {'VerticalAlignment'}; varargin(N+6) = {VertAlign};
varargin(N+7) = {'visible'}; varargin(N+8) = {'off'};

%place the text (invisible) in middle of figure to get its Extent.
posi = .5;
h = text(posi, posi, str, varargin{:});
Ext = get(h, 'Extent');

%text is soo large that it will require a change in axes limits.
%Do not allow
if Ext(3) > 1 || Ext(4) > 1,
    warning('String size exceeds current axes size. Text placement aborted');
    delete(h);
    h = []; %empty handle, this is returned
    axis([0 1 0 1]);
    set(gca,'Units', orgUnit); %set axes units back to its orig. setting
    return
end

%find the position of the text
cc(1) = 1-Ext(3)-offset;
if strfind(Location,'west'), cc(1) = 0+offset; end

cc(2) = 1-offset;
if strncmp(Location,'south', 5), cc(2) = 0+offset; end

%put the text in this position & make visible
set(h,'position',cc, 'visible', 'on','units','normalized');
set(gca,'Units', orgUnit); %set axes units back to its orig. setting





