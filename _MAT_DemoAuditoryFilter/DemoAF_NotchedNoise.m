%
%     Demonstrations for introducting auditory filters
%     DemoAF_NotchedNoise
%     Irino, T.
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 11 Mar 2010
%     Modified: 16 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 10 May 2010 (Unicode)
%     Modified: 11 Jun 2010 (Figure number)
%
%     
%

   DemoAF_MkProbeTone  

%% Parameter settings 
   ParamNN.fs = fs;
   ParamNN.fp = fp;
   ParamNN.FreqBand   = 0.4*fp;
   ParamNN.FreqLowMax = [1:-0.1:0.5]*fp;
   ParamNN.FreqLowMin = ParamNN.FreqLowMax-ParamNN.FreqBand;
   ParamNN.FreqUppMin = [1:0.1:1.5]*fp;
   ParamNN.FreqUppMax = ParamNN.FreqUppMin+ParamNN.FreqBand;
   ParamNN.FreqNotchWidth = ParamNN.FreqUppMin-ParamNN.FreqLowMax;

   %% Note: The following setting depends on your audio settings.
   %% These are dummy values for Demonstration purpose.
   ParamNN.N0         = 40;  % Noise level.  it is dummy value!
   ParamNN.FloorLevel = 30;  % Dummy floor level for consistency. 


%% %% PlaySnd with/without Masking noise

   for nb = 0:length(ParamNN.FreqLowMax)
     if nb == 0, % no masking noise
       disp(' ');
       if SwEnglish == 0,
         disp('５dBずつ減衰するプローブ音系列を２回再生します。');
         disp('何個聞こえるか答えてください。');
        else
         disp('You will hear 2000-Hz tone in several descreasing steps of 5 dBs.');
         disp('Count how many steps you can hear.');
         disp('Series are presented twice.');
       end;
       
       PlaySnd = pipStair;
       numResp = length(ParamNN.FreqLowMax)+1;
     
     else
       disp(['------------------------']); 
       if nb == 1,
         if SwEnglish == 0,
           disp('次にノッチ雑音を重畳します。');
           disp('ノッチ雑音の種類ごとに,何個聞こえるか答えてください。');
         else
           disp('Now the signal is masked with notched noise.');
           disp('How many steps can you hear?');
         end;
       end;
           
       BPN1 = [];
       BPN2 = [];
       if SwEnglish == 0,
         disp(['ノッチ幅 ' int2str(ParamNN.FreqNotchWidth(nb)) ...
               '(Hz)']); 
       else
         disp(['Notch width: ' int2str(ParamNN.FreqNotchWidth(nb)) ...
               '(Hz)']); 
       end;

       % making Bandpass noise and playback together        
       AmpBPN = AmpPip;   
       fBand1 = [ParamNN.FreqLowMin(nb), ParamNN.FreqLowMax(nb)];
       BPN1 = MkBPNoise(fs,fBand1,length(pipStair)/fs*1000); % in ms
       fBand2 = [ParamNN.FreqUppMin(nb), ParamNN.FreqUppMax(nb)];
       BPN2 = MkBPNoise(fs,fBand2,length(pipStair)/fs*1000); % in ms

       PlaySnd = AmpBPN*(BPN1+BPN2) + pipStair;
       numResp = nb;
     end;
     
%% %% plot Spectrogram of the initial part
     figure(11);
     Nrsl = 2^16;
     [frsp, freq] = freqz(PlaySnd(1:Nrsl),1,Nrsl,fs);
     plot(freq,20*log10(abs(frsp)));
     axis([0, fp*2.5, -40 80]);
     axis([0, fp*2.5, -20 80]);
     xlabel('Frequency (Hz)');
     ylabel('Level (dB)');
     drawnow
 

%%   %% Playback & collect response
     if max(abs(PlaySnd))> 1
         error('Sound amp. exceeds the limit (1.0).');
     end;
     if SwEnglish == 0,
       if SwSound == 1, 
          kk = input('リターンで再生開始 >> ');
       end;
       disp('再生中...　　（Figure 11 にスペクトル表示中）');
       strAns ='聞こえた数 >> ';
     else
       if SwSound == 1, 
           kk = input('Start by return >> ');
       end;
       disp('Playing now...     (Spectrum in Figure 11)');
       strAns ='Steps >> ';
     end;

     if SwSound == 1,
       sound(PlaySnd(:),fs);	
     end;
     rsp = [];
     while length(rsp) == 0,
         rsp = input(strAns);
     end;
     Resp1(numResp) = rsp;
     disp(' ');
     disp(' ');
   
  end;   %  for nb = 0:length(ParamNN.FreqLowMax)

%% %% plot notchwidth vs. ProbeLevel
   figure(6);
   disp('Figure 6: Result')
   ProbeLevel = (Resp1(1:length(ParamNN.FreqNotchWidth)) - Resp1(end))*(-5);
   ProbeLevel = ProbeLevel + ParamNN.FloorLevel;
   plot(ParamNN.FreqNotchWidth,ProbeLevel,'*-');
   xlabel('Notch bandwidth (Hz)');   
   ylabel('Degree of masking (dB)');
   ax = axis;
   axis([ax(1:2), ax(3)-5, ax(4)+5]);
   grid on;

   DemoAF_PrintFig([DirWork 'DemoAF_Fig6a']);

