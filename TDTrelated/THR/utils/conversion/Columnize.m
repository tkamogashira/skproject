function varargout = Columnize(varargin)
% Columnize - reshape array into column array
%    Columnize(X) returns X(:) for array X. This reshapes X into a column
%    vector.
%
%    [X,Y,..] = Columnize(X,Y,..) columnizes X,Y,.. in a single call.
%
%    Columnize(X,Y,..) columnizes X,Y,.. in a single call.
%
%    Columnize({X,Y,..},'cellwise') columnizes each cell X,Y,.., that is,
%    it equals {Columnize(X), Columnize(Y), ...}.
%
%    See also SameSize, TempColumnize.


if nargin==2 && iscell(varargin{1}) && isequal('cellwise', varargin{2}),
    Y = cell(size(varargin{1}));
    [Y{:}] = Columnize(varargin{1}{:});
    varargout{1} = Y;
else,
    for ii = 1:nargin,
        varargout{ii} = varargin{ii}(:);
    end
end



