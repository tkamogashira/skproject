Bin = binbeat
BB = BBsweep
FS = freqsweep
FSsm = freqSweepSmall
ICI = ICIsweep
IID = IIDsweep
ITD = ITDsweep
LMS = LMSsweep
NSPL = NSPLsweep
NTD = NTDsweep
SPL = SPLsweep
                                                       NSPL-BW   NTD-BW
      BB      BFS    CFS     FS   ICI   IID  ITD   LMS   ^   NSPL  ^   NTD  SPL  WAV
-------------------------------------------------------------------------------------
PRES: pres    pres   pres   pres  pres  itd  itd   pres pres pres itd  itd  pres list
DUR:  small   small  click  dur   dpair dur  itd   dur  dur  dur  itd  itd  dur  -
SPL:  lev     lev    lev    lev   pair  iid  lev   lev  -    -    lev  lev  -    wav
MOD:  smaller -       -     mod   -     mod  small -    -    -    -    -    mod
SCAT: -       -      cpar   -     cpar  -    -     -    npbw npar npbw npar -
SPEC:  BB   FSsm/Bin FS     FS    ICI   IID  ITD   LMS  NSPL NSPL NTD  NTD  SPL

ABBR 
pres = presentation; itd = ITDpresentation; list = ListPresentation
dur = durations; small = durationsSmall; click = durationsClick; 
      dpair = delayPair; itd =ITDdurations
lev = levels; iid = levelsIID; pair = levelPair; wav = WAVlevels
mod = modulation; small = modulationsmall; smaller = modulationSmaller; 
cpar = clickparam; npar = noiseparam; npbw = noiseParamsBW;
---WAV Menu----    
1: defaultsMenu    
2: PRP             
3: ListPresentation
4: WAVlevels       
5: WAVfileGetter   
6: SessionMenu  