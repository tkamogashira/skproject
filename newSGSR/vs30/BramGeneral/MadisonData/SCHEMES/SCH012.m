function Data = SCH012(fid)

% Verplichte DSHeader structuur moet reeds ingeladen zijn ...
% Informatie afkomstig van http://www.neurophys.wisc.edu/comp/docs/schemas/sch012.html
UDATA  = freadVAXG(fid, 1, 'uint32');                       % 0=No spike data, 1=Yes spike data 
ADATA  = freadVAXG(fid, 1, 'uint32');                       % 0=No Analog data,1=Yes Analog data
CDATA  = freadVAXG(fid, 1, 'uint32');                       % 0=No Cyc. Histogram data, 1=Yes 
SDATA  = freadVAXG(fid, 1, 'uint32');                       % 0=No Spontaneous Activity, 1=Yes 
STFORM = freadVAXG(fid, 1, 'uint32');                       % STATUS table format code 
NUMPT  = freadVAXG(fid, 1, 'uint32');                       % No. of pointers in STATUS table 
LSTAT  = freadVAXG(fid, 1, 'uint32');                       % Location of STATUS table 
NSEQ   = freadVAXG(fid, 1, 'uint32');                       % No. of sequences in STAT. table
for N = 1:3, URATE(N, :) = char(freadVAXG(fid, 4, 'uchar')'); end % Unit rating at three times 
XVAR = ReadIndepVar(fid);
YVAR = ReadIndepVar(fid);
ZVAR = ReadIndepVar(fid);
NUMV = freadVAXG(fid, 1, 'uint32');                         % No. of variables
for N = 1:NUMV, 
    varname = char(freadVAXG(fid, 8, 'uchar')'); 
    VNAME(N, :) =  [varname, blanks(8 - length(varname))]; % Variable name
end  
MDSS   = freadVAXG(fid, 1, 'uint32');                       % Master DSS number 
NREPMD = freadVAXG(fid, 1, 'uint32');                       % No. of reps for Master DSS 
NUMDSS = freadVAXG(fid, 1, 'uint32');                       % No. of DSSs used 
for N = 1:NUMDSS, DSSDAT(N) = ReadDSSDat(fid); end
TBASE = freadVAXG(fid, 1, 'float32');                       % UET time base in secs 
ISDEL = ReadVectorString(fid);                           % Inter-sequence delay in millisecs 
IXDEL = ReadVectorString(fid);                           % Inter-Xvar delay in millisecs 
CPICD = ReadVectorString(fid);                           % Click pair, Inter click delay (msecs) 
CPITD1 = ReadVectorString(fid);                          % Click pair, First click delay (usecs) 
CPITD2 = ReadVectorString(fid);                          % Click pair, Second click delay (usecs) 
UNITDEL1 = freadVAXG(fid, 1, 'uint32');                     % Code for units of DELAY1 (sec=10**code) 
UNITDUR1 = freadVAXG(fid, 1, 'uint32');                     % Code for units of DUR1 
UNITDEL2 = freadVAXG(fid, 1, 'uint32');                     % Code for units of DELAY2 
UNITDUR2 = freadVAXG(fid, 1, 'uint32');                     % Code for units of DUR2 
UNITREPI = freadVAXG(fid, 1, 'uint32');                     % Code for units of REPINT 
UNITDELM = freadVAXG(fid, 1, 'uint32');                     % Code for units of DELM 
UNITRTIM = freadVAXG(fid, 1, 'uint32');                     % Code for units of RTIME 
UNITFTIM = freadVAXG(fid, 1, 'uint32');                     % Code for units of FTIM 
UNITFMR  = freadVAXG(fid, 1, 'uint32');                     % Code for units of FMRISE 
UNITFMD  = freadVAXG(fid, 1, 'uint32');                     % Code for units of FMDWELL 
UNITFMF  = freadVAXG(fid, 1, 'uint32');                     % Code for units of FMFALL 
UNITTBAS = freadVAXG(fid, 1, 'uint32');                     % Code for units of TBASE 
UNITISD  = freadVAXG(fid, 1, 'uint32');                     % Code for units of ISDEL 
UNITIXD  = freadVAXG(fid, 1, 'uint32');                     % Code for units of IXDEL 
UNITICD  = freadVAXG(fid, 1, 'uint32');                     % Code for units of ICD 
UNITITD1 = freadVAXG(fid, 1, 'uint32');                     % Code for units of ITD1 
UNITITD2 = freadVAXG(fid, 1, 'uint32');                     % Code for units of ITD2 
NUCH     = freadVAXG(fid, 1, 'uint32');                     % No. of UET data channels 
UETCH  = freadVAXG(fid, NUCH, 'uint32');                    % UET channel number 
ASAMPT = freadVAXG(fid, 1, 'float32');                      % Analog sampling time in secs 
ABUF   = freadVAXG(fid, 1, 'uint32');                       % No. of points per cycle 
ANCYC  = freadVAXG(fid, 1, 'uint32');                       % No. of cycles sampled 
ANSEP  = freadVAXG(fid, 1, 'uint32');                       % Actual no. of cycles stored/stim point 
AVCODE = freadVAXG(fid, 1, 'uint32');                       % 0=No averaging, 1=Yes averaging 
AVOLC  = freadVAXG(fid, 1, 'float32');                      % Voltage conversion factor 
AVCC   = freadVAXG(fid, 1, 'float32');                      % Voltage Conversion Code 
ANBITS = freadVAXG(fid, 1, 'uint32');                       % No. of bits per sample 16/32 
NACH   = freadVAXG(fid, 1, 'uint32');                       % No. of A/D channels 
ADCH   = freadVAXG(fid, NACH, 'uint32');                    % A/D Channel number 

WorkSpaceVar = whos;
Data = PackStruct(WorkSpaceVar.name);
Data = rmfield(Data, {'N', 'fid'});

function INDEPVAR = ReadIndepVar(fid)

INDEPVAR = struct([]);

LOW    = freadVAXG(fid, 1, 'float32');
HIGH   = freadVAXG(fid, 1, 'float32');
INC    = freadVAXG(fid, 1, 'float32');             % Step size (if linear incr) 
SOCT   = freadVAXG(fid, 1, 'float32');             % Steps per Octave (if log incr) 
LOGLIN = freadVAXG(fid, 1, 'uint32');              % 1=Linear steps, 2=Log steps 
OPRES  = freadVAXG(fid, 1, 'uint32');              % Order of Presentation 

INDEPVAR = CollectInStruct(LOW, HIGH, INC, SOCT, LOGLIN, OPRES);

function DSSDAT = ReadDSSDat(fid)

DSSDAT = struct([]);

fPos = ftell(fid); 
LDSS = freadVAXG(fid, 1, 'uint32');                     % Length of DSSDAT (words) 
MaxPos = (fPos + 4*LDSS);

DSSN = freadVAXG(fid, 1, 'uint32');                     % DSS number (1 or 2) 
MODE = freadVAXG(fid, 1, 'uint32');                     % DSS output mode 
MODEX = freadVAXG(fid, 1, 'uint32');                    % external or prog start 
MODED1 = freadVAXG(fid, 1, 'uint32');                   % Delay-1 mode 
MODED2 = freadVAXG(fid, 1, 'uint32');                   % Delay-2 mode 
MSLAVE = freadVAXG(fid, 1, 'uint32');                   % Master or slave mode(1=master,2=slave) 
CONSPL = freadVAXG(fid, 1, 'uint32');                   % Constant SPL code, 0=No, 1=Yes 
PHFLAG = freadVAXG(fid, 1, 'uint32');                   % 0=Not corrected for phase, 1=Yes 
GWNUMP = freadVAXG(fid, 1, 'uint32');                   % No. of points in GW waveform 
GWESPL = freadVAXG(fid, 1, 'uint32');                   % if 1 then Eff. SPL used for GW 
GWCODE = freadVAXG(fid, 1, 'uint32');                   % GW waveform type code, or CNOIS type 
GWUNF  = freadVAXG(fid, 1, 'uint32');                   % GW noise 0=frozen, 1=unfrozen 
GWSINC = freadVAXG(fid, 1, 'uint32');                   % GW start increment in no. points 
GWDIFF = freadVAXG(fid, 1, 'uint32');                   % GW address diff for Cosine Noise 
ZPNUMP = freadVAXG(fid, 1, 'uint32');                   % No. of points in ZP waveform 
RNSEED = freadVAXG(fid, 1, 'uint32');                   % Seed for random number generator 
ZPNBPR = freadVAXG(fid, 1, 'uint32');                   % 1=bandpass, 2=band-reject ZP noise 
GWRES = freadVAXG(fid, 1, 'float32');                   % GW playback resolution in microsecs 
SPLCLIP = freadVAXG(fid, 1, 'float32');                 % dB range below which calib clipped 
EFFSPL = freadVAXG(fid, 1, 'float32');                  % Eff. Max SPL of GW or ZP waveform 
EFFT1 = freadVAXG(fid, 1, 'float32');                   % Start time for eff SPL comp (msecs) 
EFFT2 = freadVAXG(fid, 1, 'float32');                   % Stop time for eff SPL comp (msecs) 
CALID = char(freadVAXG(fid, 12, 'uchar')');             % Calib ID used for correction 
CPPN = char(freadVAXG(fid, 4, 'uchar')');               % Click pair - POSitive or NEGative 
if ftell(fid) < MaxPos, FREQ = ReadVectorString(fid); end % Carrier freq in Hz 
if ftell(fid) < MaxPos, DELAY1 = ReadVectorString(fid); end                      % in microsecs 
if ftell(fid) < MaxPos, DUR1 = ReadVectorString(fid); end                        % in millisecs 
if ftell(fid) < MaxPos, DELAY2 = ReadVectorString(fid); end                      % in microsecs 
if ftell(fid) < MaxPos, DUR2 = ReadVectorString(fid); end   % in millisecs 
if ftell(fid) < MaxPos, REPINT = ReadVectorString(fid); end % Repetition time in millisecs 
if ftell(fid) < MaxPos, DELM = ReadVectorString(fid); end   % Master delay in microsecs 
if ftell(fid) < MaxPos, NREPS = ReadVectorString(fid); end  % No. of repetitions 
if ftell(fid) < MaxPos, SPL = ReadVectorString(fid); end    % Initial SPL (dB) 
if ftell(fid) < MaxPos, RENV = ReadVectorString(fid); end   % Rise time envelope shape 
if ftell(fid) < MaxPos, RTIME = ReadVectorString(fid); end  % Rise time in millisecs 
if ftell(fid) < MaxPos, FENV = ReadVectorString(fid); end   % Fall time envelope shape 
if ftell(fid) < MaxPos, FTIME = ReadVectorString(fid); end  % Fall time in millisecs 
if ftell(fid) < MaxPos, PHASE = ReadVectorString(fid); end  % Initial phase (0-1) 
if ftell(fid) < MaxPos, FMOD = ReadVectorString(fid); end   % Modulation Freq. (Hz) 
if ftell(fid) < MaxPos, PHASM = ReadVectorString(fid); end  % Modulation Phase (0-1) 
if ftell(fid) < MaxPos, DMOD = ReadVectorString(fid); end   % Depth of Modulation (0-1) 
if ftell(fid) < MaxPos, VALM = ReadVectorString(fid); end   % Modulation value (-1 to +1) 
if ftell(fid) < MaxPos, VALC = ReadVectorString(fid); end   % Carrier Modulation constant 
if ftell(fid) < MaxPos, FRLOW = ReadVectorString(fid); end  % Low Frequency (Hz) 
if ftell(fid) < MaxPos, FRHIGH = ReadVectorString(fid); end % High Frequency (Hz) 
if ftell(fid) < MaxPos, FMRISE = ReadVectorString(fid); end % Rise time for FM sweep (msecs) 
if ftell(fid) < MaxPos, FMDWELL = ReadVectorString(fid); end % Hold time for FM sweep (msecs) 
if ftell(fid) < MaxPos, FMFALL = ReadVectorString(fid); end % Fall time for FM sweep (msecs) 
if ftell(fid) < MaxPos, ATTSET = ReadVectorString(fid); end % Attenuator setting (dB) 
if ftell(fid) < MaxPos, GWFIL = ReadVectorString(fid); end  % Name of GW storage file 
if ftell(fid) < MaxPos, GWID = ReadVectorString(fid); end   % ID for General Waveform 
if ftell(fid) < MaxPos, GWDS = ReadVectorString(fid); end   % GW data set number (or, speaker #) 
if ftell(fid) < MaxPos, TONLVL = ReadVectorString(fid); end % Tone level,mask stim(0-1, or dB UP) 
if ftell(fid) < MaxPos, GWLVL = ReadVectorString(fid); end  % GW level for mask stimulus (0-1) 
if ftell(fid) < MaxPos, MSKSTM = ReadVectorString(fid); end % Masking Stimulus name (TONE/GW) 
if ftell(fid) < MaxPos, MODSTM = ReadVectorString(fid); end % Modulating waveform (TONE/GW) 
if ftell(fid) < MaxPos, ZPNLF = ReadVectorString(fid); end  % Low freq cutoff for ZP noise (Hz) 
if ftell(fid) < MaxPos, ZPNHF = ReadVectorString(fid); end  % High freq cutoff for ZP noise (Hz) 
if ftell(fid) < MaxPos, ZPNLFS = ReadVectorString(fid); end % Low freq slope for ZP noise (dB/oct)
if ftell(fid) < MaxPos, ZPNHFS = ReadVectorString(fid); end % High freq slop for ZP noise (dB/oct)
if ftell(fid) < MaxPos, ZPAMC1 = ReadVectorString(fid); end % ZP - computed AM - component-1 
if ftell(fid) < MaxPos, ZPAMC2 = ReadVectorString(fid); end % ZP - computed AM - component-2 
if ftell(fid) < MaxPos, ZPAMC3 = ReadVectorString(fid); end % ZP - computed AM - component-3 
if ftell(fid) < MaxPos, CPCW = ReadVectorString(fid); end   % Click pair click width (microsecs) 
if ftell(fid) < MaxPos, GPGWI1 = ReadVectorString(fid); end % ID for 1st waveform (GW pair expt) 
if ftell(fid) < MaxPos, GPGWI2 = ReadVectorString(fid); end % ID for 2nd waveform (GW pair expt) 
if ftell(fid) < MaxPos, GPDUR1 = ReadVectorString(fid); end % Duration of 1st wave (msecs) (GWP expt) 
if ftell(fid) < MaxPos, GPDUR2 = ReadVectorString(fid); end % Duration of 2nd wave (msecs) (GWP expt) 
if ftell(fid) < MaxPos, PHASLSB = ReadVectorString(fid); end  % Phase of lower side-band (0-1) (CAM) 
if ftell(fid) < MaxPos, PHASUSB = ReadVectorString(fid); end  % Phase of upper side-band (0-1) (CAM) 
if ftell(fid) < MaxPos, CAMACORR = ReadVectorString(fid); end % if Y then CAM corrected for amp calib 
if ftell(fid) < MaxPos, CAMPCORR = ReadVectorString(fid); end % if Y then CAM corrected for phs calib 
if ftell(fid) < MaxPos, SPKNUM = ReadVectorString(fid); end % Speaker number for free-field expt 
if ftell(fid) < MaxPos, VSMC = ReadVectorString(fid); end   % VS manipulation code (1,2,3..etc.) 
if ftell(fid) < MaxPos, FFHRTF = ReadVectorString(fid); end % Free-field HRTF file name 
if ftell(fid) < MaxPos, VSWVTYP = ReadVectorString(fid); end % VS or SYN waveform type (CLICK or GW) 
if ftell(fid) < MaxPos, AZIMTH = ReadVectorString(fid); end  % Azimuth for VS (degrees) 
if ftell(fid) < MaxPos, ELEVTN = ReadVectorString(fid); end  % Elevation for VS (degrees) 
if ftell(fid) < MaxPos, GAUFILT = ReadVectorString(fid); end % Gaussian filter for VS (Y/N) 
if ftell(fid) < MaxPos, GAUFCF = ReadVectorString(fid); end  % Center Freq. for Gaus.Filt for VS (Hz) 
if ftell(fid) < MaxPos, GAUFBW = ReadVectorString(fid); end  % 3dB Bandwidth for Gaus.Filt (Octaves) 
if ftell(fid) < MaxPos, NOTYPE = ReadVectorString(fid); end  % Notch Type (POON/EXP/LIN) for SYN 
if ftell(fid) < MaxPos, NOTCF = ReadVectorString(fid); end   % Notch Center Freq for SYN (Hz) 
if ftell(fid) < MaxPos, NOTBW = ReadVectorString(fid); end   % Notch 10dB bandwidth for SYN (Hz) 
if ftell(fid) < MaxPos, NOTDEP = ReadVectorString(fid); end  % Notch Depth for SYN (dB) 
if ftell(fid) < MaxPos, FLATCAL = ReadVectorString(fid); end % Waveform flattened with calib. (Y/N) 
if ftell(fid) < MaxPos, SRVNODE = ReadVectorString(fid); end % Remote compute server node name 
if ftell(fid) < MaxPos, WAVSRC = ReadVectorString(fid); end  % Waveform source (COMP or FILE) 
if ftell(fid) < MaxPos, CDUR = ReadVectorString(fid); end    % Compute duration of waveform(millisec) 
if ftell(fid) < MaxPos, WAVUFC = ReadVectorString(fid); end  % Upper Freq. cutoff for comp. wave (Hz) 
if ftell(fid) < MaxPos, BPFILT = ReadVectorString(fid); end  % Band-pass filter ? (Y or N) 
if ftell(fid) < MaxPos, BPFCF = ReadVectorString(fid); end   % Bandpass filter Center Freq. (Hz) 
if ftell(fid) < MaxPos, BPFBWU = ReadVectorString(fid); end  % Bandpass filt Bandwidth units (HZ/OCT) 
if ftell(fid) < MaxPos, BPFBW = ReadVectorString(fid); end   % Bandpass filt Bandwidth (in Hz or Oct) 
if ftell(fid) < MaxPos, B2NCF2 = ReadVectorString(fid); end  % 2-Band Noise Center Freq-2 (Hz) 
if ftell(fid) < MaxPos, B2NBW2 = ReadVectorString(fid); end  % 2-Band Noise Bandwidth-2 (Hz) 
if ftell(fid) < MaxPos, B2NMF2 = ReadVectorString(fid); end  % 2-Band Noise Modulation_freq-2 (Hz) 
if ftell(fid) < MaxPos, B2NMD2 = ReadVectorString(fid); end  % 2-Band Noise Modulation_depth-2 (0-2) 
if ftell(fid) < MaxPos, B2NMP2 = ReadVectorString(fid); end  % 2-Band Noise Modulation_pahse-2 (0-1) 
if ftell(fid) < MaxPos, B2NB2LVL = ReadVectorString(fid); end % 2-Band Noise Second Band Level (dB) 
if ftell(fid) < MaxPos, CSPECL = ReadVectorString(fid); end  % Spectrum level held constant (Y or N) 
if ftell(fid) < MaxPos, SPECLVL = ReadVectorString(fid); end % Constant Spectrum level (dB/Hz) 
if ftell(fid) < MaxPos, ITD1 = ReadVectorString(fid); end    % Initial ITD for shifted GEWAB (usecs) 
if ftell(fid) < MaxPos, ITD2 = ReadVectorString(fid); end    % Final ITD for shifted GEWAB (usecs) 
if ftell(fid) < MaxPos, ITDRATE = ReadVectorString(fid); end % ITD rate for shifted GEWAB (usec/sec) 
if ftell(fid) < MaxPos, ADTYP = ReadVectorString(fid); end   % Adapter Type for SSF (e.g. TONE/GW) 
if ftell(fid) < MaxPos, ADFREQ = ReadVectorString(fid); end  % Adapter Freq for SSF (Hz) 
if ftell(fid) < MaxPos, ADDUR = ReadVectorString(fid); end   % Adapter Duration for SSF (millisecs) 
if ftell(fid) < MaxPos, ADSPL = ReadVectorString(fid); end   % Adapter SPL for SSF (dB) 
if ftell(fid) < MaxPos, SILINT = ReadVectorString(fid); end  % Silent Interval for SSF (millisecs) 
if ftell(fid) < MaxPos, TGFREQ = ReadVectorString(fid); end  % Target CF for SSF (Hz) 
if ftell(fid) < MaxPos, TGF0 = ReadVectorString(fid); end    % Target F0 for SSF (Hz) 
if ftell(fid) < MaxPos, TGDUR = ReadVectorString(fid); end   % Target Duration for SSF (millisecs) 
if ftell(fid) < MaxPos, TGNUMH = ReadVectorString(fid); end  % Target Number of Harmonics for SSF 
if ftell(fid) < MaxPos, TGSLOP = ReadVectorString(fid); end  % Target Filter Slope for SSF (dB/oct) 
if ftell(fid) < MaxPos, TGSPL = ReadVectorString(fid); end   % Target SPL for SSF (dB) 
if ftell(fid) < MaxPos, FILTYP = ReadVectorString(fid); end  % Filter Type for Stimulus (e.g. KLATT or NONE)

fseek(fid, MaxPos, 'bof');

WorkSpaceVar = whos;
DSSDAT = PackStruct(WorkSpaceVar.name);
DSSDAT = rmfield(DSSDAT, {'DSSDAT', 'fid'});