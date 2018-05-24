classdef ParametricEQFilter< handle
%ParametricEQFilter Second-order parametric equalizer filter.
%   H = dsp.ParametricEQFilter returns a second-order parametric
%   equalizer filter which independently filters each channel of the
%   input over time using a specified center frequency, bandwidth, and
%   peak (dip) gain. The center frequency and bandwidth are specified
%   in Hz and are tunable. The peak gain (dip) is specified in dB and
%   is also tunable. The bandwidth is measured at the arithmetic mean
%   between the peak gain in absolute power units and one.
%
%   H = dsp.ParametricEQFilter('Name', Value, ...) returns a
%   parametric EQ filter with each specified property name set to the
%   specified value. You can specify additional name-value pair
%   arguments in any order as (Name1,Value1,...,NameN,ValueN).
%
%   H = dsp.ParametricEQFilter('Specification', 'Quality factor and
%   center frequency') specifies the quality factor (Q factor) of the
%   filter instead of the bandwidth. The Q factor is defined as the
%   center frequency/bandwidth. A higher Q factor corresponds to a
%   narrower peak/dip. The Q factor should be a scalar value greater
%   than 0. The Q factor is tunable.
%
%   H = dsp.ParametricEQFilter('Specification', 'Coefficients')
%   allows specifying the gain values for the bandwidth and center
%   frequency directly rather than specifying the design parameter in
%   Hz. This removes the trigonometry calculations involved when the
%   properties are tuned. The CenterFrequencyCoefficient should be a
%   scalar between -1 and 1, with -1 corresponding to 0 Hz and 1
%   corresponding to the Nyquist frequency. The BandwidthCoefficient
%   should be a scalar betwen -1 and 1, with -1 corresponding to the
%   largest bandwidth and 1 corresponding to the smallest bandwidth. In
%   this mode, the peak gain is specified in linear units rather than
%   dB.
%
%   Step method syntax:
%
%   Y = step(H, X) filters the real or complex input signal X using the
%   specified filter to produce the equalized filter output Y. The
%   filter processes each channel of the input signal (each column of
%   X) independently over time.
%
%   ParametricEQFilter methods:
%
%   step               - See above description for use of this method
%   release            - Allow property value and input characteristics
%                        changes
%   clone              - Create ParametricEQFilter object with same
%                        property values
%   isLocked           - Locked status (logical)
%   reset              - Reset the internal states to initial
%                        conditions
%   getBandwidth       - Convert quality factor or bandwidth
%                        coefficient to bandwidth in Hertz
%   getOctaveBandwidth - Bandwidth measured in number of octaves
%   getCenterFrequency - Convert center freq. coefficient to Hertz
%   getQualityFactor   - Convert bandwidth to quality factor
%   getPeakGain        - Convert peak gain/dip from dB to absolute
%                        units
%   getPeakGaindB      - Convert peak gain/dip from absolute units to
%                        dB
%   tf                 - Transfer function of parametric EQ filter
%
%   ParametricEQFilter properties:
%
%   Specification              - Design parameters or Coefficients
%   Bandwidth                  - filter bandwidth
%   CenterFrequency            - Center frequency of the filter
%   QualityFactor              - Quality (Q) factor
%   SampleRate                 - Sample rate of input in Hz
%   BandwidthCoefficient       - Bandwidth gain (0 to 1)
%   CenterFrequencyCoefficient - Center frequency gain (-1 to 1)
%   PeakGaindB                 - Peak (or dip) gain in dB
%   PeakGain                   - Peak (or dip) gain in linear units
%
%   % EXAMPLE: Parametric EQ filter with center frequency of 5000,
%   % bandwidth of 500, and peak gain of 6 dB
%   h = dsp.ParametricEQFilter('CenterFrequency',5000,...
%       'Bandwidth',500);
%   htf = dsp.TransferFunctionEstimator(...
%       'FrequencyRange','onesided','SpectralAverages',50);
%   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-15 15],...
%       'SampleIncrement',44100/1024);
%   tic,
%   while toc < 20 % Run for 20 seconds
%       x = randn(1024,1);
%       y = step(h,x);
%       H = step(htf,x,y);
%       magdB = 20*log10(abs(H));
%       step(hplot,magdB);
%       if toc > 10 % After 10 seconds
%           % Tune center frequency to 10000
%           h.CenterFrequency = 10000;
%           % Tune bandwidth to 2000;
%           h.Bandwidth = 2000;
%           % Tune peak to -10 dB
%           h.PeakGaindB = -10;
%       end
%   end
%   release(h); release(htf); release(hplot)
%
%   See also dsp.BiquadFilter, dsp.NotchPeakFilter.

     
    % Copyright 2013 The MathWorks, Inc.

    methods
        function out=ParametricEQFilter
            %ParametricEQFilter Second-order parametric equalizer filter.
            %   H = dsp.ParametricEQFilter returns a second-order parametric
            %   equalizer filter which independently filters each channel of the
            %   input over time using a specified center frequency, bandwidth, and
            %   peak (dip) gain. The center frequency and bandwidth are specified
            %   in Hz and are tunable. The peak gain (dip) is specified in dB and
            %   is also tunable. The bandwidth is measured at the arithmetic mean
            %   between the peak gain in absolute power units and one.
            %
            %   H = dsp.ParametricEQFilter('Name', Value, ...) returns a
            %   parametric EQ filter with each specified property name set to the
            %   specified value. You can specify additional name-value pair
            %   arguments in any order as (Name1,Value1,...,NameN,ValueN).
            %
            %   H = dsp.ParametricEQFilter('Specification', 'Quality factor and
            %   center frequency') specifies the quality factor (Q factor) of the
            %   filter instead of the bandwidth. The Q factor is defined as the
            %   center frequency/bandwidth. A higher Q factor corresponds to a
            %   narrower peak/dip. The Q factor should be a scalar value greater
            %   than 0. The Q factor is tunable.
            %
            %   H = dsp.ParametricEQFilter('Specification', 'Coefficients')
            %   allows specifying the gain values for the bandwidth and center
            %   frequency directly rather than specifying the design parameter in
            %   Hz. This removes the trigonometry calculations involved when the
            %   properties are tuned. The CenterFrequencyCoefficient should be a
            %   scalar between -1 and 1, with -1 corresponding to 0 Hz and 1
            %   corresponding to the Nyquist frequency. The BandwidthCoefficient
            %   should be a scalar betwen -1 and 1, with -1 corresponding to the
            %   largest bandwidth and 1 corresponding to the smallest bandwidth. In
            %   this mode, the peak gain is specified in linear units rather than
            %   dB.
            %
            %   Step method syntax:
            %
            %   Y = step(H, X) filters the real or complex input signal X using the
            %   specified filter to produce the equalized filter output Y. The
            %   filter processes each channel of the input signal (each column of
            %   X) independently over time.
            %
            %   ParametricEQFilter methods:
            %
            %   step               - See above description for use of this method
            %   release            - Allow property value and input characteristics
            %                        changes
            %   clone              - Create ParametricEQFilter object with same
            %                        property values
            %   isLocked           - Locked status (logical)
            %   reset              - Reset the internal states to initial
            %                        conditions
            %   getBandwidth       - Convert quality factor or bandwidth
            %                        coefficient to bandwidth in Hertz
            %   getOctaveBandwidth - Bandwidth measured in number of octaves
            %   getCenterFrequency - Convert center freq. coefficient to Hertz
            %   getQualityFactor   - Convert bandwidth to quality factor
            %   getPeakGain        - Convert peak gain/dip from dB to absolute
            %                        units
            %   getPeakGaindB      - Convert peak gain/dip from absolute units to
            %                        dB
            %   tf                 - Transfer function of parametric EQ filter
            %
            %   ParametricEQFilter properties:
            %
            %   Specification              - Design parameters or Coefficients
            %   Bandwidth                  - filter bandwidth
            %   CenterFrequency            - Center frequency of the filter
            %   QualityFactor              - Quality (Q) factor
            %   SampleRate                 - Sample rate of input in Hz
            %   BandwidthCoefficient       - Bandwidth gain (0 to 1)
            %   CenterFrequencyCoefficient - Center frequency gain (-1 to 1)
            %   PeakGaindB                 - Peak (or dip) gain in dB
            %   PeakGain                   - Peak (or dip) gain in linear units
            %
            %   % EXAMPLE: Parametric EQ filter with center frequency of 5000,
            %   % bandwidth of 500, and peak gain of 6 dB
            %   h = dsp.ParametricEQFilter('CenterFrequency',5000,...
            %       'Bandwidth',500);
            %   htf = dsp.TransferFunctionEstimator(...
            %       'FrequencyRange','onesided','SpectralAverages',50);
            %   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-15 15],...
            %       'SampleIncrement',44100/1024);
            %   tic,
            %   while toc < 20 % Run for 20 seconds
            %       x = randn(1024,1);
            %       y = step(h,x);
            %       H = step(htf,x,y);
            %       magdB = 20*log10(abs(H));
            %       step(hplot,magdB);
            %       if toc > 10 % After 10 seconds
            %           % Tune center frequency to 10000
            %           h.CenterFrequency = 10000;
            %           % Tune bandwidth to 2000;
            %           h.Bandwidth = 2000;
            %           % Tune peak to -10 dB
            %           h.PeakGaindB = -10;
            %       end
            %   end
            %   release(h); release(htf); release(hplot)
            %
            %   See also dsp.BiquadFilter, dsp.NotchPeakFilter.
        end

        function getBandwidth(in) %#ok<MANU>
            %BW = getBandwidth(obj) get filter bandwidth
            %   BW = getBandwidth(obj) returns the bandwidth for the
            %   parametric EQ filter. The bandwidth is measured halfway
            %   between 1 and the peak gain/cut of the filter measured in
            %   absolute power units (magnitude squared of the filter). If
            %   the Specification is set to 'Quality factor and center
            %   frequency', the bandwidth is determined from the quality
            %   factor value. If the Specification property is set to
            %   'Coefficients', the bandwidth is determined from the
            %   BandwidthCoefficient value and the sample rate.
        end

        function getCenterFrequency(in) %#ok<MANU>
            %CF = getCenterFrequency(obj) get center frequency
            %   CF = getCenterFrequency(obj) returns the center frequency
            %   for the parametric EQ filter. If the Specification property
            %   is set to 'Coefficients', the center frequency is
            %   determined from the CenterFrequencyCoefficient value and
            %   the sample rate.
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
            %   parametric EQ filter measured in number of octaves rather
            %   than Hz.
        end

        function getPeakGain(in) %#ok<MANU>
            %G = getPeakGain(obj) get peak gain
            %   G = getPeakGain(obj) returns the peak gain/cut for the
            %   parametric EQ filter in absolute units.
        end

        function getPeakGaindB(in) %#ok<MANU>
            %GdB = getPeakGaindB(obj) get peak gain in dB
            %   G = getPeakGaindB(obj) returns the peak gain/cut for the
            %   parametric EQ filter in decibels.
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
            %Get default parameters group for this System object
        end

        function getQualityFactor(in) %#ok<MANU>
            %Q = getQualityFactor(obj) get quality (Q) factor
            %   Q = getQualityFactor(obj) returns the quality factor (Q
            %   factor) for the parametric EQ filter. The Q factor is
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
        end

        function stepImpl(in) %#ok<MANU>
        end

        function tf(in) %#ok<MANU>
            %[B,A] = tf(obj) Transfer function
            %   [B,A] = TF(obj) returns the vector of numerator
            %   coefficients B and the vector of denominator coefficients A
            %   for the equivalent transfer function corresponding to the
            %   parametric EQ filter.
        end

        function validateInputsImpl(in) %#ok<MANU>
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

        %PeakGain Peak (or dip) gain in linear units
        %   Specify the peak or dip of the filter in linear units. Values
        %   greater than one correspond to a boost while values less than
        %   one correspond to a dip or cut. The default is 2 (6.0206 dB).
        %   This property is tunable.
        PeakGain;

        %PeakGain Peak (or dip) gain in dB
        %   Specify the peak or dip of the filter in decibels. Values
        %   greater than zero correspond to a boost while values less than
        %   zero correspond to a dip or cut. The default is 6.02036dB. This
        %   property is tunable.
        PeakGaindB;

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

    end
end
