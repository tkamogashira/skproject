clear;ds1 = dataset('G0901', '2-1-THR');
警告: Unable to decode spike times 
> In GetSGSRdata at 57
  In dataset.dataset at 106
dss1=struct(ds1);
dss1
dss1 = 
          ID: [1x1 struct]
       Sizes: [1x1 struct]
        Data: [1x1 struct]
    Stimulus: [1x1 struct]
    Settings: [1x1 struct]

dss1.ID    
ans = 
        FileName: 'G0901'
      FileFormat: 'SGSR'
    FullFileName: [1x56 char]
            iSeq: 2
        StimType: 'THR'
           iCell: 2
           SeqID: '2-1-THR'
            Time: [28 8 2008 20 33 41]
           Place: 'Leuven/Bigscreen'
    Experimenter: 'Shotaro'    
    
dss1.ID.FullFileName
ans =
C:\whiteHD_BU20100205\recover_data\Shotaro\rawData\G0901

dss1.Sizes
ans = 
            Nsub: 58
    NsubRecorded: 1
            Nrep: 1

dss1.Data
ans = 
    SpikeTimes: {1x188 cell}
     OtherData: [1x1 struct]

dss1.Data.OtherData
ans = 
    thrCurve: [1x1 struct]
    
dss1.Data.OtherData.thrCurve
ans = 
         freq: [1x57 double]
    threshold: [1x57 double]    
dss1.Data.OtherData.thrCurve.freq(1)
ans =
  206.1731
dss1.Data.OtherData.thrCurve.freq(2)
ans =
  220.9709
dss1.Data.OtherData.thrCurve.freq(end)
ans =
  1.0000e+004
%　こちらは小さい順  
dss1.Data.OtherData.thrCurve.threshold(1)
ans =
   NaN
dss1.Data.OtherData.thrCurve.threshold(2)
ans =
   NaN
dss1.Data.OtherData.thrCurve.threshold(end)
ans =
   77.2500
%　こちらも小さい順

dss1.Stimulus
ans = 
     IndepVar: [1x1 struct]
      Special: [1x1 struct]
    StimParam: [1x1 struct]    
    
    
dss1.Stimulus.IndepVar
ans = 
         Name: 'Frequency'
    ShortName: 'Frequency'
       Values: [1x57 double]
         Unit: 'Hz'
    PlotScale: 'linear'
dss1.Stimulus.IndepVar.Values(1)
ans =
  1.0000e+004
dss1.Stimulus.IndepVar.Values(2)
ans =
  9.3303e+003
dss1.Stimulus.IndepVar.Values(end)
ans =
  206.1731    
% こちらは提示した順。大から小へ    
    
dss1.Stimulus.Special
ans = 
         RepDur: 200
       BurstDur: 80
        CarFreq: [57x1 double]
        ModFreq: NaN
       BeatFreq: NaN
    BeatModFreq: NaN
     ActiveChan: 1            
            
dss1.Stimulus.Special.CarFreq(1)
ans =
  206.1731
dss1.Stimulus.Special.CarFreq(2)
ans =
  220.9709
dss1.Stimulus.Special.CarFreq(end)
ans =
  1.0000e+004            
%　こちらも小さい順

dss1.Stimulus.StimParam
ans = 
       dummy: ''
      lofreq: 206.1731
       dfreq: 0.1000
      hifreq: 10000
      cfreqs: [57x1 double]
    stepunit: 'log'
     silence: 15
    interval: 200
       order: 0
    burstDur: 80
     riseDur: 2.5000
     fallDur: 2.5000
       delay: [0 0]
         SPL: 80
      active: 1
    stepSize: 1.5000
    startSPL: 65
        Nrev: 6
    critMode: 'spike'
     critVal: 2
      minSPL: -10

dss1.Stimulus.StimParam.cfreqs(1)
ans =
  206.1731
dss1.Stimulus.StimParam.cfreqs(end)
ans =
  1.0000e+004
%　こちらも小さい順

dss1.Settings
ans = 
     SessionInfo: [1x1 struct]
    RecordParams: [1x1 struct]

dss1.Settings.SessionInfo
ans = 
           startTime: [28 8 2008 15 24 4]
            dataFile: 'C:\SGSRwork\ExpData\G0901'
                iSeq: 3
         SeqRecorded: [1 2 3]
        SGSRSeqIndex: 2
       iJustRecorded: -2
       RecordingSide: 'Left'
             ERCfile: 'C:\SGSRwork\ExpData\G0899'
          leftDACear: 'L'
           DAchannel: 'B'
           requestID: 1
             KeepPen: 1
     ElectrodeNumber: 1
            PenDepth: 543
    NotifiedComputer: ''
          NotifyPort: 0
               iCell: 2
         iseqPerCell: 1
        Experimenter: 'Shotaro'
     CurrentStimMenu: 'THR'

dss1.Settings.RecordParams
ans = 
     samFreqs: [6.0096e+004 1.2500e+005]
    switchDur: 80










            