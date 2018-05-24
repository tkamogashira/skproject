function gencontents(Dir)
% gencontents - makecontents accepting partial dir names
%    gencontents('Foo') generates contents.m file for directory Foo.
%    Partial paths are allowed.
%
%    See also AddContents, HELP, WHAT.

qq = what(Dir);
if ~isequal(1,length(qq)),
    error(['Ambiguous or non-existent path ''' Dir '''.']);
end

makecontentsfile(qq.path);



