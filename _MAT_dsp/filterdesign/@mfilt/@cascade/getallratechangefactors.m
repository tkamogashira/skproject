function [R, noblefactors] = getallratechangefactors(Hm)
%GETALLRATECHANGEFACTORS Get the rate change factors between sections and
% the noble factors to apply to each section to transform Hi(z) to
% Hi(z^noblefactors(i))

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% This should be private

S = Hm.Section;
n = nstages(Hm);

% Get all the rate change factors
% Rij is a nsect x 3 matrix (with nsect number of sections). For each row
% i, the first column stores the interpolation factor of section i+1, the
% second column stores the decimation factor of section i and the third
% columns stores the rate change factor between section i and section i+1.
Ri = S(1).privRateChangeFactor;
Rij = zeros(n,3);
Rij = [Ri(1) 1 Ri(1)];
for i=1:n-1,
    Ri = S(i).privRateChangeFactor; % [Li Mi]
    Rj = S(i+1).privRateChangeFactor; % [Li+1 Mi+1]
    Rij(i+1,1) = Rj(1); % Li+1
    Rij(i+1,2) = Ri(2); % Mi
    Rij(i+1,3) = Rj(1)/Ri(2); % [Li+1/Mi]
end

% Noble factors to apply to each section Hi(z) -> Hi(z^noblefactors(i))
for i=1:n,
    noblefactors(i) = prod(Rij(i+1:end,1))*prod(Rij(1:i,2));
end

% Keep only rate change factors between sections
R = Rij(:,3);

% [EOF]
