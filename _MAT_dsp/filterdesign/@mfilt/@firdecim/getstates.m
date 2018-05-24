function S = getstates(Hm,S)
%GETSTATES   Get the states.

%   Author(s): V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

Scir = Hm.HiddenStates;

tapIndex = Hm.tapIndex+1; %1-based indexing
try
    M = Hm.privRateChangeFactor(2);
catch
    M = 1;
end

% Number of states per phase
nstpp = size(Scir,1)/M;

% Circular -> Linear for each phase
Slin = [];
for i=1:M,
    inc = (i-1)*nstpp;
    lidx = (tapIndex(i)+1:nstpp)+inc;
    uidx = (1:tapIndex(i)-1)+inc;
    % Remove phantom state
    Slin = [Slin; Scir(lidx,:); Scir(uidx,:)];
end

% New number of states per phase
nstpp = size(Slin,1)/M;

% States of each phase are concatenated vertically at this point
S = Slin;
for i=1:M,
    % Interleave states of each phase
    for j=1:nstpp,
        S(i+(j-1)*M,:) = Slin((M-i)*nstpp+j,:);
    end
end



% [EOF]
