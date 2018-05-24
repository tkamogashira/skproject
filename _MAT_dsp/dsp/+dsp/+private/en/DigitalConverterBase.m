classdef DigitalConverterBase< handle
%dsp.private.DigitalConverterBase Baseclass for the DigitalDownConverter and
%DigitalUpconverter classes.

     
    %   Copyright 2010-2012 The MathWorks, Inc.

    methods
        function out=DigitalConverterBase
            %dsp.private.DigitalConverterBase Baseclass for the DigitalDownConverter and
            %DigitalUpconverter classes.
        end

        function callPlotMethod(in) %#ok<MANU>
            % Call either fvtool or visualizeFilterStages of the filter designer
            % object. The plotMethod input can be 'fvtool' or 'visualizeFilterStages'.
            % Input varargin contains other arguments that can be passed to fvtool.
        end

        function designFilters(in) %#ok<MANU>
            % Check the validity of inputArith and then design filters if a design
            % is not available or if the filters must be redesigned for a different
            % arithmetic.
        end

        function designOscillator(in) %#ok<MANU>
            % Design a sine wave generator or an NCO
        end

        function fvtool(in) %#ok<MANU>
            %fvtool Visualize response of filter cascade
            %   fvtool(H) plots the magnitude response of the cascade of
            %   filters. By default, the object plots the cascade response
            %   up to the second CIC null frequency (or to the first when
            %   only one CIC null exists). When the FilterSpecification
            %   property is set to 'Design parameters' the method plots a
            %   mask based on the filter specifications.
            %
            %   fvtool(H,..,'Arithmetic',ARITH,...) specifies the
            %   arithmetic of the filter cascade. You set input ARITH to
            %   'double', 'single', or 'fixed-point'. When object H is in
            %   an unlocked state you must specify the arithmetic. When
            %   object H is in a locked state the arithmetic input is
            %   ignored.
            %
            %   fvtool(H,..., PROP1, VALUE1,PROP2,VALUE2, etc.) launches
            %   FVTool and sets the specified FVTool properties to the
            %   specified values.
            %
            %  See also visualizeFilterStages.
        end

        function getInputType(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function groupDelay(in) %#ok<MANU>
            %groupDelay Group delay of filter cascade
            %   D = groupDelay(H,N) returns a vector of group delays, D,
            %   evaluated at N frequency points equally spaced around the
            %   upper half of the unit circle. If you don't specify N, it
            %   defaults to 8192.
            %
            %   [D,F] = groupDelay(H,N) returns a vector of frequencies at
            %   which the group delay has been computed.
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadSubObjects(in) %#ok<MANU>
        end

        function parseArithmetic(in) %#ok<MANU>
            % Parse arithmetic input
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setInputOutputTypes(in) %#ok<MANU>
            % Cache data types of inputs and outputs
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

        function visualizeFilterStages(in) %#ok<MANU>
            %visualizeFilterStages Display response of filter stages
            %   visualizeFilterStages(H) plots the magnitude response of
            %   the filter stages and of the cascade response. When the
            %   FilterSpecification property is set to 'Design parameters'
            %   the method plots a mask based on the filter specifications.
            %   By default, the object plots the response of the filters up
            %   to the second CIC null frequency (or to the first when only
            %   one CIC null exists).
            %
            %   visualizeFilterStages(H,'Arithmetic',ARITH) specifies the
            %   arithmetic of the filter stages. You set input ARITH to
            %   'double', 'single', or 'fixed-point'. When object H is in
            %   an unlocked state you must specify the arithmetic. When
            %   object H is in a locked state the arithmetic input is
            %   ignored.
            %
            %   hfvt = visualizeFilterStages(H) returns a handle to an
            %   FVTool object.
        end

    end
    methods (Abstract)
        checkFactorLength; %#ok<NOIN>

        checkFactorValues; %#ok<NOIN>

        checkFsFc; %#ok<NOIN>

        designDesignerIfEmpty; %#ok<NOIN>

        getCustomFiltersDataType; %#ok<NOIN>

        getFilterDesigner; %#ok<NOIN>

        isFilterCoefficientsDataTypeSameAsInput; %#ok<NOIN>

        releaseDesignerIfLocked; %#ok<NOIN>

        setCustomCoefficientsDataType; %#ok<NOIN>

    end
    properties
        %Bandwidth Two sided bandwidth of input signal in Hertz
        %   Set this property to a positive, integer scalar. The object
        %   sets the passband frequency of the cascade of filters to
        %   one-half of the value that you specify in the Bandwidth
        %   property. This property applies when you set the
        %   FilterSpecification property to 'Design parameters'. The
        %   default is 200e3 Hertz.
        Bandwidth;

        % CustomOutputDataType Fixed-point data type of output
        %   Specify the output fixed-point type as a scaled numerictype
        %   object with a Signedness of Auto. This property applies when
        %   you set the OutputDataType property to 'Custom'. The default is
        %   numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        % CustomSecondFilterCoefficientsDataType Fixed-point data type of
        %                                        second filter coefficients
        %   Specify the second filter coefficients fixed-point type as a
        %   scaled numerictype object with a Signedness of Auto. This
        %   property applies when you set the
        %   SecondFilterCoefficientsDataType property to 'Custom'. The
        %   default is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomSecondFilterCoefficientsDataType;

        %Dither Dither control for NCO
        %   When you set this property to true, a number of dither bits
        %   specified in the NumDitherBits property will be used to apply
        %   dither to the NCO signal. This property applies when you set
        %   the Oscillator property to 'NCO'. The default is true.
        %
        %   See also dsp.NCO.
        Dither;

        %NumAccumulatorBits Number of NCO accumulator bits
        %   Specify this property as an integer scalar in the range [1
        %   128]. This property applies when you set the Oscillator
        %   property to 'NCO'. The default is 16.
        %
        %   See also dsp.NCO.
        NumAccumulatorBits;

        %NumDitherBits Number of NCO dither bits
        %   Specify this property as an integer scalar smaller than the
        %   number of accumulator bits that you specify in the
        %   NumAccumulatorBits property. This property applies when you set
        %   the Oscillator property to 'NCO' and the Dither property to
        %   true. The default is 4.
        %
        %   See also dsp.NCO.
        NumDitherBits;

        %NumQuantizedAccumulatorBits Number of NCO quantized accumulator
        %bits
        %   Specify this property as an integer scalar in the range [1
        %   128]. The value you specify in the NumQuantizedAccumulatorBits
        %   property must be less than the value you specify in the
        %   NumAccumulatorBits property. This property applies when you set
        %   the Oscillator property to 'NCO'. The default is 12.
        %
        %   See also dsp.NCO.
        NumQuantizedAccumulatorBits;

        % OutputDataType Data type of output
        %    Specify the data type of output as 'Same as input' | 'Custom'.
        %    The default is 'Same as input'.
        OutputDataType;

        %PassbandRipple Passband ripple of cascade response in dB
        %   Set this property to a double precision, positive scalar. When
        %   you set the MinimumOrderDesign property to true, the object
        %   designs the filters so that the cascade response meets the
        %   passband ripple that you specify in the PassbandRipple
        %   property. This property applies when you set the
        %   FilterSpecification property to 'Design parameters' and the
        %   MinimumOrderDesign property to true. The default is 0.1 dB.
        PassbandRipple;

        % SecondFilterCoefficientsDataType Data type of second filter
        % coefficients
        %   Specify the second filter coefficients data type as 'Same as
        %   input' |'Custom'. The default is 'Same as input'. This property
        %   applies when you set the FilterSpecification  property to
        %   'Coefficients'.
        SecondFilterCoefficientsDataType;

        %SecondFilterOrder Order of CIC compensation filter stage
        %   Set this property to a positive, integer scalar. This property
        %   applies when you set the FilterSpecification property to
        %   'Design parameters' and the MinimumOrderDesign property to
        %   false. The default is 12.
        SecondFilterOrder;

        %StopbandAttenuation Stopband attenuation of cascade response in dB
        %   Set this property to a double precision, positive scalar. When
        %   you set the MinimumOrderDesign property to true, the object
        %   designs the filters so that the cascade response meets the
        %   stopband attenuation that you specify in the
        %   StopbandAttenuation property. This property applies when you
        %   set the FilterSpecification property to 'Design parameters' and
        %   the MinimumOrderDesign property to true. The default is 60 dB.
        StopbandAttenuation;

        %StopbandFrequency Stopband frequency in Hertz
        %   Set this property to a double precision positive scalar. This
        %   property applies when you set the FilterSpecification property
        %   to 'Design parameters' and the StopbandFrequencySource property
        %   to 'Property'. The default is 150e3 Hertz.
        StopbandFrequency;

        %pArithmetic Arithmetic of filters. Can be 'double', 'single' or 'fixed-point'
        pArithmetic;

        %pCIC CIC filter
        pCIC;

        %pCICComp CIC compensator filter
        pCICComp;

        %pCICNormalizationFactor Scaling factor to normalize CIC response
        pCICNormalizationFactor;

        %pCastOutputToBuiltInInteger If true, then we need to cast the output to
        %a built in integer
        pCastOutputToBuiltInInteger;

        %pCastOutputToFloatingFi If true then we need to cast the output to a
        %double or single fi object.
        pCastOutputToFloatingFi;

        %pFilterDesigner Filter designer object
        pFilterDesigner;

        %pInitCICNormOutput Data initialization used to cast CIC normalization
        %output
        pInitCICNormOutput;

        %pInitMixerOutput Data initialization used to cast the mixer output
        pInitMixerOutput;

        %pInitOscillatorOutput Data initialization used to cast the oscillator
        %output.
        pInitOscillatorOutput;

        %pInputDataType Input data type
        pInputDataType;

        %pInputDesignDataType Data Type of input used in designFilters
        pInputDesignDataType;

        %pInputNumericType If input is fixed point, this property holds the
        %numerictype of that input data.
        pInputNumericType;

        %pInputSize Size of input signal
        pInputSize;

        %pIsInputFixedPoint True if input is fixed point
        pIsInputFixedPoint;

        %pNormalizeCICOutputFunction Handle to CIC normalization helper function
        pNormalizeCICOutputFunction;

        %pOscillator Oscillator for the frequency converter
        pOscillator;

        %pOscillatorOutputNumericType Numeric type of oscillator output
        pOscillatorOutputNumericType;

        %pOutputCastFunction Handle to the output cast function
        pOutputCastFunction;

        %pOutputNumericType Numeric type of output
        pOutputNumericType;

        %pReinterpretCastNumericType Numeric type of reinterpreted CIC output
        pReinterpretCastNumericType;

        %pRemNormFactor Remaining normalization factor
        pRemNormFactor;

        %pSecondFilterCoefficientsNumericType Numeric type of second filter
        %coefficients
        pSecondFilterCoefficientsNumericType;

    end
end
