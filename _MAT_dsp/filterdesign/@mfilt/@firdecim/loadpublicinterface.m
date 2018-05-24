function loadpublicinterface(this, s)
%LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% R14sp1 we saved the hidden states which we will now need to revert to the
% normal States.
if s.version.number == 1

    Scir     = s.HiddenStates;
    tapIndex = s.TapIndex+1; %1-based indexing
    M        = s.DecimationFactor;

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
    Scir = Slin;
    for i=1:M,
        % Interleave states of each phase
        for j=1:nstpp,
            Scir(i+(j-1)*M,:) = Slin((M-i)*nstpp+j,:);
        end
    end

    s.States = Scir;
end

abstractfirdecim_loadpublicinterface(this, s);

if s.version.number == 0
    if ~isempty(s.PartialSum)
        set(this, 'PolyphaseAccum', s.PartialSum);
    end
end

% [EOF]
