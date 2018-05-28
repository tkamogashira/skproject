function D = docdir(D);
% docdir - personal doc dir
%
%   See also processed_datadir.

Pdir = fileparts(processed_datadir);
D = fullfile(Pdir, 'doc');





