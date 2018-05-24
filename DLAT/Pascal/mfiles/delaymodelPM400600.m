% delaymodelPM 
%
% phase- vs group delay
% - shiftarg = 0 shifts entire phase range
% - shiftarg = 1 rotation, constant phase of CF
% - shiftarg = 2 rotation, constant phase of lowest freq.
%   frequentie vastgehouden wordt.
%
% e.g. 500Hz centerfreq, 51 components, rotate on zero: delaymodelPM(500,51,2,1) 
%
% PM Oct. 06
% ===========================================================================================================

function delaymodelPM = delaymodelPM(centerfreq,comp,shiftarg,shiftpara)

close all;

% parameters & vectors used----------------------------------------------------------------------------------

a = 0;
b = 2;

F= [];
A = [];

Ltau = [];
Rtau = [];

S = [];

Lstim = cell(comp,1);
Rstim = cell(comp,1);

Ltot = 0;
Rtot = 0;

Fs = 5000;                   % Sampling frequency 
Ts = 1/Fs;                   % Sample time 
L = 10;                      % Length of signal (ms)

ts = 0:Ts:L;                   

CF = centerfreq*((2*pi)/1000);
%------------------------------------------------------------------------------------------------------------------------
% frequency & amplitude: Le & Ri
%------------------------------------------------------------------------------------------------------------------------

% frequencydomain
% eg. centered on 440Hz: [293 - 587]

bandlim = (centerfreq/5); 
lowlim = (centerfreq - bandlim);
uplim = (centerfreq + bandlim);

for n = 0:8:(lowlim) 
    freq = n;
    F = [F freq];
end

for n = 1:((comp/2)-0.5)
    freq = lowlim + ((n-1)*(bandlim/(comp/2)));
    F = [F freq]; 
end  

freq = centerfreq;
F = [F freq];

for n = 1:((comp/2)-0.5)
    freq = centerfreq + ((n)*(bandlim/(comp/2))) + randn;
    F = [F freq];
end    

for n = 600:8:1000 % voorbereiding op filter
    freq = n;
    F = [F freq];
end

% ampl: gaussian distr.

for n = 0:8:(lowlim)  %filterprincipe: alle freq. onder bepaalde lowlim krijgen amplitude 0
    A = [A 0];
end

B = gausswin(comp);
    
for n = 1:comp
    A = [A B(n,1)];
end

for n = 1:8:404 % filter: alles boven uplim krijgt amplitude 0
    A = [A 0];
end

% plot Le F/A

    figure(1);
    subplot(4,2,1);
    plot(F,A);
    xlim([0 1000]);
    xlabel('frequency(Hz)');
    ylabel('amplitude');
    title('Left');
    grid on;

% plot Ri F/A

    subplot(4,2,2);
    plot(F,A);
    xlim([0 1000])
    xlabel('frequency(Hz)');
    ylabel('amplitude');
    title('Right');
    grid on;
    
% freq. omzetten naar tijdsdomein
    
%------------------------------------------------------------------------------------------------------------------------
% random phase: Le
%------------------------------------------------------------------------------------------------------------------------

for n = 1:123;
    p = a + b * rand;
    ltau = p;
    Ltau = [Ltau ltau];
end

    subplot(4,2,3);
    plot(F,(Ltau),'o');
    xlim([0 1000])
    xlabel('frequency(Hz)');
    ylabel('phase(*pi,rad)');
    grid on;

%------------------------------------------------------------------------------------------------------------------------
% random phase: Ri
%------------------------------------------------------------------------------------------------------------------------

% shift entire freq/phase up

if shiftarg == 0
    Rtau = Ltau;
    for n = 1:123;
        s = shiftpara;
        S = [S s];
    end
    Rtau = Rtau+S; 
end

% rotate around center frequency

if shiftarg == 1
    Rtau = Ltau;
    S = [-shiftpara:((2*shiftpara)/(123-1)):shiftpara];
    Rtau = Rtau + S;
end

% rotate around point of zero frequency

if shiftarg == 2
    Rtau = Ltau;
    S = [0:(shiftpara/(123-1)):shiftpara];
    Rtau = Rtau + S;
end
    
    subplot(4,2,4);
    plot(F,Rtau,'o');
    xlim([0 1000])
    xlabel('frequency(Hz)');
    ylabel('phase(*pi,rad)');
    grid on;
    
