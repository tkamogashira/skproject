function DSS = assembleDSfieldDSS(DSSParam)

%B. Van de Sande 07-08-2003

DSS(1).Nr   = DSSParam.MasterNr;
DSS(1).Mode = DSSParam.MasterMode;

if DSSParam.Nr > 1,
    DSS(2).Nr   = DSSParam.SlaveNr;
    DSS(2).Mode = DSSParam.SlaveMode;
end    