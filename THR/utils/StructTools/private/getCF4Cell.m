function CF = getCF4Cell(DataFile, CellNr)

%B. Van de Sande 29-08-2003

SeqNr = getTHRSeq(DataFile, CellNr);
ds = dataset(DataFile, SeqNr);
CF = EvalTHR(ds, 'plot', 'n');