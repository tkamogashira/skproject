function THRStimulus = assembleDSfieldTHRStimulus(DSSParam, GenStimParam, ThrCurveParam, IndepVarParam, Thresholds)

%B. Van de Sande 09-07-2004

IndepVar.Name      = 'Frequency';
IndepVar.ShortName = 'Frequency';
IndepVar.Values    = IndepVarParam.Values;
IndepVar.Unit      = 'Hz';
IndepVar.PlotScale = 'linear';

Special.RepDur      = GenStimParam.RepDur;
Special.BurstDur    = GenStimParam.BurstDur;
Special.CarFreq     = repmat(IndepVarParam.Values, 1, DSSParam.Nr);
Special.ModFreq     = repmat(NaN, 1, DSSParam.Nr);
Special.BeatFreq    = repmat(NaN, 1, DSSParam.Nr);
Special.BeatModFreq = repmat(NaN, 1, DSSParam.Nr);
if DSSParam.Nr == 2, Special.ActiveChan = 0; else, Special.ActiveChan = DSSParam.MasterNr; end

[StimParam.ThrCurveParam, StimParam.GenStimParam] = deal(ThrCurveParam, GenStimParam);
StimParam.lofreq   = IndepVarParam.Values(1);
StimParam.dfreq    = log2(IndepVarParam.Values(2)/IndepVarParam.Values(1));
StimParam.hifreq   = IndepVarParam.Values(end);
StimParam.cfreqs   = IndepVarParam.Values;
StimParam.stepunit = 'log';
StimParam.silence  = NaN; %?? ...
StimParam.interval = GenStimParam.RepDur;
StimParam.order    = (log2(IndepVarParam.Values(2)/IndepVarParam.Values(1))<0)+1;
StimParam.burstDur = GenStimParam.BurstDur;
StimParam.riseDur  = GenStimParam.RiseDur;
StimParam.fallDur  = GenStimParam.FallDur;
StimParam.delay    = GenStimParam.Delay;
StimParam.SPL      = max(Thresholds); %Or ThrCurveParam.maxSPL ?? ...
if DSSParam.Nr == 2, StimParam.active = 0; else, StimParam.active = DSSParam.MasterNr; end
StimParam.stepSize = NaN; %?? ...
StimParam.startSPL = NaN; %?? ...
StimParam.Nrev     = NaN; %?? ...
StimParam.critMode = '';  %?? ...
StimParam.critVal  = NaN; %?? ...
StimParam.minSPL   = min(Thresholds);

THRStimulus = CollectInStruct(IndepVar, Special, StimParam);