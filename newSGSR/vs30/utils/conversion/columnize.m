function S = columnize(S,fieldname)
% columnize - convert vector-valued field of struct array to column vector
N = length(S);
for ii=1:N,
    Si = S(ii);
    eval(['f = Si.' fieldname ';']);
    f = f(:);
    eval(['Si.' fieldname ' = f;']);
    S(ii) = Si;
end



