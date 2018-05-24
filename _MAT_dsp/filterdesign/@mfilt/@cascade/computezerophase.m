function [hz, wz, phiz, opts] = computezerophase(Hm, varargin)
%COMPUTEZEROPHASE Compute the zerophase response of a multirate/multistage filter. 
% If Fs is specified as input, it's interpreted as the maximum frequency of
% the system.

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% This should be private

% Compute:
%  - the frequency vector W for the cascade, 
%  - the frequency vector (normalized) WFAST for the fastest Stage, 
%  - the rate change factors RSECT between one Stage and the fastest
[wz, wfast, Rsect] = computew(Hm,varargin{:});

S = Hm.Stage;
n = nstages(Hm);
hz = 1;
phiz = 0;

for i=1:n,
    % Compute the frequency vector for current Stage by scaling wfast
    wsec = wfast*Rsect(i);
    % Zero-phase response of the cascade of first i Stages
    [h,dummy,phi,opts] = zerophase(S(i),wsec);
    hz = hz.*h;
    phiz = phiz+phi;
    if wz(1)==0 && (phiz(1)>=pi || phiz(1)<-pi),
        % Keep phiz between -pi and pi at origin
        phiz = phiz-sign(phiz(1))*pi;
        hz = -hz;
    end
end

% [EOF]
