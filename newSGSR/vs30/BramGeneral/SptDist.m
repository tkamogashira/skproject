function dist = SptDist(Spt1, Spt2, CostPerTime)
%SPTDIST    distance metric for spiketrains.
%   D = SPTDIST(Spt1, Spt2, CostPerTime) calculates a distance metric for
%   the two supplied spiketrains based on a genetic algorithm. 
%   The first two argmuments must be column- or rowvectors containing the
%   spiketrains for which the distance metric needs to be calculated. The 
%   cost per unit of time for shifting spiketrains must be given as a third
%   argument. This can be a scalar or a column- or rowvector.
%
%   Further information: DIMITRIY ARONOV "Fast Algorithm for the Metric-Space
%   Analysis of Simultaneous Responses of Multiple Single Neurons.", JOURNAL
%   OF NEUROSCIENCE METHODS 00 (2003) 1-5

%B. Van de Sande 06-07-2005