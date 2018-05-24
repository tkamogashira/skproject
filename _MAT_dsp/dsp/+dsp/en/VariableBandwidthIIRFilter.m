classdef VariableBandwidthIIRFilter< handle
%VariableBandwidthIIRFilter Variable bandwidth IIR filter
%   HIIR = dsp.VariableBandwidthIIRFilter returns a System object, HIIR, 
%   which independently filters each channel of the input over time using
%   specified IIR filter specifications. The IIR filter's passband 
%   frequency may be tuned during the filtering operation. The IIR filter 
%   is designed using the elliptical method. The IIR filter is tuned using 
%   IIR spectral transformations based on allpass filters [1]. 
%
%   H = dsp.VariableBandwidthIIRFilter('Name', Value, ...) returns a 
%   Variable Bandwidth IIR Filter System object, H, with each specified 
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
%   VariableBandwidthIIRFilter methods:
%
%   step          - See above description for use of this method
%   release       - Allow property value and input characteristics changes                      
%   clone         - Create Variable Bandwidth IIR Filter object with 
%                   same property values                      
%   isLocked      - Locked status (logical)
%   reset         - Reset the internal states to initial conditions
%
%   VariableBandwidthIIRFilter properties:
%
%   SampleRate                   - Input sample rate
%   FilterType                   - IIR filter type
%   FilterOrder                  - IIR filter order
%   PassbandFrequency            - Filter passband frequency
%   CenterFrequency              - Filter center frequency
%   Bandwidth                    - Filter bandwidth
%   PassbandRipple               - Filter passband ripple
%   StopbandAttenuation          - Filter stopband attenuation
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.VariableBandwidthIIRFilter.helpFilterAnalysis
%
%   % Example: Filter a signal through a variable bandwidth bandpass IIR
%   % filter. Tune the center frequency and the bandwidth of the IIR filter. 
%   Fs = 44100; % Input sample rate
%   % Define a bandpass variable bandwidth IIR filter:
%   hiir = dsp.VariableBandwidthIIRFilter('FilterType','Bandpass',...
%                                         'FilterOrder',8,...
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
%      y = step(hiir,x);
%      % Transfer function estimation
%      h = step(htfe,x,y);
%      % plot transfer function
%      step(hplot,20*log10(abs(h)))   
%      % Tune bandwidth and center frequency of the IIR filter
%      if (i==250)
%        hiir.CenterFrequency = 5000;
%        hiir.Bandwidth = 2000;
%      end
%   end
%
%   References:
%
%   [1] A. G. Constantinides, "Spectral transformations for digital 
%       filters",  Proc. Inst. Elect. Eng.,  vol. 117,  no. 8,  pp.1585 -
%       1590, 1970. 
%
%   See also dsp.VariableBandwidthFIRFilter, dsp.FIRFilter, dsp.IIRFilter, 
%            dsp.BiquadFilter, dsp.AllpoleFilter

 
%   Copyright 2013 The MathWorks, Inc.

    methods
        function out=VariableBandwidthIIRFilter
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

        function newpoly(in) %#ok<MANU>
            % Compute new polynomial after substitution
            % For each coefficient, we will have a resulting polynomial after we
            % substitute, form each polynomial and then add them all up to compute
            % the new numerator or denominator.
        end

        function polyallpasssub(in) %#ok<MANU>
            %POLYALLPASSSUB   Substitute delays in polynomials with allpass filters. 
            % Remove possible trailing zeros and get polynomial lengths
        end

        function polypow(in) %#ok<MANU>
            %POLYPOW   Evaluate polynomial to power of N. 
            % Initialize recursion
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Invoke setupImpl method of base class
        end

        function stepImpl(in) %#ok<MANU>
            % step the IIR filter
        end

        function tuneCoefficients(in) %#ok<MANU>
        end

        function validateFrequencyRange(in) %#ok<MANU>
            % PassbandFrequency must be less than SampleRate/2
            % This method is invoked in validatePropertiesImpl of the base class
        end

    end
    methods (Abstract)
    end
    properties
        % FilterOrder IIR filter order
        %   Specify the order of the IIR filter as a positive integer scalar. The 
        %   default is 8.
        FilterOrder;

        % PassbandFrequency Filter passband frequency
        %   Specify the filter passband frequency in Hz as a real, positive
        %   scalar smaller than SampleRate/2. This property applies when you set 
        %   the FilterType property to 'Lowpass' or 'Highpass'. The default is 
        %   512 Hz. This property is tunable.
        PassbandFrequency;

        % PassbandRipple Filter passband ripple
        %   Specify the filter passband ripple as a real, positive scalar in 
        %   decibels (dB). The default is 1 dB.
        PassbandRipple;

        % StopbandAttenuation Filter Stopband attenuation
        %   Specify the filter stopband attenuation as a real, positive scalar in 
        %   decibels (dB). The default is 60 dB.
        StopbandAttenuation;

    end
end
