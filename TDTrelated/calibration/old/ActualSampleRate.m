function Actual=ActualSampleRate(Nominal)
%ActualSampleRate -- Map a simple and nominal sampling rate to actual rate for the RP,.
% based on the following look-up table.
%
% Nominal (Hz)    Actual (Hz)
%      6000         6103.515625
%     12000        12207.031250
%     25000        24414.062500
%     50000        48828.125000
%    100000        97656.250000
%    200000       195312.500000
%
%Usage: Actual=RP_SmplRate(Nominal)
%By SF, 7/23/01

%Look-up table of nominal and actual sampling rate
LUT=[...
      6000         6103.515625;...
      12000        12207.031250;...
      25000        24414.062500;...
      50000        48828.125000;...
      100000        97656.250000;...
      200000       195312.500000];

%Find the rate specified
I=find(LUT(:,1)==Nominal);
if isempty(I)
   error('The specified noimnal rate is not registered');
else
   Actual=LUT(I,2);
end
