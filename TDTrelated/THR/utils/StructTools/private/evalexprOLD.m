function Value = EvalExpr(Expr, Data)

%B. Van de Sande 28-05-2005

%Check input arguments ...
if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~iscell(Expr) | (size(Expr, 1) ~= 1), error('First argument should be cell-array with semi-parsed expression.'); end
if ~iscell(Data), error('Second argument should be cell-array with flattened structure-array.'); end

%Evaluate expression ...
idx = find(cellfun('isclass', Expr, 'double')); NFields = length(idx);
for n = 1:NFields,
    if all(cellfun('isclass', Data(:, Expr{idx(n)}), 'double')) & ...
            all((cellfun('size', Data(:, Expr{idx(n)}), 1) == 1)) & ...
            (length(unique(cellfun('size', Data(:, Expr{idx(n)}), 2))) == 1),
        Expr{idx(n)} = sprintf('(cat(1, Data{:, %d}))', Expr{idx(n)});
    elseif (size(Data, 1) == 1) & ischar(Data{Expr{idx(n)}}),
        Expr{idx(n)} = sprintf('(Data{%d})', Expr{idx(n)});
    else, Expr{idx(n)} = sprintf('(Data(:, %d))', Expr{idx(n)}); end
end
if (nargout == 0), eval(cat(2, Expr{:})); %Statement ...
else, Value = eval(cat(2, Expr{:})); end