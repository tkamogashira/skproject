% ITDxcorrPM = crosscorrelation of ILD-shifted ITD curves
% 
% 29/09
% Een upsampling van vector X en vector Y via interp1 w. uitgevoerd, om vervolgens 
% een kruiscorrelatie van de bekomen ITD curves te maken, normalised tov de piek v/d 
% autocorr. Upsampling van X gebeurt van -max(x) tot max(x) in stappen van 1.
%
% 02/10 DelayShift en PeakHeight toegevoegd. 
%
% 03/10 Correlatieplot in tijd (delay) dimensie, niet langer in samples. 
%
% 04/10 Subplots gemaakt, tijds-as aangepast, conventie ingevoerd.
% Conventie als volgt: steeds a (negatieve ILD) met b (positieve ILD) correleren. 
% (Dit is gelijk aan a met de hoogste contra intensiteit vgl'en met b met de laagste contra int.)
% Bij twee positieve ILDs steeds grootste als a. 
%
% 05/10 Groupplot van DelayShift vs dILD toegevoegd. Opgelet: steeds ILD2-ILD1.
% Reden is dat de SPLs steeds als I|C aangegeven staan: ipv C-I te doen is er dus steeds 
% I-C gedaan in vorige versies. Deze omgekeerde intensiteitscodering is ook de reden waarom
% er sort(-ds1.indepval) wordt gebruik ipv gewoon sort(indepval). Groupplot geeft verwachte rechte door 0.
%
% Opgelet, 98-34 vs 98-35 staat voorlopig in comment (2e piek versus piek discussie).

close all

DF = 'M0545D';
DelayShift = [];
PeakHeight = [];
dILD = [];

%=======================================================
% neuron 98: controle autocorr.
%=======================================================

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -n1:1:n1;

% upsampling
% YI = INTERP1(Y,XI) assumes X = 1:N, where N is the length(Y) ...
% for vector Y or SIZE(Y,1) for matrix Y.

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD (dashed line = interpolated curve)');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

% idem voor neuron aan andere ILD

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

% eerst delta berekenen voor group-plot

delta = ILD2 - ILD1;
dILD = [dILD delta];

% voortgaan met correlatie

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-','LineWidth',1.5);
    plot(XI,YI2,'--','LineWidth',1.5);
    
    hold off;
    
% kruiscorrelatie: geen effect van XI1, want gelijk gesampled: enkel YI kruiscorreleren.

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R); % geeft x-as voor gebruik met xcorr R op. Zonder length-parameter gebruikt x-as "samples".
    title('autocorrelation of ILD-shifted ITD functions: 98-31-NTD');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
   
% autocorr. van de twee noise-delays (ITD)

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth', 1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
    
pause;
close;

%=======================================================
% neuron 98: MBL 70
%=======================================================

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);
    
n1 = max(X1);
XI = -n1:1:n1;

% upsampling
% YI = INTERP1(Y,XI) assumes X = 1:N, where N is the length(Y) ...
% for vector Y or SIZE(Y,1) for matrix Y.

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD & ITD 98-32-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
   
    hold on;
    plot(XI,YI1,'--');

% idem voor neuron aan andere ILD

dsIDp = '98-32-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

% eerst delta berekenen voor group-plot

delta = ILD2 - ILD1;
dILD = [dILD delta];

% voortgaan met correlatie

YI2 = INTERP1(X2, Y2,XI);


    plot(X2,Y2,'-', 'LineWidth', 1.5);
    plot(XI,YI2,'--', 'LineWidth', 1.5);
    hold off;
  
% kruiscorrelatie: geen effect van XI1, want gelijk gesampled: enkel YI kruiscorreleren.

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 98-31-NTD & 98-32-NTD');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

% autocorr. van de twee noise-delays (ITD)

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth', 1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD & 98-32-NTD (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;    
        
pause;
close;

%==============================================================================================================================================

% dsIDp = '98-34-NTD'; 
% ds1 = dataset(DF, dsIDp);
% Nrec  = ds1.nsubrecorded;
% [X1, idx] = sort(-ds1.indepval(1:Nrec));
% Y1 = getrate(ds1, idx);
% 
% ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);
% 
% n1 = max(X1);
% XI = -n1:1:n1;
% 
% YI1 = INTERP1(X1, Y1,XI);
% 
%     figure(1);
%     subplot(5,1,1);
%     plot(X1,Y1,'-');
%     title('ITD 98-34-NTD & ITD 98-35-NTD (bold) (dashed line = interpolated curve) ');
%     xlabel('delay (\mus)');grid on;
%     ylabel('Rate');grid on;
%     
%     hold on;
%     plot(XI,YI1,'--');
%     
% dsIDp = '98-35-NTD'; 
% ds1 = dataset(DF, dsIDp);
% Nrec  = ds1.nsubrecorded;
% [X2, idx] = sort(-ds1.indepval(1:Nrec));
% Y2 = getrate(ds1, idx);
% 
% ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);
% 
% % eerst delta berekenen voor group-plot
% 
% delta = ILD2 - ILD1;
% dILD = [dILD delta];
% 
% % voortgaan met correlatie
% 
% 
% YI2 = INTERP1(X2, Y2,XI);
% 
%     plot(X2,Y2,'-','LineWidth',1.5);
%     plot(XI,YI2,'--','LineWidth',1.5);
%     hold off;
% 
% R = xcorr(YI1, YI2, 'coeff');
% 
%     subplot(5,1,3);
%     
%     [How,Where] = max(R); % opgelet, maximum piek en secundaire piek bijna even groot. Erg grote shift van delay: beter naar secundaire piek kijken?
%     DelayShift = [DelayShift (Where-6000)]; 
%     PeakHeight = [PeakHeight How];
%     
%     plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
%     title('crosscorrelation of ILD-shifted ITD functions: 98-34-NTD & 98-35-NTD');
%     xlabel('delay (\mus)');grid on;
%     ylabel('correlation (R)');grid on;
% 
% A1 = xcorr(YI1, 'coeff');
% A2 = xcorr(YI2, 'coeff');
%     
%     subplot(5,1,5)
%     plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
%     hold on;
%     plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
%     hold off;
%     title('autocorrelation of ILD shifted ITD functions: 98-34-NTD & 98-35-NTD (bold)')
%     xlabel('delay (\mus)');grid on;
%     ylabel('correlation (R)');grid on;      
%     
% pause;
% close;

