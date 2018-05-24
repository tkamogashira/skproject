% delaymodel
%
% phase- vs group delay
% - shiftarg = 0 shifts entire phase range
% - shiftarg = 1 rotation, constant phase of CF
% - shiftarg = 2 rotation, constant phase of lowest freq.

function DMPM = DMPM(df,bw, shiftarg, dfshift,slope)

% DMPM - slope    (s)             - constant time shift 
%      - dfshift  (cycles 0-1)    - constant phase shift
%      - df       (Hz)            - dominant frequency
%      - bw       (Hz)            - bandwidth
 
close all;

%------------------------------------------------------------------------------------------------------------------------
% constant parameters
%------------------------------------------------------------------------------------------------------------------------

Ltau = [];
Rtau = [];
Ltot = 0;
Rtot = 0;

%------------------------------------------------------------------------------------------------------------------------
% time-parameters
%------------------------------------------------------------------------------------------------------------------------
Fs = 5000;                % Sampling frequency (kHz) 
Ts = 1/Fs;                % Sample time 
L = 40;                   % Length of signal (ms)

t = 0:Ts:L;   
 

%------------------------------------------------------------------------------------------------------------------------
% frequency-range
%------------------------------------------------------------------------------------------------------------------------

fmin = 0;
fmax = 1000; % (Hz)
fres = 0.5;    % (Hz)

f = fmin:fres:fmax;

%------------------------------------------------------------------------------------------------------------------------
% amplitude
%------------------------------------------------------------------------------------------------------------------------

cutoff = 0.001;

a = NORMPDF(f,df,(bw/4));    
a = a/max(a); % normalizing a (max = 1)

Index = find(a>cutoff);     
frange = f(Index);
arange = a(Index); % nt-gebruikte a's verwijderen

%------------------------------------------------------------------------------------------------------------------------
% plot powerspectrum
%------------------------------------------------------------------------------------------------------------------------

figure(1);
subplot(4,2,1);
plot(frange,arange)
xlabel('frequency')
ylabel('relative amplitude')
grid on;
subplot(4,2,2);
plot(frange,arange)
xlabel('frequency')
ylabel('relative amplitude')
grid on;

%------------------------------------------------------------------------------------------------------------------------
% get random phase 
%------------------------------------------------------------------------------------------------------------------------

for n = 1:(length(frange))
    Ltau(n) = rand;
end

    subplot(4,2,3);
    plot(frange,(Ltau),'o');
    xlabel('frequency(Hz)');
    ylabel('phase(*pi,rad)');
    grid on;

%------------------------------------------------------------------------------------------------------------------------
% calculate phase and time shifts
%------------------------------------------------------------------------------------------------------------------------

if shiftarg == 0 | shiftarg == 1
dt = slope; % slope M
dph = dfshift; % IPd van df, vb roteren rond df: dph = 0

c = dph - dt*df; % slope * df + c = dph  waarbij c de intercept (evt. pure phase delay (situatie met constante IPD shift))

y = dt*frange + c; %vergelijking van de rechte die (f, IPD) plot omvat, algemene vorm y = mx + c

end

if shiftarg == 2
dt = slope; % slope M
y = dt*f; % vergelijking van de rechte die (f, IPD) plot omvat, algemene vorm y = mx + c
    
y = y(Index);
end

%------------------------------------------------------------------------------------------------------------------------
% calculate shifted phase
%------------------------------------------------------------------------------------------------------------------------

Rtau = Ltau + y;

    subplot(4,2,4)
    plot(frange, Rtau, 'o');
    xlabel('frequency(Hz)');
    ylabel('phase(*pi,rad)');
    grid on;
    axis([min(frange) max(frange) min([Rtau Ltau]) max([Rtau Ltau])])
    subplot(4,2,3)
    axis([min(frange) max(frange) min([Rtau Ltau]) max([Rtau Ltau])])
    
%------------------------------------------------------------------------------------------------------------------------    
% components of first noise
%------------------------------------------------------------------------------------------------------------------------

for n = 1:length(frange)
    Lcomp = arange(n) * sin(2*pi*frange(n)*t/1000 + (Ltau(1,n)*2*pi));
    subplot(4,2,5);
    plot(t,Lcomp); 
    xlabel('time(ms)');
    ylabel('amplitude');
    hold on;
    grid on;
    Lstim(n,:) = Lcomp;
end 
size(Lstim)
%------------------------------------------------------------------------------------------------------------------------
% first noise
%------------------------------------------------------------------------------------------------------------------------

Ltot = sum(Lstim);

    subplot(4,2,7);
    plot(t,Ltot);
    xlabel('time(ms)');
    ylabel('amplitude');
    grid on;
    
%------------------------------------------------------------------------------------------------------------------------
% components of second noise
%------------------------------------------------------------------------------------------------------------------------

Ltau
Rtau 
for n = 1:length(frange)
    Rcomp = arange(n) * sin(2*pi*frange(n)*t/1000 + (Rtau(1,n)*2*pi));
    subplot(4,2,6);
    plot(t,Rcomp); 
    xlabel('time(ms)');
    ylabel('amplitude');
    hold on;
    grid on;
    %Rstim(n) = {Rcomp};
    Rstim(n,:) = Rcomp;
end 

%------------------------------------------------------------------------------------------------------------------------
% second noise
%------------------------------------------------------------------------------------------------------------------------

Rtot = sum(Rstim);   
subplot(4,2,8);
    plot(t,Rtot);
    xlabel('time(ms)');
    ylabel('amplitude');
    grid on;
    axis([min(t) max(t) min([Rtot Ltot]) max([Rtot Ltot])])
    subplot(4,2,7)
    axis([min(t) max(t) min([Rtot Ltot]) max([Rtot Ltot])])
    
    
%------------------------------------------------------------------------------------------------------------------------
% correlogram 
%------------------------------------------------------------------------------------------------------------------------

SC = xcorr(Ltot, 'coeff');
[how,where] = max(SC);

XC = xcorr(Ltot, Rtot, 'coeff');
[How,Where] = max(XC);

txc = -L:Ts:L;    
    
%------------------------------------------------------------------------------------------------------------------------
% plot IPD and correlograms
%------------------------------------------------------------------------------------------------------------------------

    figure(2);
    subplot(2,1,1);
    plot(frange,y)
    xlabel('frequency')
    ylabel('IPD')
    grid on;

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


