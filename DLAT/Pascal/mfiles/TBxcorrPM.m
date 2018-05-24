% TBxcorrPM
% Popscript: verkrijg datasets op basis van StimStruct (MMCL file, zie StimStruct)
% Ter vergelijk met AN data (zie TF)
% Op basis van crosscorrelograms bekomen in EVALcrosscorr effect van SPL op ITD curves bekijken
%
% - Eigenlijke berekening van ILD: zie function crosscrosscor
% - Check steeds CF: enkel laag tot mid-CF is interessant voor vergelijking met AN data
% 
% Dec 06 PM


% TB Data
% steeds 1 referentie per dataset (beperking berekeningen)
% tag: 1 = good, CF < 1500
%      2 = decent, CF = 1500-4500
%      3 = bad, CF > 4500

TB = [];

%=======================================================
% D0120
%=======================================================
DF = 'D0120';

% ref 50 dB
%--------------------------------9----------------------
seq = -9; 
ds1 = dataset(DF, seq);
maxshift = ds1.Stimulus.Special.BurstDur;
S = EVALcrosscorr(ds1,5,ds1,1,'plot','yes','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim) % variables gedefineerd als inputargumenten worden wél meegelezen in CrossCross. Andere variabelen zijn m-files specifiek
C.tag = 3;
pause;
close all;

S = EVALcrosscorr(ds1,5,ds1,2,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,3,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,4,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,6,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;
%--------------------------------10----------------------
seq = -10; 
S = EVALcrosscorr(ds1,5,ds1,1,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim) 
C.tag = 3;
close all;

S = EVALcrosscorr(ds1,5,ds1,2,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,3,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,4,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,6,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;
%--------------------------------11----------------------
seq = -11; 
S = EVALcrosscorr(ds1,5,ds1,1,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim) 
C.tag = 3;
close all;

S = EVALcrosscorr(ds1,5,ds1,2,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,3,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,4,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,6,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;
%--------------------------------12----------------------
seq = -12; 
S = EVALcrosscorr(ds1,5,ds1,1,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim) 
C.tag = 3;
close all;

S = EVALcrosscorr(ds1,5,ds1,2,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,3,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,4,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

S = EVALcrosscorr(ds1,5,ds1,6,'plot','no','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim)
close all;

%=======================================================
% D0121
%=======================================================
DF = 'D0121';

% ref 50 dB
%--------------------------------9----------------------
seq = -117; 
ds1 = dataset(DF, seq);
maxshift = ds1.Stimulus.Special.BurstDur;
S = EVALcrosscorr(ds1,3,ds1,4,'plot','yes','cormaxlag',15);
C = CrossCrossCor(DF,seq,S,xlim) % variables gedefineerd als inputargumenten worden wél meegelezen in CrossCross. Andere variabelen zijn m-files specifiek
C.tag = 3;
pause;
close all;














% % IC Data
% DF = 'M0545'
% ds1
% S.cor = ds1.Stim....
% S.spl = ds1.StimParam.SPL    
% C = CrossCrossCor(S)
% 
% Tijdelijk uitgesteld: voeg hier later ITDxcorrPM aan toe op basis van crosscrosscor
