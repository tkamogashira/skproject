function S = StructFilter(S, Expr)
%STRUCTFILTER   filter structure-array.
%   S = STRUCTFILTER(S, C) reduces the structure-array S to only those elements 
%   which correspond to the logical expression given by the string C. Any MATLAB
%   expression that returns a logical vector with the same number of elements in
%   a field is valid. Fieldnames in these expressions must be enclosed between 
%   dollar signs and for branched structures fieldnames can be given using the 
%   dot as a fieldname separator.
%
%   See also STRUCTVIEW, STRUCTDISP, STRUCTSORT, STRUCTMERGE, STRUCTFIELD and
%   STRUCTPLOT.
%
%   Additional tools that can be used for expressions are GETCOLUMN, FINDPATTERN
%   and FINDELEMENT.

%B. Van de Sande 21-02-2005

%------------------------------main program-----------------------------------
%Evaluate input arguments ...
if ~isstruct(S), error('First argument should be structure-array.'); end
if ~ischar(Expr), error('Second argument should be character string with conditional expression.'); end

%Filter using a logical expression ...
[Data, FNames] = destruct(S); %Reorganize data ...
idx = find(EvalExpr(ParseExpr(Expr, FNames), Data));
S = S(idx);

%-----------------------------------------------------------------------------