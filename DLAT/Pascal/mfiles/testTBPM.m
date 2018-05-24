% Voorbeeld: zie ITDxcorr.m
% Basisidee: NSPL data sets hebben "Spiketimes" in verschillende rijen
% Elke rij bevat spiketimes van 1 SPL
% Met behulp van ds.SpikeTimes(:,1) kunnen we filteren op 1 SPL
% Plot de noise/delay curves voor elke SPL 
% Maak correlogrammen van de verschillende noise delay curves, cfr. IC data
%

close all

%-----------------------------------------------------------------------------------------------------
% D0121
%-----------------------------------------------------------------------------------------------------

DF = 'D0121C'
dsIDp = '83-6';
ds1 = dataset(DF, dsIDp);
Nrec  = ds1.nsubrecorded;
[X1, idx] = sort(ds1.indepval(1:Nrec));
Y1 = getrate(ds1, idx);

    figure(1);
    plot(X1,Y1,'-');
    title('ITD (dashed line = interpolated curve)');
    xlabel('delay (\mus)');grid on;
    ylabel('Rate');grid on;

    % plot blijkbaar rate (ok) versus SPL (nok)!
    % nsubrecorded is aantal SPL en NIET de delay.