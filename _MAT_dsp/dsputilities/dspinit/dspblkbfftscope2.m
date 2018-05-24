function varargout = dspblkbfftscope2(action, varargin)
% DSPBLKBFFTSCOPE2 DSP System Toolbox Spectrum Scope block helper function.

% Copyright 1995-2012 The MathWorks, Inc.

% Params structure fields:
% ( 1) ScopeProperties: checkbox
%   2  Domain: 0=Time, 1=Frequency, 2=User Defined
%   3  HorizSpan: Horizontal time span (number of frames)
%   4 useBuffer: checkbox
%   5 BufferSize: edit box
%   6 Overlap: edit box
%   7 TreatMby1Signals: popup (see Buffer block)
%   8 wintypeSpecScope: popup (see Periodogram block)
%   9 RsSpecScope: edit box (see Periodogram block)
%  10 betaSpecScope: edit box (see Periodogram block)
%  11 winsampSpecScope: popup (see Periodogram block)
%  12 inpFftLenInherit: checkbox
%  13 FFTlength: edit box
%  14 NumAvg: edit box
%
% (15) DisplayProperties: checkbox
%  16  AxisGrid: checkbox
%  17  Memory: checkbox
%  18  FrameNumber: checkbox
%  19  AxisLegend: checkbox
%  20  AxisZoom: checkbox
%  21  OpenScopeAtSimStart: checkbox
%  22  OpenScopeImmediately: checkbox
%  23  FigPos: figure position
%
% (24) AxisProperties: checkbox
%  25  XUnits:
%       User, Time: ignored
%       Freq: 0=Hz, 1=rad/sec
%  26  XRange:
%       User, Time: ignored
%       Freq: 0=[0,Fn] , 1=[-Fn,Fn], 2=[0, Fs]
%                 (Fn=Nyquist rate, Fs=Sample rate)
%  27  InheritXIncr: checkbox
%  28  XIncr: increment of x-axis samples, used for x-axis display
%       Time: ignored (assumes frame-based)
%       Freq: Only displayed if data was zero-padded
%       User: seconds per sample
%  29  XLabel:
%       Time, Frequency: ignored
%       User: displayed
%  30  YUnits:
%       User, Time: ignored
%       Freq: 0=Magnitude, 1=dB
%  31  YMin: minimum Y-limit
%  32  YMax: maximum Y-limit
%  33  YLabel:
%       Always used
%
% (34) LineProperties: checkbox
%  35  LineDisables: pipe-delimited string
%  36  LineStyles: pipe-delimited string
%  37  LineMarkers: pipe-delimited string
%  38  LineColors: pipe-delimited string

blk    = gcb;
blkh   = gcbh;
domain = get_param(blkh,'Domain');

switch action
case 'icon'
    if ~strcmp(domain,'Frequency'),
        error(message('dsp:dspblkbfftscope2:unhandledCase'));
    end
    x = [0 NaN 100 NaN ...
            8 8 92 92 8 NaN 16 16 84 NaN 24 24 NaN 32 32 32 NaN ...
            40 40 NaN 48 48 NaN 56 56 NaN 64 64 NaN ...
            80 80 80 80 NaN 72 72 72];
    y = [0 NaN 100 NaN ...
            92 40 40 92 92 NaN 88 48 48 NaN 76 48 NaN 65 48 48 NaN ...
            79 48 NaN 60 48 NaN 58 48 NaN 64 48 NaN ...
            49 49 48 48 NaN 48 48 54];
    
    useBuffer = isOn(get_param(blkh,'useBuffer'));
    if useBuffer,
        str='B-FFT';
    else
        str='FFT';
    end
    
    varargout(1:3) = {x,y,str};
    
