function varargout = dspblkburgmeth2(action, varargin)
% DSPBLKBURGMETH2 Mask dynamic dialog function for
% Burg Method power spectrum estimation block

% Copyright 1995-2009 The MathWorks, Inc.

blk = gcb;

switch action
case 'dynamic'
    
    % Execute dynamic dialogs
    
    % Cache original dialog mask enables
    ena_orig = get_param(blk,'maskenables');
    ena = ena_orig;
    
    % Determine "Inherit FFT length", "Inherit order" and "Inherit sample time" checkbox settings
    inhFftStr = get_param(blk,'inheritFFT');
    inhOrdStr = get_param(blk,'inheritOrd');
    inhTsStr  = get_param(blk,'inheritTs');
    
    % Determine if Estimation order, FFT length and Sample time edit boxes are visible
    iFFTedit = 4; fftEditBoxEnabled = strcmp(inhFftStr, 'off');
    iOrdEdit = 2; ordEditBoxEnabled = strcmp(inhOrdStr, 'off');
    iTsEdit  = 6; TsEditBoxEnabled  = strcmp(inhTsStr,  'off');
    
    % Map true/false to off/on strings, and place into visibilities array:
    enaopt = {'off','on'};
    ena([iFFTedit iOrdEdit iTsEdit]) = enaopt([fftEditBoxEnabled ordEditBoxEnabled TsEditBoxEnabled]+1);
    if ~isequal(ena,ena_orig),
        set_param(blk,'maskenables',ena);
        set_param(blk,'maskvisibilities',ena);
    end
    
    
case 'init'
    
    % Determine "Inherit FFT length" and "Inherit order" checkbox settings
    inhOrd_check = varargin{1};
    inhFft_check = varargin{2};
    inhTs_check  = varargin{3};
    Ts           = varargin{4};

    magfft_blk    = [blk, '/Magnitude FFT'];
    burgarest_blk = [blk, '/Burg AR Estimator'];
    
    magfft_check = get_param(magfft_blk,'fftLenInherit');
    burgarest_check = get_param(burgarest_blk,'inheritOrder');
    
    changePending = ~( strcmp(inhFft_check, magfft_check) & ...
                       strcmp(inhOrd_check, burgarest_check) ...
                      );
    if changePending,
        set_param(magfft_blk,    'fftLenInherit', inhFft_check);  % INHERIT FFT LENGTH
        set_param(burgarest_blk, 'inheritOrder',  inhOrd_check);  % INHERIT ESTIMATION ORDER
    end
    
    % Build the underlying system for 'Inherit sample time from input' parameter
    % 3rd input arg below is the block position for adding Frame Period To Sample Time OR
    % Constant block to the subsystem. This ensures straight lines in the subsystem.
    % 4th input arg below indicates whether the block is a Periodogram block or not. In 
    % this case, it is not - hence false.
    dspspect3_helper('init', blk, inhTs_check, Ts, [200 140 250 180], false);
        
case 'icon'
    
    [varargout{1:nargout}]  = dspspect3_helper('icon');
    
end

% [EOF] dspblkburgmeth2.m
