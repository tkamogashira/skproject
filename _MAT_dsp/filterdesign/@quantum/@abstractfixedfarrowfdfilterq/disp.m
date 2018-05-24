function disp(this, varargin)
%DISP Object display.

%   Author(s): V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

% Re-order properties
if this.CoeffAutoScale,
    coeffprop = {'CoeffWordLength';...
        'CoeffAutoScale';...
        'Signed'};
else
    coeffprop = {'CoeffWordLength';...
        'CoeffAutoScale';...
        'CoeffFracLength';...
        'Signed'};
end

inprop = {'InputWordLength';...
    'InputFracLength'};
    
if isfield(get(this),'FDComputeWordLength')
    if this.FDAutoScale,    
        fdprop = {'FDComputeWordLength';'FDWordLength';...
        'FDAutoScale'};
    else
        fdprop = {'FDComputeWordLength';'FDWordLength';...
        'FDAutoScale'; ...
        'FDFracLength'};
    end
else
    if this.FDAutoScale,    
        fdprop = {'FDWordLength';...
        'FDAutoScale'};
    else
        fdprop = {'FDWordLength';...
        'FDAutoScale'; ...
        'FDFracLength'};
    end
end

internalsprop = {'FilterInternals'};

if strcmpi(this.FilterInternals,'SpecifyPrecision'),
    outprop = {'OutputWordLength',...
        'OutputFracLength'};
    modes = {'RoundMode',...
        'OverflowMode'};
    accprop = {'AccumWordLength';...
        'AccumFracLength'};
    prodprop = {'ProductWordLength';...
        'ProductFracLength'};
    multprop = {'MultiplicandWordLength';...
        'MultiplicandFracLength'};
    fdprodprop = {'FDProdWordLength';...
        'FDProdFracLength'};

    siguddutils('dispstr', this, {coeffprop, inprop, fdprop,internalsprop, ...
        outprop, prodprop, accprop, multprop, fdprodprop, modes}, varargin{:});
else
    siguddutils('dispstr', this, {coeffprop, inprop, fdprop,internalsprop}, varargin{:})
end

% [EOF]
