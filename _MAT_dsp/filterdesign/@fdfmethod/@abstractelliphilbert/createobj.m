function Hd = createobj(this,Hhalf)
%CREATEOBJ

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.

% Convert halfband to hilbert
Hd = copy(Hhalf);

fn = fieldnames(Hd.stage(1).stage(1).AllpassCoefficients);
allpasscoeffs = Hd.stage(1).stage(1).AllpassCoefficients;
for k = 1:length(fn),
    sectioncoeffs = getfield(allpasscoeffs,fn{k});
    sectioncoeffs(2) = -sectioncoeffs(2); % Transform by 90 pi/2
    allpasscoeffs = setfield(allpasscoeffs,fn{k},sectioncoeffs);
end
% If the number of sections is odd, we need to include a gain of -1 because
% of the transformation
if rem(length(fn),2),
    Ha =  Hd.stage(1).stage(1);
    Ha.AllpassCoefficients = allpasscoeffs;
    Hd.stage(1).stage(1) = cascade(dfilt.scalar(-1),Ha);
else
    Hd.stage(1).stage(1).AllpassCoefficients = allpasscoeffs;
end

% For some low order halfbands, the second branch is simply a delay
if isa(Hd.Stage(1).Stage(2),'dfilt.cascade'),
    fn = fieldnames(Hd.stage(1).stage(2).stage(2).AllpassCoefficients);
    allpasscoeffs = Hd.stage(1).stage(2).stage(2).AllpassCoefficients;
    for k = 1:length(fn),
        sectioncoeffs = getfield(allpasscoeffs,fn{k});
        sectioncoeffs(2) = -sectioncoeffs(2); % Transform by 90 pi/2
        allpasscoeffs = setfield(allpasscoeffs,fn{k},sectioncoeffs);
    end
    % If the number of sections is odd, we need to include a gain of -1 because
    % of the transformation
    if rem(length(fn),2),
        Ha =  Hd.stage(1).stage(2).stage(2);
        Ha.AllpassCoefficients = allpasscoeffs;
        Hd.stage(1).stage(2).stage(2) = cascade(dfilt.scalar(-1),Ha);
    else
        Hd.stage(1).stage(2).stage(2).AllpassCoefficients = allpasscoeffs;
    end

    Hd.stage(1).stage(2).stage(1) = dfilt.dffir([0 complex(0,1)]);
else
    Hd.stage(1).stage(2) = dfilt.dffir([0 complex(0,1)]);
end

% [EOF]
