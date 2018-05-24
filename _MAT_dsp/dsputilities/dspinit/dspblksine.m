function dspblksine()
% DSPBLKSINE DSP System Toolbox Sine Wave block helper function.

% Copyright 1995-2010 The MathWorks, Inc.

blk  = gcbh;
obj  = get_param(blk,'object');
Mode = obj.SampleMode;
isDiscrete = strncmp(Mode,'Discrete',8);

vis     = obj.MaskVisibilities;
lastVis = vis;

% Update visibilities of the following mask dialog parameters:
%   computation method, complex computation method,
%   sample time, samples per frame, data-type and re-enable.
[AMPLITUDE, FREQUENCY, PHASE] = deal(1,2,3);
[COMPMETHOD, TABLESIZE, SAMPLETIME, SAMPLESPERFRAME] = deal(6,7,8,9);
if isDiscrete,
    vis(COMPMETHOD) = {'on'};
    vis(SAMPLETIME) = {'on'};
    vis(SAMPLESPERFRAME) = {'on'};
    obj.MaskVisibilities = vis;
    lastVis = vis;
    Method = obj.CompMethod;
    isTable = strcmp(Method,'Table lookup');
    isDiff  = strcmp(Method,'Differential');
    if isTable,
        vis(TABLESIZE)={'on'};
    else
        vis(TABLESIZE)={'off'};
    end
else
    isTable = 0;
    isDiff  = 0;
    vis(COMPMETHOD : SAMPLESPERFRAME) = {'off'};
end

% Set the tunability of the Amp, Freq, and Phase.
% These need to be "off" in Table Lookup Mode
tune = obj.MaskTunableValues;
orig_tune = tune;
if isTable,
    tune(AMPLITUDE : PHASE) = {'off'};
else
    if isDiff
        tune(AMPLITUDE) = {'on'};
        tune(FREQUENCY : PHASE) = {'off'};
    else
        tune(AMPLITUDE : PHASE) = {'on'};
    end
end
if ~isequal(tune,orig_tune),
    obj.MaskTunableValues = tune;
end

% Set the mask parameter visibilities
if ~isequal(vis,lastVis)
    obj.MaskVisibilities = vis;
end
