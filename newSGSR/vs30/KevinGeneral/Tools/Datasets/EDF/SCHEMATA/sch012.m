function D = sch012(fid)

%This is the schema for data collected with the Response Area program (RA). The original DDL can be found
%at http://www.neurophys.wisc.edu/comp/docs/schemas/sch012.html

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

TBASE    = freadVAXG(fid, 1, 'float32');                    %UET time base in secs 
ISDEL    = readEDFVecStr(fid);                          %Inter-sequence delay in millisecs 
IXDEL    = readEDFVecStr(fid);                          %Inter-Xvar delay in millisecs 
CPICD    = readEDFVecStr(fid);                          %Click pair, Inter click delay (msecs) 
CPITD1   = readEDFVecStr(fid);                          %Click pair, First click delay (usecs) 
CPITD2   = readEDFVecStr(fid);                          %Click pair, Second click delay (usecs) 
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
UNITICD  = freadVAXG(fid, 1, 'int32');                     %Code for units of ICD 
UNITITD1 = freadVAXG(fid, 1, 'int32');                     %Code for units of ITD1 
UNITITD2 = freadVAXG(fid, 1, 'int32');                     %Code for units of ITD2 
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
GWESPL  = freadVAXG(fid, 1, 'int32');                         %if 1 then Eff. SPL used for GW 
GWCODE  = freadVAXG(fid, 1, 'int32');                         %GW waveform type code, or CNOIS type 
GWUNF   = freadVAXG(fid, 1, 'int32');                         %GW noise 0=frozen, 1=unfrozen 
GWSINC  = freadVAXG(fid, 1, 'int32');                         %GW start increment in no. points 
GWDIFF  = freadVAXG(fid, 1, 'int32');                         %GW address diff for Cosine Noise 
ZPNUMP  = freadVAXG(fid, 1, 'int32');                         %No. of points in ZP waveform 
RNSEED  = freadVAXG(fid, 1, 'int32');                         %Seed for random number generator 
ZPNBPR  = freadVAXG(fid, 1, 'int32');                         %1=bandpass, 2=band-reject ZP noise 
GWRES   = freadVAXG(fid, 1, 'float32');                        %GW playback resolution in microsecs 
SPLCLIP = freadVAXG(fid, 1, 'float32');                        %dB range below which calib clipped 
EFFSPL  = freadVAXG(fid, 1, 'float32');                        %Eff. Max SPL of GW or ZP waveform 
EFFT1   = freadVAXG(fid, 1, 'float32');                        %Start time for eff SPL comp (msecs) 
EFFT2   = freadVAXG(fid, 1, 'float32');                        %Stop time for eff SPL comp (msecs) 
CALID   = char(freadVAXG(fid, 12, 'uchar')');                  %Calib ID used for correction 
CPPN    = char(freadVAXG(fid, 4, 'uchar')');                   %Click pair - POSitive or NEGative 
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
if ftell(fid) < MaxPos, ZPNLF    = readEDFVecStr(fid); else, ZPNLF    = []; end %Low freq cutoff for ZP noise (Hz) 
if ftell(fid) < MaxPos, ZPNHF    = readEDFVecStr(fid); else, ZPNHF    = []; end %High freq cutoff for ZP noise (Hz) 
if ftell(fid) < MaxPos, ZPNLFS   = readEDFVecStr(fid); else, ZPNLFS   = []; end %Low freq slope for ZP noise (dB/oct)
if ftell(fid) < MaxPos, ZPNHFS   = readEDFVecStr(fid); else, ZPNHFS   = []; end %High freq slop for ZP noise (dB/oct)
if ftell(fid) < MaxPos, ZPAMC1   = readEDFVecStr(fid); else, ZPAMC1   = []; end %ZP - computed AM - component-1 
if ftell(fid) < MaxPos, ZPAMC2   = readEDFVecStr(fid); else, ZPAMC2   = []; end %ZP - computed AM - component-2 
if ftell(fid) < MaxPos, ZPAMC3   = readEDFVecStr(fid); else, ZPAMC3   = []; end %ZP - computed AM - component-3 
if ftell(fid) < MaxPos, CPCW     = readEDFVecStr(fid); else, CPCW     = []; end %Click pair click width (microsecs) 
if ftell(fid) < MaxPos, GPGWI1   = readEDFVecStr(fid); else, GPGWI1   = []; end %ID for 1st waveform (GW pair expt) 
if ftell(fid) < MaxPos, GPGWI2   = readEDFVecStr(fid); else, GPGWI2   = []; end %ID for 2nd waveform (GW pair expt) 
if ftell(fid) < MaxPos, GPDUR1   = readEDFVecStr(fid); else, GPDUR1   = []; end %Duration of 1st wave (msecs) (GWP expt) 
if ftell(fid) < MaxPos, GPDUR2   = readEDFVecStr(fid); else, GPDUR2   = []; end %Duration of 2nd wave (msecs) (GWP expt) 
if ftell(fid) < MaxPos, PHASLSB  = readEDFVecStr(fid); else, PHASLSB  = []; end %Phase of lower side-band (0-1) (CAM) 
if ftell(fid) < MaxPos, PHASUSB  = readEDFVecStr(fid); else, PHASUSB  = []; end %Phase of upper side-band (0-1) (CAM) 
if ftell(fid) < MaxPos, CAMACORR = readEDFVecStr(fid); else, CAMACORR = []; end %if Y then CAM corrected for amp calib 
if ftell(fid) < MaxPos, CAMPCORR = readEDFVecStr(fid); else, CAMPCORR = []; end %if Y then CAM corrected for phs calib 
if ftell(fid) < MaxPos, SPKNUM   = readEDFVecStr(fid); else, SPKNUM   = []; end %Speaker number for free-field expt 
if ftell(fid) < MaxPos, VSMC     = readEDFVecStr(fid); else, VSMC     = []; end %VS manipulation code (1,2,3..etc.) 
if ftell(fid) < MaxPos, FFHRTF   = readEDFVecStr(fid); else, FFHRTF   = []; end %Free-field HRTF file name 
if ftell(fid) < MaxPos, VSWVTYP  = readEDFVecStr(fid); else, VSWVTYP  = []; end %VS or SYN waveform type (CLICK or GW) 
if ftell(fid) < MaxPos, AZIMTH   = readEDFVecStr(fid); else, AZIMTH   = []; end %Azimuth for VS (degrees) 
if ftell(fid) < MaxPos, ELEVTN   = readEDFVecStr(fid); else, ELEVTN   = []; end %Elevation for VS (degrees) 
if ftell(fid) < MaxPos, GAUFILT  = readEDFVecStr(fid); else, GAUFILT  = []; end %Gaussian filter for VS (Y/N) 
if ftell(fid) < MaxPos, GAUFCF   = readEDFVecStr(fid); else, GAUFCF   = []; end %Center Freq. for Gaus.Filt for VS (Hz) 
if ftell(fid) < MaxPos, GAUFBW   = readEDFVecStr(fid); else, GAUFBW   = []; end %3dB Bandwidth for Gaus.Filt (Octaves) 
if ftell(fid) < MaxPos, NOTYPE   = readEDFVecStr(fid); else, NOTYPE   = []; end %Notch Type (POON/EXP/LIN) for SYN 
if ftell(fid) < MaxPos, NOTCF    = readEDFVecStr(fid); else, NOTCF    = []; end %Notch Center Freq for SYN (Hz) 
if ftell(fid) < MaxPos, NOTBW    = readEDFVecStr(fid); else, NOTBW    = []; end %Notch 10dB bandwidth for SYN (Hz) 
if ftell(fid) < MaxPos, NOTDEP   = readEDFVecStr(fid); else, NOTDEP   = []; end %Notch Depth for SYN (dB) 
if ftell(fid) < MaxPos, FLATCAL  = readEDFVecStr(fid); else, FLATCAL  = []; end %Waveform flattened with calib. (Y/N) 
if ftell(fid) < MaxPos, SRVNODE  = readEDFVecStr(fid); else, SRVNODE  = []; end %Remote compute server node name 
if ftell(fid) < MaxPos, WAVSRC   = readEDFVecStr(fid); else, WAVSRC   = []; end %Waveform source (COMP or FILE) 
if ftell(fid) < MaxPos, CDUR     = readEDFVecStr(fid); else, CDUR     = []; end %Compute duration of waveform(millisec) 
if ftell(fid) < MaxPos, WAVUFC   = readEDFVecStr(fid); else, WAVUFC   = []; end %Upper Freq. cutoff for comp. wave (Hz) 
if ftell(fid) < MaxPos, BPFILT   = readEDFVecStr(fid); else, BPFILT   = []; end %Band-pass filter ? (Y or N) 
if ftell(fid) < MaxPos, BPFCF    = readEDFVecStr(fid); else, BPFCF    = []; end %Bandpass filter Center Freq. (Hz) 
if ftell(fid) < MaxPos, BPFBWU   = readEDFVecStr(fid); else, BPFBWU   = []; end %Bandpass filt Bandwidth units (HZ/OCT) 
if ftell(fid) < MaxPos, BPFBW    = readEDFVecStr(fid); else, BPFBW    = []; end %Bandpass filt Bandwidth (in Hz or Oct) 
if ftell(fid) < MaxPos, B2NCF2   = readEDFVecStr(fid); else, B2NCF2   = []; end %2-Band Noise Center Freq-2 (Hz) 
if ftell(fid) < MaxPos, B2NBW2   = readEDFVecStr(fid); else, B2NBW2   = []; end %2-Band Noise Bandwidth-2 (Hz) 
if ftell(fid) < MaxPos, B2NMF2   = readEDFVecStr(fid); else, B2NMF2   = []; end %2-Band Noise Modulation_freq-2 (Hz) 
if ftell(fid) < MaxPos, B2NMD2   = readEDFVecStr(fid); else, B2NMD2   = []; end %2-Band Noise Modulation_depth-2 (0-2) 
if ftell(fid) < MaxPos, B2NMP2   = readEDFVecStr(fid); else, B2NMP2   = []; end %2-Band Noise Modulation_pahse-2 (0-1) 
if ftell(fid) < MaxPos, B2NB2LVL = readEDFVecStr(fid); else, B2NB2LVL = []; end %2-Band Noise Second Band Level (dB) 
if ftell(fid) < MaxPos, CSPECL   = readEDFVecStr(fid); else, CSPECL   = []; end %Spectrum level held constant (Y or N) 
if ftell(fid) < MaxPos, SPECLVL  = readEDFVecStr(fid); else, SPECLVL  = []; end %Constant Spectrum level (dB/Hz) 
if ftell(fid) < MaxPos, ITD1     = readEDFVecStr(fid); else, ITD1     = []; end %Initial ITD for shifted GEWAB (usecs) 
if ftell(fid) < MaxPos, ITD2     = readEDFVecStr(fid); else, ITD2     = []; end %Final ITD for shifted GEWAB (usecs) 
if ftell(fid) < MaxPos, ITDRATE  = readEDFVecStr(fid); else, ITDRATE  = []; end %ITD rate for shifted GEWAB (usec/sec) 
if ftell(fid) < MaxPos, ADTYP    = readEDFVecStr(fid); else, ADTYP    = []; end %Adapter Type for SSF (e.g. TONE/GW) 
if ftell(fid) < MaxPos, ADFREQ   = readEDFVecStr(fid); else, ADFREQ   = []; end %Adapter Freq for SSF (Hz) 
if ftell(fid) < MaxPos, ADDUR    = readEDFVecStr(fid); else, ADDUR    = []; end %Adapter Duration for SSF (millisecs) 
if ftell(fid) < MaxPos, ADSPL    = readEDFVecStr(fid); else, ADSPL    = []; end %Adapter SPL for SSF (dB) 
if ftell(fid) < MaxPos, SILINT   = readEDFVecStr(fid); else, SILINT   = []; end %Silent Interval for SSF (millisecs) 
if ftell(fid) < MaxPos, TGFREQ   = readEDFVecStr(fid); else, TGFREQ   = []; end %Target CF for SSF (Hz) 
if ftell(fid) < MaxPos, TGF0     = readEDFVecStr(fid); else, TGF0     = []; end %Target F0 for SSF (Hz) 
if ftell(fid) < MaxPos, TGDUR    = readEDFVecStr(fid); else, TGDUR    = []; end %Target Duration for SSF (millisecs) 
if ftell(fid) < MaxPos, TGNUMH   = readEDFVecStr(fid); else, TGNUMH   = []; end %Target Number of Harmonics for SSF 
if ftell(fid) < MaxPos, TGSLOP   = readEDFVecStr(fid); else, TGSLOP   = []; end %Target Filter Slope for SSF (dB/oct) 
if ftell(fid) < MaxPos, TGSPL    = readEDFVecStr(fid); else, TGSPL    = []; end %Target SPL for SSF (dB) 
if ftell(fid) < MaxPos, FILTYP   = readEDFVecStr(fid); else, FILTYP   = []; end %Filter Type for Stimulus (e.g. KLATT or NONE)

fseek(fid, MaxPos, 'bof');
DSSDAT = packSCHFields;