function [h,l,framing] = dspblk2chsbank(blkh, hpf,lpf,framing, ...
    dtRndMode, dtOFMode)
% DSPBLK2CHSBANK DSP System Toolbox 2-Channel Synthesis Filter Bank block helper function.

% Copyright 2002-2011 The MathWorks, Inc.

dspSetFrameUpgradeParameter(blkh,'InputProcessing', ...
    'Inherited (this choice will be removed - see release notes)', ...
    'framing', 'Maintain input frame size');

% Maintain input frame size(3) maps to Allow multi-rate(2)
% Maintain input frame rate(4) maps to Enforce single-rate(1)
if framing == 3
    framing = 2;
elseif framing == 4
    framing = 1;
end


fullblk     = getfullname(blkh);
sum_blk     = [fullblk '/Sum'];
dt_cnvt_blk = [fullblk '/Data Type Conversion'];

% Under the block mask, set the Sum and Convert
% block rounding and overflow parameters to what
% was specified at the top-level of the mask
rndModeVec = {'Ceiling','Convergent','Floor','Nearest','Round','Simplest','Zero'};
rndMode = rndModeVec{dtRndMode};
set_param(sum_blk,     'RndMeth', rndMode);
set_param(dt_cnvt_blk, 'RndMeth', rndMode);

%%ck: if (dtInfo.roundingMode == 4)
%%ck:     set_param(sum_blk,     'RndMeth', 'Floor');
%%ck:     set_param(dt_cnvt_blk, 'RndMeth', 'Floor');
%%ck: else
%%ck:     set_param(sum_blk,     'RndMeth', 'Nearest');
%%ck:     set_param(dt_cnvt_blk, 'RndMeth', 'Nearest');
%%ck: end

if (dtOFMode == 2)
    set_param(sum_blk,     'SaturateOnIntegerOverflow', 'on');
    set_param(dt_cnvt_blk, 'SaturateOnIntegerOverflow', 'on');
else
    set_param(sum_blk,     'SaturateOnIntegerOverflow', 'off');
    set_param(dt_cnvt_blk, 'SaturateOnIntegerOverflow', 'off');
end

h = [];
l = [];

[M,N] = size(hpf);
if (M ~= 1 && N ~= 1)
    error(message('dsp:dspblk2chsbank:invalidCoefficient1'));
end
[M,N] = size(lpf);
if (M ~= 1 && N ~= 1)
    error(message('dsp:dspblk2chsbank:invalidCoefficient2'));
end


if(~isempty(hpf) && ~isempty(lpf))

    % Need to reshuffle the coefficients into phase order
    h = phaseReshuffle(hpf);
    l = phaseReshuffle(lpf);

end

function y = phaseReshuffle(x)
    % Need to reshuffle the coefficients into phase order
    y = x(:);
    len = length(x);
    if (rem(len, 2) ~= 0)
        nzeros = 2 - rem(len, 2);
        y = [y(:); zeros(nzeros,1)];
    end
    len = length(y);
    nrows = len / 2;
    % Re-arrange the coefficients
    y = reshape(y, 2, nrows).';

% [EOF] dspblk2chsbank.m
