function S = MoutofNstr(M,N,ch);
% MoutofNstr - aligned 'M/N' string
%    MoutofNstr(9,100) returns the string '  9/100', etc. The length of the
%    string is determined by N, and is such that N/N fits exactly. This is
%    used to report progress by a fix-length string. N and M must be
%    nonnegative integer scalars.
%
%    MoutofNstr(M,N,CH) uses characrt CH insetad of blanks.

if nargin<3, ch=' '; end

if ~isscalar(M) || ~isscalar(N) || ~isnumeric(M) || ~isnumeric(N) ...
        || ~isequal(round([M N]), [M N]) || any([M N]<0),
    error('Both input args M and N must be nonnegative integer scalars.');
end

mn = max(1,[M N]);
Nblank = diff(floor(log10(mn))); % prevent log10(0)
S = [repmat(ch, 1, Nblank) num2str(M) '/' num2str(N)];

