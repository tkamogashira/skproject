function D = calib(fid)

%This is the schema for data collected with the calibration program (NEUCAL). The original DDL can be found
%at http://www.neurophys.wisc.edu/comp/docs/schemas/calib.html

%The mandatory dataset header must already be read from file ...

FREQ.LOW  = freadVAXG(fid, 1, 'float32');           %Frequency range and increment
FREQ.HIGH = freadVAXG(fid, 1, 'float32');           %in Hz
FREQ.INC  = freadVAXG(fid, 1, 'float32');

NTIMES    = freadVAXG(fid, 1, 'int32');             %No. of frequencies
DSSN      = freadVAXG(fid, 1, 'int32');             %DSS number
RFTIME    = freadVAXG(fid, 1, 'float32');           %Rise/Fall time (secs)
NHARM     = freadVAXG(fid, 1, 'int32');             %No. of harmonics (incl fund.)
CORCRV    = char(freadVAXG(fid, 12, 'uchar')');     %Correction curve name

LDUMMY    = freadVAXG(fid, 1, 'int32');
DUMMY     = freadVAXG(fid, LDUMMY, 'int32');

%Data stored so phase and amplitude alternate
Nrs = freadVAXG(fid, 2*NHARM*NTIMES, 'float32');
Tmp = reshape(Nrs, 2*NHARM, NTIMES);

DATA.CALDAT.SPLMAX = Tmp([1:2:end], :);
DATA.CALDAT.PHASE  = Tmp([2:2:end], :);

D = packSCHFields;
