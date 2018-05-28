function IndepVal = calcEDFIndepVal(EDFIndepVar)

%B. Van de Sande 12-02-2004

Tol = 1e-3;

if isfield(EDFIndepVar, 'LOGLIN') & (EDFIndepVar.LOGLIN == 2),
    Increment = 1/EDFIndepVar.SOCT;
    IndepRange = roundof(log2(EDFIndepVar.HIGH/EDFIndepVar.LOW)/Increment + 1, Tol);
    if (IndepRange < 0), IndepVal = EDFIndepVar.LOW * 2.^-( (0:abs(IndepRange)-1)' * Increment );
    else, IndepVal = EDFIndepVar.LOW * 2.^( (0:IndepRange-1)' * Increment ); end
else,
    IndepRange = roundof(((EDFIndepVar.HIGH - EDFIndepVar.LOW)/EDFIndepVar.INC) + 1, Tol);
    IndepVal = EDFIndepVar.LOW + (0:IndepRange-1)' * EDFIndepVar.INC;
end;

%--------------------------------------------local functions--------------------------------------
function V = roundof(V, Tol)

if (V - floor(V)) > (1-Tol), V = ceil(V);
else V = floor(V); end