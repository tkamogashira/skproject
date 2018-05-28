function refreshpath(Dir);
% removes and prepends dir from and to path (path problems with W2000)

rmpath(Dir);
path(Dir, path);