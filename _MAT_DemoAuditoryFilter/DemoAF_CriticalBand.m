%
%     Demonstrations for introducting auditory filters
%     DemoAF_CriticalBand
%     Irino, T.
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 11 Mar 2010
%     Modified: 16 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 11 Apr 2010
%     Modified: 10 May 2010 (Unicode for MATLAB 2010a)
%     Modified: 27 May 2010 
%     Modified: 11 Jun 2010 (Figure number)
%
%     Reference:
%     Houtsma, A.J.M., Rossing, T.D., Wagenaars, W.M., 
%     "Auditory Demostrations," p.10, IPO/ASA CD, Philips, 1126-061,
%     Sept., 1987.
%          
%     
%

   DemoAF_MkProbeTone  

%% %% PlaySnd with/without Masking noise
   %%   bwList = [4000, 1000, 250, 100, 10, 5];
   bwList = [0 4000, 1000, 250, 100, 10];

   for nBW = 1:length(bwList)

     if nBW == 1, % no masking noise
       disp(' ');
       if SwEnglish == 0,
         disp('５dBずつ減衰するプローブ音系列を２回再生します。');
         disp('何個聞こえるか答えてください。');
       else
         disp('You will hear 2000-Hz tone in several descreasing steps of 5 dBs. ');
         disp('Count how many steps you can hear.');
         disp('Series are presented twice.');
       end;
       PlaySnd = pipStair;
     else  % with masking noise
       disp(['------------------------']); 
       if nBW == 2,
         if SwEnglish == 0,
           disp('次に帯域雑音を重畳します。');
           disp('帯域雑音の種類ごとに,何個聞こえるか答えてください。');
           % making Bandpass noise and playback together
         else
           disp('Now the signal is masked with bandpass noise.');
           disp('How many steps can you hear? ');
         end;
       end;
           
       bw = bwList(nBW);
       BPN = [];
       if SwEnglish == 0,
         disp(['帯域幅 ' int2str(bw) ' (Hz)']); 
       else
         disp(['Bandwidth: ' int2str(bw) ' (Hz)']); 
       end;
       AmpBPN = AmpPip*0.2;   
       fBand = [ max(0,fp-bw/2),  fp+bw/2];
       BPN = MkBPNoise(fs,fBand,length(pipStair)/fs*1000); % in ms
       PlaySnd = AmpBPN*BPN + pipStair;
     end;

%% %% plot Spectrogram of the initial part
     figure(11); clf;
     Nrsl = 2^16;
     [frsp, freq] = freqz(PlaySnd(1:Nrsl),1,Nrsl,fs);
     plot(freq,20*log10(abs(frsp)));
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
         rsp     = input(strAns);
     end;
     Resp1(nBW) = rsp;
     disp(' ');
     disp(' ');
   
  end;   %   for nb = 0:length(bwList)

%%
   figure(4); clf;
   disp('Figure 4: Result')
   [frList nsort]  = sort(bwList); % sort order
   RespPl = (Resp1(nsort) - Resp1(1))*(-5); % relative level from no masker
   frListPl = [frList.^(0.3)]; % only for plot purpose. non-linear axis

   plot(frListPl,RespPl,'*-');
   set(gca,'Xtick',frListPl);
   set(gca,'XtickLabel',frList);
   ax = axis;
   axis([ax(1:2), ax(3), ax(4)+5]);
   xlabel('Noise bandwidth (Hz)');   
   ylabel('Degree of masking (dB)');
   grid on;

   DemoAF_PrintFig([DirWork 'DemoAF_Fig4']);
