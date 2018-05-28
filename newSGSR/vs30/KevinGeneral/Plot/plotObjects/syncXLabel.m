function xLabel = syncXLabel(ds, iSubSeqs)

[IndepVal, ConstIndepNr] = ExtractIndepVal(ds, iSubSeqs);
if strcmpi(ds.FileFormat, 'EDF') && (ds.indepnr == 2)
    if isnan(ConstIndepNr)
        fprintf('WARNING: No one-dimensional restriction on dataset with more than one independent variable.\n');
        xLabel = 'SubSequence (#)';
    elseif (ConstIndepNr == 1), %First independent variable is held constant ...
        xLabel = [ ds.yname '(' ds.yunit ')'];
    else
        xLabel = [ ds.xname '(' ds.xunit ')']; 
    end
else
    xLabel = [ ds.xname '(' ds.xunit ')'];
end
