function IndepVarParam = extractSCHIndepVarParam(SchData, DSSParam)

%B. Van de Sande 04-05-2004

%Organisation of independent variable information in SGSR:
%
%   IndepVar.Name
%   IndepVar.ShortName
%   IndepVar.Values - this should always be a column vector ...
%   IndepVar.Unit
%   IndepVar.PlotScale - should be 'linear' or 'logaritmic' ...
%
%The organisation in EDF is somewhat different. For schemata SCH012 and SCH016 the number of 
%independent variables is given by NUMV and the actual names by VNAME (using DCP convention).
%The name of the X-variable or Y-variable in EDF can be upto 8 characters long. The list of 
%possible variable names is as follows :
%
%         FREQ        : Tone frequency (Hz)
%         SPL         : Sound pressure level or Intensity (dB)
%         DELAY       : Inter-aural delay (microsecs)
%         PHASE       : Initial phase of tone or Carrier frequency(0-1)
%         FCARR       : Carrier frequency (Hz)
%         FMOD        : Modulation frequency (Hz)
%         PHASM       : Initial phase of modulating tone (0 to 1)
%         DMOD        : Depth of Modulation (0 to 1)
%         TONLVL      : Tone level for Masking Stimulus paradigm
%         GWLVL       : GW level for Masking Stimulus paradigm
%         DELAY2      : Masked stimulus delay (microsecs)
%         DUR2        : Masked stimulus duration (millisecs)
%         REPINT      : Repetition interval (millisecs)
%         STMDUR      : Stimulus duration (millisecs)
%         RTIME       : Rise Time (millisecs)
%         FTIME       : Fall Time (millisecs)
%         GWRES       : GW playback resolution (microsecs)
%        *ICD         : Inter-click delay (millisecs)
%         ITD1        : Inter-aural delay between first pair (microsecs)
%         ITD2        : Inter-aural delay between second pair (microsecs)
%         DSNUM       : Data set number
%         ELEVTN      : Elevation (degrees)
%         AZIMTH      : Azimuth (degrees)
%        *NOTCHCF     : Notch CF (Hz)
%        *NOTCHDEP    : Notch Depth (dB)
%        *PHASLSB     : Phase of lower side-band (0 to 1)
%        *PHASUSB     : Phase of upper side-band (0 to 1)
%        *CF          : Center Frequency (Hz)
%        *CF2         : Center Frequency of 2nd band (Hz)
%        *BW2         : Band-width of 2nd band (Hz)
%        *FMOD2       : Modulation frequency for 2nd band (Hz)
%        *PHASM2      : Phase of Modulation freq. for 2nd band (0 to 1)
%        *DMOD2       : Modulation depth for second band (0 to 1)
%        *BAND2LVL    : Level of 2nd Band (dB up from 1st Band)
%         ITRATE      : ITD rate (microsecs per second)
%        *RMULT       : CF Ratio Multiplier (for 2-band noise)
%        *ASPL        : Adapter SPL (dB)
%        *TSPL        : Target SPL (dB)
%         NONE        : None (do not vary)
%
%Attention! The variable names with an asteriks as prefix are not yet implemented. ITD1 and
%ITD2 are interpreted as being part of the shifted GEWAB stimulus instead of the click pair 
%stimulus.
%Any of the variable names can be extended by specifying which DSS it is to be varied on.
%For example, to vary the SPL on the slave DSS, we can use SPL#S as the variable name, and
%to vary the modulation depth on the master DSS we can use DMOD#M. This only applies for 
%two-DSS experiments. By default, if no extension is specified for the variable name, the 
%variable is assumed to apply to the master DSS. Thus in the above example, DMOD#M is the
%same as DMOD. 
%This information is retrieved from the Data Collection Program (DCP) Users Guide on
%http://www.neurophys.wisc.edu/comp/dcp/rep002.html
%
%Storing ranges is done via two structures, XVAR and YVAR (in SCH012 there is also a ZVAR, 
%but this is never used with the collection program RA):
%
%   LOW
%   HIGH
%   INC - linear increment ...
%   SOCT - steps per octave ...
%   LOGLIN - 1 denotes linear and 2 logaritmic ...
%   OPRES - the order of presentation, with 1 signifying ascending, 2 descending and 3 random
%           presentation ...
%
%These two organisations are merged in a structure array IndepVarParam, with the following fields:
%
%   IndepVarParam.Name
%   IndepVarParam.ShortName
%   IndepVarParam.DCPName - original name in the dataset schema. This follows the conventions of
%                           the Data Collection Program (DCP). The optional suffix for specifying
%                           the DSS which is varied has been removed ...
%   IndepVarParam.DSS - 'master' or 'slave' ...
%   IndepVarParam.DSSidx - index of the DSS which is varied ...
%   IndepVarParam.SCHName - the corresponding name of this variable in the dataset schema if present ...
%   IndepVarParam.Values - the values in order of presentation. Always a column vector! Linear or 
%                          logaritmic doesn't matter anymore, the actual values are stored in the vector ... 
%   IndepVarParam.Unit
%   IndepVarParam.PlotScale

