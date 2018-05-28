function INDEPVAR = readEDFSchVarParam(fid)

LOW    = freadVAXG(fid, 1, 'float32');
HIGH   = freadVAXG(fid, 1, 'float32');
INC    = freadVAXG(fid, 1, 'float32');             %Step size (if linear incr) 
SOCT   = freadVAXG(fid, 1, 'float32');             %Steps per Octave (if log incr) 
LOGLIN = freadVAXG(fid, 1, 'uint32');              %1=Linear steps, 2=Log steps 
OPRES  = freadVAXG(fid, 1, 'uint32');              %Order of Presentation 

INDEPVAR = CollectInStruct(LOW, HIGH, INC, SOCT, LOGLIN, OPRES);