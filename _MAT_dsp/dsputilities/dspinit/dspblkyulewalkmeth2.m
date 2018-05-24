function varargout = dspblkyulewalkmeth2(action, varargin)
% DSPBLKYULEWALKMETH2 Mask dynamic dialog function for
% Yule-Walker Method power spectrum estimation block

% Copyright 1995-2009 The MathWorks, Inc.

blk = gcb;

switch action
case 'icon'
    
    [varargout{1:nargout}]  = dspspect3_helper('icon');
    
case 'dynamic'
    % Execute dynamic dialogs
    
    % Cache original dialog mask enables
    ena_orig = get_param(blk,'maskenables');
    ena = ena_orig;
    
    % Determine "Inherit FFT length", "Inherit order" and "Inherit sample time" checkbox settings
    inhOrdStr = get_param(blk,'inheritOrd');
    inhFftStr = get_param(blk,'inheritFFT');
    inhTsStr  = get_param(blk,'inheritTs');
    
    % Determine if Estimation order, FFT length and Sample time edit boxes are visible
    iOrdEdit = 2; ordEditBoxEnabled = strcmp(inhOrdStr, 'off');
    iFFTedit = 4; fftEditBoxEnabled = strcmp(inhFftStr, 'off');
    iTsEdit  = 6; TsEditBoxEnabled  = strcmp(inhTsStr,  'off');
    
    % Map true/false to off/on strings, and place into visibilities array:
    enaopt = {'off','on'};
    ena([iFFTedit iOrdEdit iTsEdit]) = enaopt([fftEditBoxEnabled ordEditBoxEnabled TsEditBoxEnabled]+1);
    if ~isequal(ena,ena_orig),
        set_param(blk,'maskenables',ena);
        set_param(blk,'maskvisibilities',ena);
    end
    
  case 'init'
    
    % Execute side-effect behaviors
    % i.e., set_param to underlying blocks, build the underlying system for sample time inheritance etc.
    
    % Determine "Inherit FFT length" and "Inherit order" checkbox settings
    inhOrd_check = varargin{1};
    inhFft_check = varargin{2};
    inhTs_check  = varargin{3};
    Ts           = varargin{4};
    
    % Determine names of underlying blocks:
    magfft_blk  = strcat(blk, '/Magnitude FFT');
    ywarest_blk = strcat(blk, '/Yule-Walker AR Estimator');
    
    % Get affected parameters of underlying blocks:
    ywarest_check = get_param(ywarest_blk,'inheritOrder'); % INHERIT ESTIMATION ORDER
    magfft_check  = get_param(magfft_blk,'fftLenInherit'); % INHERIT FFT LENGTH
    
    changePending_order = ~strcmp(inhOrd_check, ywarest_check);
    changePending_fft   = ~strcmp(inhFft_check, magfft_check);
    anyChangePending = changePending_fft | changePending_order;
    
    if anyChangePending,
        set_param(ywarest_blk, 'inheritOrder', inhOrd_check);
        set_param(magfft_blk, 'fftLenInherit', inhFft_check);
    end
    
    % Build the underlying system for 'Inherit sample time from input' parameter
    % 3rd input arg below is the block position for adding Frame Period To Sample Time OR
    % Constant block to the subsystem. This ensures straight lines in the subsystem.
    % 4th input arg below indicates whether the block is a Periodogram block or not. In 
    % this case, it is not - hence false.
    dspspect3_helper('init', blk, inhTs_check, Ts, [165 119 210 161], false);

end

% [EOF] dspblkyulewalkmeth2.m
