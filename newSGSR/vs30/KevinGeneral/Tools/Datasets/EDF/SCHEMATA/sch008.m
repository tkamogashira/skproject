function D = sch008(fid)

%This is the schema for data collected with the Tuning Curve program (TH). The original DDL can be found
%at http://www.neurophys.wisc.edu/comp/docs/schemas/sch008.html

%The mandatory dataset header must already be read from file ...

NSEQ        = freadVAXG(fid, 1, 'int32');   %No. of values in TH data table
LDATA       = freadVAXG(fid, 1, 'int32');   %Location of DATA table
NCRIT       = freadVAXG(fid, 1, 'int32');   %Threshold criterion number
MAXSPL      = freadVAXG(fid, 1, 'float32');  %Max SPL for TH determination
NSPON       = freadVAXG(fid, 1, 'int32');   %No. of times spon. recorded
MSPON       = freadVAXG(fid, 1, 'float32');  %Mean spontaneous activity count
SDSPON      = freadVAXG(fid, 1, 'float32');  %Std. Dev. of spon. activity cnt
TARSPK      = freadVAXG(fid, 1, 'float32');  %Target Spk cnt. for threshold
TARSYN      = freadVAXG(fid, 1, 'float32');  %Target Sync. coeff. for thresh

FREQ        = readEDFSchVarParam(fid);

MDSS        = freadVAXG(fid, 1, 'int32');   %Master DSS number
NREPMD      = freadVAXG(fid, 1, 'int32');   %No. of reps for Master DSS
NUMDSS      = freadVAXG(fid, 1, 'int32');   %No. of DSSs used
for n = 1:NUMDSS, DSSDAT(n) = readDSSData(fid); end

UNITDEL1    = freadVAXG(fid, 1, 'int32');   %Code for units of DELAY1 (sec=10**code)
UNITDUR1    = freadVAXG(fid, 1, 'int32');   %Code for units of DUR1
UNITDEL2    = freadVAXG(fid, 1, 'int32');   %Code for units of DELAY2
UNITDUR2    = freadVAXG(fid, 1, 'int32');   %Code for units of DUR2
UNITREPI    = freadVAXG(fid, 1, 'int32');   %Code for units of REPINT
UNITDELM    = freadVAXG(fid, 1, 'int32');   %Code for units of DELM
UNITRTIM    = freadVAXG(fid, 1, 'int32');   %Code for units of RTIME
UNITFTIM    = freadVAXG(fid, 1, 'int32');   %Code for units of FTIM

%Extra space for future use
LDUMMY      = freadVAXG(fid, 1, 'int32');
DUMMY       = freadVAXG(fid, LDUMMY, 'int32');

%Spike time data
Nrs = freadVAXG(fid, NSEQ*2, 'float32');           
DATA.FREQ   = Nrs(1:2:end)';             %Frequency
DATA.THSPL  = Nrs(2:2:end)';             %Threshold SPL at THFREQ

D = packSCHFields;

function DSSDAT = readDSSData(fid)

LDSS   = freadVAXG(fid, 1, 'int32');                          %Length of DSSDAT (words) 
MaxPos = (ftell(fid) + 4*(LDSS-1));

DSSN   = freadVAXG(fid, 1, 'int32');                        %DSS number (1 or 2)
MODE   = freadVAXG(fid, 1, 'int32');                        %DSS output mode
MODEX  = freadVAXG(fid, 1, 'int32');                        %external or prog start
MODED1 = freadVAXG(fid, 1, 'int32');                        %Delay-1 mode
MODED2 = freadVAXG(fid, 1, 'int32');                        %Delay-2 mode
MSLAVE = freadVAXG(fid, 1, 'int32');                        %Master or slave mode(1=master,2=slave)
GWNUMP = freadVAXG(fid, 1, 'int32');                        %No. of points in GW waveform
GWCODE = freadVAXG(fid, 1, 'int32');                        %GW waveform type code
GWRES  = freadVAXG(fid, 1, 'float32');                       %GW playback resolution in microsecs
if ftell(fid) < MaxPos, DELAY1 = readEDFVecStr(fid); else DELAY1 = []; end %in microsecs
if ftell(fid) < MaxPos, DUR1   = readEDFVecStr(fid); else DUR1   = []; end %in millisecs
if ftell(fid) < MaxPos, DELAY2 = readEDFVecStr(fid); else DELAY2 = []; end %in microsecs
if ftell(fid) < MaxPos, DUR2   = readEDFVecStr(fid); else DUR2   = []; end %in millisecs
if ftell(fid) < MaxPos, REPINT = readEDFVecStr(fid); else REPINT = []; end %Repetition time in millisecs
if ftell(fid) < MaxPos, DELM   = readEDFVecStr(fid); else DELM   = []; end %Master delay in microsecs
if ftell(fid) < MaxPos, NREPS  = readEDFVecStr(fid); else NREPS  = []; end %No. of repetitions
if ftell(fid) < MaxPos, RENV   = readEDFVecStr(fid); else RENV   = []; end %Rise time envelope shape
if ftell(fid) < MaxPos, RTIME  = readEDFVecStr(fid); else RTIME  = []; end %Rise time in millisecs
if ftell(fid) < MaxPos, FENV   = readEDFVecStr(fid); else FENV   = []; end %Fall time envelope shape
if ftell(fid) < MaxPos, FTIME  = readEDFVecStr(fid); else FTIME  = []; end %Fall time in millisecs
if ftell(fid) < MaxPos, PHASE  = readEDFVecStr(fid); else PHASE  = []; end %Initial phase (0-1)
if ftell(fid) < MaxPos, FMOD   = readEDFVecStr(fid); else FMOD   = []; end %Modulation Freq. (Hz)
if ftell(fid) < MaxPos, PHASM  = readEDFVecStr(fid); else PHASM  = []; end %Modulation Phase (0-1)
if ftell(fid) < MaxPos, DMOD   = readEDFVecStr(fid); else DMOD   = []; end %Depth of Modulation (0-1)
if ftell(fid) < MaxPos, VALM   = readEDFVecStr(fid); else VALM   = []; end %Modulation value (-1 to +1)
if ftell(fid) < MaxPos, VALC   = readEDFVecStr(fid); else VALC   = []; end %Carrier Modulation constant
if ftell(fid) < MaxPos, GWFIL  = readEDFVecStr(fid); else GWFIL  = []; end %Name of GW storage file
if ftell(fid) < MaxPos, GWID   = readEDFVecStr(fid); else GWID   = []; end %ID for General Waveform
if ftell(fid) < MaxPos, GWDS   = readEDFVecStr(fid); else GWDS   = []; end %GW data set number
if ftell(fid) < MaxPos, TONLVL = readEDFVecStr(fid); else TONLVL = []; end %Tone level for mask stimulus(0-1)
if ftell(fid) < MaxPos, GWLVL  = readEDFVecStr(fid); else GWLVL  = []; end %GW level for mask stimulus (0-1)
if ftell(fid) < MaxPos, MSKSTM = readEDFVecStr(fid); else MSKSTM = []; end %Masking Stimulus name (TONE/GW)
if ftell(fid) < MaxPos, MODSTM = readEDFVecStr(fid); else MODSTM = []; end %Modulating waveform (TONE/GW)

fseek(fid, MaxPos, 'bof');
DSSDAT = packSCHFields;