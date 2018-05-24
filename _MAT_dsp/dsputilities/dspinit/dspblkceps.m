function varargout = dspblkceps(varargin)
% DSPBLKRCEPS Mask dynamic dialog function for Real/Complex Cepstrum blocks

% Copyright 1995-2009 The MathWorks, Inc.

if nargin==0   % For dynamic dialog callback, dspblkceps is called with no arguments
    action = 'dynamic';
else
    action = varargin{1};  % 'init'
end

blk = gcb;

% Determine "Inherit FFT length" checkbox setting
inhFftStr = get_param(blk, 'inheritFFT');

switch action
case 'dynamic'
    
    % Execute dynamic dialog behavior
    
    % Cache original dialog mask enables/visibility
    ena_orig = get_param(blk, 'maskenables');
    vis      = get_param(blk, 'maskvisibilities');
    ena      = ena_orig;
    
    % Determine if FFT length edit box is visible/enabled
    iFFTedit = 2; fftEditBoxEnabled = strcmp(inhFftStr, 'off');
    
    % Map true/false to off/on strings, and place into visibilities array:
    enaOrVisOpt = {'off', 'on'};
    ena(iFFTedit) = enaOrVisOpt(fftEditBoxEnabled + 1);
    vis(iFFTedit) = enaOrVisOpt(fftEditBoxEnabled + 1);
    
    if ~isequal(ena,ena_orig),
        % Only update if a change was really made:
        set_param(blk, 'maskenables', ena);
        set_param(blk, 'maskvisibilities', vis);
    end
    
case 'init'
    
    % Execute Initialization-mode settings
    
    % Update the Zero Pad block underneath the top level
    if strcmp(inhFftStr, 'on'),
        set_param([blk '/Zero Pad'], 'zpadAlong', 'None');
    else
        set_param([blk '/Zero Pad'], 'zpadAlong', 'Columns');
    end
    
end

% [EOF] dspblkrceps.m
