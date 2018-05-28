function sf = SPKscaleFactor(tmult, tdecade)

% function sf = SPKscaleFactor(tmult, tdecade);
% returns scale factor as function of UET settings
% Calculation is based on code in sclclc.pas
% the scalefactor is used as follows:
% StoredNumberInDataArrayRecord = scalefactor*ArrivalTimeInMillisecond
% or, equivalently:
% ArrivalTimeInMillisecond = StoredNumberInDataArrayRecord /scalefactor

multEq=[1 2 5];
sf = 10^(3-tdecade)/multEq(tmult+1);
