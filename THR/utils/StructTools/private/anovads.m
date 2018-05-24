function [p, MSbetween, MSwithin] = anovads(ds)
%ANOVADS    one-way ANOVA on dataset-object
%   [p, MSbetween, MSwithin] = ANOVADS(DS)
%   ANOVADS performs a one-way ANOVA on a dataset-object with stimulustype NITD or NTD to see if there is a
%   significant change in rate when the ITD is changed. It returns the p-value for the null hypothesis that 
%   there is no change in rate when ITD is varied. MSbetween and MSwithin are also given back as parameters.

%B. Van de Sande 03-12-2003

%Parameters nagaan ...
if nargin ~= 1, error('Wrong number of input parameter.'); end
if ~isa(ds, 'dataset'), error('Argument should be datasetobject.'); end
if isempty(strfind(ds.stimtype, 'NTD')) & isempty(strfind(ds.stimtype, 'NITD')),
    warning(sprintf('Unknown dataset stimulus type: ''%s''.', ds.stimtype)); 
end    

%ANOVA-waarden berekenen ...
NSubSeq = ds.nsubrecorded;
NRep    = ds.nrep;

Rate = []; Spt = ds.spt;
for SubSeqNr = 1:NSubSeq
    for RepNr = 1:NRep
        Rate(SubSeqNr, RepNr) = length(Spt{SubSeqNr, RepNr});
    end
end

GenMean = mean(Rate(:));

SSbetween = sum(NRep*(mean(Rate, 2) - GenMean).^2); 
DFbetween = NSubSeq - 1;
if DFbetween ~= 0, MSbetween = SSbetween / DFbetween;
else MSbetween = NaN; end    

Squares = (Rate - repmat(mean(Rate, 2), 1, NRep)).^2;
SSwithin = sum(Squares(:));
DFwithin = prod(size(Rate)) - NSubSeq;
if DFwithin ~= 0, MSwithin = SSwithin / DFwithin;
else MSwithin = NaN; end    

%Testen van de H0-hypothese, namelijk dat er geen afwijking is van de gemiddelde rate met verandering
%van een stimulusparameter. Bij NITD-datasets is de parameter interauraal tijdsverschil...
if (SSwithin ~= 0)
   F = MSbetween / MSwithin;
   p = 1 - fcdf(F, DFbetween, DFwithin);
elseif (SSbetween == 0)
   F = 0;
   p = 1;
else 
   F = Inf;
   p = 0;
end
