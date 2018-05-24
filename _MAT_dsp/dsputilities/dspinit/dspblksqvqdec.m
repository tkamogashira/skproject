function dspblksqvqdec()
% DSPBLKSQVQDEC DSP System Toolbox Scalar and Vector Quantizer Decoder mask helper function.

% Copyright 2010 The MathWorks, Inc.

blkh         = gcbh;
obj          = get_param(blkh,'object');
visibles     = obj.MaskVisibilities;
old_visibles = visibles;

[CBValuesParamIndex, OutUDTStrParamIndex] = deal(3, 10);

if ~strcmp(obj.CBsource,'Input port')
    visibles(CBValuesParamIndex)  = {'on'};
    visibles(OutUDTStrParamIndex) = {'on'};
else
    visibles(CBValuesParamIndex)  = {'off'};
    visibles(OutUDTStrParamIndex) = {'off'};
end

if ~isequal(visibles, old_visibles)
    obj.MaskVisibilities = visibles;
end
