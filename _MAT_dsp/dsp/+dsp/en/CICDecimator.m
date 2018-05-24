classdef CICDecimator< handle
%CICDecimator Decimate signal using Cascaded Integrator-Comb filter
%   HCICDEC = dsp.CICDecimator returns a System object, HCICDEC, that
%   applies a Cascaded Integrator-Comb (CIC) Decimation filter to the input
%   signal. Inputs and outputs to the object are signed fixed-point data
%   types. A Fixed-Point Designer license is required to use this System
%   object.
%
%   HCICDEC = dsp.CICDecimator('PropertyName', PropertyValue, ...) returns
%   a CIC decimation object, HCICDEC, with each specified property set to
%   the specified value.
%
%   HCICDEC = dsp.CICDecimator(R, M, N, 'PropertyName', PropertyValue, ...)
%   returns a CIC decimation object, HCICDEC, with the DecimationFactor
%   property set to R, the DifferentialDelay property set to M, the
%   NumSections property set to N, and other specified properties set to
%   the specified values.
%
%   Step method syntax:
%
%   Y = step(HCICDEC, X) decimates fixed-point input X to produce a
%   fixed-point output Y using the CIC decimator object HCICDEC.
%
%   CICDecimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create CIC decimation object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the internal states to initial conditions
%
%   CICDecimator properties:
%
%   DecimationFactor       - Decimation factor of filter
%   DifferentialDelay      - Differential delay of filter comb sections
%   NumSections            - Number of integrator and comb sections
%   FixedPointDataType     - Fixed-point property designations
%   SectionWordLengths     - Word lengths for each filter section
%   SectionFractionLengths - Fraction lengths for each filter section
%   OutputWordLength       - Word length for filter output
%   OutputFractionLength   - Fraction length for filter output
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.CICDecimator.helpFilterAnalysis.
%
%   % EXAMPLE: Decimate signal by a factor of 4 (downsample from 44.1 kHz 
%   % to 11.025 kHz) by specifying the 'Minimum section word lengths' 
%   % FixedPointDataType mode.
%       hcicdec = dsp.CICDecimator(4);  
%       % Specify DecimationFactor = 4, use default NumSections = 2, 
%       % DifferentialDelay = 1
%       hcicdec.FixedPointDataType = 'Minimum section word lengths'; 
%       hcicdec.OutputWordLength = 16;  % Specify the output word length
%       % Create fixed-point sinusoidal input signal 
%       Fs = 44.1e3;              % Original sampling frequency: 44.1 kHz
%       n = (0:1023)';            % 1024 samples, 0.0232 second long signal
%       x = fi(sin(2*pi*1e3/Fs*n),true,16,15);     
%       hsr = dsp.SignalSource(x, 64); % Create SignalSource System object
%       % Process the input signal
%       y = zeros(16,16);
%       for ii=1:16
%         % Decimated output with 16 samples per frame
%         y(ii,:) = step(hcicdec, step( hsr ));   
%       end
%       % Plot the first frame of the original and decimated signals. The output
%       % latency is 2 samples.  
%       gainCIC = ...
%       (hcicdec.DecimationFactor*hcicdec.DifferentialDelay)^hcicdec.NumSections;
%       stem(n(1:56)/Fs, double(x(4:59))); hold on;     
%       stem(n(1:14)/(Fs/hcicdec.DecimationFactor), double(y(1,3:end))/gainCIC,'r','filled'); 
%       xlabel('Time (sec)');ylabel('Signal Amplitude');
%       legend('Original signal', 'Decimated signal', 'location', 'north');
%       hold off;    
%
%   See also dsp.CICInterpolator, dsp.FIRDecimator.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=CICDecimator
            %CICDecimator Decimate signal using Cascaded Integrator-Comb filter
            %   HCICDEC = dsp.CICDecimator returns a System object, HCICDEC, that
            %   applies a Cascaded Integrator-Comb (CIC) Decimation filter to the input
            %   signal. Inputs and outputs to the object are signed fixed-point data
            %   types. A Fixed-Point Designer license is required to use this System
            %   object.
            %
            %   HCICDEC = dsp.CICDecimator('PropertyName', PropertyValue, ...) returns
            %   a CIC decimation object, HCICDEC, with each specified property set to
            %   the specified value.
            %
            %   HCICDEC = dsp.CICDecimator(R, M, N, 'PropertyName', PropertyValue, ...)
            %   returns a CIC decimation object, HCICDEC, with the DecimationFactor
            %   property set to R, the DifferentialDelay property set to M, the
            %   NumSections property set to N, and other specified properties set to
            %   the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HCICDEC, X) decimates fixed-point input X to produce a
            %   fixed-point output Y using the CIC decimator object HCICDEC.
            %
            %   CICDecimator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create CIC decimation object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the internal states to initial conditions
            %
            %   CICDecimator properties:
            %
            %   DecimationFactor       - Decimation factor of filter
            %   DifferentialDelay      - Differential delay of filter comb sections
            %   NumSections            - Number of integrator and comb sections
            %   FixedPointDataType     - Fixed-point property designations
            %   SectionWordLengths     - Word lengths for each filter section
            %   SectionFractionLengths - Fraction lengths for each filter section
            %   OutputWordLength       - Word length for filter output
            %   OutputFractionLength   - Fraction length for filter output
            %
            %   This System object supports several filter analysis methods. For more
            %   information, type dsp.CICDecimator.helpFilterAnalysis.
            %
            %   % EXAMPLE: Decimate signal by a factor of 4 (downsample from 44.1 kHz 
            %   % to 11.025 kHz) by specifying the 'Minimum section word lengths' 
            %   % FixedPointDataType mode.
            %       hcicdec = dsp.CICDecimator(4);  
            %       % Specify DecimationFactor = 4, use default NumSections = 2, 
            %       % DifferentialDelay = 1
            %       hcicdec.FixedPointDataType = 'Minimum section word lengths'; 
            %       hcicdec.OutputWordLength = 16;  % Specify the output word length
            %       % Create fixed-point sinusoidal input signal 
            %       Fs = 44.1e3;              % Original sampling frequency: 44.1 kHz
            %       n = (0:1023)';            % 1024 samples, 0.0232 second long signal
            %       x = fi(sin(2*pi*1e3/Fs*n),true,16,15);     
            %       hsr = dsp.SignalSource(x, 64); % Create SignalSource System object
            %       % Process the input signal
            %       y = zeros(16,16);
            %       for ii=1:16
            %         % Decimated output with 16 samples per frame
            %         y(ii,:) = step(hcicdec, step( hsr ));   
            %       end
            %       % Plot the first frame of the original and decimated signals. The output
            %       % latency is 2 samples.  
            %       gainCIC = ...
            %       (hcicdec.DecimationFactor*hcicdec.DifferentialDelay)^hcicdec.NumSections;
            %       stem(n(1:56)/Fs, double(x(4:59))); hold on;     
            %       stem(n(1:14)/(Fs/hcicdec.DecimationFactor), double(y(1,3:end))/gainCIC,'r','filled'); 
            %       xlabel('Time (sec)');ylabel('Signal Amplitude');
            %       legend('Original signal', 'Decimated signal', 'location', 'north');
            %       hold off;    
            %
            %   See also dsp.CICInterpolator, dsp.FIRDecimator.
        end

        function convertToDFILT(in) %#ok<MANU>
        end

        function gain(in) %#ok<MANU>
            %GAIN   Gain of the CIC decimation filter System object
            %   G  = gain(Hd) returns the gain, G, of the first stage up to and
            %   including the last stage of the CIC decimation filter System
            %   object, Hd.      
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
        %DecimationFactor Decimation factor of filter
        %   Specify a positive integer amount by which the input signal will be
        %   decimated. The default value of this property is 2.
        DecimationFactor;

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

        %NumSections Number of integrator and comb sections
        %   Specify the number of integrator and comb sections in the filter as
        %   a positive integer value. The default value of this property is 2.
        NumSections;

        % OutputFractionLength  Fraction length for filter output
        %   Specify the fixed-point fraction length to use for the filter
        %   output. This property is applicable when the FixedPointDataType
        %   property is set to 'Specify word and fraction lengths'. The default
        %   value of this property is 0.
        OutputFractionLength;

        % OutputWordLength  Word length for filter output
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