case 'init'   

    [spectrumUnits specifyFft_check wintypeSpecScope winsampSpecScope inheritTs_check] = ...
        deal(varargin{:});

    % Five steps:
    % 1. Copy and return all mask dialog entries as a structure
    s = getWorkspaceVarsAsStruct(blkh);

    % --- Pre-processing for backward compatibility - start ---
    % 'Frequency units' parameter (XUnits block parameter varaiable) has been removed in R2009B
    % and only 'Hertz' is supported as frequency unit. Hence, always set 'XUnits' field of the
    % structure to 1, which corresponds to 'Hertz' selection, so that the S-Function does the 
    % right thing with it.
    s.XUnits = 1;
    % Starting with R2009B, Spectrum Scope has different behavior than Frequency Domain of Vector
    % Scope. Add information that this block is Spectrum Scope in the block's user-data that is used
    % extensively by the s-fcn (sdspfscope2.m). The s-fcn is to use the existence of 
    % 'SpectrumScope' field in the user-data as an indication that the block is Spectrum Scope.
    % The 'ComplexInput' field is used in the s-fcn to check for input complexity for one-sided
    % spectrum.
    s.SpectrumScope.isInputComplex = 0;
    s.SpectrumScope.scaleYAxis = 0;
    % Starting with R2009B, 'Spectrum units' (formerly, 'Y-axis scaling') parameter has different
    % set of options. Need to take care of that mapping before passing block parameters to s-fcn
    % s.SpectrumScope.scaleYAxis is used by the s-function to determine (if 1) whether to scale
    % Y-axis limits to ease user transition from previous releases to R2009b. Once the user model
    % is saved in R2009b, s.YUnits would never be 7 or 8 and no need to scale Y-axis. Note that,
    % in R2009b, the output of Spectrum Scope changed due to correct scaling by signal sampling
    % frequency.
    if (s.YUnits == 7) % Magnitude-squared
        spectrumUnits = 1;
        s.YUnits = 1; % Watts/Hertz
        s.SpectrumScope.scaleYAxis = 1;
    elseif (s.YUnits == 8) % dB
        spectrumUnits = 3;
        s.YUnits = 3; % dBW/Hertz
        s.SpectrumScope.scaleYAxis = 1;
    end
    % Starting with R2009B, 'Spectrum type' (formerly, 'Frequency range') parameter has different
    % set of options. Need to take care of that mapping before passing block parameters to s-fcn
    if (s.XRange == 3) % [0...Fs/2]
        s.XRange = 1; % One-sided ([0...Fs/2])
    elseif (any(s.XRange == [4 5])) % [-Fs/2...Fs/2] or [0...Fs]
        s.XRange = 2; % Two-sided ((-Fs/2...Fs/2])
    end
    % --- Pre-processing for backward compatibility - end ---
    
    varargout{1} = s;
    sdspfscope2([],[],[],'DialogApply',s);

    % Frame upgrade method at model load time: For a non-lib block, if its
    % hidden parameter 'isFrameUpgraded' is unchecked, the model containing
    % it is from a pre-11a version and we should check this parameter.
    % Meanwhile, if the underneath Buffer block is used, we should set the
    % 'TreatMby1Signals' parameter to the "inherited" mode as well.
    if ~isempty(get_param(blk, 'ReferenceBlock')) && ... 
        strcmpi(get_param(blk, 'isFrameUpgraded'), 'off')
        
        set_param(blk, 'isFrameUpgraded', 'on');
        if strcmpi(get_param(blk, 'useBuffer'), 'on')
            set_param(blk, 'TreatMby1Signals', 'M channels');
         end
     end
    
    stfft_blk   = [blk '/Periodogram'];
    
    % 2. Update Measurement parameter of Periodogram block under the hood
    if any(spectrumUnits == [1 3 5])
        % Measurement = PSD
        measurement = 'Power spectral density';
    else
        % Measurement = MSS
        measurement = 'Mean-square spectrum';
    end        
    stfft_measurement = get_param(stfft_blk, 'measurement');
    if ~strcmpi(measurement, stfft_measurement)
        % The 'measurement' parameter of Periodogram block can only be changed if simulation is NOT
        % running or paused. 
        simStatus = get_param(bdroot(blk),'SimulationStatus');
        if any(strcmp(simStatus,{'running','paused'}))
            % create correct error message based on the 'measurement' parameter
            if strcmpi(stfft_measurement, 'Power spectral density')
                error(message('dsp:dspblkbfftscope2:invalidParam1')); 
            else % MSS
                error(message('dsp:dspblkbfftscope2:invalidParam2')); 
            end
        end

        set_param(stfft_blk, 'measurement', measurement);    
    end        
    
    % 3. Update checkbox for inheriting FFT size
    if (specifyFft_check == 1) % 'Specify FFT length' = 'On'
        inhFft_check = 'off';
    else
        inhFft_check = 'on';
    end
    stfft_check = get_param(stfft_blk,'inheritFFT');
    
    changePending = ~strcmp(inhFft_check, stfft_check);
    if changePending,
        set_param(stfft_blk, 'inheritFFT', inhFft_check);
    end
    
    % 4. Update window parameters under the hood
    % windowName must be exactly same as the options for 'wintypeSpecScope' (Window) parameter
    windowName = {'Bartlett', 'Blackman', 'Boxcar', 'Chebyshev', 'Hamming', 'Hann', ...
                  'Hanning', 'Kaiser', 'Triang'};
    stfft_wintype    = get_param(stfft_blk,'wintype');
    changePending = ~strcmp(windowName{wintypeSpecScope}, stfft_wintype);
    if changePending,
        set_param(stfft_blk, 'wintype', windowName{wintypeSpecScope});
    end
    
    % winSamplingName must be exactly same as the options for 'winsampSpecScope' 
    % (Window sampoing) parameter
    winSamplingName = {'Symmetric', 'Periodic'};
    stfft_winsamp    = get_param(stfft_blk,'winsamp');
    changePending = ~strcmp(winSamplingName{winsampSpecScope}, stfft_winsamp);
    if changePending,
        set_param(stfft_blk, 'winsamp', winSamplingName{winsampSpecScope});
    end
    
    % 5. Update checkbox for inheriting sample time from input
    stfft_inheritTs_check = get_param(stfft_blk,'inheritTs');
    changePending = ~strcmpi(inheritTs_check, stfft_inheritTs_check);
    if changePending
        set_param(stfft_blk, 'inheritTs', inheritTs_check);
    end
    
