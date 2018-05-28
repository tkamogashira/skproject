function BufDBNs = stimgenNClicks(wf, storage);

% STIMGENnclicks -  computes (realizes) nclicks waveform
% SYNTAX:
% function SD = stimgennclicks(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.



% collect generating params from GENdata field of waveform
channel = wf.channel;
gd = wf.GENdata;
Portions = gd.Portions;
Nsam = sum(Portions);
numAtt = gd.numAtt;
% initialize waveform
Waveform = zeros(1,Nsam);
S1 = [0 cumsum(Portions)];
S0 = 1+S1;
S0 = S0(1:(end-1));
S1 = S1(2:end);
Nportion = length(S0);
iclick = 0;
% visit clicks one by one
for ii=2:2:Nportion,
   s0 = S0(ii);
   s1 = S1(ii);
   iclick = iclick+1;
   Waveform(s0:s1) = gd.clickAmp(iclick)*db2a(-numAtt);
end
% figure;plot(Waveform); pause
%       channel: R
%           clickType: 1
%%            clickAmp: [11354.0285           32000]'
%            Portions: 625     63    937     63  60812
%              GENfun: nclicks
%           createdby: stimevalnclicks
%              numAtt: 10.4576
%        -------- 


BufDBNs = storeSamples(Waveform, storage);
