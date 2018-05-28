function D = sch006(fid)

%This is the schema for data collected with the Response Area program (RA). The original DDL can be found
%at http://www.neurophys.wisc.edu/comp/docs/schemas/sch006.html

%The mandatory dataset header must already be read from file ...

UDATA  = freadVAXG(fid, 1, 'int32');                       %0=No spike data, 1=Yes spike data 
ADATA  = freadVAXG(fid, 1, 'int32');                       %0=No Analog data,1=Yes Analog data
CDATA  = freadVAXG(fid, 1, 'int32');                       %0=No Cyc. Histogram data, 1=Yes 
SDATA  = freadVAXG(fid, 1, 'int32');                       %0=No Spontaneous Activity, 1=Yes 
STFORM = freadVAXG(fid, 1, 'int32');                       %STATUS table format code 
NUMPT  = freadVAXG(fid, 1, 'int32');                       %No. of pointers in STATUS table 
LSTAT  = freadVAXG(fid, 1, 'int32');                       %Location of STATUS table 
NSEQ   = freadVAXG(fid, 1, 'int32');                       %No. of sequences in STAT. table

for n = 1:3, URATE(n, :) = char(freadVAXG(fid, 4, 'uchar')'); end %Unit rating at three times 

XVAR   = readEDFSchVarParam(fid);
YVAR   = readEDFSchVarParam(fid);
ZVAR   = readEDFSchVarParam(fid);
NUMV   = freadVAXG(fid, 1, 'int32');                       %No. of variables
VNAME  = readEDFSchVarNames(fid, NUMV);

MDSS   = freadVAXG(fid, 1, 'int32');                       %Master DSS number 
NREPMD = freadVAXG(fid, 1, 'int32');                       %No. of reps for Master DSS 
NUMDSS = freadVAXG(fid, 1, 'int32');                       %No. of DSSs used 
for n = 1:NUMDSS, DSSDAT(n) = readDSSData(fid); end

TBASE    = freadVAXG(fid, 1, 'float32');                   %UET time base in secs 
ISDEL    = readEDFVecStr(fid);                         %Inter-sequence delay in millisecs 
IXDEL    = readEDFVecStr(fid);                         %Inter-Xvar delay in millisecs 
UNITDEL1 = freadVAXG(fid, 1, 'int32');                     %Code for units of DELAY1 (sec=10**code) 
UNITDUR1 = freadVAXG(fid, 1, 'int32');                     %Code for units of DUR1 
UNITDEL2 = freadVAXG(fid, 1, 'int32');                     %Code for units of DELAY2 
UNITDUR2 = freadVAXG(fid, 1, 'int32');                     %Code for units of DUR2 
UNITREPI = freadVAXG(fid, 1, 'int32');                     %Code for units of REPINT 
UNITDELM = freadVAXG(fid, 1, 'int32');                     %Code for units of DELM 
UNITRTIM = freadVAXG(fid, 1, 'int32');                     %Code for units of RTIME 
UNITFTIM = freadVAXG(fid, 1, 'int32');                     %Code for units of FTIM 
UNITFMR  = freadVAXG(fid, 1, 'int32');                     %Code for units of FMRISE 
UNITFMD  = freadVAXG(fid, 1, 'int32');                     %Code for units of FMDWELL 
UNITFMF  = freadVAXG(fid, 1, 'int32');                     %Code for units of FMFALL 
UNITTBAS = freadVAXG(fid, 1, 'int32');                     %Code for units of TBASE 
UNITISD  = freadVAXG(fid, 1, 'int32');                     %Code for units of ISDEL 
UNITIXD  = freadVAXG(fid, 1, 'int32');                     %Code for units of IXDEL 
NUCH     = freadVAXG(fid, 1, 'int32');                     %No. of UET data channels 
UETCH    = freadVAXG(fid, NUCH, 'int32');                  %UET channel number 
ASAMPT   = freadVAXG(fid, 1, 'float32');                    %Analog sampling time in secs 
ABUF     = freadVAXG(fid, 1, 'int32');                     %No. of points per cycle 
ANCYC    = freadVAXG(fid, 1, 'int32');                     %No. of cycles sampled 
ANSEP    = freadVAXG(fid, 1, 'int32');                     %Actual no. of cycles stored/stim point 
AVCODE   = freadVAXG(fid, 1, 'int32');                     %0=No averaging, 1=Yes averaging 
AVOLC    = freadVAXG(fid, 1, 'float32');                    %Voltage conversion factor 
AVCC     = freadVAXG(fid, 1, 'float32');                    %Voltage Conversion Code 
ANBITS   = freadVAXG(fid, 1, 'int32');                     %No. of bits per sample 16/32 
NACH     = freadVAXG(fid, 1, 'int32');                     %No. of A/D channels 
ADCH     = freadVAXG(fid, NACH, 'int32');                  %A/D Channel number 

D = packSCHFields;

function DSSDAT = readDSSData(fid)

LDSS    = freadVAXG(fid, 1, 'int32');                         %Length of DSSDAT (words) 
MaxPos  = (ftell(fid) + 4*(LDSS-1));

DSSN    = freadVAXG(fid, 1, 'int32');                         %DSS number (1 or 2) 
MODE    = freadVAXG(fid, 1, 'int32');                         %DSS output mode 
MODEX   = freadVAXG(fid, 1, 'int32');                         %external or prog start 
MODED1  = freadVAXG(fid, 1, 'int32');                         %Delay-1 mode 
MODED2  = freadVAXG(fid, 1, 'int32');                         %Delay-2 mode 
MSLAVE  = freadVAXG(fid, 1, 'int32');                         %Master or slave mode(1=master,2=slave) 
CONSPL  = freadVAXG(fid, 1, 'int32');                         %Constant SPL code, 0=No, 1=Yes 
PHFLAG  = freadVAXG(fid, 1, 'int32');                         %0=Not corrected for phase, 1=Yes 
GWNUMP  = freadVAXG(fid, 1, 'int32');                         %No. of points in GW waveform 
GWCORR  = freadVAXG(fid, 1, 'int32');                         %if 1 then GW corrected for calib
GWCODE  = freadVAXG(fid, 1, 'int32');                         %GW waveform type code, or CNOIS type 
GWUNF   = freadVAXG(fid, 1, 'int32');                         %GW noise 0=frozen, 1=unfrozen 
GWSINC  = freadVAXG(fid, 1, 'int32');                         %GW start increment in no. points 
GWDIFF  = freadVAXG(fid, 1, 'int32');                         %GW address diff for Cosine Noise 
GWRES   = freadVAXG(fid, 1, 'float32');                       %GW playback resolution in microsecs 
CALID   = char(freadVAXG(fid, 12, 'uchar')');                 %Calib ID used for correction 
if ftell(fid) < MaxPos, FREQ     = readEDFVecStr(fid); else, FREQ     = []; end %Carrier freq in Hz 
if ftell(fid) < MaxPos, DELAY1   = readEDFVecStr(fid); else, DELAY1   = []; end %in microsecs 
if ftell(fid) < MaxPos, DUR1     = readEDFVecStr(fid); else, DUR1     = []; end %in millisecs 
if ftell(fid) < MaxPos, DELAY2   = readEDFVecStr(fid); else, DELAY2   = []; end %in microsecs 
if ftell(fid) < MaxPos, DUR2     = readEDFVecStr(fid); else, DUR2     = []; end %in millisecs 
if ftell(fid) < MaxPos, REPINT   = readEDFVecStr(fid); else, REPINT   = []; end %Repetition time in millisecs 
if ftell(fid) < MaxPos, DELM     = readEDFVecStr(fid); else, DELM     = []; end %Master delay in microsecs 
if ftell(fid) < MaxPos, NREPS    = readEDFVecStr(fid); else, NREPS    = []; end %No. of repetitions 
if ftell(fid) < MaxPos, SPL      = readEDFVecStr(fid); else, SPL      = []; end %Initial SPL (dB) 
if ftell(fid) < MaxPos, RENV     = readEDFVecStr(fid); else, RENV     = []; end %Rise time envelope shape 
if ftell(fid) < MaxPos, RTIME    = readEDFVecStr(fid); else, RTIME    = []; end %Rise time in millisecs 
if ftell(fid) < MaxPos, FENV     = readEDFVecStr(fid); else, FENV     = []; end %Fall time envelope shape 
if ftell(fid) < MaxPos, FTIME    = readEDFVecStr(fid); else, FTIME    = []; end %Fall time in millisecs 
if ftell(fid) < MaxPos, PHASE    = readEDFVecStr(fid); else, PHASE    = []; end %Initial phase (0-1) 
if ftell(fid) < MaxPos, FMOD     = readEDFVecStr(fid); else, FMOD     = []; end %Modulation Freq. (Hz) 
if ftell(fid) < MaxPos, PHASM    = readEDFVecStr(fid); else, PHASM    = []; end %Modulation Phase (0-1) 
if ftell(fid) < MaxPos, DMOD     = readEDFVecStr(fid); else, DMOD     = []; end %Depth of Modulation (0-1) 
if ftell(fid) < MaxPos, VALM     = readEDFVecStr(fid); else, VALM     = []; end %Modulation value (-1 to +1) 
if ftell(fid) < MaxPos, VALC     = readEDFVecStr(fid); else, VALC     = []; end %Carrier Modulation constant 
if ftell(fid) < MaxPos, FRLOW    = readEDFVecStr(fid); else, FRLOW    = []; end %Low Frequency (Hz) 
if ftell(fid) < MaxPos, FRHIGH   = readEDFVecStr(fid); else, FRHIGH   = []; end %High Frequency (Hz) 
if ftell(fid) < MaxPos, FMRISE   = readEDFVecStr(fid); else, FMRISE   = []; end %Rise time for FM sweep (msecs) 
if ftell(fid) < MaxPos, FMDWELL  = readEDFVecStr(fid); else, FMDWELL  = []; end %Hold time for FM sweep (msecs) 
if ftell(fid) < MaxPos, FMFALL   = readEDFVecStr(fid); else, FMFALL   = []; end %Fall time for FM sweep (msecs) 
if ftell(fid) < MaxPos, ATTSET   = readEDFVecStr(fid); else, ATTSET   = []; end %Attenuator setting (dB) 
if ftell(fid) < MaxPos, GWFIL    = readEDFVecStr(fid); else, GWFIL    = []; end %Name of GW storage file 
if ftell(fid) < MaxPos, GWID     = readEDFVecStr(fid); else, GWID     = []; end %ID for General Waveform 
if ftell(fid) < MaxPos, GWDS     = readEDFVecStr(fid); else, GWDS     = []; end %GW data set number (or, speaker #) 
if ftell(fid) < MaxPos, TONLVL   = readEDFVecStr(fid); else, TONLVL   = []; end %Tone level,mask stim(0-1, or dB UP) 
if ftell(fid) < MaxPos, GWLVL    = readEDFVecStr(fid); else, GWLVL    = []; end %GW level for mask stimulus (0-1) 
if ftell(fid) < MaxPos, MSKSTM   = readEDFVecStr(fid); else, MSKSTM   = []; end %Masking Stimulus name (TONE/GW) 
if ftell(fid) < MaxPos, MODSTM   = readEDFVecStr(fid); else, MODSTM   = []; end %Modulating waveform (TONE/GW) 

fseek(fid, MaxPos, 'bof');
DSSDAT = packSCHFields;