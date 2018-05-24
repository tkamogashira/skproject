function cm = determineufactor(this,Fedges,Aedges,Dev,rcf)
%DETERMINEUFACTOR   Determine optimal upsampling factor.

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

% Determine order estimate for single-section case
N = firpmord(Fedges,Aedges,Dev);

% Check if wideband lowpass
Fpass = Fedges(1);
Fstop = Fedges(2);
if Fpass > 0.5,
    fend = 1 - Fpass;
    % Flip edges, and freq.vector for length estimation
    Fedges = 1 - fliplr(Fedges);
    % Flip deviations
    Dev = fliplr(Dev);
else
    fend = Fstop;
end

% Setup freq vector
F = [0 Fedges 1];

% Determine maximum possible interpolation factor
maxufact = floor((1-eps)/fend);

% Initialize cost matrix
cm = zeros(maxufact,1);

cm(1) = [(N+1)/rcf]; % Single-section cost
                             
% Find all factors of rcf
fctrs = factors(this,rcf);

for k = 2:maxufact,
        
    % Find simple number of multipliers
    Nu = upsampledcost(this,k,Fedges,Aedges,Dev,N);
    Ni = imagesuppcost(this,k,F,Aedges,Dev);    
    
    % Determine cost
    rcf1 = max(gcd(k,fctrs));
    
    cm(k) = (Ni+1)/rcf1+(Nu+1)/rcf;
end

%--------------------------------------------------------------------------
function Nu = upsampledcost(this,k,Fedges,Aedges,Dev,N)
    
if this.JointOptimization,
    % Compute upsampled filter order for 'advanced' design
    Nu = ceil(N/k);
else
    % Compute upsampled filter order for simple design
    Nu = firpmord(k*Fedges,Aedges,[Dev(1)./2 Dev(2)]);
end

%--------------------------------------------------------------------------
function Ni = imagesuppcost(this,k,F,Aedges,Dev)

if this.JointOptimization,
    % Estimate order for image suppressor and 'advanced' design
    Ni = max(3,estimateifirgord(k,F,Dev));
else
    % Estimate order for image suppressor and 'simple' design
    Ni = max(3,...
        firpmord([F(2) 2/k-F(3)],Aedges,[Dev(1)./2 Dev(2)]));
end

% [EOF]
