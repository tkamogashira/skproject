function [limSPL, limLab] = findMaxSPL(maxSPL,Lab);
% findMaxSPL - returns most critical SPL and corresponding "label" such as freq

[limSPL, ii] = min(maxSPL);
limLab = Lab(min(end,ii));