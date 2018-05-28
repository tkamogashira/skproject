function dsize(varargin);
% dsize - display size of variable(s)  [debug tool]
%    dsize(Foo) shows displays the size of variable Foo.
%
%    dsize(Foo1, Foo2, ..) displays sizes of multiple variables.

for iarg=1:nargin,
    S = size(varargin{iarg});
    ND = ndims(varargin{iarg});
    str = sprintf('size of %8s: [', inputname(iarg));
    for idim=1:ND, str = [str ' ' num2str(S(idim))]; end
    str = [str ' ]'];
    disp(str);
end
