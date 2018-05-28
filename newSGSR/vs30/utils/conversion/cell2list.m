function varargout = cell2list(c);
% cell2list - expand cell in to list of its arguments like in C{:}

error bullshit
N = length(c)
[varargout{1:N}] = deal(c{:});

