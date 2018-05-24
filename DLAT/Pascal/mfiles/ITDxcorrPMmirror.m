% mirrored ITDxcorrPM: corr(a b) wordt nu corr (b a)
% opgelet, grafieken nog niet aangepast. Uitsluitend bedoeld om
% naar PeakShift te kijken!!
%


close all
DF = 'M0545D';DelayShift = [];
PeakHeight = [];



%=======================================================
% neuron 98: MBL 70
%=======================================================

dsIDp = '98-32-NTD'; ds1 = dataset(DF, dsIDp);Nrec  = ds1.nsubrecorded;[X1, idx] = sort(-ds1.indepval(1:Nrec));Y1 = getrate(ds1, idx);
n1 = max(X1);XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);
    figure(1);    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD & ITD 98-32-NTD (bold) (dashed line = interpolated curve) ');    xlabel('delay (mus)');grid on;    ylabel('Rate');grid on;
    hold on;    plot(XI,YI1,'--');
dsIDp = '98-31-NTD'; ds1 = dataset(DF, dsIDp);Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);
YI2 = INTERP1(X2, Y2,XI);
    plot(X2,Y2,'-', 'LineWidth', 1.5);    plot(XI,YI2,'--', 'LineWidth', 1.5);    hold off;
R = xcorr(YI1, YI2, 'coeff');
    subplot(5,1,3);
    [How,Where] = max(R);
    DelayShift = [DelayShift (Where-6000)];
    PeakHeight = [PeakHeight How];
        plot(( ((-length(R))/2) : ((length(R))-1)/2), R);    title('crosscorrelation of ILD-shifted ITD functions: 98-31-NTD & 98-32-NTD');    xlabel('delay (mus)');grid on;    ylabel('correlation (R)');grid on;
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth', 1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD & 98-32-NTD (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;    
        
pause;
close;

%==============================================================================================================================================

dsIDp = '98-35-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
    
n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-34-NTD & ITD 98-35-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '98-34-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

YI2 = INTERP1(X2, Y2,XI);

    plot(X2,Y2,'-','LineWidth',1.5);
    plot(XI,YI2,'--','LineWidth',1.5);
    hold off;

R = xcorr(YI1, YI2, 'coeff');

    subplot(5,1,3);
    
    [How,Where] = max(R); % opgelet, maximum piek en secundaire piek bijna even groot. Erg grote shift van delay: beter naar secundaire piek kijken?
    DelayShift = [DelayShift (Where-6000)]; 
    PeakHeight = [PeakHeight How];
    
    plot(( ((-length(R))/2) : ((length(R))-1)/2), R);
    title('crosscorrelation of ILD-shifted ITD functions: 98-34-NTD & 98-35-NTD');
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-34-NTD & 98-35-NTD (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;      
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-34-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
    
n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD & ITD 98-34-NTD (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1, '--');

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD & 98-34-NTD (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;          
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-35-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
    
n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-31-NTD & ITD 98-35-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '98-31-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-31-NTD & 98-35-NTD (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;        
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-34-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
    
n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-32-NTD & ITD 98-34-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '98-32-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    title('crosscorrelation of ILD-shifted ITD functions: 98-32-NTD & 98-34-NTD');
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-32-NTD & 98-34-NTD (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;       
    
pause;
close;

%==============================================================================================================================================

dsIDp = '98-35-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);
    
n1 = max(X1);
XI = -n1:1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 98-32-NTD & ITD 98-35-NTD (bold) (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '98-32-NTD'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 98-32-NTD & 98-35-NTD (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;       
    
pause;
close;

%=======================================================
% neuron 110: MBL 70
%=======================================================

dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-11-NTD-6080 & ITD 110-12-NTD-8060 (bold) (dashed line = interpolated curve) ');  
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-11-NTD-6080 & 110-12-NTD-8060 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
        
pause;    
close;    

%==============================================================================================================================================
        
dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-13-NTD-5090 & ITD 110-14-NTD-9050 (bold) (dashed line = interpolated curve) ');    
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-13-NTD-5090 & 110-14-NTD-9050 (bold))')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;    

%==============================================================================================================================================

dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-13-NTD-5090 & ITD 110-12-NTD-8060 (bold) (dashed line = interpolated curve) ');   
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-13-NTD-5090 & 110-12-NTD-8060 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
 
pause;
close;    

%==============================================================================================================================================

dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-13-NTD-5090 & ITD 110-11-NTD-6080 (bold) (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
   
dsIDp = '110-13-NTD-5090'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-13-NTD-5090 & 110-11-NTD-6080 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;  

%==============================================================================================================================================

dsIDp = '110-11-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-14-NTD-9050 & ITD 110-11-NTD-6080 (bold) (dashed line = interpolated curve) ');
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    title('crosscorrelation of ILD-shifted ITD functions: 110-14-NTD-9050 & 110-11-NTD-6080');
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
      
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-14-NTD-9050 & 110-11-NTD-6080 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close;  

%==============================================================================================================================================

dsIDp = '110-12-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-14-NTD-9050 & ITD 110-12-NTD-8060 (bold) (dashed line = interpolated curve) ');    
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '110-14-NTD-9050'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
    
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-14-NTD-9050 & 110-12-NTD-8060 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
  
pause;
close;  

%=======================================================
% neuron 110: MBL 65
%=======================================================

dsIDp = '110-17-NTD-7060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-15-NTD-6070 & ITD 110-17-NTD-7060 (bold) (dashed line = interpolated curve) ');   
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');

dsIDp = '110-15-NTD-6070'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
  
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-15-NTD-6070 & 110-17-NTD-7060 (bold)')
    xlabel('delay (mus)');grid on;
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

n1 = max(X1);
XI = -(n1-100):1:(n1-100);

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 110-16-NTD-8070 & ITD 110-18-NTD-7080 (bold) (dashed line = interpolated curve) ');    
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '110-16-NTD-8070'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    title('crosscorrelation of ILD-shifted ITD functions: 110-16-NTD-8070 & 110-18-NTD-7080');
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;

A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2, 'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 110-16-NTD-8070 & 110-18-NTD-7080 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
    
pause;
close; 

%=======================================================
% neuron 112: MBL 70
%=======================================================

dsIDp = '112-7-NTD-8060'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(-ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

n1 = max(X1);
XI = -(n1):1:n1;

YI1 = INTERP1(X1, Y1,XI);

    figure(1);
    subplot(5,1,1);
    plot(X1,Y1,'-');
    title('ITD 112-6-NTD-6080 & ITD 112-7-NTD-8060 (bold) (dashed line = interpolated curve) ');  
    xlabel('delay (mus)');grid on;
    ylabel('Rate');grid on;
    
    hold on;
    plot(XI,YI1,'--');
    
dsIDp = '112-6-NTD-6080'; 
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X2, idx] = sort(-ds1.indepval(1:Nrec));
Y2 = getrate(ds1, idx);

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
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;
    
A1 = xcorr(YI1, 'coeff');
A2 = xcorr(YI2, 'coeff');
    
    subplot(5,1,5)
    plot(( ((-length(A1))/2) : ((length(A1))-1)/2), A1);
    hold on;
    plot(( ((-length(A2))/2) : ((length(A2))-1)/2), A2,'LineWidth',1.5);
    hold off;
    title('autocorrelation of ILD shifted ITD functions: 112-6-NTD-6080 & 112-7-NTD-8060 (bold)')
    xlabel('delay (mus)');grid on;
    ylabel('correlation (R)');grid on;   
  
pause;
close; 