%------------------------------------------------------------------------------------------------------------------------
% Components of the Le & Ri stimulus 
%------------------------------------------------------------------------------------------------------------------------

Fst = F./1000;
    
Fc = Fst';
Ltauc = Ltau';
Rtauc = Rtau';

A = A';

% cell array --> each row is a seperate component of the noise

for n = 52:72
    Lcomp = A(n,1) *sin (Fc(n,1) *(ts*2*pi)  + (Ltauc(n,1)*pi)) ;
    subplot(4,2,5);
    plot(ts,Lcomp); 
    xlabel('time(ms)');
    ylabel('amplitude');
    hold on;
    grid on;
    Lstim(n-51) = {Lcomp};
end

hold off;    

for n = 52:72
    Rcomp = A(n,1) *sin (Fc(n,1) *(ts*2*pi)  + (Rtauc(n,1)*pi)) ;
    subplot(4,2,6);
    plot(ts,Rcomp);
    xlabel('time(ms)');
    ylabel('amplitude');
    hold on;
    grid on;
    Rstim(n-51) = {Rcomp};
end

hold off;    
    
%------------------------------------------------------------------------------------------------------------------------
% Le & Ri stimulus 
%------------------------------------------------------------------------------------------------------------------------

for n = 1:comp-1
    Ln = Lstim{n,1}+Lstim{n+1,1};
    Ltot = Ltot + Ln;
end
Ltot = Ltot';
    
    subplot(4,2,7);
    plot(ts,Ltot);
    xlim([0 10])
    ylim([-10 10])
    xlabel('time(ms)');
    ylabel('amplitude');
    grid on;

for n = 1:comp-1
    Rn = Rstim{n,1}+Rstim{n+1,1};
    Rtot = Rtot + Rn;
end

Rtot = Rtot';
    
    subplot(4,2,8);
    plot(ts,Rtot);
    xlim([0 10])
    ylim([-10 10])
    xlabel('time(ms)');
    ylabel('amplitude');
    grid on;


%------------------------------------------------------------------------------------------------------------------------
% interaural phase difference 
%------------------------------------------------------------------------------------------------------------------------

IPD = (Rtauc-Ltauc);

    if shiftarg == 0
    figure(2);
    subplot(2,1,1);
    plot(F,IPD);
    xlim([0 1000])
    ylim([-2 2])
    xlabel('frequency(Hz)');
    ylabel('interaural phase difference(pi)');
    title('constant phaseshift, all frequencies');
    grid on;
    end

    if shiftarg == 1
    figure(2);
    subplot(2,1,1);
    plot(F,IPD);
    xlim([0 1000])
    ylim([-2 2])
    xlabel('frequency(Hz)');
    ylabel('interaural phase difference(pi)');
    title('frequency-dependent shift: CF constant');
    grid on;
    end

    if shiftarg == 2
    figure(2);
    subplot(2,1,1);
    plot(F,IPD);
    xlim([0 1000])
    ylim([-2 2])
    xlabel('frequency(Hz)');
    ylabel('interaural phase difference(pi)');
    title('frequency-dependent shift: lowest frequency constant');
    grid on;
    end
    
%------------------------------------------------------------------------------------------------------------------------
% slope
%------------------------------------------------------------------------------------------------------------------------

% frequency = Hz: t-1
% phase in pi, no dimension
% slope of IPD function is time function

Slope = (max(IPD)-(min(IPD))/((max(F)-min(F))))      

%------------------------------------------------------------------------------------------------------------------------
% correlogram 
%------------------------------------------------------------------------------------------------------------------------

SC = xcorr(Ltot, 'coeff');
[how,where] = max(SC);

XC = xcorr(Ltot, Rtot, 'coeff');
[How,Where] = max(XC);

txc = -L:Ts:L;    

    subplot(2,1,2);
    plot(txc,SC,'--');
    hold on;
    plot(txc,XC,'r-','LineWidth',2);
    xlim([-10 10])
    ylim = ([0 1]);
    xlabel('delay(ms)');
    ylabel('correlation');
    title('dashed line = corr. without IPD, bold line = corr. with IPD');
    grid on;
    hold off;
    
peakshift = where - Where

