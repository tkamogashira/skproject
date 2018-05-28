function N = evalDCPExpr(Expr, SubstVal, VarNames)

%B. Van de Sande 03-10-2003

VarNames = cellstr(VarNames);
NVar = length(VarNames);

for n = 1:NVar, Expr = strrep(Expr, VarNames{n}, mat2str(SubstVal)); end
Expr = strrep(Expr, '*', '.*');
Expr = strrep(Expr, '/', './');
N = eval(Expr);