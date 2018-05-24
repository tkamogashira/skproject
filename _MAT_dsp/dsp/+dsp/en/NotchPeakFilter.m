classdef NotchPeakFilter< handle
%NotchPeakFilter Second-order tunable notching and peaking IIR filter.
%   H = dsp.NotchPeakFilter returns a second-order notching and peaking
%   IIR filter which independently filters each channel of the input
%   over time using a specified center frequency and 3 dB bandwidth.
%   Both of these properties are specified in Hz and are tunable. Both
%   of these values must be scalars between 0 and half the sample rate.
%
%   H = dsp.NotchPeakFilter('Name', Value, ...) returns a notch filter
%   with each specified property name set to the specified value. You
%   can specify additional name-value pair arguments in any order as
%   (Name1,Value1,...,NameN,ValueN).
%
%   H = dsp.NotchPeakFilter('Specification', 'Quality factor and center
%   frequency') specifies the quality factor (Q factor) of the
%   notch/peak filter instead of the 3 dB bandwidth. The Q factor is
%   defined as the center frequency/bandwidth. A higher Q factor
%   corresponds to a narrower notch/peak. The Q factor should be a
%   scalar value greater than 0. The Q factor is tunable.
%
%   H = dsp.NotchPeakFilter('Specification', 'Coefficients') specifies
%   the coefficient values that affect bandwidth and center frequency
%   directly rather than specifying the design parameters in Hz. This
%   removes the trigonometry calculations involved when the properties
%   are tuned. The CenterFrequencyCoefficient should be a scalar
%   between -1 and 1, with -1 corresponding to 0 Hz and 1 corresponding
%   to the Nyquist frequency. The BandwidthCoefficient should be a
%   scalar betwen -1 and 1, with -1 corresponding to the largest 3 dB
%   bandwidth and 1 corresponding to the smallest 3 dB bandwidth. Both
%   coefficient values are tunable.
%
%   Step method syntax:
%
%   [Yn,Yp] = step(H, X) filters the real or complex input signal X
%   using the specified filter to produce the notch filter output, Yn,
%   and the peak filter output Yp. The filter processes each channel of
%   the input signal (each column of X) independently over time. The
%   peak filter output is optional and is computed efficiently using
%   most of the same computation used to compute the notch filter.
%
%   NotchPeakFilter methods:
%
%   step               - See above description for use of this method
%   release            - Allow property value and input characteristics
%                        changes
%   clone              - Create NotchPeakFilter object with same
%                        property values
%   isLocked           - Locked status (logical)
%   reset              - Reset the internal states to initial 
%                        conditions
%   getBandwidth       - Convert quality factor or bandwidth
%                        coefficient to bandwidth in Hertz
%   getOctaveBandwidth - Bandwidth measured in number of octaves
%   getCenterFrequency - Convert center freq. coefficient to Hertz
%   getQualityFactor   - Convert bandwidth to quality factor 
%   tf                 - Transfer function for notch/peak filter
%
%   NotchPeakFilter properties:
%
%   Specification              - Design parameters or Coefficients
%   Bandwidth                  - 3 dB bandwidth in Hz
%   CenterFrequency            - Center frequency of the notch filter
%                                in Hz
%   QualityFactor              - Quality (Q) factor
%   SampleRate                 - Sample rate of input in Hz
%   BandwidthCoefficient       - Bandwidth coefficient value (0 to 1)
%   CenterFrequencyCoefficient - Center frequency coefficient (-1 to 1)
%
%   % EXAMPLE: Notch/Peak filter with center frequency of 5000 Hz and 3 
%   % dB bandwidth of 500 Hz.
%   h = dsp.NotchPeakFilter('CenterFrequency',5000,'Bandwidth',500);
%   hscope =  dsp.SpectrumAnalyzer('SampleRate',44100,...
%       'PlotAsTwoSidedSpectrum',false,'SpectralAverages',50);
%   for i=1:5000
%       y = step(h,randn(1024,1));
%       step(hscope,y);
%       if (i==2500)
%           % Tune center frequency to 10000
%           h.CenterFrequency = 10000;
%       end
%   end
%   release(h)
%   release(hscope)
%
%   See also dsp.BiquadFilter, iirnotch, iirpeak.

     
    % Copyright 2013 The MathWorks, Inc.

    methods
        function out=NotchPeakFilter
            %NotchPeakFilter Construct the NotchPeakFilter class.
        end

        function getBandwidth(in) %#ok<MANU>
            %BW = getBandwidth(obj) get 3 dB bandwidth
            %   BW = getBandwidth(obj) returns the 3 dB bandwidth for the
            %   notch/peak filter. If the Specification is set to 'Quality
            %   factor and center frequency', the 3 dB bandwidth is
            %   determined from the quality factor value. If the 
            %   Specification property is set to 'Coefficients', the 3 dB
            %   bandwidth is determined from the BandwidthCoefficient value
            %   and the sample rate.
        end

        function getCenterFrequency(in) %#ok<MANU>
            %CF = getCenterFrequency(obj) get center frequency
            %   CF = getCenterFrequency(obj) returns the center frequency
            %   for the notch/peak filter. If the Specification property is
            %   set to 'Coefficients', the center frequency is determined
            %   from the CenterFrequencyCoefficient value and the sample
            %   rate.
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify number of System outputs
        end

        function getOctaveBandwidth(in) %#ok<MANU>
            %N = getOctaveBandwidth(obj) bandwidth in number of octaves
            %   N = getOctaveBandwidth(obj) returns the bandwidth of the
            %   notch/peak filter measured in number of octaves rather than
            %   Hz.
        end

        function getQualityFactor(in) %#ok<MANU>
            %Q = getQualityFactor(obj) get quality (Q) factor
            %   Q = getQualityFactor(obj) returns the quality factor (Q
            %   factor) for both the notch and peak filter. The Q factor is
            %   defined as the center frequency divided by the bandwitdh.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Re-load state if saved version was locked
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
            % Specify initial values for DiscreteState properties
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Default implementaion saves all public properties
        end

        function setupImpl(in) %#ok<MANU>
            % Implement any tasks that need to be performed only once, such
            % as computation of constants or creation of child System objects
        end

        function stepImpl(in) %#ok<MANU>
            % Implement System algorithm. Calculate y as a function of
            % input u and state.
        end

        function tf(in) %#ok<MANU>
            %[B,A,B2,A2] = tf(obj) Transfer function
            %   [B,A] = TF(obj) returns the vector of numerator
            %   coefficients B and the vector of denominator coefficients A
            %   for the equivalent transfer function corresponding to the
            %   notch filter.
            %
            %   [B,A,B2,A2] = TF(obj) returns the vector of numerator
            %   coefficients B2 and the vector of denominator coefficients
            %   A2 for the equivalent transfer function corresponding to
            %   the peak filter.
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Bandwidth 3 dB bandwidth
        %   Specify the filter's 3 dB bandwith as a finite positive numeric
        %   scalar in Hertz. The default is 2205 Hz. This property is
        %   tunable.
        Bandwidth;

        %BandwidthCoefficient Bandwidth Coefficient
        %   Specify the value that determines the filter's 3 dB bandwith as
        %   a finite numeric scalar between 0 and 1. 0 corresponds to the
        %   maximum 3 dB bandwidth (SampleRate/4). 1 corresponds to the
        %   minimum 3 dB bandwidth (0 Hz; i.e. an allpass filter). The
        %   default is 0.72654. This property is tunable.
        BandwidthCoefficient;

        %CenterFrequency Notch/Peak center frequency
        %   Specify the filter's center frequency (for both the notch and
        %   the peak) as a finite positive numeric scalar in Hertz. The
        %   default is 11025 Hz. This property is tunable.
        CenterFrequency;

        %CenterFrequencyCoefficient Center Frequency Coefficient
        %   Specify the value that determines the filter's center frequency
        %   as a finite numeric scalar between -1 and 1. -1 corresponds to
        %   the minimum center frequency (0 Hz). 1 corresponds to the
        %   maximum center frequency (SampleRate/2 Hz). The default is 0
        %   which corresponds to SampleRate/4 Hz. This property is tunable.
        CenterFrequencyCoefficient;

        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;

        %QualityFactor Quality factor for notch/peak filter
        %   Specify the quality factor (Q factor) for both the notch and
        %   peak filter. The Q factor is defined as the center frequency
        %   divided by the bandwitdh. The default value is 5. This
        %   property is tunable.
        QualityFactor;

        %SampleRate Sample rate of input
        %   Specify the sample rate of the input in Hertz as a finite
        %   numeric scalar. The default is 44100 Hz.
        SampleRate;

        %Specification Filter specification
        %   Set the specification as one of 'Bandwidth and center
        %   frequency' | 'Quality factor and center frequency' | 
        %   'Coefficients'. The default is 'Bandwidth and center
        %   frequency'.
        Specification;

        % Define any discrete-time states
        States;

    end
end
