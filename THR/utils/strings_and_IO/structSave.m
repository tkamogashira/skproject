function structsave(Filename, S, varargin);
% structSave - save struct fields to MAT file as variables.
%   structSave('Foo', S, ...) saves the fields of S as variables to file Foo.
%   A subsequent S = load('Foo') will retrieve S. The ellipses .. represent
%   any trailing arguments, which will be passed to SAVE.
%
%   See also struct/unpack, SAVE.

unpack(S);
FNS = fieldnames(S);
save(Filename, FNS{:}, varargin{:});





