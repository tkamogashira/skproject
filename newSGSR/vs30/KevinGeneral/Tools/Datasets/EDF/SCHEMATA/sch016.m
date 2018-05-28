function D = sch016(fid)

%This is the schema for data collected with the search program (SER). The original DDL can be found
%at http://www.neurophys.wisc.edu/comp/docs/schemas/sch016.html

%The mandatory dataset header must already be read from file ...

UDATA  = freadVAXG(fid, 1, 'int32');                       %0=No spike data, 1=Yes spike data 
ADATA  = freadVAXG(fid, 1, 'int32');                       %0=No Analog data,1=Yes Analog data
CDATA  = freadVAXG(fid, 1, 'int32');                       %0=No Cyc. Histogram data, 1=Yes 
SDATA  = freadVAXG(fid, 1, 'int32');                       %0=No Spontaneous Activity, 1=Yes 
PHFLAG = freadVAXG(fid, 1, 'int32');                       %0=Not corrected for phase, 1=Yes
STFORM = freadVAXG(fid, 1, 'int32');                       %STATUS table format code 
NUMPT  = freadVAXG(fid, 1, 'int32');                       %No. of pointers in STATUS table 
LSTAT  = freadVAXG(fid, 1, 'int32');                       %Location of STATUS table 
NSEQ   = freadVAXG(fid, 1, 'int32');                       %No. of sequences in STAT. table

XVAR   = readEDFSchVarParam(fid);
YVAR   = readEDFSchVarParam(fid);
NUMV   = freadVAXG(fid, 1, 'int32');                       %No. of variables
VNAME  = readEDFSchVarNames(fid, NUMV);

MDSS   = freadVAXG(fid, 1, 'int32');                       %Master DSS number 
NREPMD = freadVAXG(fid, 1, 'int32');                       %No. of reps for Master DSS 
NUMDSS = freadVAXG(fid, 1, 'int32');                       %No. of DSSs used 
for n = 1:NUMDSS, DSSDAT(n) = readDSSData(fid); end

TBASE  = freadVAXG(fid, 1, 'float32');                      %UET time base in secs
NUCH   = freadVAXG(fid, 1, 'int32');                       %No. of UET data channels
UETCH  = freadVAXG(fid, NUCH, 'int32');                    %UET channel number
FMCYC  = freadVAXG(fid, 1, 'float32');                      %Number of cycles of FM sweep
ESTCF  = freadVAXG(fid, 1, 'float32');                      %Estimated CF (Hz) for 1st UET channel
ESTCF2 = freadVAXG(fid, 1, 'float32');                      %Estimated CF (Hz) for 2nd UET channel

D = packSCHFields;

function DSSDAT = readDSSData(fid)

DSSN    = freadVAXG(fid, 1, 'int32');          %DSS number (1 or 2)
FREQ    = freadVAXG(fid, 1, 'float32');         %Carrier freq in Hz
MODEX   = freadVAXG(fid, 1, 'int32');          %external or prog start
MODED1  = freadVAXG(fid, 1, 'int32');          %Delay-1 mode
MODED2  = freadVAXG(fid, 1, 'int32');          %Delay-2 mode
MSLAVE  = freadVAXG(fid, 1, 'int32');          %Master or slave mode(1=master,2=slave)
DELAY1  = freadVAXG(fid, 1, 'float32');         %in secs
DUR1    = freadVAXG(fid, 1, 'float32');         %in secs
DELAY2  = freadVAXG(fid, 1, 'float32');         %in secs
DUR2    = freadVAXG(fid, 1, 'float32');         %in secs
REPINT  = freadVAXG(fid, 1, 'float32');         %repetition time in secs
DELM    = freadVAXG(fid, 1, 'float32');         %Master delay in secs
NREPS   = freadVAXG(fid, 1, 'int32');          %No. of repetitions
SPL     = freadVAXG(fid, 1, 'float32');         %Initial SPL (dB)
RTIME   = freadVAXG(fid, 1, 'float32');         %Rise time in secs
FTIME   = freadVAXG(fid, 1, 'float32');         %Fall time in secs
MODE    = freadVAXG(fid, 1, 'int32');          %DSS output mode
PHASE   = freadVAXG(fid, 1, 'float32');         %Initial phase (0-1)
FRLOW   = freadVAXG(fid, 1, 'float32');         %Low Frequency (Hz)
FRHIGH  = freadVAXG(fid, 1, 'float32');         %High Frequency (Hz)
FMRISE  = freadVAXG(fid, 1, 'float32');         %Rise time for FM sweep (secs)
FMDWELL = freadVAXG(fid, 1, 'float32');         %Hold time for FM sweep (secs)
FMFALL  = freadVAXG(fid, 1, 'float32');         %Fall time for FM sweep (secs)
ATTSET  = freadVAXG(fid, 1, 'float32');         %Attenuator setting (dB)
CONSPL  = freadVAXG(fid, 1, 'int32');          %Constant SPL code, 0=No, 1=Yes
SPLCLIP = freadVAXG(fid, 1, 'float32');         %dB range below which calib clipped
DACBITS = freadVAXG(fid, 1, 'int32');          %No. of DAC bits used
DELTFRQ = freadVAXG(fid, 1, 'float32');         %Diff. Freq. (Hz) Actual=FREQ+deltfrq
GWRES   = freadVAXG(fid, 1, 'float32');         %GW playback interval (microsecs)
GWFIL   = char(freadVAXG(fid, 32, 'uchar')');   %Name of GW storage file
GWID    = char(freadVAXG(fid, 12, 'uchar')');   %ID for General Waveform
%FMCYC   = freadVAXG(fid, 1, 'int32');          %Number of cycles of FM sweep

DSSDAT = packSCHFields;