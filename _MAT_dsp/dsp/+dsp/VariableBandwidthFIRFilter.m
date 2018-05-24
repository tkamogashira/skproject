classdef VariableBandwidthFIRFilter < dsp.private.VariableBandwidthFilterBase & matlab.system.mixin.CustomIcon 
%VariableBandwidthFIRFilter Variable bandwidth FIR filter
%   HFIR = dsp.VariableBandwidthFIRFilter returns a System object, HFIR, 
%   which independently filters each channel of the input over time using
%   specified FIR filter specifications. The FIR filter's cutoff frequency
%   may be tuned during the filtering operation. The FIR filter is designed
%   using the window method. 
%
%   H = dsp.VariableBandwidthFIRFilter('Name', Value, ...) returns a 
%   Variable Bandwidth FIR Filter System object, H, with each specified 
%   property name set to the specified value. You can specify additional 
%   name-value pair arguments in any order as (Name1,Value1,...,NameN,
%   ValueN).
%
%   Step method syntax:
%
%   Y = step(H, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. The System object filters
%   each channel of the input signal independently over time.
%
%   VariableBandwidthFIRFilter methods:
%
%   step          - See above description for use of this method
%   release       - Allow property value and input characteristics changes                      
%   clone         - Create Variable Bandwidth FIR Filter object with 
%                   same property values                      
%   isLocked      - Locked status (logical)
%   reset         - Reset the internal states to initial conditions
%
%   VariableBandwidthFIRFilter properties:
%
%   SampleRate                   - Input sample rate
%   FilterType                   - FIR filter type
%   FilterOrder                  - FIR filter order
%   Window                       - Window function
%   KaiserWindowParameter        - Kaiser window parameter
%   SidelobeAttenuation          - Chebyshev window sidelobe attenuation
%   CutoffFrequency              - Filter cutoff frequency
%   CenterFrequency              - Filter center frequency
%   Bandwidth                    - Filter bandwidth            
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.VariableBandwidthFIRFilter.helpFilterAnalysis
%
%   % Example: Filter a signal through a variable bandwidth bandpass FIR
%   % filter. Tune the center frequency and the bandwidth of the FIR 
%   % filter. 
%   Fs = 44100; % Input sample rate
%   % Define a bandpass variable bandwidth FIR filter:
%   hfir = dsp.VariableBandwidthFIRFilter('FilterType','Bandpass',...
%                                         'FilterOrder',100,...
%                                         'SampleRate',Fs,...
%                                         'CenterFrequency',1e4,...
%                                         'Bandwidth',4e3);
%   htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided');
%   hplot = dsp.ArrayPlot('PlotType','Line',...
%                         'XOffset',0,...
%                         'YLimits',[-120 5], ...
%                         'SampleIncrement', 44100/1024,...
%                         'YLabel','Frequency Response (dB)',...
%                         'XLabel','Frequency (Hz)',...
%                         'Title','System Transfer Function');
%   FrameLength = 1024;
%   hsin = dsp.SineWave('SamplesPerFrame',FrameLength);
%   for i=1:500
%      % Generate input
%      x = step(hsin) + randn(FrameLength,1);
%      % Pass input through the filter
%      y = step(hfir,x);
%      % Transfer function estimation
%      h = step(htfe,x,y);
%      % Plot transfer function
%      step(hplot,20*log10(abs(h)))   
%      % Tune bandwidth and center frequency of the FIR filter
%      if (i==250)
%         hfir.CenterFrequency = 5000;
%         hfir.Bandwidth = 2000;
%      end
%   end
%
%   References:
%
%   [1] P.Jarske, Y. Neuvo, and S. K. Mitra, "A simple approach to the 
%       design of linear phase FIR digital filters with variable 
%       characteristics", Signal Process. (Elsevier), vol. 14, pp. 313-326,
%       1988.
%
%   See also dsp.VariableBandwidthIIRFilter, dsp.FIRFilter, dsp.IIRFilter, 
%            dsp.BiquadFilter, dsp.AllpoleFilter

%   Copyright 2013 The MathWorks, Inc.
    
%#codegen
%#ok<*EMCLS>

properties (Nontunable)
  % FilterOrder FIR filter order
  %   Specify the order of the FIR filter as a positive integer scalar. The 
  %   default is 30.
  FilterOrder = 30;
  % Window Window function
  %   Specify the window function used to design the FIR filter as one of 
  %   'Hann' | 'Hamming' | 'Chebyshev' | 'Kaiser'. The default is 'Hann'.
  Window = 'Hann';
  % KaiserWindowParameter Kaiser window parameter
  %   Specify the Kaiser window parameter as a real scalar. This property 
  %   applies when you set the  Window property to 'Kaiser'. The default is 
  %   0.5;
  KaiserWindowParameter = .5;
  % SidelobeAttenuation  Chebyshev window sidelobe attenuation
  %   Specify the Chebyshev window sidelobe attenuation as a real, positive 
  %   scalar in decibels (dB). This property applies when you set the 
  %   Window property to 'Chebyshev'. The default is 60 dB.
  SidelobeAttenuation = 60;
end

properties(Constant, Hidden)
  WindowSet = matlab.system.StringSet({'Hann', ...
                                       'Hamming',...
                                       'Chebyshev',...
                                       'Kaiser'});
end

properties
  % CutoffFrequency Filter Cutoff frequency
  %   Specify the filter cutoff frequency in Hz as a real, positive scalar 
  %   smaller than SampleRate/2. This property applies when you set the 
  %   FilterType property to 'Lowpass' or 'Highpass'. The default is 512 Hz. 
  %   This property is tunable.
  CutoffFrequency   = 512;
end
    
properties (Access = private, Nontunable)
  % pPrototypeWindow Window vector
  pPrototypeWindow;
  % pNumTaps Number of filter taps
  pNumTaps;
end

%--------------------------------------------------------------------------
% Public methods
%--------------------------------------------------------------------------
methods
  function obj = VariableBandwidthFIRFilter(varargin)
    % Constructor
    obj@dsp.private.VariableBandwidthFilterBase(varargin{:})
  end
  %------------------------------------------------------------------------   
  function set.CutoffFrequency(obj,value)
    validateattributes(value,{'double','single'},...
                             {'real','scalar','positive','finite'},...
                             '','CutoffFrequency');%#ok<EMCA>
    obj.CutoffFrequency = value;
  end
  %------------------------------------------------------------------------   
  function set.FilterOrder(obj,value)
    validateattributes(value,{'double','single'}, ...
    {'real','scalar','positive',...
    'integer'},'','FilterOrder');%#ok<EMCA>
    coder.internal.errorIf(mod(value,2)~=0,...
           'dsp:system:VariableBandwidthFilter:FIROrderOdd');
    obj.FilterOrder = value;
  end  
  %------------------------------------------------------------------------   
  function set.KaiserWindowParameter(obj,value)
    validateattributes(value,{'double','single'},...
                             {'real','scalar','finite'},...
                             '','KaiserWindowParameter');%#ok<EMCA>
    obj.KaiserWindowParameter = value;
  end
  %------------------------------------------------------------------------   
  function set.SidelobeAttenuation(obj,value)
    validateattributes(value,{'double','single'},...
                             {'real','scalar','positive','finite'},...
                             '','SidelobeAttenuation');%#ok<EMCA>
    obj.SidelobeAttenuation = value;
  end
end  
%--------------------------------------------------------------------------
% Protected methods
%--------------------------------------------------------------------------
methods (Access = protected)
  function setupImpl(obj, x)
    % Invoke setupImpl method of base class
    setupImpl@dsp.private.VariableBandwidthFilterBase(obj,x);
    % Cache the number of filter taps
    obj.pNumTaps =   obj.FilterOrder+1;
    % extrinsic functions for window vector design
    coder.extrinsic('dsp.VariableBandwidthFIRFilter.designWindow');
    coder.extrinsic('dsp.VariableBandwidthFIRFilter.designParametrizedWindow');
    switch obj.Window
        case {'Hamming','Hann'}
            obj.pPrototypeWindow = coder.const(@obj.designWindow,obj.Window,obj.pNumTaps,obj.pDatatype);
        case {'Chebyshev'}
            obj.pPrototypeWindow = coder.const(@obj.designParametrizedWindow,obj.Window,obj.SidelobeAttenuation,obj.pNumTaps,obj.pDatatype);
        case {'Kaiser'}
            obj.pPrototypeWindow = coder.const(@obj.designParametrizedWindow,obj.Window,obj.KaiserWindowParameter,obj.pNumTaps,obj.pDatatype);
    end
    % Instantiate FIR filter with initial dummy numerator (the coefficients
    % will be recomputed in tuneCoefficients
    obj.pfilter = dsp.FIRFilter('Numerator',obj.pPrototypeWindow);
    setup(obj.pfilter,x);
    % Compute coefficients based on cutoff frequency
    tuneCoefficients(obj);
  end
  %------------------------------------------------------------------------   
  function  tuneCoefficients(obj)
    switch obj.FilterType
        case {'Lowpass','Highpass'}
           % Compute normalized cutoff frequency
           newCutoff =  cast(obj.CutoffFrequency * 2 / obj.SampleRate,obj.pDatatype); 
           % Update lowpass filter coefficients
           updateLowpassCoefficients(obj,newCutoff);
           if strcmp(obj.FilterType,'Highpass')
               % update highpass filter coefficients
               updateHighpassCoefficients(obj); 
           end
        case {'Bandpass','Bandstop'}
           % Compute normalized cutoff frequency
           newCutoff =  cast(obj.Bandwidth  / obj.SampleRate,obj.pDatatype);
           % Update lowpass filter coefficients
           updateLowpassCoefficients(obj,newCutoff);
           if strcmp(obj.FilterType,'Bandpass')
               % update bandpass filter coefficients
               updateBandpassCoefficients(obj);
           else
               % update bandstop filter coefficients
               updateBandstopCoefficients(obj);
           end
    end
  end
  %------------------------------------------------------------------------     
  function updateLowpassCoefficients(obj,wc2)
    % Tune filter coefficients to new cutoff frequency
    % Compute coefficients of truncated ideal lowpass impulse response
    L = obj.pNumTaps;
    pCoefficients = cast(zeros(1,L),obj.pDatatype);
    ind = (L-1)/2 + 1;
    for i= -(L-1)/2:(L-1)/2
    if (i==0)
        pCoefficients(ind + i) = wc2;
    else
        pCoefficients(ind + i) =  sin(wc2*i*pi) / (pi*i);
    end
    end
    % Multiply coefficients by window vector and scale to ensure 0 dB gain
    % at 0 Hz. 
    obj.pfilter.Numerator = obj.pPrototypeWindow .* pCoefficients;
    obj.pfilter.Numerator = obj.pfilter.Numerator / sum(obj.pfilter.Numerator); 
  end
  %------------------------------------------------------------------------   
  function updateBandpassCoefficients(obj)
    % Modulate the lowpass coefficients by 2 * cos(wc.n)
    L = obj.pNumTaps;
    wc = obj.CenterFrequency * 2 / obj.SampleRate;
    obj.pfilter.Numerator = 2 * cos(pi*wc*(-(L-1)/2 : (L-1)/2)) .* obj.pfilter.Numerator;
  end
  %------------------------------------------------------------------------   
  function updateHighpassCoefficients(obj)
    % Get highpass coefficients from lowpass coefficients (Hhp(w) = 1 -
    % Hlp(w))
    L = obj.pNumTaps;
    b = - obj.pfilter.Numerator;
    % DC
    N = (L - 1) / 2 + 1;
    b(N) = 1 - obj.pfilter.Numerator(N);
    obj.pfilter.Numerator = b;
  end
  %------------------------------------------------------------------------   
  function updateBandstopCoefficients(obj)
    % Modulate the lowpass coefficients by 2 * cos(wc.n) and then flip
    % the frequency response
    L = obj.pNumTaps;
    wc = obj.CenterFrequency * 2 / obj.SampleRate;
    b = 2 * cos(pi*wc*(-(L-1)/2 : (L-1)/2)) .* obj.pfilter.Numerator;
    N = (obj.pNumTaps - 1) / 2 + 1;
    b2 = - b;
    b2(N) = 1 - b(N);
    obj.pfilter.Numerator = b2;
  end
  %------------------------------------------------------------------------   
  function y = stepImpl(obj, x)
    % step the FIR filter
    y = step(obj.pfilter,x);
  end
  %------------------------------------------------------------------------          
  function validateFrequencyRange(obj)
    % CutoffFrequency must be less than SampleRate/2
    % This method is invoked in validatePropertiesImpl of the base class
    coder.internal.errorIf(obj.CutoffFrequency > obj.SampleRate/2, ...
                          'dsp:system:VariableBandwidthFilter:CharacteristicTooLarge','CutoffFrequency');
  end
  %------------------------------------------------------------------------         
  function s = saveObjectImpl(obj)
    s = saveObjectImpl@dsp.private.VariableBandwidthFilterBase(obj);
    if isLocked(obj)
        s.pPrototypeWindow = obj.pPrototypeWindow;
        s.pNumTaps = obj.pNumTaps;
    end
  end
  %------------------------------------------------------------------------            
  function loadObjectImpl(obj, s, wasLocked)
    if wasLocked
        obj.pPrototypeWindow = s.pPrototypeWindow;
        obj.pNumTaps = s.pNumTaps;
    end
    loadObjectImpl@dsp.private.VariableBandwidthFilterBase(obj,s,wasLocked);
  end
  %------------------------------------------------------------------------             
  function flag = isInactivePropertyImpl(obj, prop)
    flag = false;
    switch prop
        case {'CutoffFrequency'}
            if ~strcmp(obj.FilterType,'Lowpass') && ...
                ~strcmp(obj.FilterType,'Highpass')
                flag = true;
            end
        case 'SidelobeAttenuation'
            if ~strcmp(obj.Window,'Chebyshev')
                flag = true;
            end
        case 'KaiserWindowParameter'
            if ~strcmp(obj.Window,'Kaiser')
                flag = true;
            end
        otherwise
            flag = isInactivePropertyImpl@dsp.private.VariableBandwidthFilterBase(obj,prop);
    end
  end
  %------------------------------------------------------------------------            
  function icon = getIconImpl(~)
    % MATLAB system block icon
    icon = sprintf('Variable Bandwidth\nFIR Filter');
  end
end
%--------------------------------------------------------------------------
% Static, hidden methods
%--------------------------------------------------------------------------
methods (Static, Hidden)
  function d = getdfiltobj(sysObjToAnalyze,arith)
    % Equivalent DFILT object for filter analysis methods
    d = sysObjToAnalyze.pfilter.convertToDFILT(arith);
  end
  %------------------------------------------------------------------------
  function w = designWindow(winType,L,datatype)
    % Design Hamming and Hann windows
    if strcmp(winType,'Hann')
        w = cast(hann(L),datatype).';
    else % hamming
        w = cast(hamming(L),datatype).';
    end
  end
  %------------------------------------------------------------------------
  function w = designParametrizedWindow(winType,winParam,L,datatype)
    % Design Kaiser and Chebyshev 
    if strcmp(winType,'Kaiser')
        w = cast(kaiser(L,winParam),datatype).';
    else % Chebyshev
        w = cast(chebwin(L,winParam),datatype).';
    end
  end
end
%--------------------------------------------------------------------------
% Static, Protected methods
%--------------------------------------------------------------------------   
methods(Static, Access=protected)
  function group = getPropertyGroupsImpl
    % Modify order of display
    group =  matlab.system.display.Section(...
    'Title', 'Parameters', ...
    'PropertyList', {'SampleRate', 'FilterOrder','FilterType','CutoffFrequency',...
    'CenterFrequency','Bandwidth','Window','KaiserWindowParameter','SidelobeAttenuation'}); %#ok
  end
  %------------------------------------------------------------------------
  function header = getHeaderImpl
    % MATLAB System block header
    header = matlab.system.display.Header('dsp.VariableBandwidthFIRFilter', ...
         'ShowSourceLink', true, 'Title', 'Variable Bandwidth FIR Filter');
  end
end   
end
