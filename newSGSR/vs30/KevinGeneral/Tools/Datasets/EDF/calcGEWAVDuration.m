function Dur = calcGEWAVDuration(GenWaveFormParam)

%B. Van de Sande 23-04-2004

Dur = GenWaveFormParam.PbPer*GenWaveFormParam.NPoints*1e-3; %In milliseconds ...