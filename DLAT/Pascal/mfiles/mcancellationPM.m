function cancellationresult = mcancellationPM(wave1,t)

% - mcreatenoise : maak 2 x noise aan. Beide identiek, met uitzondering van "teken" van delay (vb. 300 vs -300). 
% - mwaveadd : tel twee noises bij elkaar op --> double delay
% - mcreatetone : maak signaal aan. Afhankelijk van S0 of Spi : delay functie gebruiken
% - mwaveadd : tel signaal bij doubledelay --> NxSy
% - mcanncellationPM : trek signaal in linkerkanaal van signaal in rechterkanaal af. 
%   Komt overeen met het "cancellation" deel van Durlach EC model.
%
% - t wordt als venster gebruikt: van 0-t wordt venster over cancellationresult gezet. Vb: 300ms
% ----------------------------------------------------------------------------------------------------------------------------- 

close all
% subtract two channels

cancellationresult = wave1.leftwaveform - wave1.rightwaveform;

plot(cancellationresult);


