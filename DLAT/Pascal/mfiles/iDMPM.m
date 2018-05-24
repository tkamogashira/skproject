% IDMPM
% inverse fft method used for delaymodel
% note similarities/differences between this file and DMPM
%
% DMPM - slope    (ms)            - constant time shift 
%      - dfshift  (*pi)           - constant phase shift
%      - df       (Hz)            - dominant frequency
%      - bw       (Hz)            - bandwidth
 
function DMPM = DMPM(df,bw, dfshift,slope)

% DMPM - slope    (ms)            - constant time shift 
%      - dfshift  (*pi)           - constant phase shift
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
% Note: Increasing the length of the signal in the time domain...
% will increase resolution in the frequenct domain - a property...
% of the fft.

tmax = 0.2;       % maximum time (s)
Ts = 1e-5;        % Sample time  
t = 0:Ts:tmax; 

L = tmax*1e3;    % Length of signal (ms) (used to calculate vector sizes (infra))

%------------------------------------------------------------------------------------------------------------------------
% frequency-range
%------------------------------------------------------------------------------------------------------------------------
% make frequency vector
N = length(t);
ddf = 1/tmax;
f =  (0:N-1) * ddf;
fres = f(2)-f(1);

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
    subplot(3,2,1);
    plot(frange,arange)
    xlabel('frequency')
    ylabel('relative amplitude')
    grid on;
    
    subplot(3,2,2);
    plot(frange,arange)
    xlabel('frequency')
    ylabel('relative amplitude')
    grid on;

%------------------------------------------------------------------------------------------------------------------------
% get random phase 
%------------------------------------------------------------------------------------------------------------------------

for n = 1:(length(f))
    Ltau(n) = (2*rand);
end
LtauRange = Ltau(Index);

    subplot(3,2,3);
    plot(frange,(LtauRange),'o');
    xlabel('frequency(Hz)');
    ylabel('phase(*pi rad)');
    ylim([-2 10])
    grid on;

%------------------------------------------------------------------------------------------------------------------------
% calculate phase and time shifts
%------------------------------------------------------------------------------------------------------------------------

dfshift = dfshift * pi;

dt = ((slope/1000)*(2*pi));    % slope M
dph = dfshift;                 % IPD van df, vb roteren rond df: dph = 0

c = dph - dt*df;               % slope * df + c = dph  waarbij c de intercept 
                               % (evt. pure phase delay (situatie met constante IPD shift))

y = dt*f + c;                  % vergelijking van de rechte die (f, IPD) plot omvat, algemene vorm y = mx + c


%------------------------------------------------------------------------------------------------------------------------
% calculate shifted phase
%------------------------------------------------------------------------------------------------------------------------

Rtau = Ltau + y;

RtauRange = Rtau(Index);

    subplot(3,2,4)
    plot(frange, RtauRange, 'o');
    xlabel('frequency(Hz)');
    ylabel('phase(*pi rad)');
    ylim([-2 10])
    grid on;
%     axis([min(frange) max(frange) min([Rtau Ltau]) max([Rtau Ltau])])
    subplot(3,2,3)
%     axis([min(frange) max(frange) min([Rtau Ltau]) max([Rtau Ltau])])
    
%------------------------------------------------------------------------------------------------------------------------
% iFFT
%------------------------------------------------------------------------------------------------------------------------
    
% combine phase and amplitude parts into complex spectrum
Lspectrum = a .* exp(Ltau * i);
Rspectrum = a .* exp(Rtau * i);

% inverse fft Left
Lsignal = ifft(Lspectrum);
Lsignal = real(fftshift(Lsignal));

% inverse fft Right
Rsignal = ifft(Rspectrum);
Rsignal = real(fftshift(Rsignal));

% plot
    subplot(3,2,5);
    plot(t,Lsignal);
    xlabel('time(s)');
    ylabel('amplitude');
    axis([min(t) max(t) min([Lsignal Rsignal]) max([Lsignal Rsignal])]);
    grid on;
    
    subplot(3,2,6);
    plot(t,Rsignal);
    xlabel('time(ms)');
    ylabel('amplitude');
    axis([min(t) max(t) min([Lsignal Rsignal]) max([Lsignal Rsignal])]);
    grid on;

%------------------------------------------------------------------------------------------------------------------------
% correlogram 
%------------------------------------------------------------------------------------------------------------------------

SC = xcorr(Lsignal, 'coeff');
[how,where] = max(SC);

XC = xcorr(Lsignal, Rsignal, 'coeff');
[How,Where] = max(XC);

%------------------------------------------------------------------------------------------------------------------------
% plot IPD and correlograms
%------------------------------------------------------------------------------------------------------------------------

txc = -tmax:Ts:tmax;    

y(Index) = y(Index)./pi;

    figure(2);
    subplot(2,1,1);
    plot(frange,y(Index), '-', 'LineWidth',2)
    xlabel('frequency')
    ylabel('IPD (*pi)')
    title(['Slope is ',num2str(slope), ' ms', ', Shift of DF is ', num2str(dfshift/pi), ' * pi'])
    grid on;

    subplot(2,1,2);
    plot(txc,SC,'--');
    hold on;
    plot(txc,XC,'r-','LineWidth',2);
    xlabel('delay(s)');
    ylabel('correlation');
    title('dashed line = corr. without IPD, bold line = corr. with IPD');
    axis([-.02 0.02 min([SC XC]) max([SC XC])]);
    grid on;
    hold off; 
    

