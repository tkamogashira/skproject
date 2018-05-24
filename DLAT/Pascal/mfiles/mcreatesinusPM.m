% mcreatesinusPM(amplitude1, amplitude2, frequentie 1, frequentie 2, tau 1, tau 2, phaseshift, plot, correlatie)
%
% phaseshift : verschuift phase van de verschillende componenten v. noise
%
% plot : 1 voor het plotten van de twee tone-signalen (sinus), 0 voor het plotten van de twee noise-signalen 
%
% correlatie : - 11 voor sin1/sin1 
%              - 12 of 21 voor sin1/sin2
%              - 22 voor sin2/sin2 
%              - 33 voor noise1/noise1
%              - 34 of 43 voor noise1/noise2
%              - 44 voor noise2/noise 2
%

% aanmaken van sinus/noise

function sinustone = mcreatesinusPM(a1,a2,freqpara1,freqpara2,tau1,tau2,PhaseShift,plottone,correlatie)

close all

Fs = 2500;                   % Sampling frequency (Hz: 2500 samples per second)
T = 1/Fs;                    % Sample time 
L = 5;                       % Length of signal (s)

t = 0:T:L;                   % t varieert van 0 tot length in stappen van 'sample time'

freq1 = (freqpara1*(2*pi/1000)); 
freq2 = (freqpara2*(2*pi/1000));

sinustone1 = a1*sin(freq1*t+tau1);
sinustone2 = a2*sin((freq2*t+tau2)+PhaseShift);

% om van tone --> noise: meerdere frequenties toevoegen per oor.------------------------------------------------------------------

noise1 = zeros(1,length(t));    % maakt vector van zelfde lengte als t aan
noise2 = zeros(1,length(t));

for n = 1:1000                  % # random variaties in frequency en phase (ook phaseshift tussen frequenties in noise nodig, anders: cancelling out
    Rnum = abs(rand);           % uniform distribution, zie help rand
    Rnum2 = abs(rand);
    RNoise1 =  a1*sin((Rnum*freqpara1*t*2*pi) + Rnum2*tau1*pi);                     
    RNoise2 =  a2*sin((Rnum*freqpara2*t*2*pi) + (Rnum2*tau2+PhaseShift)*pi);
    noise1 = noise1 + RNoise1;
    noise2 = noise2 + RNoise2;
end

noise1 = gausswin(length(noise1))'.*noise1;     % gausswindow reduceert sterke edge-effecten (onverklaarbare piek rond 0 wordt weggefilterd)
noise2 = gausswin(length(noise2))'.*noise2;

% Cave: bovenstaande manier van noise-genereren zorgt voor twee identieke ruis-inputs als freq en ...
% tau voor beiden hetzelfde zijn. Noise1 en noise2 zijn dus niet random tov elkaar, maar identiek.

% plot tones/ruis-------------------------------------------------------------------------------------------------------------------

if plottone == 1
   figure(1) 
   subplot(2,1,1),plot(t,sinustone1)
   title('Left Ear Tone')
   ylabel('Amplitude'),grid on
   xlabel('Time(ms)'),grid on
   
   subplot(2,1,2),plot(t,sinustone2)
   title('Left Ear Tone')
   ylabel('Amplitude'),grid on
   xlabel('Time(ms)'),grid on
   
elseif plottone == 0
   figure(1)
   subplot(2,1,1),plot(t,noise1)
   title('Left Ear Noise')
   ylabel('Amplitude'),grid on
   xlabel('Time(ms)'),grid on
   
   subplot(2,1,2),plot(t,noise2)
   title('Right Ear Noise')
   ylabel('Amplitude'),grid on
   xlabel('Time(ms)'),grid on
end;

% Bovenstaand genereert tone/noise. Conventie: 1 = links, 2 = rechts.

% Vervolgens: cross-correlatie binaurale input(functie van MSO). Ref: FFT, chapter 8: correlation-----------------------------------

% R(f) = X(f)Y*(f) = [X*(f)Y(f)]* met * = conjugatie (complex conjugate function = "conj")

NFFT = 2^nextpow2(length(t)); % Next power of 2 from length of signal

X1 = fft(noise1,NFFT)/L;
X2 = fft(noise2,NFFT)/L;

f = Fs/2*linspace(0,1,NFFT/2);

% Plot single-sided amplitude spectrum.
    figure(2)
    
    subplot(2,1,1),plot(f,2*abs(X1(1:NFFT/2))) 
    title('Single-Sided Amplitude Spectrum of left noise')
    xlabel('Frequency (Hz)')
    ylabel('|X1(f)|')
    
    subplot(2,1,2),plot(f,2*abs(X2(1:NFFT/2))) 
    title('Single-Sided Amplitude Spectrum of right noise')
    xlabel('Frequency (Hz)')
    ylabel('|X2(f)|')

% 1250 points: f gaat van 0 (op t = 1) tot 1250 (op t = end. Merk op: t = end is t = 1251 (5 * 2500 of Fs * L)) 
   
% Supra: ok. Infra: crosscorr.----------------------------------------------------------------------------------------------------

t = -L:T:L;  

if correlatie == 11
    R = xcorr(sinustone1,sinustone1,'coeff');
    figure(3)
    plot(t,R)
    title('autocorrelation tone1')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
    
elseif correlatie == 12  
    R = xcorr(sinustone1,sinustone2,'coeff');
    figure(3)
    plot(t,R)
    title('crosscorrelation tone1 & tone2')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
    
elseif correlatie == 21  
    R = xcorr(sinustone1,sinustone2,'coeff');
    figure(3)
    plot(t,R)
    title('crosscorrelation tone1 & tone2')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
    
elseif correlatie == 22
    R = xcorr(sinustone2,sinustone2,'coeff');
    figure(3)
    plot(t,R)
    title('autocorrelation tone2')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
   
elseif correlatie == 33   
    R = xcorr(noise1,noise1,'coeff');
    figure(3)
    plot(t,R)
    title('autocorrelation noise1')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on

elseif correlatie == 44   
    R = xcorr(noise2,noise2,'coeff');
    figure(3)
    plot(t,R)
    title('autocorrelation noise2')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
   
elseif correlatie == 34    
    R = xcorr(noise1,noise2,'coeff');
    figure(3)
    plot(t,R)
    title('crosscorrelation noise1 & noise2')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
    
elseif correlatie == 43    
    R = xcorr(noise1,noise2,'coeff');
    figure(3)
    plot(t,R)
    title('crosscorrelation noise1 & noise2')
    xlabel('delay(ms)'),grid on
    ylabel('correlation'),grid on
end

% supra: correlatie. Nu: filtering.-------------------------------------------------------------------------------------------------- 