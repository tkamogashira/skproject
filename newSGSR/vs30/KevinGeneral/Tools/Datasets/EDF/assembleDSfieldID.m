function ID = assembleDSfieldID(FileName, FullFileName, LUT)

%B. Van de Sande 04-12-2003

ID.FileName     = upper(FileName);
ID.FileFormat   = 'EDF';
ID.FullFileName = FullFileName;
ID.iSeq         = LUT.iSeq;
ID.StimType     = upper(LUT.ExpType);
ID.iCell        = extractiCellfromIDstr(LUT.IDstr);
ID.SeqID        = upper(LUT.IDstr);
ID.Time         = LUT.RecTime;
ID.Place        = 'University of Wisconsin (Madison)';
ID.Experimenter = '';

%-----------------------------------------------local functions--------------------------------------------------
function iCell = extractiCellfromIDstr(IDstr)

idx = findstr(IDstr, '-');
if ~isempty(idx)
    iCell = str2num(IDstr(1:idx-1));
    if isempty(iCell) | ~isequal(0, imag(iCell)) % only take real numbers!
        iCell = NaN; 
    end
else
    iCell = NaN; 
end