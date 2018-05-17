%
%     Demonstrations for introducting auditory filters
%     DemoAF_ShapeEstimation
%     Estimation of Auditory filter frequency response
%     Irino, T.
%     Created:  16 Mar 2010
%     Modified: 16 Mar 2010
%     Modified: 11 May 2010
%     Modified: 21 May 2010
%     Modified: 11 Jun 2010 (Figure number)
%     Modified: 14 Jun 2010 (Gammatone & Gammachirp)
%     Modified: 25 Jun 2010 (Fig. 12)
%
%     


%% %% 
   Nrsl = 2^12;
   ParamNN.Nrsl = Nrsl;
   
   b_init  = 1.019; 
   K_init  = 4; 
   [frsp_init, freq] = GammaChirpFrsp(ParamNN.fp,ParamNN.fs,4,...
                                      b_init,0,0,ParamNN.Nrsl);
%% optimization
   ParamOpt = [b_init K_init];
   [ParamOpt, fval] = fminsearch(@DemoAF_PowerSpecModel,...
                                  ParamOpt,[],ParamNN,ProbeLevel);
   
   b_opt = ParamOpt(1);
   K_opt = ParamOpt(2);
  
   str1 = ['b = ' num2str(b_opt,3) ', K = ' num2str(K_opt,3)];
   str2 = ['RMS error = ' num2str(fval,3) ' (dB)'];

   if SwEnglish == 0,
     disp(['推定結果']);
     disp(['パラメータ値: ', str1]);
     disp(['推定誤差: ', str2]);
   else
     disp(['Estimation Result']);
     disp(['Parameter values: ' str1]);
     disp([ str2]);
   end;       

%% % plot results
   [frsp_opt,  freq] = GammaChirpFrsp(ParamNN.fp,ParamNN.fs,4,...
                                      b_opt,0,0,ParamNN.Nrsl);

   figure(7)
   disp('Figure 7: Estimated filter shape')
   plot(freq, 20*log10(abs(frsp_opt) /max(abs(frsp_opt))), ...
        freq, 20*log10(abs(frsp_init)/max(abs(frsp_init))), '--')
   xlabel('Frequency (Hz)');
   ylabel('Filter Gain (dB)');
   legend('Estimated GT','Default GT');
   axis([0, ParamNN.fp*2, -50 5]);
   DemoAF_PrintFig([DirWork 'DemoAF_Fig7']);
   pause(1)
   
   
%% % plot Estimation points
   figure(6)
   disp('Figure 6: Result and Prediction')  
   [ErrorVal] = DemoAF_PowerSpecModel(ParamOpt,ParamNN,ProbeLevel,1);

   plot(ParamNN.FreqNotchWidth,ProbeLevel,'*-',...
        ParamNN.FreqNotchWidth,ProbeLevel - ErrorVal,'ro');
   legend('Measured level','Model prediction');
   xlabel('Notch bandwidth (Hz)');   
   ylabel('Degree of masking (dB)');
   grid on;
   DemoAF_PrintFig([DirWork 'DemoAF_Fig6']);
   
   
%% % Impulse response of gammatone & gammachirp
   figure(12);
   fp = 2000;
   fs = 44100;
   n = 4;       
   b = 1.019;   % default Gammatone
   cGt = 0;
   cGc = -3;
   [gt, LenGt] = GammaChirp(fp,fs,n,b,cGt);
   gmEnv = GammaChirp(fp,fs,n,b,cGt,0,'envelope');
   [gc, LenGc] = GammaChirp(fp,fs,n,b,cGc);
   tPl = 8;
   nPl = 1:tPl*fs/1000;
   tms = (nPl-1)/fs*1000;
   bz = 2.5;
   gme = [1; -1]*gmEnv(nPl);
   plot(tms,gc(nPl)+bz,tms,gt(nPl),'--', ...
       tms,gme,':k', tms,gme+bz,':k',[0 tPl],[ 0, bz; 0, bz],'k');
   ax = axis;
   axis([0 tPl, -1.2, 3.7]);
   set(gca,'YTickLabel',' ');
   %grid on
   xlabel('Time (ms)');
   ylabel('Amplitude (a.u.)');
   legend('Gammachirp','Gammatone','Location','East');
   title('Impulse Response');
   disp('Figure 12: Impulse response of GT and GC')
   DemoAF_PrintFig([DirWork 'DemoAF_Fig12']);
  
   
%% % Frequency response of gammatone & gammachirp
   figure(13);
   Nfrsl = 1024;
   [frspGT, freq] = freqz(gt,1,Nfrsl,fs);
   [frspGC, freq] = freqz(gc,1,Nfrsl,fs);
   GTdB = 20*log10(abs(frspGT));
   GTdB = GTdB-max(GTdB);
   GCdB = 20*log10(abs(frspGC));
   GCdB = GCdB-max(GCdB);
   plot(freq,GCdB,freq,GTdB,'--');
   axis([0 fp*2, -50, 5]);
   legend('Gammachirp','Gammatone');
   title('Fourier Spectrum');
   xlabel('Frequency (Hz)');
   ylabel('Filter Gain (dB)');
   disp('Figure 13: Fourier spectrum of GT and GC')
   DemoAF_PrintFig([DirWork 'DemoAF_Fig13']);
   
   %%
 
   