case 'setMaskEnables'
    % set 'maskenables' correctly for dependent, non-tunable edit-field mask params
    setMaskEnables(blkh, varargin{:});

end


% --------------------------------------------------------------------
function y = isOn(str)
y = strcmp(str,'on');


% --------------------------------------------------------------------
function s = getWorkspaceVarsAsStruct(blkh)
% Get mask workspace variables:

ss = get_param(blkh,'maskwsvariables');

% Only the first "numdlg" variables are from dialog;
% others are created in the mask init fcn itself.
dlg = get_param(blkh,'masknames');
ss = ss((ismember({ss.Name}, dlg) == 1));

% Create a structure with:
%   field names  = variable names
%   field values = variable values
s = cell2struct({ss.Value}',{ss.Name}',1);

% --------------------------------------------------------------------
function setMaskEnables(blkh, varargin)
% This function sets 'maskenables' correctly for dependent, non-tunable 
% edit-field mask params based on the settings of main params. 

useBuffer        = varargin{1};
inpFftLenInherit = varargin{2};
wintypeSpecScope = varargin{3};
inheritXIncr     = varargin{4};

[bufferSizeIdx, overlapIdx, treatMby1SigIdx, fftLengthIdx, betaIdx, xIncrIdx] = ... 
    dspGetMaskParamIdx(blkh, 'BufferSize', 'Overlap', 'TreatMby1Signals', ...
                             'FFTlength', 'betaSpecScope', 'XIncr');

en = get_param(blkh, 'maskenables');
newEn = en;

% 'Buffer size' and 'Buffer overlap' params - dependent on 'Buffer input' param
if strncmpi(useBuffer, 'on', 2) 
    newEn{bufferSizeIdx}   = 'on';
    newEn{overlapIdx}      = 'on';
    newEn{treatMby1SigIdx} = 'on';
else
    newEn{bufferSizeIdx}   = 'off';
    newEn{overlapIdx}      = 'off';    
    newEn{treatMby1SigIdx} = 'off';    
end

% 'FFT length' param - dependent on 'Specify FFT length' param
if inpFftLenInherit
    newEn{fftLengthIdx} = 'on';
else
    newEn{fftLengthIdx} = 'off';    
end

% 'Beta' param - dependent on 'Window type' param being set to "Kaiser"
if (wintypeSpecScope == 8) % Kaiser
    newEn{betaIdx} = 'on';
else
    newEn{betaIdx} = 'off';    
end

% 'Sample time of original time series' param - dependent on 'Inherit sample 
% increment from input' param
if strncmpi(inheritXIncr, 'on', 2)
    newEn{xIncrIdx} = 'off';
else
    newEn{xIncrIdx} = 'on';    
end

% Set mask enables if needed
if ~isequal(newEn, en)
    set_param(blkh, 'maskenables', newEn);
end    

% [EOF] dspblkbfftscope2.m
