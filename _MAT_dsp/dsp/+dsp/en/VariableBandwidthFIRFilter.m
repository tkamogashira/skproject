classdef VariableBandwidthFIRFilter< handle
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

    methods
        function out=VariableBandwidthFIRFilter
            % Constructor
        end

        function getHeaderImpl(in) %#ok<MANU>
            % MATLAB System block header
        end

        function getIconImpl(in) %#ok<MANU>
            % MATLAB system block icon
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
            % Modify order of display
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Invoke setupImpl method of base class
        end

        function stepImpl(in) %#ok<MANU>
            % step the FIR filter
        end

        function tuneCoefficients(in) %#ok<MANU>
        end

        function updateBandpassCoefficients(in) %#ok<MANU>
            % Modulate the lowpass coefficients by 2 * cos(wc.n)
        end

        function updateBandstopCoefficients(in) %#ok<MANU>
            % Modulate the lowpass coefficients by 2 * cos(wc.n) and then flip
            % the frequency response
        end

        function updateHighpassCoefficients(in) %#ok<MANU>
            % Get highpass coefficients from lowpass coefficients (Hhp(w) = 1 -
            % Hlp(w))
        end

        function updateLowpassCoefficients(in) %#ok<MANU>
            % Tune filter coefficients to new cutoff frequency
            % Compute coefficients of truncated ideal lowpass impulse response
        end

        function validateFrequencyRange(in) %#ok<MANU>
            % CutoffFrequency must be less than SampleRate/2
            % This method is invoked in validatePropertiesImpl of the base class
        end

    end
    methods (Abstract)
    end
    properties
        % CutoffFrequency Filter Cutoff frequency
        %   Specify the filter cutoff frequency in Hz as a real, positive scalar 
        %   smaller than SampleRate/2. This property applies when you set the 
        %   FilterType property to 'Lowpass' or 'Highpass'. The default is 512 Hz. 
        %   This property is tunable.
        CutoffFrequency;

        % FilterOrder FIR filter order
        %   Specify the order of the FIR filter as a positive integer scalar. The 
        %   default is 30.
        FilterOrder;

        % KaiserWindowParameter Kaiser window parameter
        %   Specify the Kaiser window parameter as a real scalar. This property 
        %   applies when you set the  Window property to 'Kaiser'. The default is 
        %   0.5;
        KaiserWindowParameter;

        % SidelobeAttenuation  Chebyshev window sidelobe attenuation
        %   Specify the Chebyshev window sidelobe attenuation as a real, positive 
        %   scalar in decibels (dB). This property applies when you set the 
        %   Window property to 'Chebyshev'. The default is 60 dB.
        SidelobeAttenuation;

        % Window Window function
        %   Specify the window function used to design the FIR filter as one of 
        %   'Hann' | 'Hamming' | 'Chebyshev' | 'Kaiser'. The default is 'Hann'.
        Window;

    end
end
