function Info = getIndepVarParamSGSRInfo(IndepVarParam)

%B. Van de Sande 06-08-2003

persistent LUT;
if isempty(LUT), LUT = generateLUT; end    

VName = strtok(IndepVarParam.Name, '#');

VNames = { LUT.EDFName };
idx = find(strcmp(VNames, VName));

if ~isempty(idx), Info = getfields(LUT(idx), {'Name', 'ShortName', 'Unit'});
else, Info = struct('Name', VName, 'ShortName', '??', 'Unit', '??'); end

%---------------------------------------------local functions-------------------------------------------------
function LUT = generateLUT

LUT(1).EDFName   = 'spl';
LUT(1).Name      = 'Intensity';
LUT(1).ShortName = 'Level';
LUT(1).Unit      = 'dB SPL';

LUT(2).EDFName   = 'delay';
LUT(2).Name      = 'Interaural time';
LUT(2).ShortName = 'ITD';
LUT(2).Unit      = '\mus';

LUT(3).EDFName   = 'dsnum';
LUT(3).Name      = 'GW dataset number';
LUT(3).ShortName = 'DS nr';
LUT(3).Unit      = '#';

LUT(4).EDFName   = 'itrate';
LUT(4).Name      = 'Movement rate';
LUT(4).ShortName = 'IT rate';
LUT(4).Unit      = '\mus/s';

LUT(5).EDFName   = 'itd1';
LUT(5).Name      = 'Preceding interaural time difference';
LUT(5).ShortName = 'PreITD';
LUT(5).Unit      = '\mus';

LUT(6).EDFName   = 'itd2';
LUT(6).Name      = 'Ending interaural time difference';
LUT(6).ShortName = 'PostITD';
LUT(6).Unit      = '\mus';

LUT(7).EDFName   = 'freq';
LUT(7).Name      = 'Carrier frequency';
LUT(7).ShortName = 'Fcar';
LUT(7).Unit      = 'Hz';

LUT(8).EDFName   = 'fcarr';
LUT(8).Name      = 'Carrier frequency';
LUT(8).ShortName = 'Fcar';
LUT(8).Unit      = 'Hz';

LUT(9).EDFName   = 'fmod';
LUT(9).Name      = 'Modulation frequency';
LUT(9).ShortName = 'Fmod';
LUT(9).Unit      = 'Hz';