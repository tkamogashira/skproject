function [h,l,framing] = dspblk2chabank2(blkh,hpf,lpf,framing)
% DSPBLK2CHABANK2 Mask dynamic dialog function for the Two-Channel
% Analysis Subband Filter block

% Copyright 2005-2011 The MathWorks, Inc.

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

    h = [];
    l = [];
    [M,N] = size(hpf);
    if (M ~= 1 && N ~= 1)
       error(message('dsp:dspblk2chabank2:invalidCoefficient1')); 
    end
    [M,N] = size(lpf);
    if (M ~= 1 && N ~= 1)
       error(message('dsp:dspblk2chabank2:invalidCoefficient2')); 
    end
    if(~isempty(hpf) && ~isempty(lpf))
            % Direct form
            % Need to reshuffle the coefficients into phase order
            h = phaseReshuffle(hpf);
            l = phaseReshuffle(lpf);
    end

function y = phaseReshuffle(x)
    len = length(x);
    y = flipud(x(:));
    if (rem(len, 2) ~= 0)
        nzeros = 2 - rem(len, 2);
        y = [zeros(nzeros,1); y];
    end
    len = length(y);
    nrows = len / 2;
    % Re-arrange the coefficients
    y = flipud(reshape(y, 2, nrows).');

% end of dspblk2chabank2.m
