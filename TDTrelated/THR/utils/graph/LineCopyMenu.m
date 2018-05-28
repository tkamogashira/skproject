function Y = LineCopyMenu(hmenu, hline, varargin);
% LineCopyMenu - add line-copy menu item to a ui(context)menu
%   LineCopyMenu(hmenu, hline) appends a menu item to an existing menu with
%   graphics handle hmenu. The new item is labeled 'Copy line'. When
%   selected, the menu item stores the contents of hline, i.e., the struct 
%   returned by get(hline), in a special "line clip board". 
%   
%   LineCopyMenu('paste') returns the content of the line clip board.
%
%   See also IDpoints.


if isequal('paste',hmenu),
    Y = local_copyline('paste');
else,
    uimenu(hmenu, 'label', 'copy line', 'callback', @(src,ev)local_copyline(hline), varargin{:});
end

%================================
function Y=local_copyline(hline);
persistent LINE
if nargout>0,
    Y = LINE;
else,
    LINE = get(hline);
end



