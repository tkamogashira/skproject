function varargout = dspblkcovarmeth2(action,varargin)
% DSPBLKCOVARMETH2 Mask dynamic dialog function for
% Covariance Method power spectrum estimation block

% Copyright 1995-2011 The MathWorks, Inc.

blk = gcb;

switch action
    
case 'dynamic'
    
    % Execute dynamic dialogs
    
    % Cache original dialog mask enables
    ena_orig = get_param(blk,'maskenables');
    ena = ena_orig;
    
    % Determine "Inherit FFT length" and "Inherit sample time" checkbox settings
    inhFftStr = get_param(blk,'inheritFFT');
    inhTsStr  = get_param(blk,'inheritTs');
    
    % Determine if FFT length and sample time edit boxes are visible
    iFFTedit = 3; fftEditBoxEnabled = strcmp(inhFftStr, 'off');
    iTsedit  = 5; TsEditBoxEnabled  = strcmp(inhTsStr, 'off');
    
    % Map true/false to off/on strings, and place into visibilities array:
    enaopt = {'off','on'};
    ena([iFFTedit iTsedit]) = enaopt([fftEditBoxEnabled TsEditBoxEnabled]+1);
    if ~isequal(ena,ena_orig),
        % Only update if a change was really made:
        set_param(blk,'maskenables',ena);
        set_param(blk,'maskvisibilities',ena);
    end

    
case 'init'
    % Determine "Inherit FFT length" checkbox setting
    inhFft_check = varargin{1};
    inhTs_check  = varargin{2};
    Ts           = varargin{3};

    magfft_blk   = [blk, '/Magnitude FFT'];
    magfft_check = get_param(magfft_blk,'fftLenInherit');
    
    changePending = ~strcmp(inhFft_check, magfft_check);
    if changePending,
        set_param(magfft_blk, 'fftLenInherit', inhFft_check);
    end

    % Build the underlying system for 'Inherit sample time from input' parameter
    % 3rd input arg below is the block position for adding Frame Period To Sample Time OR
    % Constant block to the subsystem. This ensures straight lines in the subsystem.
    % 4th input arg below indicates whether the block is a Periodogram block or not. In 
    % this case, it is not - hence false.
    dspspect3_helper('init', blk, inhTs_check, Ts, [165 129 210 171], false);    
    
case 'icon'

    ord      = varargin{1};
    fftsize  = varargin{2};
    
    if ~isreal(ord) || (ord <= 0) || (ord~=floor(ord))
        error(message('dsp:dspblkcovarmeth2:InvalidEstimationOrder'));
    end
    
    if ~isreal(fftsize) || (fftsize <= 1) || (fftsize~=floor(fftsize))
        error(message('dsp:dspblkcovarmeth2:InvalidFFTSize'));
    end

    [varargout{1:nargout}]  = dspspect3_helper('icon');
    
end

% [EOF] dspblkcovarmeth2.m
