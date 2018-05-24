classdef CICInterpolator< handle
%CICInterpolator Interpolate signal using Cascaded Integrator-Comb filter 
%   HCICINT = dsp.CICInterpolator returns a System object, HCICINT, that
%   applies a Cascaded Integrator-Comb (CIC) Interpolation filter to the
%   input signal. Inputs and outputs to the object are signed fixed-point
%   data types. A Fixed-Point Designer license is required to use this
%   System object.
%
%   HCICINT = dsp.CICInterpolator('PropertyName', PropertyValue, ...)
%   returns a CIC interpolation object, HCICINT, with each specified
%   property set to the specified value.
%
%   HCICINT = dsp.CICInterpolator(R, M, N, 'PropertyName', PropertyValue,
%   ...) returns a CIC interpolation object, HCICINT, with the
%   InterpolationFactor property set to R, the DifferentialDelay property
%   set to M, the NumSections property set to N, and other specified
%   properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HCICINT, X) interpolates fixed-point input X to produce a
%   fixed-point output Y using the CIC interpolator object HCICINT.
%
%   CICInterpolator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create CIC interpolation object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   CICInterpolator properties:
%
%   InterpolationFactor    - Interpolation factor of filter
%   DifferentialDelay      - Differential delay of filter comb sections
%   NumSections            - Number of integrator and comb sections
%   FixedPointDataType     - Fixed-point property designations
%   SectionWordLengths     - Word lengths for each filter section
%   SectionFractionLengths - Fraction lengths for each filter section
%   OutputWordLength       - Word length for filter output
%   OutputFractionLength   - Fraction length for filter output
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.CICInterpolator.helpFilterAnalysis.
%
%   % EXAMPLE: Interpolate signal by a factor of 2 (upsample from 22.05 kHz 
%   % to 44.1 kHz) by specifying the 'Full precision' FixedPointDataType
%   % mode. 
%    hcicint = dsp.CICInterpolator(2);
%    % Uses default NumSections = 2, DifferentialDelay = 1
%    % Create fixed-point sinusoidal input signal 
%    Fs = 22.05e3;                 % Original sampling frequency: 22.05 kHz
%    n = (0:511)';                 % 512 samples, 0.0113 second long signal
%    x = fi(sin(2*pi*1e3/Fs*n),true,16,15);     
%    hsr = dsp.SignalSource(x, 32); % Create SignalSource System object
%    % Process the input signal
%    y = zeros(16,64);
%    for ii=1:16
%      % Interpolated output with 64 samples per frame
%      y(ii,:) = step(hcicint,step( hsr ));   
%    end
%    % Plot the first frame of the original and interpolated signals. The output
%    % latency is 2 samples.  
%    gainCIC = ...
%      (hcicint.InterpolationFactor*hcicint.DifferentialDelay)...
%      ^hcicint.NumSections/hcicint.InterpolationFactor;
%    stem(n(1:31)/Fs, double(x(1:31)),'r','filled'); hold on;     
%    stem(n(1:61)/(Fs*hcicint.InterpolationFactor), double(y(1,4:end))/gainCIC,'b'); 
%    xlabel('Time (sec)');ylabel('Signal Amplitude');
%    legend('Original signal', 'Interpolated signal', 'location', 'north');
%    hold off;    
%
%   See also dsp.CICDecimator, dsp.FIRInterpolator.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=CICInterpolator
            %CICInterpolator Interpolate signal using Cascaded Integrator-Comb filter 
            %   HCICINT = dsp.CICInterpolator returns a System object, HCICINT, that
            %   applies a Cascaded Integrator-Comb (CIC) Interpolation filter to the
            %   input signal. Inputs and outputs to the object are signed fixed-point
            %   data types. A Fixed-Point Designer license is required to use this
            %   System object.
            %
            %   HCICINT = dsp.CICInterpolator('PropertyName', PropertyValue, ...)
            %   returns a CIC interpolation object, HCICINT, with each specified
            %   property set to the specified value.
            %
            %   HCICINT = dsp.CICInterpolator(R, M, N, 'PropertyName', PropertyValue,
            %   ...) returns a CIC interpolation object, HCICINT, with the
            %   InterpolationFactor property set to R, the DifferentialDelay property
            %   set to M, the NumSections property set to N, and other specified
            %   properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HCICINT, X) interpolates fixed-point input X to produce a
            %   fixed-point output Y using the CIC interpolator object HCICINT.
            %
            %   CICInterpolator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create CIC interpolation object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   CICInterpolator properties:
            %
            %   InterpolationFactor    - Interpolation factor of filter
            %   DifferentialDelay      - Differential delay of filter comb sections
            %   NumSections            - Number of integrator and comb sections
            %   FixedPointDataType     - Fixed-point property designations
            %   SectionWordLengths     - Word lengths for each filter section
            %   SectionFractionLengths - Fraction lengths for each filter section
            %   OutputWordLength       - Word length for filter output
            %   OutputFractionLength   - Fraction length for filter output
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.CICInterpolator.helpFilterAnalysis.
            %
            %   % EXAMPLE: Interpolate signal by a factor of 2 (upsample from 22.05 kHz 
            %   % to 44.1 kHz) by specifying the 'Full precision' FixedPointDataType
            %   % mode. 
            %    hcicint = dsp.CICInterpolator(2);
            %    % Uses default NumSections = 2, DifferentialDelay = 1
            %    % Create fixed-point sinusoidal input signal 
            %    Fs = 22.05e3;                 % Original sampling frequency: 22.05 kHz
            %    n = (0:511)';                 % 512 samples, 0.0113 second long signal
            %    x = fi(sin(2*pi*1e3/Fs*n),true,16,15);     
            %    hsr = dsp.SignalSource(x, 32); % Create SignalSource System object
            %    % Process the input signal
            %    y = zeros(16,64);
            %    for ii=1:16
            %      % Interpolated output with 64 samples per frame
            %      y(ii,:) = step(hcicint,step( hsr ));   
            %    end
            %    % Plot the first frame of the original and interpolated signals. The output
            %    % latency is 2 samples.  
            %    gainCIC = ...
            %      (hcicint.InterpolationFactor*hcicint.DifferentialDelay)...
            %      ^hcicint.NumSections/hcicint.InterpolationFactor;
            %    stem(n(1:31)/Fs, double(x(1:31)),'r','filled'); hold on;     
            %    stem(n(1:61)/(Fs*hcicint.InterpolationFactor), double(y(1,4:end))/gainCIC,'b'); 
            %    xlabel('Time (sec)');ylabel('Signal Amplitude');
            %    legend('Original signal', 'Interpolated signal', 'location', 'north');
            %    hold off;    
            %
            %   See also dsp.CICDecimator, dsp.FIRInterpolator.
        end

        function convertToDFILT(in) %#ok<MANU>
        end

        function gain(in) %#ok<MANU>
            %GAIN   Gain of the CIC interpolation filter System object
            %   G = gain(Hm,J) is the gain of the Jth stage of a CIC
            %   interpolation filter. If empty or omitted, J is assumed to be
            %   2*N. In this scenario, G corresponds to the gain to the entire
            %   set of filter stages.      
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %DifferentialDelay Differential delay of filter comb sections
        %   Specify a positive integer delay value to be used in each of the
        %   comb sections of the filter. The default value of this property is
        %   1.
        DifferentialDelay;

        %FixedPointDataType Fixed-point property designations
        %   Specify the fixed-point data type as one of [{'Full precision'} |
        %   'Minimum section word lengths' | 'Specify word lengths' | 'Specify
        %   word and fraction lengths']. When this property is set to 'Full
        %   precision', the System object automatically determines the word and
        %   fraction lengths of the filter sections and output. When the
        %   property is set to 'Minimum section word length', the object
        %   automatically determines the word and fraction lengths of the
        %   filter sections and the fraction length of the output. When the
        %   property is set to 'Specify word lengths', the object automatically
        %   determines the fraction lengths of the filter sections and the
        %   output.
        FixedPointDataType;

        %InterpolationFactor Interpolation factor of filter
        %   Specify a positive integer amount by which the input signal will be
        %   interpolated. The default value of this property is 2.
        InterpolationFactor;

        %NumSections Number of integrator and comb sections
        %   Specify the number of integrator and comb sections in the filter as
        %   a positive integer value. The default value of this property is 2.
        NumSections;

        % OutputFractionLength Fraction length for filter output 
        %   Specify the fixed-point fraction length to use for the filter
        %   output. This property is applicable when the FixedPointDataType
        %   property is set to 'Specify word and fraction lengths'. The default
        %   value of this property is 0.
        OutputFractionLength;

        % OutputWordLength Word length for filter output 
        %   Specify the fixed-point word length to use for the filter output.
        %   This property is applicable when the FixedPointDataType property is
        %   set to one of ['Minimum section word lengths' | 'Specify word
        %   lengths' | 'Specify word and fraction lengths']. The default value
        %   of this property is 32.
        OutputWordLength;

        % SectionFractionLengths Fraction lengths for each filter section
        %   Specify the fixed-point fraction length to use for each filter
        %   section. There are (2*NumSections) filter sections to be specified.
        %   This property is applicable when the FixedPointDataType property is
        %   set to 'Specify word and fraction lengths'. The default value of
        %   this property is 0.
        SectionFractionLengths;

        % SectionWordLengths Word lengths for each filter section
        %   Specify the fixed-point word length to use for each filter section.
        %   There are (2*NumSections) filter sections to be specified. This
        %   property is applicable when the FixedPointDataType property is set
        %   to one of ['Specify word lengths' | 'Specify word and fraction
        %   lengths']. The default value of this property is [16 16 16 16].
        SectionWordLengths;

    end
end
