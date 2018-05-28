function hel(varargin);
% hel - correct misspelling "help" 
%    hel pfoo is the same as help foo
%
%    See also HELP.

help(varargin{1}(2:end), varargin{2:end});

