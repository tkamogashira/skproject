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

function delaymodelPM = delaymodelPM(centerfreq,shiftarg,shiftcf,slope)

close all;

% parameters & vectors used----------------------------------------------------------------------------------

comp = 21;

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

IPD = [];

ts = 0:Ts:L;                   

CF = centerfreq*((2*pi)/1000);
%------------------------------------------------------------------------------------------------------------------------
% frequency & amplitude: Le & Ri
%------------------------------------------------------------------------------------------------------------------------

F = 0:2:1000;

% bandlim = (centerfreq/10); 
% lowlim = (centerfreq - bandlim);
% uplim = (centerfreq + bandlim);
% 
% for n = 0:4:(lowlim) 
%     freq = n;
%     F = [F freq];
% end
% 
% for n = 1:((comp/2)-0.5)
%     freq = lowlim + ((n-1)*(bandlim/(comp/2))) + randn;
%     F = [F freq]; 
% end  
% 
% freq = centerfreq;
% F = [F freq];
% 
% for n = 1:((comp/2)-0.5)
%     freq = centerfreq + ((n)*(bandlim/(comp/2))) + randn;
%     F = [F freq];
% end    
% 
% for n = 559:4:1008 % voorbereiding op filter
%     freq = n;
%     F = [F freq];
% end

% ampl: gaussian distr.

for n = 1:225  % filterprincipe: alle freq. onder bepaalde lowlim krijgen amplitude 0
    A = [A 0];
end

B = gausswin(51);

% B = NORMPDF(F,DF,BW)    
% geeft Gaussian, F voor frequentie-vector (vb definieren als fmin = 0, fmax = 1000 )
% DF als mean, BW als standard deviation. 

% Index = find(B<cutoff)
% Frange = F(Index);

for n = 1:51
    A = [A B(n,1)];
end

for n = 1:225 % filter: alles boven uplim krijgt amplitude 0
    A = [A 0];
end


% plot Le F/A

    figure(1);
    subplot(4,2,1);
    plot(F,A);
    xlim([centerfreq-(centerfreq/3) centerfreq+(centerfreq/3)]);
    xlabel('frequency(Hz)');
    ylabel('amplitude');
    title('Left');
    grid on;

% plot Ri F/A

    subplot(4,2,2);
    plot(F,A);
    xlim([centerfreq-(centerfreq/3) centerfreq+(centerfreq/3)]);
    xlabel('frequency(Hz)');
    ylabel('amplitude');
    title('Right');
    grid on;

%------------------------------------------------------------------------------------------------------------------------
% random phase: Le
%------------------------------------------------------------------------------------------------------------------------

for n = 1:501;
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
% "slope" concept
%------------------------------------------------------------------------------------------------------------------------

if shiftarg == 0
    Rtau = Ltau;
    for n = 1:247;
        s = shiftcf;
        S = [S s];
    end
    Rtau = Rtau+S; 
    IPD = Rtau - Ltau;
end


% Helling IPD curve als "tijd"

% c = CF-slope*CF
% line = slope*F + c
% Rtau = Ltau+line

if shiftarg == 1
    c = CF-slope*CF;
    line = slope*F + c;
    Rtau = Ltau+line;
    IPD = Rtau - Ltau;

%    for n = 1:123
%    slopeweight = (123:-1:1)';
%    IPD(n,1) = shiftcf - ((slopeweight(n,1).*(slope/1000)));
%    end
%    
% 
%         for n = 1
%         IPD(124,1) = shiftcf;
%         end
%         
% 
%            for n = 1:123
%            IPD(n+124) = shiftcf + ((slope/1000) * n);
%            end
%             
%                 for n = 1:247
%                 Rtau(1,n) = Ltau(1,n) + IPD(n,1);
%                 end
end           

if shiftarg == 2
   for n = 1:247
       IPD(n,1) = F(1,n).*slope;
   end
   for n = 1:247
   Rtau(1,n) = Ltau(1,n) + IPD(n,1);
   end
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

for n = 226:277
    Lcomp = A(n,1) *sin (Fc(n,1) *(ts*2*pi)  + ((Ltauc(n,1)*pi))) ;
    subplot(4,2,5);
    plot(ts,Lcomp); 
    xlabel('time(ms)');
    ylabel('amplitude');
    hold on;
    grid on;
    Lstim(n-225) = {Lcomp};
end

hold off;    

for n = 226:277
    Rcomp = A(n,1) *sin (Fc(n,1) *(ts*2*pi)  + ((Rtauc(n,1)*pi))) ;
    subplot(4,2,6);
    plot(ts,Rcomp);
    xlabel('time(ms)');
    ylabel('amplitude');
    hold on;
    grid on;
    Rstim(n-225) = {Rcomp};
end

hold off;    
    
%------------------------------------------------------------------------------------------------------------------------
% Le & Ri stimulus 
%------------------------------------------------------------------------------------------------------------------------

for n = 1:51
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

for n = 1:51
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

    if shiftarg == 0
    figure(2);
    subplot(2,1,1);
    plot(F,IPD,'o');
    xlim([0 1000])
    xlabel('frequency(Hz)');
    ylabel('interaural phase difference(ms)');
    title('constant phaseshift, all frequencies');
    grid on;
    end

    if shiftarg == 1
    figure(2);
    subplot(2,1,1);
    plot(F,IPD,'o');
    xlim([0 1000])
    xlabel('frequency(Hz)');
    ylabel('interaural phase difference(ms)');
    title('frequency-dependent shift: CF constant');
    grid on;
    end

    if shiftarg == 2
    figure(2);
    subplot(2,1,1);
    plot(F,IPD,'o');
    xlim([0 1000])
    xlabel('frequency(Hz)');
    ylabel('interaural phase difference(ms)');
    title('frequency-dependent shift: lowest frequency constant');
    grid on;
    end
      

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
    

