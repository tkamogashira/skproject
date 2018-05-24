function params = blockparams(this, mapstates, varargin)
%BLOCKPARAMS   Return the parameters to set-up the block.

%   Copyright 1999-2012 The MathWorks, Inc.


params = thisblockparams(this);

params.M                = sprintf('%d', this.DifferentialDelay);
params.N                = sprintf('%d', this.NumberOfSections);
params.filterInternals  = filterinternalsstrmap(this.FilterInternals);
params.BPS              = mat2str(this.SectionWordLengths);
params.FLPS             = mat2str(this.SectionFracLengths);
params.outputWordLength = sprintf('%d', this.OutputWordLength);
params.outputFracLength = sprintf('%d', this.OutputFracLength);

if strcmpi(mapstates, 'on'),
    warning(message('dsp:mfilt:abstractcic:blockparams:cannotMapStates'));
end

%--------------------------------------------------------------------------
function outstr = filterinternalsstrmap(instr)
% Map the filter internals string to a valid one for block

switch lower(instr),
    case  'fullprecision',
        outstr = 'Full precision';
    case 'minwordlengths',
        outstr = 'Minimum section word lengths';
    case 'specifywordlengths',
        outstr = 'Specify word lengths';
    case 'specifyprecision',
        outstr = 'Binary point scaling';
end

