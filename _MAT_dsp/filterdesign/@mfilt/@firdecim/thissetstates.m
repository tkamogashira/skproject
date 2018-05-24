function S = thissetstates(Hd,S)
%THISSETSTATES Overloaded set for the States property.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

try
    M = Hd.privRateChangeFactor(2);
catch
    M = 1;
end
if isempty(S),
    % Prepend the state vector with one extra zero per phase and per channel
    Sp = nullstate1(Hd.filterquantizer);
    for i=2:M,
        Sp = [Sp;nullstate1(Hd.filterquantizer)];
    end
else
    % Check data type, quantize if needed
    S = validatestates(Hd.filterquantizer, S);
    
    % Number of states of each phase
    nstpp = size(S,1)/M; 
    
    % Separate states of each phase 
    Scont = S;
    for i=1:M,
        for j=1:nstpp,
            Scont((M-i)*nstpp+j,:) = S(i+(j-1)*M,:);
        end
    end

    % Prepend the state vector with one extra zero per phase and per channel
    Sp = [];
    for i=1:M,
        Sp = [Sp;prependzero(Hd.filterquantizer, Scont((i-1)*nstpp+1:i*nstpp,:))];
    end
end

Hd.TapIndex=zeros(M,1);
Hd.HiddenStates = Sp;

S = [];