switch SchData.SchName, 
case 'calib',
    IndepVarParam.Name      = 'Frequency';
    IndepVarParam.ShortName = 'Freq';
    IndepVarParam.DCPName   = '';
    IndepVarParam.DSS       = '';
    IndepVarParam.DSSidx    = SchData.DSSN;
    IndepVarParam.SCHName   = struct([]);
    IndepVarParam.Values    = calcEDFIndepVal(SchData.FREQ);
    IndepVarParam.Unit      = 'Hz';
    IndepVarParam.PlotScale = 'linear';
case 'sch005',
    IndepVarParam.Name      = 'Time';
    IndepVarParam.ShortName = 'Time';
    IndepVarParam.DCPName   = '';
    IndepVarParam.DSS       = '';
    IndepVarParam.DSSidx    = NaN;
    IndepVarParam.SCHName   = struct([]);
    IndepVarParam.Values    = SchData.TRES/2+(0:(SchData.NUMPTS-1))'*SchData.TRES;
    IndepVarParam.Unit      = '\mus';
    IndepVarParam.PlotScale = 'linear';
case 'sch008',
    IndepVarParam = createIVPStruct(SchData.FREQ, 'freq', DSSParam);
case {'sch006', 'sch012', 'sch016'},
    NVar   = SchData.NUMV;
    VNames = lower(cellstr(SchData.VNAME)); %Already partially parsed by readEDFSchVarNames.m ...
    
    if NVar >= 1, IndepVarParam(1) = createIVPStruct(SchData.XVAR, VNames{1}, DSSParam); end
    if NVar >= 2, IndepVarParam(2) = createIVPStruct(SchData.YVAR, VNames{2}, DSSParam); end
    if NVar == 3, IndepVarParam(3) = createIVPStruct(SchData.ZVAR, VNames{3}, DSSParam); end
otherwise, IndepVarParam = struct([]); end 

%------------------------------------------------local functions----------------------------------------------    
function IndepVarParam = createIVPStruct(EDFIndepVar, VName, DSSParam)

[DCPName, DSSName] = parseDCPVarName(VName);
LUTEntry = DCPIndepVarLUT(DCPName);

IndepVarParam.Name      = LUTEntry.Name;
IndepVarParam.ShortName = LUTEntry.ShortName;
IndepVarParam.DCPName   = DCPName;
IndepVarParam.DSS       = DSSName;
if strcmp(DSSName, 'master'), IndepVarParam.DSSidx = DSSParam.MasterIdx;
elseif strcmp(DSSName, 'slave'), IndepVarParam.DSSidx = DSSParam.SlaveIdx;
else IndepVarParam.DSSidx = NaN; end
FNames = fieldnames(LUTEntry);
idx = find(strncmp(FNames, 'SCH', 3) | strcmp(FNames, 'CALIB'));
IndepVarParam.SCHName   = getfields(LUTEntry, FNames(idx));

IndepVarParam.Values    = calcEDFIndepVal(EDFIndepVar);

IndepVarParam.Unit      = LUTEntry.Unit;
IndepVarParam.PlotScale = LUTEntry.PlotScale;