
        G0901_1_2_SPL
        G0901_1_2_SPL = 
                  ID: [1x1 struct]
               Sizes: [1x1 struct]
                Data: [1x1 struct]
            Stimulus: [1x1 struct]
            Settings: [1x1 struct]

        % この５つは変えられない

        G0901_1_2_SPL.ID
        ans = 
                FileName: 'G0901'
              FileFormat: 'IDF/SPK'
            FullFileName: [1x56 char]
                    iSeq: -1
                StimType: 'SPL'
                   iCell: 1
                   SeqID: '1-2-SPL'
                    Time: [28 8 2008 20 9 35]
                   Place: '??/**'
            Experimenter: ''

 s.ID.FileName='G201401';
 s.ID.FileFormat='IDF/SPK';
 s.ID.FullFileName='C:\whiteHD_BU20100205\recover_data\Shotaro\rawData\G201401';...
     %例えば上記のファイルに移す。元は 'C:\TDTtoshibatonec\TDTexperiment\TDTNTT\recording\#0';
 s.ID.iSeq=-1;
 s.ID.StimType='SPL';
 s.ID.iCell=1;%何番目にあたったニューロンか
 s.ID.SeqID='1-2-SPL';
 s.ID.Time=[31 12 2014 23 59 59];%そのときのday month year hour min secを入れる
 s.ID.Place='??/**';%このままでよいだろう
 s.ID.Experimenter= '';%このままでよいだろう   
    
    
        G0901_1_2_SPL.ID.FullFileName
        ans =
        C:\whiteHD_BU20100205\recover_data\Shotaro\rawData\G0901

        G0901_1_2_SPL.Sizes
        ans = 
                    Nsub: 11
            NsubRecorded: 11
                    Nrep: 200

s.Sizes.Nsub=3;% #0\Info.txtの中の%NStim= 3から抽出する　あるいは  MonitorSetting.PSTH.StimIdx=3より
s.Sizes.NsubRecorded=3;% #0\Info.txtの中の%NStim= 3から抽出する
s.Sizes.Nrep=10;% Toneを使って#Re=10の場合を想定した。MultiToneなら1でよいはずだがよく考える必要がある。

        G0901_1_2_SPL.Data
        ans = 
            SpikeTimes: {11x200 cell}
             OtherData: []
% dse=dataset(G0901_1_2_SPL, 'convert')にすればdseの中にはdse.spikecount/nsptなどが計算されてできるはず。
tpassm=MonitorSetting.Spikes.TPassM(:,1);
re=reshape(tpassm, s.Sizes.Nsub, s.Sizes.Nrep);
s.Data.SpikeTimes=re; 
%=MonitorSetting.Spikes.TPassとする。音圧を３種類で#Cond=3で、#Re=10なら{3x10 cell}として収納する。

s.Data.OtherData=[];

        G0901_1_2_SPL.Stimulus
        ans = 
             IndepVar: [1x1 struct]
              Special: [1x1 struct]
            StimParam: [1x1 struct]
        G0901_1_2_SPL.Stimulus.IndepVar
        ans = 
                 Name: 'Intensity'
            ShortName: 'Level'
               Values: [11x1 double]
                 Unit: 'dB SPL'
            PlotScale: 'linear'

s.Stimulus.IndepVar.Name='Intensity';% SPLのようなrate curveならこれでいいだろう
s.Stimulus.IndepVar.ShortName= 'Level';

s.Stimulus.IndepVar.Unit= 'dB SPL';
s.Stimulus.IndepVar.PlotScale= 'linear';
    
        G0901_1_2_SPL.Stimulus.IndepVar.Values
        ans =
            40
            45
            50
            55
            60
            65
            70
            75
            80
            85
            90

s.Stimulus.IndepVar.Values=[70;80;90]; %音圧を３種類で#Cond=3

        G0901_1_2_SPL.Stimulus.Special
        ans = 
                 RepDur: 100
               BurstDur: 25
                CarFreq: 6094
                ModFreq: 1.4694e-039
               BeatFreq: 0
            BeatModFreq: 0
             ActiveChan: 1

