%
%     Demonstrations for introducting auditory filters
%     DemoAF_Basics
%     Irino, T.
%     Created:  18 Mar 2010
%     Modified: 18 Mar 2010
%     Modified: 11 May 2010 (Figure number)
%     Modified: 27 May 2010 (marker)
%     Modified: 11 Jun 2010 (Figure number)
%
%     
%

%%% Param values from PUI 2003 %%%
n = 4;       
b1 = 1.81;   
c1 = -2.96;  
b2 = 2.17;   
c2 = 2.20;   
frat0 = 0.466;
frat1 = 0.0109;

Nrsl = 2^12;
fs = 44100;
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf;
%%% Frequnecy dependency %%%%
disp('Figure 1: Frequency response');
fpList = [250 500 1000 2000 4000 8000];
fpXTick = [100 250 500 1000 2000 4000 8000 16000];
ERBNXTick = Freq2ERB(fpXTick);

Ps = 50;
frat = frat0 + frat1*Ps;
for fp = fpList
  fr1 = Fp2toFr1(n,b1,c1,b2,c2,frat,fp); 
  cGCresp = CmprsGCFrsp(fr1,fs,n,b1,c1,frat,b2,c2,Nrsl);

  cGCFrsp = cGCresp.cGCFrsp;
  cGCFrspdB = 20*log10(cGCFrsp/max(cGCFrsp));
  freq = cGCresp.freq;
  ERBNnum = Freq2ERB(freq);
  
  plot(ERBNnum,cGCFrspdB)
  ax = axis;
  axis([ERBNXTick([1 end]) -70 5]);
  set(gca,'XTick',ERBNXTick);
  set(gca,'XTickLabel',fpXTick);
  hx = xlabel('Frequency (Hz)');
  hy = ylabel('Filter Gain (dB)');
  title('Frequnecy response');
  hold on
end;
drawnow
hold off
DemoAF_PrintFig([DirWork 'DemoAF_Fig1']);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10); clf;
%%% Frequnecy dependency %%%%
disp('Figure 10: ERB_N');
freq = 100:100:12000;
[ERBNnum ERBN] = Freq2ERB(freq);
loglog(freq,ERBN);
axis([50 15000 20 2500]);
xlabel('Center frequency (Hz)');
ylabel('Equivalent Rectangular Bandwidth (Hz)');
grid on
%set(gca,'Xtick',[50 100 200 500 1000 2000 5000 10000]);
%set(gca,'Xticklabel',[50 100 200 500 1000 2000 5000 10000]);
%set(gca,'Ytick',[20 50 100 200 500 1000 2000]);
%set(gca,'Yticklabel',[20 50 100 200 500 1000 2000]);
drawnow
hold off
DemoAF_PrintFig([DirWork 'DemoAF_Fig10']);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2); clf;
Marker = ['o','x','d','*','^','p','s'];
%%% Level dependency %%%%
disp('Figure 2: Filter level dependency');
fp = 2000;
PsList = 30:10:90;
cGCFrspdBMax = [];
cnt = 0;
for Ps = PsList
  cnt = cnt +1;
  frat = frat0 + frat1*Ps;
  fr1 = Fp2toFr1(n,b1,c1,b2,c2,frat,fp); 
  cGCresp = CmprsGCFrsp(fr1,fs,n,b1,c1,frat,b2,c2,Nrsl);

  cGCFrsp = cGCresp.cGCFrsp;
  if cnt == 1, cGCFrspRef = max(cGCFrsp); end;
  cGCFrspdB = 20*log10(cGCFrsp/cGCFrspRef);
  freq = cGCresp.freq;
  cGCFrspdBMax(cnt) = max(cGCFrspdB);
  
  plot(freq,cGCFrspdB)
  hold on;
  plot(fp,cGCFrspdBMax(cnt),Marker(cnt))
  axis([0 4000 -70 5]);
  set(gca,'XTick',[0:1000:4000]);

  text(fp*1.05, cGCFrspdBMax(cnt), int2str(Ps));
  hx = xlabel('Frequency (Hz)');
  hy = ylabel('Filter Gain (dB)');
end;
text(fp*1.15,2.5,'Input Level (dB)');
title('Frequnecy response');
drawnow
hold off
DemoAF_PrintFig([DirWork 'DemoAF_Fig2']);


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% input output function %%%
figure(3); clf;
disp('Figure 3: Input-output function');
OutputLevel = cGCFrspdBMax+PsList+33;
plot(PsList,OutputLevel,PsList,PsList,'--');
hold on
for cnt =1:length(OutputLevel);
    plot(PsList(cnt),OutputLevel(cnt),Marker(cnt));
end;
axis([PsList([1 end]), PsList(1), PsList(end)+5]);
set(gca,'XTick',PsList);
hx = xlabel('Input Level (dB)');
set(gca,'YTick',PsList);
hy = ylabel('Output Level (dB)');
title('Input-Output function');
% legend('IO function','linear line',4);
drawnow
DemoAF_PrintFig([DirWork 'DemoAF_Fig3']);

