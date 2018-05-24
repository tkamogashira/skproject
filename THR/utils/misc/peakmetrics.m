function S = peakmetrics(X,Y, Ydown, FN);
% peakmetrics - various peak metrics
%    S=peakmetrics(X,Y, Ydown) returns the metrics describing the peak of Y
%    versus X in a struct
%     Ypeak: max(Y)
%     Xpeak: X value at Ymax
%     downWidth: smallest distance between a pair of X values surrounding
%            Xpeak whose Y values are smaller than Ypeak-Ydown. Nan if no
%            such pair exists.
%     Xdown: the pair  of values described abive.
%
%    X, Y and Ydown must have compatible sizes (see SameSize).
%    If any of them is a NxM matrix, S is an M-element struct arrays 
%    describing the peaks of the corresponding columns of X,Y, Ydown.
%
%    S=peakmetrics(X,Y, Ydown, 'Foo') only returns field Foo of S.

if nargin<4, FN = []; end

if ~isvector(Ydown),
    error('Ydown must be vector');
end
if isvector(X), X = X(:); end
if isvector(Y), Y = Y(:); end

Ydown = Ydown(:).';
[X,Y, Ydown] = sameSize(X,Y, Ydown);
S = [];
for icol = 1:size(Y,2),
    [x, isort] = sort(X(:,icol));
    y = Y(isort,icol);
    ydown = Ydown(1,icol);
    s.Xpeak = nan;
    [s.Ypeak, imax] = max(y);
    s.Xpeak = x(imax);
    ilo = find((x<s.Xpeak) & (y<s.Ypeak-ydown), 1, 'last');
    ihi = find((x>s.Xpeak) & (y<s.Ypeak-ydown), 1, 'first');
    s.Xdown = [nan; nan];
    if ~isempty(ilo), s.Xdown(1,1) = x(ilo); end
    if ~isempty(ihi), s.Xdown(2,1) = x(ihi); end
    s.downWidth = diff(s.Xdown);
    S = [S s];
end

if ~isempty(FN),
    S = [S.(FN)];
end
