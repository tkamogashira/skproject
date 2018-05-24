classdef DigitalUpConverter< handle
%dsp.DigitalUpConverter Digitally up convert input signal
%   H = dsp.DigitalUpConverter creates a digital up converter (DUC) System
%   object, H. The object up samples the input signal using a cascade of
%   three interpolation filters. The object frequency up converts the up
%   sampled signal by multiplying it with a complex exponential with center
%   frequency equal to the value in the CenterFrequency property. When you
%   set the FilterSpecification property to 'Design parameters', the DUC
%   object designs the interpolation filters according to the filter
%   specifications that you set in the filter-related object properties. In
%   this case the filter cascade consists of a first FIR interpolation
%   stage, a CIC compensator, and a CIC interpolator. The first filter
%   stage can be bypassed depending on how you set the properties of the
%   DUC object.
%
%   H = dsp.DigitalUpConverter(Name,Value) creates a DUC object, H, with the
%   specified property Name set to the specified Value. You can specify
%   additional name-value pair arguments in any order as
%   (Name1,Value1,...,NameN,ValueN).
%
%   Step method syntax:
%
%   Y = step(H,X) takes a real or complex input column vector X and outputs
%   an up sampled and frequency up converted signal Y. X can be of data
%   type double, single, signed integer, or signed fixed point (fi
%   objects). The length of Y is equal to the length of X multiplied by the
%   InterpolationFactor. When the data type of X is double or single
%   precision, the data type of Y is the same as that of X. When the data
%   type of X is of a fixed point type, the data type of Y is defined by
%   the OutputDataType property.
%
%   dsp.DigitalUpConverter methods:
%
%   step                    - Digitally up convert input signal (see above)
%   release                 - Allow property value and input characteristics
%                             changes
%   clone                   - Create DUC object with same property values
%   isLocked                - Locked status (logical)
%   getFilters              - Get handles to interpolation filter objects
%   getFilterOrders         - Get orders of interpolation filters
%   getInterpolationFactors - Get interpolation factors of each filter stage
%   visualizeFilterStages   - Visualize response of each filter stage
%   fvtool                  - Visualize response of the filter cascade
%   groupDelay              - Compute the group delay of the filter cascade
%
%   dsp.DigitalUpConverter properties:
%
%   SampleRate                  - Sample rate of input signal
%   InterpolationFactor         - Interpolation factor
%   FilterSpecification         - Filter specification
%   MinimumOrderDesign          - Minimum order filter design
%   FirstFilterCoefficients     - Coefficients of first filter stage
%   SecondFilterCoefficients    - Coefficients of second filter stage
%   FirstFilterOrder            - Order of first filter stage
%   SecondFilterOrder           - Order of CIC compensation filter stage
%   NumCICSections              - Number of sections of CIC interpolator
%   Bandwidth                   - Two sided bandwidth of input signal in Hertz
%   StopbandFrequencySource     - Source of stopband frequency
%   StopbandFrequency           - Stopband frequency in Hertz
%   PassbandRipple              - Passband ripple of cascade response in dB
%   StopbandAttenuation         - Stopband attenuation of cascade response in dB
%   Oscillator                  - Type of oscillator
%   CenterFrequency             - Center frequency of output signal in Hertz
%   NumAccumulatorBits          - Number of NCO accumulator bits
%   NumQuantizedAccumulatorBits - Number of NCO quantized accumulator bits
%   Dither                      - Dither control for NCO
%   NumDitherBits               - Number of NCO dither bits
%
%   The dsp.DigitalUpConverter object supports fixed-point operations. For
%   more information, type dsp.DigitalUpConverter.helpFixedPoint.
%
%   % Example:
%   %   Create a digital up converter object that up samples a 1 KHz
%   %   sinusoidal signal by a factor of 20 and up converts it to 50 KHz.
%
%   % Create a sine wave generator to obtain the 1 KHz sinusoidal signal
%   % with a sample rate of 6 KHz.
%   Fs = 6e3; % Sample rate
%   hSig = dsp.SineWave('Frequency',1000,'SampleRate', Fs,'SamplesPerFrame',1024);
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
%   % Create a spectrum estimator to visualize the signal spectrum before
%   % and after up converting.
%   window = hamming(floor(length(x)/10));
%   figure; pwelch(x,window,[],[],Fs,'centered');
%   title('Spectrum of baseband signal x')
%
%   % Up convert the signal and visualize the spectrum
%   xUp = step(hDUC,x); % up convert
%   window = hamming(floor(length(xUp)/10));
%   figure; pwelch(xUp,window,[],[],20*Fs,'centered')
%   title('Spectrum of up converted signal xUp')
%
%   % Visualize the response of the interpolation filters
%   visualizeFilterStages(hDUC)
%
%   See also dsp.DigitalDownConverter, dsp.SineWave, dsp.NCO,
%   dsp.CICInterpolator, dsp.FIRInterpolator.

     
    %   Copyright 2010-2013 The MathWorks, Inc.

    methods
        function out=DigitalUpConverter
            %dsp.DigitalUpConverter Digitally up convert input signal
            %   H = dsp.DigitalUpConverter creates a digital up converter (DUC) System
            %   object, H. The object up samples the input signal using a cascade of
            %   three interpolation filters. The object frequency up converts the up
            %   sampled signal by multiplying it with a complex exponential with center
            %   frequency equal to the value in the CenterFrequency property. When you
            %   set the FilterSpecification property to 'Design parameters', the DUC
            %   object designs the interpolation filters according to the filter
            %   specifications that you set in the filter-related object properties. In
            %   this case the filter cascade consists of a first FIR interpolation
            %   stage, a CIC compensator, and a CIC interpolator. The first filter
            %   stage can be bypassed depending on how you set the properties of the
            %   DUC object.
            %
            %   H = dsp.DigitalUpConverter(Name,Value) creates a DUC object, H, with the
            %   specified property Name set to the specified Value. You can specify
            %   additional name-value pair arguments in any order as
            %   (Name1,Value1,...,NameN,ValueN).
            %
            %   Step method syntax:
            %
            %   Y = step(H,X) takes a real or complex input column vector X and outputs
            %   an up sampled and frequency up converted signal Y. X can be of data
            %   type double, single, signed integer, or signed fixed point (fi
            %   objects). The length of Y is equal to the length of X multiplied by the
            %   InterpolationFactor. When the data type of X is double or single
            %   precision, the data type of Y is the same as that of X. When the data
            %   type of X is of a fixed point type, the data type of Y is defined by
            %   the OutputDataType property.
            %
            %   dsp.DigitalUpConverter methods:
            %
            %   step                    - Digitally up convert input signal (see above)
            %   release                 - Allow property value and input characteristics
            %                             changes
            %   clone                   - Create DUC object with same property values
            %   isLocked                - Locked status (logical)
            %   getFilters              - Get handles to interpolation filter objects
            %   getFilterOrders         - Get orders of interpolation filters
            %   getInterpolationFactors - Get interpolation factors of each filter stage
            %   visualizeFilterStages   - Visualize response of each filter stage
            %   fvtool                  - Visualize response of the filter cascade
            %   groupDelay              - Compute the group delay of the filter cascade
            %
            %   dsp.DigitalUpConverter properties:
            %
            %   SampleRate                  - Sample rate of input signal
            %   InterpolationFactor         - Interpolation factor
            %   FilterSpecification         - Filter specification
            %   MinimumOrderDesign          - Minimum order filter design
            %   FirstFilterCoefficients     - Coefficients of first filter stage
            %   SecondFilterCoefficients    - Coefficients of second filter stage
            %   FirstFilterOrder            - Order of first filter stage
            %   SecondFilterOrder           - Order of CIC compensation filter stage
            %   NumCICSections              - Number of sections of CIC interpolator
            %   Bandwidth                   - Two sided bandwidth of input signal in Hertz
            %   StopbandFrequencySource     - Source of stopband frequency
            %   StopbandFrequency           - Stopband frequency in Hertz
            %   PassbandRipple              - Passband ripple of cascade response in dB
            %   StopbandAttenuation         - Stopband attenuation of cascade response in dB
            %   Oscillator                  - Type of oscillator
            %   CenterFrequency             - Center frequency of output signal in Hertz
            %   NumAccumulatorBits          - Number of NCO accumulator bits
            %   NumQuantizedAccumulatorBits - Number of NCO quantized accumulator bits
            %   Dither                      - Dither control for NCO
            %   NumDitherBits               - Number of NCO dither bits
            %
            %   The dsp.DigitalUpConverter object supports fixed-point operations. For
            %   more information, type dsp.DigitalUpConverter.helpFixedPoint.
            %
            %   % Example:
            %   %   Create a digital up converter object that up samples a 1 KHz
            %   %   sinusoidal signal by a factor of 20 and up converts it to 50 KHz.
            %
            %   % Create a sine wave generator to obtain the 1 KHz sinusoidal signal
            %   % with a sample rate of 6 KHz.
            %   Fs = 6e3; % Sample rate
            %   hSig = dsp.SineWave('Frequency',1000,'SampleRate', Fs,'SamplesPerFrame',1024);
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
            %   % Create a spectrum estimator to visualize the signal spectrum before
            %   % and after up converting.
            %   window = hamming(floor(length(x)/10));
            %   figure; pwelch(x,window,[],[],Fs,'centered');
            %   title('Spectrum of baseband signal x')
            %
            %   % Up convert the signal and visualize the spectrum
            %   xUp = step(hDUC,x); % up convert
            %   window = hamming(floor(length(xUp)/10));
            %   figure; pwelch(xUp,window,[],[],20*Fs,'centered')
            %   title('Spectrum of up converted signal xUp')
            %
            %   % Visualize the response of the interpolation filters
            %   visualizeFilterStages(hDUC)
            %
            %   See also dsp.DigitalDownConverter, dsp.SineWave, dsp.NCO,
            %   dsp.CICInterpolator, dsp.FIRInterpolator.
        end

        function checkFactorLength(in) %#ok<MANU>
            % Error out if interpolation factor is not a 1x2 or 1x3 vector
        end

        function checkFactorValues(in) %#ok<MANU>
            % Check value of InterpolationFactor vector
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
            % Return the custom filter output data type. This is called from
            % designFilters in base class
        end

        function getFilterDesigner(in) %#ok<MANU>
            % Return the filter designer to be used. This is called from
            % the base class constructor
        end

        function getFilterOrders(in) %#ok<MANU>
            %getFilterOrders Get orders of interpolation filters
            %   S = getFilterOrders(H) returns a structure, S, that contains the
            %   orders of the interpolation filter stages. The FirstFilterOrder
            %   structure field will be empty if the first filter stage has been
            %   bypassed.
            %
            %   See also visualizeFilterStages, dsp.DigitalUpConverter.fvtool,
            %   groupDelay, getFilters, getInterpolationFactors.
        end

        function getFilters(in) %#ok<MANU>
            %getFilters Get handles to interpolation filter objects
            %   S = getFilters(H) returns a structure, S, with copies of the filter
            %   System objects and the CIC normalization factor that form the
            %   interpolation filter cascade. The FirstFilterStage structure field
            %   will be empty if the first filter stage has been bypassed. The CIC
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
            %   See also visualizeFilterStages, dsp.DigitalUpConverter.fvtool,
            %   groupDelay, getFilterOrders, getInterpolationFactors.
        end

        function getInterpolationFactors(in) %#ok<MANU>
            %getInterpolationFactors Get interpolation factors of each filter stage
            %   M = getInterpolationFactors(H) returns a vector, M, with the
            %   interpolation factors of each filter stage. If the first filter
            %   stage is bypassed, then M is a 1x2 vector containing the
            %   interpolation factors of the second and third stages in the first
            %   and second elements respectively. If the first filter stage is not
            %   bypassed then M is a 1x3 vector containing the interpolation
            %   factors of the first, second and third filter stages.
            %
            %   See also visualizeFilterStages, dsp.DigitalUpConverter.fvtool,
            %   groupDelay, getFilters, getFilterOrders.
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.DigitalUpConverter System object fixed-point
            %               information
            %   dsp.DigitalUpConverter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.DigitalUpConverter
            %   System object.
        end

        function isFilterCoefficientsDataTypeSameAsInput(in) %#ok<MANU>
            % Return true if any of the FirstFilterCoefficientsDataType or
            % SecondFilterCoefficientsDataType properties are set to 'Same as
            % input'.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseDesignerIfLocked(in) %#ok<MANU>
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
            % Frequency up conversion
        end

    end
    methods (Abstract)
    end
    properties
        %CenterFrequency Center frequency of output signal in Hertz
        %   Specify this property as a double precision, positive scalar. The
        %   object up converts the input signal so that the output spectrum
        %   centers at the frequency you specify in the CenterFrequency property.
        %   The default is 14e6 Hertz.
        CenterFrequency;

        %CustomFiltersOutputDataType Fixed-point data type of output of each filter stage
        %   Specify the filters output fixed-point type as a scaled numerictype
        %   object with a Signedness of Auto. This property applies when you set
        %   the FiltersOutputDataType property to 'Custom'. The default is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomFiltersOutputDataType;

        % CustomFirstFilterCoefficientsDataType Fixed-point data type of first
        %                                       filter coefficients
        %   Specify the first filter coefficients fixed-point type as a scaled
        %   numerictype object with a Signedness of Auto. This property applies
        %   when you set the FirstFilterCoefficientsDataType property to 'Custom'.
        %   The default is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomFirstFilterCoefficientsDataType;

        %FilterSpecification Filter specification
        %   Set the filter specification as one of 'Design parameters' |
        %   'Coefficients'. The default is 'Design parameters'. The DUC object
        %   performs interpolation using a cascade of three interpolation
        %   filters. The third filter stage is always a CIC interpolator. When
        %   you set the FilterSpecification property to 'Design parameters', the
        %   object designs the cascade of interpolation filters internally
        %   according to a set of parameters that you specify using the
        %   filter-related object properties. In this case, the first and second
        %   stages of the cascade consist of a halfband or lowpass FIR
        %   interpolator, and a CIC compensator respectively. When you set the
        %   FilterSpecification property to 'Coefficients', you specify an
        %   arbitrary set of filter coefficients for the first and second stages
        %   using the FirstFilterCoefficients, and SecondFilterCoefficients
        %   properties respectively. You specify the number of CIC sections using
        %   the NumCICSections property. In all cases, the first filter stage can
        %   be bypassed by setting the InterpolationFactor property appropriately.
        %
        %   When the input data type is double or single the object implements an
        %   N-section CIC interpolation filter as an FIR filter with a response
        %   that corresponds to a cascade of N boxcar filters. A true CIC filter
        %   with actual comb and integrator sections is implemented when the
        %   input data is of a fixed point type.
        FilterSpecification;

        %FiltersOutputDataType Data type of output of each filter stage
        %   Specify the data type at the output of the first (if it has not been
        %   bypassed), second, and third filter stages as one of 'Same as input'
        %   | 'Custom'. The default is 'Same as input'. The object casts the data
        %   at the output of each filter stage according to the value you set in
        %   this property. For the CIC stage, the casting is done after the
        %   signal has been scaled by the normalization factor.
        FiltersOutputDataType;

        %FirstFilterCoefficients Coefficients of first filter stage
        %   Set this property to a double precision row vector of real
        %   coefficients that correspond to an FIR filter. When you set the
        %   InterpolationFactor property to a 1x2 vector, the object ignores the
        %   value of the FirstFilterCoefficients property because the first filter
        %   stage is bypassed. This property applies when you set the
        %   FilterSpecification property to 'Coefficients'. The default is 1.
        FirstFilterCoefficients;

        % FirstFilterCoefficientsDataType Data type of first filter coefficients
        %   Specify first filter coefficients data type as 'Same as input'
        %   |'Custom'. The default is 'Same as input'. This property applies when
        %   you set the FilterSpecification  property to 'Coefficients'.
        FirstFilterCoefficientsDataType;

        %FirstFilterOrder Order of first filter stage
        %   Set this property to a positive, integer, even scalar. When you set
        %   the InterpolationFactor property to a 1x2 vector, the object ignores
        %   the FirstFilterOrder property because the first filter stage is
        %   bypassed. This property applies when you set the FilterSpecification
        %   property to 'Design parameters' and the MinimumOrderDesign property to
        %   false. The default is 10.
        FirstFilterOrder;

        %InterpolationFactor Interpolation factor
        %   Set this property to a positive, integer scalar, or to a 1x2 or 1x3
        %   vector of positive integers.
        %
        %   When you set this property to a scalar the object automatically
        %   chooses the interpolation factors for each of the three filtering
        %   stages.
        %
        %   When you set this property to a 1x2 vector, the object bypasses the
        %   first filter stage and sets the interpolation factor of the second and
        %   third filtering stages to the values in the first and second vector
        %   elements respectively. When you set the FilterSpecification property
        %   to 'Design parameters', both elements of the InterpolationFactor
        %   vector must be greater than one. When you set the FilterSpecification
        %   property to 'Coefficients', the second element of the
        %   InterpolationFactor vector must be greater than 1.
        %
        %   When you set this property to a 1x3 vector, the i-th element of the
        %   vector specifies the interpolation factor for the i-th filtering
        %   stage. When you set the FilterSpecification property to 'Design
        %   parameters', the second and third elements of the InterpolationFactor
        %   vector must be greater than one and the first element must be 1 or 2.
        %   When you set the FilterSpecification property to 'Coefficients', the
        %   third element of the InterpolationFactor vector must be greater than
        %   1.
        %
        %   When you set the FilterSpecification property to 'Coefficients', you
        %   must set the InterpolationFactor property to a 1x3 or 1x2 vector .
        %
        %   The default is 100.
        InterpolationFactor;

        %MinimumOrderDesign Minimum order filter design
        %   When you set this property to true the object designs filters with the
        %   minimum order that meets the passband ripple, stopband attenuation,
        %   passband frequency, and stopband frequency specifications that you set
        %   using the PassbandRipple, StopbandAttenuation, Bandwidth,
        %   StopbandFrequencySource, and StopbandFrequency properties. When you
        %   set this property to false, the object designs filters with orders
        %   that you specify in the FirstFilterOrder, SecondFilterOrder, and
        %   NumCICSections properties. The filter designs meet the passband and
        %   stopband frequency specifications that you set using the Bandwidth,
        %   StopbandFrequencySource, and StopbandFrequency properties. This
        %   property applies when you set the FilterSpecification property to
        %   'Design parameters'. The default is true.
        MinimumOrderDesign;

        %NumCICSections Number of sections of CIC interpolator
        %   Set this property to a positive, integer scalar. This property applies
        %   when you set the FilterSpecification property to 'Design parameters'
        %   and the MinimumOrderDesign property to false, or when you set the
        %   FilterSpecification property to 'Coefficients'. The default is 3.
        NumCICSections;

        %Oscillator Type of oscillator
        %   Specify the oscillator as one of 'Sine wave' | 'NCO'. The default is
        %   'Sine wave'. When you set this property to 'Sine wave', the object
        %   frequency up converts the output of the interpolation filter cascade
        %   using a complex exponential signal obtained from samples of a
        %   sinusoidal trigonometric function. When you set this property to
        %   'NCO' the object performs frequency up conversion with a complex
        %   exponential obtained using a numerically controlled oscillator (NCO).
        Oscillator;

        %SampleRate Sample rate of input signal
        %   Set this property to a double precision, positive scalar. The default
        %   is 300e3 Hertz.
        SampleRate;

        %SecondFilterCoefficients Coefficients of second filter stage
        %   Set this property to a double precision row vector of real
        %   coefficients that correspond to an FIR filter. Usually, the response
        %   of this filter should be that of a CIC compensator since a CIC
        %   interpolation filter follows the second filter stage. This property
        %   applies when you set the FilterSpecification property to
        %   'Coefficients'. The default is 1.
        SecondFilterCoefficients;

        %StopbandFrequencySource Source of stopband frequency
        %   Specify the source of the stopband frequency as one of 'Auto' |
        %   'Property'. The default is 'Auto'. When you set this property to
        %   'Auto', the object places the cutoff frequency of the cascade filter
        %   response at approximately Fc = SampleRate/2 Hertz, and computes the
        %   stopband frequency as Fstop = Fc + TW/2. TW is the transition
        %   bandwidth of the cascade response, computed as 2*(Fc-Fp), and the
        %   passband frequency, Fp, equals Bandwidth/2. This property applies when
        %   you set the FilterSpecification property to 'Design parameters'.
        StopbandFrequencySource;

    end
end
