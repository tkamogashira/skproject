function boolean = isDCPExpr(Expr, VarNames)

%B. Van de Sande 03-10-2003

if ~ischar(Expr), boolean = logical(0);
else,
   boolean = logical(1);
   try, evalDCPExpr(Expr, 1, VarNames); catch, boolean = logical(0); end  
end