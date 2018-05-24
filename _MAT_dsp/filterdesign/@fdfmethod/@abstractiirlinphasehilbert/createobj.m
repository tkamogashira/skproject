function Hd = createobj(this,Hhalf)
%CREATEOBJ

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

% Convert halfband to hilbert
Hd = copy(Hhalf);

fn = fieldnames(Hd.stage(1).stage(2).stage(2).AllpassCoefficients);
allpasscoeffs = Hd.stage(1).stage(2).stage(2).AllpassCoefficients;
secondordcount = 0;
for k = 1:length(fn),
    sectioncoeffs = getfield(allpasscoeffs,fn{k});
    if length(sectioncoeffs) == 2,
        secondordcount = secondordcount + 1;
    end
    sectioncoeffs(2) = -sectioncoeffs(2); % Transform by 90 pi/2
    allpasscoeffs = setfield(allpasscoeffs,fn{k},sectioncoeffs);
end
% If the number of 2nd order sections is odd, we need to include a gain of
% -1 because of the transformation
if rem(secondordcount,2),
    Ha =  Hd.stage(1).stage(2).stage(2);
    Ha.AllpassCoefficients = allpasscoeffs;
    Hd.stage(1).stage(2).stage(2) = cascade(dfilt.scalar(-1),Ha);
else
    Hd.stage(1).stage(2).stage(2).AllpassCoefficients = allpasscoeffs;
end

Hd.stage(1).stage(2).stage(1) = dfilt.dffir([0 complex(0,1)]);

if rem(Hd.stage(1).stage(1).Latency,4) == 2,
    Hd.stage(1).stage(1) = ...
        dfilt.dffir([zeros(1,Hd.stage(1).stage(1).Latency) -1]);
end

% [EOF]
