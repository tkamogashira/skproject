function C = CrossCrossCor(DF,seq,S,xrange)
% merk gelijkenis op met binaurale cel met SPL 5 | 6 input
% geeft struct met fields lag; cor; SPL
% lag is tijdvector, shifts in 50 mus over 15 ms
% cor bevat correlogram
% 
% Dec 06 PM

%
% TO DO
% Check berekening van slope (ms/ \mus?)

if nargin<4; xrange = [S(1).lag(1) S(1).lag(end)]; end

%------------------------ scalars/vectors to be used ---------------------------

DelayShift = [];
PeakHeight = [];
dILD = [];

%------------------------ extract correlogram ---------------------------

X1 = S(1).lag;
[val indmin] = min(abs(X1-xrange(1)));
[val indmax] = min(abs(X1-xrange(2)));

Y1 = S(1).cor(indmin:indmax);
Y2 = S(2).cor(indmin:indmax);

%------------------------ extract SPL -----------------------------------

SX1 = S(1).SPL;
SX2 = S(2).SPL;

%------------------------ calculate ILD ----------------------------------

ILD1 = SX1(1)-SX1(2);
ILD2 = SX2(1)-SX2(2);
delta = ILD1 - ILD2;

% CAVE: nog nood aan groupplot: delta in TBxcorrPM nog in vector steken

%------------------------ extract delay ----------------------------------

ds1 = dataset(DF, seq);

LAG = S(1).lag(indmin:indmax);

%------------------------ plotting ----------------------------------------

% n1 = 15;
% XI = -(n1):1:(n1);
% 
% YI1 = INTERP1(LAG, Y1,XI);
% YI2 = INTERP1(LAG, Y2,XI);

    figure(1);
    subplot(5,1,1);
    plot(LAG,Y1,'-','LineWidth', 1.5);
    hold on;
    plot(LAG,Y2,'-','LineWidth', 1);
    title(['Dataset ', DF, ', sequence ', num2str(seq), '. Lowest SPL in bold.']);
    xlabel('delay (ms)');grid on;
    ylabel('Rate');grid on;
    hold off;
    
%------------------------ crosscorrelation ----------------------------------------

R = xcorr(Y2, Y1, 'coeff');

    Rlag = 2*LAG(1):(LAG(2)-LAG(1)):2*LAG(end);
    
    [How,Where] = max(R);
    DelayShift = [DelayShift Rlag(Where)];
    PeakHeight = [PeakHeight How];
    Slope = ((DelayShift*1000) / delta);    
  
    subplot(5,1,3);
    plot(Rlag, R);  % geeft x-as voor gebruik met xcorr R op. Zonder length-parameter gebruikt x-as "samples".
    ylim([0 1]);
    xlim([Rlag(1) Rlag(end)])
    title(['crosscorrelation of ILD-shifted ITD functions ' DF, num2str(seq),'. dILD is ', num2str(delta),' dB, shift is ', num2str(DelayShift), ' ms']);
    xlabel('delay (ms)');grid on;
    ylabel('correlation (R)');grid on;
   
% autocorr. van de twee noise-delays (ITD)

A1 = xcorr(Y1, 'coeff');
A2 = xcorr(Y2, 'coeff');
    
    subplot(5,1,5)
    plot(Rlag, A1,'LineWidth', 1.5);
    hold on;
    plot(Rlag, A2);
    hold off;
    xlim([Rlag(1) Rlag(end)])
    ylim([0 1]);
    title(['autocorrelations. Slope is ' num2str(Slope), ' \mus / dB' ]);
    xlabel('delay (ms)');grid on;
    ylabel('correlation (R)');grid on;
     
C = collectinstruct(seq,DelayShift,PeakHeight,delta,Slope);