%==============================================================================================================================================

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD & ITD 98-34-NTD (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1, '--');

dsIDp = '98-34-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];


YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
    
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 98-31-NTD & 98-34-NTD');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD & 98-34-NTD (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;          
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);


n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD & ITD 98-35-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '98-35-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
    
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 98-31-NTD & 98-35-NTD');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD & 98-35-NTD (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;        
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-34-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
  
    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-34-NTD & ITD 98-32-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '98-32-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
    
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 98-34-NTD & 98-32-NTD');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-34-NTD & 98-32-NTD (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;       
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-32-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
    
    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-32-NTD & ITD 98-35-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '98-35-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
    
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 98-32-NTD & 98-35-NTD');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-32-NTD & 98-35-NTD (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;       
    
pause;
close;

%=======================================================
% neuron 110: MBL 70
%=======================================================

dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-11-NTD-6080 & ITD 110-12-NTD-8060 (bold) (dashed line = interpolated curve) ');  
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
       
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-11-NTD-6080 & 110-12-NTD-8060');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-11-NTD-6080 & 110-12-NTD-8060 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
        
pause;    
close;    

%==============================================================================================================================================
        
dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-13-NTD-5090 & ITD 110-14-NTD-9050 (bold) (dashed line = interpolated curve) ');    
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off; 

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
       
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-13-NTD-5090 & 110-14-NTD-9050');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-13-NTD-5090 & 110-14-NTD-9050 (bold))')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;    

%==============================================================================================================================================

dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-13-NTD-5090 & ITD 110-12-NTD-8060 (bold) (dashed line = interpolated curve) ');   
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-13-NTD-5090 & 110-12-NTD-8060');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-13-NTD-5090 & 110-12-NTD-8060 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
 
pause;
close;    

%==============================================================================================================================================

dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-13-NTD-5090 & ITD 110-11-NTD-6080 (bold) (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
   
dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off; 

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-13-NTD-5090 & 110-11-NTD-6080');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-13-NTD-5090 & 110-11-NTD-6080 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;  

%==============================================================================================================================================

dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-11-NTD-6080 & ITD 110-14-NTD-9050 (bold) (dashed line = interpolated curve) ');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
    
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-11-NTD-6080 & 110-14-NTD-9050');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
      
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-11-NTD-6080 & 110-14-NTD-9050 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;  

%==============================================================================================================================================

dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-14-NTD-9050 & ITD 110-12-NTD-8060 (bold) (dashed line = interpolated curve) ');    
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-14-NTD-9050 & 110-12-NTD-8060');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
    
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-14-NTD-9050 & 110-12-NTD-8060 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
  
pause;
close;  

%=======================================================
% neuron 110: MBL 65
%=======================================================

dsIDp = '110-15-NTD-6070'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-15-NTD-6070 & ITD 110-17-NTD-7060 (bold) (dashed line = interpolated curve) ');   
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-17-NTD-7060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-15-NTD-6070 & 110-17-NTD-7060');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-15-NTD-6070 & 110-17-NTD-7060 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;  

%=======================================================
% neuron 110: MBL 75
%=======================================================

dsIDp = '110-18-NTD-7080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-18-NTD-7080 & ITD 110-16-NTD-8070 (bold) (dashed line = interpolated curve) ');    
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '110-16-NTD-8070'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;   

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6900)];
    PeakHeight = [PeakHeight How];
    
    plot((((-length(R))/2):((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 110-18-NTD-7080 & 110-16-NTD-8070');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-18-NTD-7080 & 110-16-NTD-8070 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close; 

%=======================================================
% neuron 112: MBL 70
%=======================================================

dsIDp = '112-6-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    ILD1 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

n1 = max(X1);
XI = -(n1):1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 112-6-NTD-6080 & ITD 112-7-NTD-8060 (bold) (dashed line = interpolated curve) ');  
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '112-7-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

    ILD2 = ds1.Stimulus.StimParam.SPL(1)-ds1.Stimulus.StimParam.SPL(2);

    delta = ILD2 - ILD1;
    dILD = [dILD delta];

YI2 = INTERP1(X2, Y2,XI);

    hold on;
    plot(X2,Y2,'-', 'LineWidth',1.5);
    plot(XI,YI2,'--', 'LineWidth',1.5);
    hold off;
    
R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
    
    plot((((-length(R))/2):((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 112-6-NTD-6080 & 112-7-NTD-8060');
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;
    
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 112-6-NTD-6080 & 112-7-NTD-8060 (bold)')
    xlabel('delay (\mus)');grid on;
    ylabel('correlation (R)');grid on;   
  
pause;
close; 

%=======================================================
% groupplot
%=======================================================

plot(dILD, DelayShift,'or');
title('Groupplot DelayShift / dILD');
xlabel('dILD (ILD2 - ILD1) (dB SPL)');
ylabel('DelayShift (\mus)');
grid on;

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------