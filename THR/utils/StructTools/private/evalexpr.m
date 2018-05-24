function Value = EvalExpr(Expr, Data)

%B. Van de Sande 13-08-2005

%Check input arguments ...
if (nargin ~= 2), error('Wrong number of input arguments.'); end
if ~iscell(Expr) | (size(Expr, 1) ~= 1), error('First argument should be cell-array with semi-parsed expression.'); end
if ~iscell(Data), error('Second argument should be cell-array with flattened structure-array.'); end

%Parse expression ...
idxFields = find(cellfun('isclass', Expr, 'double')); 
FieldNrs = cat(1, Expr{idxFields}); NFields = length(FieldNrs);

idx = find(all(cellfun('isclass', Data(:, FieldNrs), 'double'), 1));
idxNumFields = idxFields(idx); NumFieldNrs = FieldNrs(idx);
NumNFields = length(NumFieldNrs);

%Numerical fields can only contain column- or rowvectors, matrices are not allowed. This
%restriction is necessary because during row per row evaluation each numerical vector is
%columnized ...
testIdx = (cellfun('size', Data(:, NumFieldNrs), 1) > 1) & (cellfun('size', Data(:, NumFieldNrs), 2) > 1);
if any(testIdx(:)), error('Numerical values in a structure-array can only be row- or columnvectors.'); end    

%OtherFieldNrs = setdiff(FieldNrs, NumFieldNrs);
%Changed on 10-08-2005 to: (sometimes the same fieldnumber is referenced more than once in
%an expression, which makes SETDIFF not useable because of its duplicate removal function)
OtherFieldNrs = FieldNrs(find(~ismember(FieldNrs, NumFieldNrs)));
idxOtherFields = setdiff(idxFields, idxNumFields); 
OtherNFields = NFields - NumNFields;

if (nargout == 0), %Execute statement ...
    %Structure-array must have size of only one row ...
    if (size(Data, 1) ~= 1), error('For statement execution the structure-array must only have one row.'); end
    %Adjust expression, all fields are replaced by content cell-array references,
    %including character strings ...
    for n = 1:NFields, Expr{idxFields(n)} = sprintf('(Data{%d})', FieldNrs(n)); end
    eval(cat(2, Expr{:}));
else, %Evaluate expression ...
    %Check if expression is vectorizable, i.e. when all numerical fields in the expression
    %can be horizontally concatenated to matrices. Fields containing character strings are
    %ignored. If an expression only contains character string fieldnames then the iteration
    %is bypasses and the expresion evaluated as vectorizable. If the supplied cell-array has
    %only one row, then vectorization is useless ...
    isVectorizable = (size(Data, 1) ~= 1); n = 1; %Optimistic approach ...
    while (isVectorizable & (n <= NumNFields)),
        if ~all((cellfun('size', Data(:, NumFieldNrs(n)), 1) == 1)) | ...
                (length(unique(cellfun('size', Data(:, NumFieldNrs(n)), 2))) ~= 1),
            isVectorizable = logical(0);
        end
        n = n + 1;
    end
    %If the expression is vectorizable, the expression is adjusted so that fieldname
    %references are replaced by the appropriate references to the variable Data ...
    %Even if the expression is assessed as vectorizable, the expression is evaluated
    %in a try block so that if evaluation fails the row-by-row evaluation is preformed.
    %This can happen if the user writes an expression that depends on scalar expansion,
    %e.g. '$rowvector$ - $scalar$', and the rowvectors all have the same length by 
    %coincidence ...
    try,
        if ~isVectorizable, error('To catch block ...'); end
        for n = 1:NFields,
            if all(cellfun('isclass', Data(:, FieldNrs(n)), 'double')), %Must be vectorizable ...
                Expr{idxFields(n)} = sprintf('(cat(1, Data{:, %d}))', FieldNrs(n));
            else, Expr{idxFields(n)} = sprintf('(Data(:, %d))', FieldNrs(n)); end
        end
        Value = eval(cat(2, Expr{:}));
    %Not vectorizable expressions are evaluated very slow, because these expressions are
    %processed row by row ...
    catch,
        NRow = size(Data, 1); Value = cell(NRow, 1); %Pre-allocation ...
        if (NRow == 1),
            %Adjust expression, all fields are replaced by content cell-array references,
            %including character strings. Numerical fields can only contain row- or 
            %columnvectors, because all references to a numerical vector are translated
            %to columnvectors in the expression ...
            for f = 1:NumNFields,
                Expr{idxNumFields(f)} = sprintf('(Data{1, %d}(:)'')', NumFieldNrs(f));
            end
            for f = 1:OtherNFields,
                Expr{idxOtherFields(f)} = sprintf('(Data{1, %d})', OtherFieldNrs(f)); 
            end
            Value{1} = eval(cat(2, Expr{:}));
        else,
            for n = 1:NRow,
                %Adjust expression, numerical fields are replaced by content cell-array references
                %while all other fields, including character strings, are cell-array referenced ...
                %Numerical fields can only contain row- or columnvectors, because all references
                %to a numerical vector are translated to columnvectors in the expression ...
                RowExpr = Expr;
                for f = 1:NumNFields, 
                    RowExpr{idxNumFields(f)} = sprintf('(Data{%d, %d}(:)'')', n, NumFieldNrs(f));
                end
                for f = 1:OtherNFields, 
                    RowExpr{idxOtherFields(f)} = sprintf('(Data(%d, %d))', n, OtherFieldNrs(f)); 
                end
                Value{n} = eval(cat(2, RowExpr{:}));
            end
        end
        
        %Can resulting value be concatenated to a matrix?
        if all(cellfun('isclass', Value, 'double')) & all((cellfun('size', Value, 1) == 1)) & ...
                (length(unique(cellfun('size', Value, 2))) == 1),
            Value = cat(1, Value{:});
        end
    end
end