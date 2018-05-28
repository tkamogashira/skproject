function THR = getListTHR(CLO)
% get CF for list assuming there is only one THR

try
    DataFile = CLO.list(1).filename;
    CellNr = CLO.list(1).icell;
    SeqNr = getTHRSeq(DataFile, CellNr);
    ds = dataset(DataFile, SeqNr);
    [THR.CF, THR.SR, THR.THRmin, THR.BW, THR.Qfactor] = EvalTHR(ds, 'plot', 'n');	
catch
    [THR.CF, THR.SR, THR.THRmin, THR.BW, THR.Qfactor] = deal(NaN); %Not a Number
end