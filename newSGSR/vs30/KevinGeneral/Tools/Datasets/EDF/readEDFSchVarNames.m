function VNAME  = readEDFSchVarNames(fid, NUMV)

VNAME = char(freadVAXG(fid, 8*NUMV, 'uchar'));
VNAME = reshape(VNAME, 8, NUMV)';