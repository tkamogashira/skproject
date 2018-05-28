function Str = EvalSacParam2Str(V, Unit, Prec)

C = num2cell(V);
Sz = size(V);
N  = prod(Sz);

if (N == 1) || all(isequal(C{:}))
    Str = sprintf(['%.'  int2str(Prec) 'f%s'], V(1), Unit);
elseif (N == 2)
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        V(1), Unit, V(2), Unit);
elseif any(Sz == 1)
    Str = sprintf(['%.' int2str(Prec) 'f%s..%.' int2str(Prec) 'f%s'], ...
        min(V(:)), Unit, max(V(:)), Unit); 
else
    Str = sprintf(['%.' int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s..%.' ...
        int2str(Prec) 'f%s/%.' int2str(Prec) 'f%s'], ...
        min(V(:, 1)), Unit, min(V(:, 2)), Unit, max(V(:, 1)), ...
        Unit, max(V(:, 2)), Unit); 
end