s.Stimulus.Special.RepDur=100;% #0\Info.txtの中のISIをコピーする
s.Stimulus.Special.BurstDur=200;% SetTone.matの中のSetting.ToneDurをコピーする。
% ただしSetting.Silence1=0;Setting.Silence2=0;にしておく必要ある
s.Stimulus.Special.CarFreq=1000;% SetTone.matの中のSetting.FreqManualをコピーする。
s.Stimulus.Special.ModFreq=0;% これでいいだろう
s.Stimulus.Special.BeatFreq=0;% これでいいだろう
s.Stimulus.Special.BeatModFreq=0;% これでいいだろう
s.Stimulus.Special.ActiveChan=1;% #0\Info.txtの中の%LChanFlag= 1 と %RChanFlag= 0からコピーする。
     
        G0901_1_2_SPL.Stimulus.StimParam
        ans = 
            stimcntrl: [1x1 struct]
                indiv: [1x1 struct]
        G0901_1_2_SPL.Stimulus.StimParam.stimcntrl
        ans = 
                complete: 1
                stimtype: 2
                  seqnum: 1
              max_subseq: 11
              contrachan: 2
              activechan: 1
               limitchan: 1
            spllimitchan: 1
                interval: 100
                repcount: 200
                    dsid: '----------'
               spl_loops: 1
               DUR2delay: [1.4694e-039 1.4694e-039]
                   today: [28 8 2008 20 9 35]
                tape_ctl: [1x1 struct] 
        
s.Stimulus.StimParam.stimcntrl.complete=1;% これでいいだろう
s.Stimulus.StimParam.stimcntrl.stimtype=2;% これでいいだろう
s.Stimulus.StimParam.stimcntrl.seqnum=1;% 同じニューロンで２番目以降の計測は２，３、、と名付けていく
s.Stimulus.StimParam.stimcntrl.max_subseq=3;% #0\Info.txtの中の%NStim= 3から抽出する　あるいは  MonitorSetting.PSTH.StimIdx=3より
s.Stimulus.StimParam.stimcntrl.contrachan=2;% 左耳刺激ならこれでいいだろう
s.Stimulus.StimParam.stimcntrl.activechan=1;% 左耳刺激ならこれでいいだろう
s.Stimulus.StimParam.stimcntrl.limitchan=1;% 左耳刺激ならこれでいいだろう
s.Stimulus.StimParam.stimcntrl.spllimitchan=1;% 左耳刺激ならこれでいいだろう
s.Stimulus.StimParam.stimcntrl.interval=100;% #0\Info.txtの中のISIをコピーする
s.Stimulus.StimParam.stimcntrl.repcount=10;% Toneを使って#Re=10の場合を想定した。MultiToneなら1でよいはずだがよく考える必要がある。
s.Stimulus.StimParam.stimcntrl.dsid='----------';% これでいいだろう
s.Stimulus.StimParam.stimcntrl.spl_loops=1;% これでいいだろう
s.Stimulus.StimParam.stimcntrl.DUR2delay=[0 0];% これでいいだろう
s.Stimulus.StimParam.stimcntrl.today= [28 8 2008 20 9 35];%そのときのday month year hour min secを入れる       
        
        G0901_1_2_SPL.Stimulus.StimParam.stimcntrl.tape_ctl
        ans = 
            block: [8 0 0 0 0 0 0 0]     

s.Stimulus.StimParam.stimcntrl.tape_ctl.block= [8 0 0 0 0 0 0 0];% これでいいだろう     
    
        G0901_1_2_SPL.Stimulus.StimParam.indiv
        ans = 
            stim: {[1x1 struct]  [1x1 struct]}     
        G0901_1_2_SPL.Stimulus.StimParam.indiv.stim
        ans = 
            [1x1 struct]    [1x1 struct]     
        G0901_1_2_SPL.Stimulus.StimParam.indiv.stim{1}
        ans = 
                 lospl: 90
                 hispl: 40
              deltaspl: -5
                  freq: 6094
               modfreq: 1.4694e-039
            modpercent: 100
                 delay: 1.4694e-039
              duration: 25
                  rise: 2.5000
                  fall: 2.5000
          
          
