function D = sch005(fid)

%This is the schema for general waveforms stored in data files. The original DDL can be found
%at http://www.neurophys.wisc.edu/comp/docs/schemas/sch005.html

%Datasets with identifier 'B32K', 'A8K', 'B8K' of datafile 'N1K32' cannot be loaded, because
%this schema seems to be inapplicable to these datasets ...

%The mandatory dataset header must already be read from file ...

NUMPTS = freadVAXG(fid, 1, 'int32');                       %No. of points in waveform
TRES   = freadVAXG(fid, 1, 'float32');                     %Time resolution in microsecs
GWCODE = freadVAXG(fid, 1, 'int32');                       %Waveform type code
SEED   = freadVAXG(fid, 1, 'int32');                       %Seed used for random no. gen
LOCGW  = freadVAXG(fid, 1, 'int32');                       %Location of waveform (word)
SFORM  = freadVAXG(fid, 1, 'int32');                       %Storage format : 0=real, 1=int*2
MAXDSS = freadVAXG(fid, 1, 'int32');                       %Max no. of DSSs possible
for n = 1:MAXDSS, ESDAT(n) = readEffSPLData(fid); end
NSEG   = freadVAXG(fid, 1, 'int32');                       %Number of segments
LSEG   = freadVAXG(fid, 1, 'int32');                       %Length of each segment (no. of points)
GAPSEG = freadVAXG(fid, 1, 'float32');                     %Inter-Segment gap in millisecs

%Extra space for future use
LDUMMY = freadVAXG(fid, 1, 'int32');
DUMMY  = freadVAXG(fid, LDUMMY, 'int32');

%Starting at word 1 of next block (512 bytes) ...
fseek(fid, ceil(ftell(fid)/512)*512, 'bof');
if SFORM == 0
    GWDATA = double(freadVAXG(fid, NUMPTS, 'float32'))';
else
    GWDATA = double(freadVAXG(fid, NUMPTS, 'int16'))';
end

D = packSCHFields;

function ESDAT = readEffSPLData(fid)

DSSN    = freadVAXG(fid, 1, 'int32');                  %DSS number (1,2,3...)
ESKOD   = freadVAXG(fid, 1, 'int32');                  %Eff. SPL computed ? 0=No, 1=Yes
ESPL    = freadVAXG(fid, 1, 'float32');                %Effective Max SPL
CALIDE  = char(freadVAXG(fid, 12, 'uchar')');          %Calibration ID used
CALDATE = char(freadVAXG(fid, 12, 'uchar')');          %Date of Calibration
TIMESPL = freadVAXG(fid, 1, 'int32');                  %Time Eff SPL computed (in 10ths of secs)

ESDAT = packSCHFields;