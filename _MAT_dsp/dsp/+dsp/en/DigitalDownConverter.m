classdef DigitalDownConverter< handle
%dsp.DigitalDownConverter Digitally down convert input signal
%   H = dsp.DigitalDownConverter creates a digital down converter (DDC)
%   System object, H. The object frequency down converts the input signal
%   by multiplying it with a complex exponential with center frequency
%   equal to the value in the CenterFrequency property. The object down
%   samples the frequency down converted signal using a cascade of three
%   decimation filters. When you set the FilterSpecification property to
%   'Design parameters', the DDC object designs the decimation filters
%   according to the filter parameters that you set in the filter-related
%   object properties. In this case the filter cascade consists of a CIC
%   decimator, a CIC compensator and a third FIR decimation stage that can
%   be bypassed depending on how you set the properties of the DDC object.
%
%   H = dsp.DigitalDownConverter(Name,Value) creates a DDC object, H,
%   with the specified property Name set to the specified Value. You can
%   specify additional name-value pair arguments in any order as
%   (Name1,Value1,...,NameN,ValueN).
%
%   Step method syntax:
%
%   Y = step(H,X) takes a real or complex input column vector X and outputs
%   a frequency down converted and down sampled signal Y. The length of
%   input X must be a multiple of the decimation factor. X can be of data
%   type double, single, signed integer, or signed fixed point (fi
%   objects). The length of Y is equal to the length of X divided by the
%   DecimationFactor. When the data type of X is double or single
%   precision, the data type of Y is the same as that of X. When the data
%   type of X is of a fixed point type, the data type of Y is defined by
%   the OutputDataType property.
%
%   Y = step(H,X,Z) uses the complex input, Z, as the oscillator signal
%   used to frequency down convert input X, when you set the Oscillator
%   property to 'Input port'. The length of Z must be equal to the number
%   of rows of X. Z can be of data type double, single, signed integer, or
%   signed fixed point (fi objects).
%
%   dsp.DigitalDownConverter methods:
%
%   step                  - Digitally down convert input signal (see above)
%   release               - Allow property value and input characteristics
%                           changes
%   clone                 - Create DDC object with same property values
%   isLocked              - Locked status (logical)
%   getDecimationFactors  - Get decimation factors of each filter stage
%   getFilters            - Get handles to decimation filter objects
%   getFilterOrders       - Get orders of decimation filters
%   visualizeFilterStages - Visualize response of each filter stage
%   fvtool                - Visualize response of the filter cascade
%   groupDelay            - Compute the group delay of the filter cascade
%
%   dsp.DigitalDownConverter properties:
%
%   SampleRate                  - Sample rate of input signal
%   DecimationFactor            - Decimation factor
%   FilterSpecification         - Filter specification
%   MinimumOrderDesign          - Minimum order filter design
%   NumCICSections              - Number of sections of CIC decimator
%   SecondFilterCoefficients    - Coefficients of second filter stage
%   ThirdFilterCoefficients     - Coefficients of third filter stage
%   SecondFilterOrder           - Order of CIC compensation filter stage
%   ThirdFilterOrder            - Order of third filter stage
%   Bandwidth                   - Two sided bandwidth of input signal in 
%                                 Hertz
%   StopbandFrequencySource     - Source of stopband frequency
%   StopbandFrequency           - Stopband frequency in Hertz
%   PassbandRipple              - Passband ripple of cascade response in dB
%   StopbandAttenuation         - Stopband attenuation of cascade response 
%                                 in dB
%   Oscillator                  - Type of oscillator
%   CenterFrequency             - Center frequency of input signal in Hertz
%   NumAccumulatorBits          - Number of NCO accumulator bits
%   NumQuantizedAccumulatorBits - Number of NCO quantized accumulator bits
%   Dither                      - Dither control for NCO
%   NumDitherBits               - Number of NCO dither bits
%
%   The dsp.DigitalDownConverter object supports fixed-point operations.
%   For more information, type dsp.DigitalDownConverter.helpFixedPoint.
%
%   % Example:
%   %   Create a digital up converter object that up samples a 1 KHz
%   %   sinusoidal signal by a factor of 20 and up converts it to 50 KHz.
%   %   Create a digital down converter object that down converts the 
%   %   signal to 0 Hz and down samples it by a factor of 20.
%
%   % Create a sine wave generator to obtain the 1 KHz sinusoidal signal
%   % with a sample rate of 6 KHz.
%   Fs = 6e3; % Sample rate
%   hSig = dsp.SineWave('Frequency',1000,'SampleRate', Fs,...
%                       'SamplesPerFrame',1024);
%   x = step(hSig); % generate signal
%
%   % Create a DUC object. Use minimum order filter designs and set the
%   % passband ripple to 0.2 dB and the stopband attenuation to 55 dB. Set
%   % the double sided signal bandwidth to 2 KHz.
%   hDUC = dsp.DigitalUpConverter(...
%    'InterpolationFactor', 20,...
%    'SampleRate', Fs,...
%    'Bandwidth', 2e3,...
%    'StopbandAttenuation', 55,...
%    'PassbandRipple',0.2,...
%    'CenterFrequency',50e3);
%
%   % Create a DDC object. Use minimum order filter designs and set the
%   % passband ripple to 0.2 dB and the stopband attenuation to 55 dB.
%   hDDC = dsp.DigitalDownConverter(...
%     'DecimationFactor',20,...
%     'SampleRate', Fs*20,...
%     'Bandwidth', 3e3,...
%     'StopbandAttenuation', 55,...
%     'PassbandRipple',0.2,...
%     'CenterFrequency',50e3);
%
%   % Create a spectrum estimator to visualize the signal spectrum before 
%   % up converting, after up converting, and after down converting.
%   window = hamming(floor(length(x)/10));
%   figure; pwelch(x,window,[],[],Fs,'centered')
%   title('Spectrum of baseband signal x')
%
%   % Up convert the signal and visualize the spectrum
%   xUp = step(hDUC,x); % up convert
%   window = hamming(floor(length(xUp)/10));
%   figure; pwelch(xUp,window,[],[],20*Fs,'centered');
%   title('Spectrum of up converted signal xUp')
%
%   % Down convert the signal and visualize the spectrum
%   xDown = step(hDDC,xUp); % down convert
%   window = hamming(floor(length(xDown)/10));
%   figure; pwelch(xDown,window,[],[],Fs,'centered');
%   title('Spectrum of down converted signal xDown')
%
%   % Visualize the response of the decimation filters
%   visualizeFilterStages(hDDC)
%
%   See also dsp.DigitalUpConverter, dsp.SineWave, dsp.NCO,
%   dsp.CICDecimator, dsp.FIRDecimator.

 
%   Copyright 2010-2013 The MathWorks, Inc.

    methods
        function out=DigitalDownConverter
            %dsp.DigitalDownConverter Digitally down convert input signal
            %   H = dsp.DigitalDownConverter creates a digital down converter (DDC)
            %   System object, H. The object frequency down converts the input signal
            %   by multiplying it with a complex exponential with center frequency
            %   equal to the value in the CenterFrequency property. The object down
            %   samples the frequency down converted signal using a cascade of three
            %   decimation filters. When you set the FilterSpecification property to
            %   'Design parameters', the DDC object designs the decimation filters
            %   according to the filter parameters that you set in the filter-related
            %   object properties. In this case the filter cascade consists of a CIC
            %   decimator, a CIC compensator and a third FIR decimation stage that can
            %   be bypassed depending on how you set the properties of the DDC object.
            %
            %   H = dsp.DigitalDownConverter(Name,Value) creates a DDC object, H,
            %   with the specified property Name set to the specified Value. You can
            %   specify additional name-value pair arguments in any order as
            %   (Name1,Value1,...,NameN,ValueN).
            %
            %   Step method syntax:
            %
            %   Y = step(H,X) takes a real or complex input column vector X and outputs
            %   a frequency down converted and down sampled signal Y. The length of
            %   input X must be a multiple of the decimation factor. X can be of data
            %   type double, single, signed integer, or signed fixed point (fi
            %   objects). The length of Y is equal to the length of X divided by the
            %   DecimationFactor. When the data type of X is double or single
            %   precision, the data type of Y is the same as that of X. When the data
            %   type of X is of a fixed point type, the data type of Y is defined by
            %   the OutputDataType property.
            %
            %   Y = step(H,X,Z) uses the complex input, Z, as the oscillator signal
            %   used to frequency down convert input X, when you set the Oscillator
            %   property to 'Input port'. The length of Z must be equal to the number
            %   of rows of X. Z can be of data type double, single, signed integer, or
            %   signed fixed point (fi objects).
            %
            %   dsp.DigitalDownConverter methods:
            %
            %   step                  - Digitally down convert input signal (see above)
            %   release               - Allow property value and input characteristics
            %                           changes
            %   clone                 - Create DDC object with same property values
            %   isLocked              - Locked status (logical)
            %   getDecimationFactors  - Get decimation factors of each filter stage
            %   getFilters            - Get handles to decimation filter objects
            %   getFilterOrders       - Get orders of decimation filters
            %   visualizeFilterStages - Visualize response of each filter stage
            %   fvtool                - Visualize response of the filter cascade
            %   groupDelay            - Compute the group delay of the filter cascade
            %
            %   dsp.DigitalDownConverter properties:
            %
            %   SampleRate                  - Sample rate of input signal
            %   DecimationFactor            - Decimation factor
            %   FilterSpecification         - Filter specification
            %   MinimumOrderDesign          - Minimum order filter design
            %   NumCICSections              - Number of sections of CIC decimator
            %   SecondFilterCoefficients    - Coefficients of second filter stage
            %   ThirdFilterCoefficients     - Coefficients of third filter stage
            %   SecondFilterOrder           - Order of CIC compensation filter stage
            %   ThirdFilterOrder            - Order of third filter stage
            %   Bandwidth                   - Two sided bandwidth of input signal in 
            %                                 Hertz
            %   StopbandFrequencySource     - Source of stopband frequency
            %   StopbandFrequency           - Stopband frequency in Hertz
            %   PassbandRipple              - Passband ripple of cascade response in dB
            %   StopbandAttenuation         - Stopband attenuation of cascade response 
            %                                 in dB
            %   Oscillator                  - Type of oscillator
            %   CenterFrequency             - Center frequency of input signal in Hertz
            %   NumAccumulatorBits          - Number of NCO accumulator bits
            %   NumQuantizedAccumulatorBits - Number of NCO quantized accumulator bits
            %   Dither                      - Dither control for NCO
            %   NumDitherBits               - Number of NCO dither bits
            %
            %   The dsp.DigitalDownConverter object supports fixed-point operations.
            %   For more information, type dsp.DigitalDownConverter.helpFixedPoint.
            %
            %   % Example:
            %   %   Create a digital up converter object that up samples a 1 KHz
            %   %   sinusoidal signal by a factor of 20 and up converts it to 50 KHz.
            %   %   Create a digital down converter object that down converts the 
            %   %   signal to 0 Hz and down samples it by a factor of 20.
            %
            %   % Create a sine wave generator to obtain the 1 KHz sinusoidal signal
            %   % with a sample rate of 6 KHz.
            %   Fs = 6e3; % Sample rate
            %   hSig = dsp.SineWave('Frequency',1000,'SampleRate', Fs,...
            %                       'SamplesPerFrame',1024);
            %   x = step(hSig); % generate signal
            %
            %   % Create a DUC object. Use minimum order filter designs and set the
            %   % passband ripple to 0.2 dB and the stopband attenuation to 55 dB. Set
            %   % the double sided signal bandwidth to 2 KHz.
            %   hDUC = dsp.DigitalUpConverter(...
            %    'InterpolationFactor', 20,...
            %    'SampleRate', Fs,...
            %    'Bandwidth', 2e3,...
            %    'StopbandAttenuation', 55,...
            %    'PassbandRipple',0.2,...
            %    'CenterFrequency',50e3);
            %
            %   % Create a DDC object. Use minimum order filter designs and set the
            %   % passband ripple to 0.2 dB and the stopband attenuation to 55 dB.
            %   hDDC = dsp.DigitalDownConverter(...
            %     'DecimationFactor',20,...
            %     'SampleRate', Fs*20,...
            %     'Bandwidth', 3e3,...
            %     'StopbandAttenuation', 55,...
            %     'PassbandRipple',0.2,...
            %     'CenterFrequency',50e3);
            %
            %   % Create a spectrum estimator to visualize the signal spectrum before 
            %   % up converting, after up converting, and after down converting.
            %   window = hamming(floor(length(x)/10));
            %   figure; pwelch(x,window,[],[],Fs,'centered')
            %   title('Spectrum of baseband signal x')
            %
            %   % Up convert the signal and visualize the spectrum
            %   xUp = step(hDUC,x); % up convert
            %   window = hamming(floor(length(xUp)/10));
            %   figure; pwelch(xUp,window,[],[],20*Fs,'centered');
            %   title('Spectrum of up converted signal xUp')
            %
            %   % Down convert the signal and visualize the spectrum
            %   xDown = step(hDDC,xUp); % down convert
            %   window = hamming(floor(length(xDown)/10));
            %   figure; pwelch(xDown,window,[],[],Fs,'centered');
            %   title('Spectrum of down converted signal xDown')
            %
            %   % Visualize the response of the decimation filters
            %   visualizeFilterStages(hDDC)
            %
            %   See also dsp.DigitalUpConverter, dsp.SineWave, dsp.NCO,
            %   dsp.CICDecimator, dsp.FIRDecimator.
        end

        function checkFactorLength(in) %#ok<MANU>
            % Error out if decimation factor is not a 1x2 or 1x3 vector
        end

        function checkFactorValues(in) %#ok<MANU>
            % Check value of DecimationFactor vector
        end

        function checkFsFc(in) %#ok<MANU>
            % Check that sample rate at oscillator input is at least twice the
            % oscillator frequency
        end

        function designDesignerIfEmpty(in) %#ok<MANU>
            % If a System object is loaded from previous release that
            % doesn't contain a saved FilterDesigner then create one
        end

        function getCustomFiltersDataType(in) %#ok<MANU>
            % Return the custom filter input data type. This is called from
            % designFilters in base class
        end

        function getDecimationFactors(in) %#ok<MANU>
            %getDecimationFactors Get decimation factors of each filter stage
            %   M = getDecimationFactors(H) returns a vector, M, with the
            %   decimation factors of each filter stage. If the third filter stage
            %   is bypassed, then M is a 1x2 vector containing the decimation
            %   factor of the first and second filter stages in the first and
            %   second elements respectively. If the third filter stage is not
            %   bypassed then M is a 1x3 vector containing the decimation factor of
            %   the first, second, and third filter stages.
            %
            %   See also visualizeFilterStages, dsp.DigitalDownConverter.fvtool,
            %   groupDelay, getFilters, getFilterOrders.
        end

        function getFilterDesigner(in) %#ok<MANU>
            % Return the filter designer to be used. This is called from
            % the base class constructor
        end

        function getFilterOrders(in) %#ok<MANU>
            %getFilterOrders Get orders of decimation filters
            %   S = getFilterOrders(H) returns a structure, S, that contains the
            %   orders of the decimation filter stages. The ThirdFilterOrder
            %   structure field will be empty if the third filter stage has been
            %   bypassed.
            %
            %   See also visualizeFilterStages, dsp.DigitalDownConverter.fvtool,
            %   groupDelay, getFilters, getDecimationFactors.
        end

        function getFilters(in) %#ok<MANU>
            %getFilters Get handles to decimation filter objects
            %   S = getFilters(H) returns a structure, S, with copies of the filter
            %   System objects and the CIC normalization factor that form the
            %   decimation filter cascade. The ThirdFilterStage structure field
            %   will be empty if the third filter stage has been bypassed. The CIC
            %   normalization factor is equal to the inverse of the CIC filter
            %   gain. In some cases this gain will have a correction factor to
            %   ensure that the cascade response meets the ripple specifications.
            %
            %   getFilters(H,'Arithmetic',ARITH) specifies the arithmetic of the
            %   filter stages. You set input ARITH to 'double', 'single', or
            %   'fixed-point'. When object H is in an unlocked state you must
            %   specify the arithmetic. When object H is in a locked state the
            %   arithmetic input is ignored.
            %
            %   See also visualizeFilterStages, dsp.DigitalDownConverter.fvtool,
            %   groupDelay, getFilterOrders, getDecimationFactors.
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.DigitalDownConverter System object
            %               fixed-point information
            %   dsp.DigitalDownConverter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   dsp.DigitalDownConverter System object.
        end

        function isFilterCoefficientsDataTypeSameAsInput(in) %#ok<MANU>
            % Return true if any of the SecondFilterCoefficientsDataType or
            % ThirdFilterCoefficientsDataType properties are set to 'Same as
            % input'.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseDesignerIfLocked(in) %#ok<MANU>
            % Release the FilterDesigner to change its properties
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setCustomCoefficientsDataType(in) %#ok<MANU>
            % Set coefficient data types of filter designer to the custom data
            % types specified by the user
        end

        function setupImpl(in) %#ok<MANU>
            % Get size and data type of input
        end

        function stepImpl(in) %#ok<MANU>
            % Frequency down conversion
        end

    end
    methods (Abstract)
    end
    properties
        %CenterFrequency Center frequency of input signal in Hertz
        %   Specify this property as a double precision scalar. The object
        %   down converts the input signal from the passband center
        %   frequency you specify in the CenterFrequency property, to 0
        %   Hertz. This property applies when you set the Oscillator
        %   property to 'Sine wave' or 'NCO'. The default is 14e6 Hertz.
        CenterFrequency;

        %CustomFiltersInputDataType Fixed-point data type of input of each
        %filter stage
        %   Specify the filters input fixed-point type as a scaled
        %   numerictype object with a Signedness of Auto. This property
        %   applies when you set the FiltersInputDataType property to
        %   'Custom'. The default is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomFiltersInputDataType;

        % CustomThirdFilterCoefficientsDataType Fixed-point data type of 
        %                                       third filter coefficients
        %   Specify the third filter coefficients fixed-point type as a
        %   scaled numerictype object with a Signedness of Auto. This
        %   property applies when you set the
        %   ThirdFilterCoefficientsDataType property to 'Custom'. The
        %   default is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomThirdFilterCoefficientsDataType;

        %DecimationFactor Decimation factor
        %   Set this property to a positive, integer scalar, or to a 1x2 or
        %   1x3 vector of positive integers.
        %
        %   When you set this property to a scalar the object automatically
        %   chooses the decimation factors for each of the three filtering
        %   stages.
        %
        %   When you set this property to a 1x2 vector, the object bypasses
        %   the third filter stage and sets the decimation factor of the
        %   first and second filtering stages to the values in the first
        %   and second vector elements respectively. When you set the
        %   FilterSpecification property to 'Design parameters', both
        %   elements of the DecimationFactor vector must be greater than
        %   one. When you set the FilterSpecification property to
        %   'Coefficients', the first element of the DecimationFactor
        %   vector must be greater than 1.
        %
        %   When you set this property to a 1x3 vector, the i-th element of
        %   the vector specifies the decimation factor for the i-th
        %   filtering stage. When you set the FilterSpecification property
        %   to 'Design parameters', the first and second elements of the
        %   DecimationFactor vector must be greater than one and the third
        %   element must be 1 or 2. When you set the FilterSpecification
        %   property to 'Coefficients', the first element of the
        %   DecimationFactor vector must be greater than 1.
        %
        %   When you set the FilterSpecification property to
        %   'Coefficients', you must set the DecimationFactor property to a
        %   1x3 or 1x2 vector.
        %
        %   The default is 100.
        DecimationFactor;

        %FilterSpecification Filter specification
        %   Set the filter specification as one of 'Design parameters' |
        %   'Coefficients'. The default is 'Design parameters'. The DDC
        %   object performs decimation using a cascade of three decimation
        %   filters. The first filter stage is always a CIC decimator. When
        %   you set the FilterSpecification property to 'Design
        %   parameters', the object designs the cascade of decimation
        %   filters internally, according to a set of parameters that you
        %   specify using the filter-related object properties. In this
        %   case, the second and third stages of the cascade consist of a
        %   CIC compensator, and a halfband or lowpass FIR decimator
        %   respectively. When you set the FilterSpecification property to
        %   'Coefficients', you specify an arbitrary set of filter
        %   coefficients for the second and third filter stages using the
        %   SecondFilterCoefficients, and ThirdFilterCoefficients
        %   properties respectively. You specify the number of CIC sections
        %   using the NumCICSections property. In all cases, the third
        %   filter stage can be bypassed by setting the DecimationFactor
        %   property appropriately.
        %
        %   When the input data type is double or single the object
        %   implements an N-section CIC decimation filter as an FIR filter
        %   with a response that corresponds to a cascade of N boxcar
        %   filters. A true CIC filter with actual comb and integrator
        %   sections is implemented when the input data is of a fixed point
        %   type.
        FilterSpecification;

        %FiltersInputDataType Data type of input of each filter stage
        %   Specify the data type at the input of the first, second, and
        %   third (if it has not been bypassed) filter stages as one of
        %   'Same as input' | 'Custom'. The default is 'Same as input'. The
        %   object casts the data at the input of each filter stage
        %   according to the value you set in this property.
        FiltersInputDataType;

        %MinimumOrderDesign Minimum order filter design
        %   When you set this property to true the object designs filters
        %   with the minimum order that meets the passband ripple, stopband
        %   attenuation, passband frequency, and stopband frequency
        %   specifications that you set using the PassbandRipple,
        %   StopbandAttenuation, Bandwidth, StopbandFrequencySource, and
        %   StopbandFrequency properties. When you set this property to
        %   false, the object designs filters with orders that you specify
        %   in the NumCICSections, SecondFilterOrder, and ThirdFilterOrder
        %   properties. The filter designs meet the passband and stopband
        %   frequency specifications that you set using the Bandwidth,
        %   StopbandFrequencySource, and StopbandFrequency properties. This
        %   property applies when you set the FilterSpecification property
        %   to 'Design parameters'. The default is true.
        MinimumOrderDesign;

        %NumCICSections Number of sections of CIC decimator
        %   Set this property to a positive, integer scalar. This property
        %   applies when you set the FilterSpecification property to
        %   'Design parameters' and the MinimumOrderDesign property to
        %   false, or when you set the FilterSpecification property to
        %   'Coefficients'. The default is 3.
        NumCICSections;

        %Oscillator Type of oscillator
        %   Specify the oscillator as one of 'Sine wave' | 'NCO' | 'Input
        %   port' | 'None'. The default is 'Sine wave'. When you set this
        %   property to 'Sine wave', the object frequency down converts the
        %   input signal using a complex exponential obtained from samples
        %   of a sinusoidal trigonometric function. When you set this
        %   property to 'NCO' the object performs frequency down conversion
        %   with a complex exponential obtained using a numerically
        %   controlled oscillator (NCO). When you set this property to
        %   'Input port', the object performs frequency down conversion
        %   using the complex signal that you set as an input to the step
        %   method. When you set this property to 'None' the object
        %   performs down sampling but no frequency down conversion.
        Oscillator;

        %SampleRate Sample rate of input signal
        %   Set this property to a positive scalar. The default is 30e6
        %   Hertz.
        SampleRate;

        %SecondFilterCoefficients Coefficients of second filter stage
        %   Set this property to a double precision row vector of real
        %   coefficients that correspond to an FIR filter. Usually, the
        %   response of this filter should be that of a CIC compensator
        %   since a CIC decimation filter precedes the second filter stage.
        %   This property applies when you set the FilterSpecification
        %   property to 'Coefficients'. The default is 1.
        SecondFilterCoefficients;

        %StopbandFrequencySource Source of stopband frequency
        %   Specify the source of the stopband frequency as one of 'Auto' |
        %   'Property'. The default is 'Auto'. When you set this property
        %   to 'Auto', the object places the cutoff frequency of the
        %   cascade filter response at approximately Fc = SampleRate/M/2
        %   Hertz, where M is the total decimation factor that you specify
        %   in the DecimationFactor property. The object computes the
        %   stopband frequency as Fstop = Fc + TW/2. TW is the transition
        %   bandwidth of the cascade response computed as 2*(Fc-Fp), and
        %   the passband frequency, Fp, equals Bandwidth/2. This property
        %   applies when you set the FilterSpecification property to
        %   'Design parameters'.
        StopbandFrequencySource;

        %ThirdFilterCoefficients Coefficients of third filter stage
        %   Set this property to a double precision row vector of real
        %   coefficients that correspond to an FIR filter. When you set the
        %   DecimationFactor property to a 1x2 vector, the object ignores
        %   the value of the ThirdFilterCoefficients property because the
        %   third filter stage is bypassed. This property applies when you
        %   set the FilterSpecification property to 'Coefficients'. The
        %   default is 1.
        ThirdFilterCoefficients;

        % ThirdFilterCoefficientsDataType Data type of third filter
        % coefficients
        %   Specify the third filter coefficients data type as 'Same as
        %   input' |'Custom'. The default is 'Same as input'. This property
        %   applies when you set the FilterSpecification  property to
        %   'Coefficients'.
        ThirdFilterCoefficientsDataType;

        %ThirdFilterOrder Order of third filter stage
        %   Set this property to a positive, integer, even scalar. When you
        %   set the DecimationFactor property to a 1x2 vector, the object
        %   ignores the ThirdFilterOrder property because the third filter
        %   stage is bypassed. This property applies when you set the
        %   FilterSpecification property to 'Design parameters' and the
        %   MinimumOrderDesign property to false. The default is 10.
        ThirdFilterOrder;

    end
end