s.Stimulus.StimParam.indiv.stim{1}.lospl=70;% 最初に提示するSPL
s.Stimulus.StimParam.indiv.stim{1}.hispl=90;% 最後に提示するSPL
s.Stimulus.StimParam.indiv.stim{1}.deltaspl=10;%　大きくしていくなら正、小さくしていくなら負になる
s.Stimulus.StimParam.indiv.stim{1}.freq=1000;% SetTone.matの中のSetting.FreqManualをコピーする。
s.Stimulus.StimParam.indiv.stim{1}.modfreq=0;% これでいいだろう
s.Stimulus.StimParam.indiv.stim{1}.modpercent=100;% これでいいだろう
s.Stimulus.StimParam.indiv.stim{1}.delay=0;% これでいいだろう
s.Stimulus.StimParam.indiv.stim{1}.duration=200;% SetTone.matの中のSetting.ToneDurをコピーする。
s.Stimulus.StimParam.indiv.stim{1}.rise=5;% SetTone.matの中のSetting.Rampをコピーする。
s.Stimulus.StimParam.indiv.stim{1}.fall=5;% SetTone.matの中のSetting.Rampをコピーする。         
          
          
        G0901_1_2_SPL.Stimulus.StimParam.indiv.stim{2}
        ans = 
                 lospl: 90
                 hispl: 40
              deltaspl: -5
                  freq: 6094
               modfreq: 1.4694e-039
            modpercent: 100
                 delay: 1.4694e-039
              duration: 25
                  rise: 2.5000
                  fall: 2.5000    
    
s.Stimulus.StimParam.indiv.stim{2}.lospl=70;% 最初に提示するSPL
s.Stimulus.StimParam.indiv.stim{2}.hispl=90;% 最後に提示するSPL
s.Stimulus.StimParam.indiv.stim{2}.deltaspl=10;%　大きくしていくなら正、小さくしていくなら負になる
s.Stimulus.StimParam.indiv.stim{2}.freq=1000;% SetTone.matの中のSetting.FreqManualをコピーする。
s.Stimulus.StimParam.indiv.stim{2}.modfreq=0;% これでいいだろう
s.Stimulus.StimParam.indiv.stim{2}.modpercent=100;% これでいいだろう
s.Stimulus.StimParam.indiv.stim{2}.delay=0;% これでいいだろう
s.Stimulus.StimParam.indiv.stim{2}.duration=200;% SetTone.matの中のSetting.ToneDurをコピーする。
s.Stimulus.StimParam.indiv.stim{2}.rise=5;% SetTone.matの中のSetting.Rampをコピーする。
s.Stimulus.StimParam.indiv.stim{2}.fall=5;% SetTone.matの中のSetting.Rampをコピーする。
                  

        G0901_1_2_SPL.Settings
        ans = 
             SessionInfo: []
            RecordParams: [1x1 struct]    

s.Settings.SessionInfo=[];% これでいいだろう    

        G0901_1_2_SPL.Settings.RecordParams
        ans = 
             samFreqs: [6.0096e+004 1.2500e+005]
            switchDur: 80

% LouageJNS2005pp1561に、"All stimuli were computed at a sample rate of 125 kHz 
% and passed through an antialiasing filter with a cutoff of 60 kHzとある
% ExptManでは、刺激を作るRP2は、Fs=48828.125 Hzで、ナイキストがその半分と考えて24414.0624 Hzとしておく
s.Settings.RecordParams.samFreqs= [24414.0624 48828.125];

s.Settings.RecordParams.switchDur=80;
% newSGSR\vs30\Init\localSysParam.mの163行目に% swichdur must be
% >=30と記載あるがExptManではswitchを使っていなさそうなので80のままにしておく。
    
    
    
    
    
    
    