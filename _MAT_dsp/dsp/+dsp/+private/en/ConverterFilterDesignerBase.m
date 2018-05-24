classdef ConverterFilterDesignerBase< handle
%dsp.private.ConverterFilterDesignerBase Base class for the UpConverterFilterDesigner
%and DownConverterFilterDesigner classes.

     
% Copyright 2010-2013 The MathWorks, Inc.

    methods
        function out=ConverterFilterDesignerBase
            %dsp.private.ConverterFilterDesignerBase Base class for the UpConverterFilterDesigner
            %and DownConverterFilterDesigner classes.
        end

        function addMask(in) %#ok<MANU>
            % Draw mask and add quantized filter response of cascade
        end

        function isDesignAvailable(in) %#ok<MANU>
        end

        function loadSubObjects(in) %#ok<MANU>
        end

        function privFvtool(in) %#ok<MANU>
            % Plot response of cascade using fvtool.
            % Fs is sampling frequency used in fvtool
            % cascadeGain is the gain of filter cascade
            % varargin contains other p-v pairs for fvtool
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
        SystemObjectsToMfilt; %#ok<NOIN>

        checkPropertyValues; %#ok<NOIN>

        computeCICNullFrequencies; %#ok<NOIN>

        computeFrequencySpecifications; %#ok<NOIN>

        designFiltersMinOrder; %#ok<NOIN>

        designFiltersSpecifiedCoefficients; %#ok<NOIN>

        designFiltersSpecifiedOrders; %#ok<NOIN>

        setFilterSectionTypes; %#ok<NOIN>

    end
    properties
        %Arithmetic Filter arithmetic
        %   Set this property to 'double', 'single', or 'fixed'. This
        %   property controls the way in which the CIC section is
        %   implemented. If set to 'double' or 'single', the CIC stage is
        %   implemented as an FIR filter (coefficients of a cascade of
        %   boxcar filters). If set to 'fixed' the CIC stage is implemented
        %   as a true CIC filter. When this property is set to 'fixed' and
        %   the FilterSpecification property is set to 'Design parameters',
        %   the filter designer finds the smallest coefficient word lengths
        %   that meet the frequency and attenuation specifications.
        Arithmetic;

        %Bandwidth Double sided signal bandwidth
        %   This property applies when you set the FilterSpecification
        %   property to 'Design parameters'.
        Bandwidth;

        %CICCompFilterSysObj Handle to System object that forms the CIC
        %compensator stage
        CICCompFilterSysObj;

        %CICFilterSysObj Handle to System object that forms the CIC stage
        CICFilterSysObj;

        %CoefficientsStage2 Coefficients of second filter stage
        %   This property applies when you set the FilterSpecification
        %   property to 'Coefficients'.
        CoefficientsStage2;

        %CoefficientsStage2DataType Data type of coefficients for stage 2
        %   This property applies when you set the FilterSpecification
        %   property to 'Coefficients'. Must be set to a scaled numerictype
        %   object with a Signedness of 'Auto'.
        CoefficientsStage2DataType;

        %FilterSpecification Filter specification
        %   Set the filter specification as one of 'Design parameters' |
        %   'Coefficients'. When you set this property to 'Design
        %   parameters', the filters will be designed internally according
        %   to a set of filter specifications. When you set this property
        %   to 'Coefficients', you specify the filter coefficients. The
        %   filter designer outputs System objects set to the specified
        %   coefficients. It also outputs the scaling factor that
        %   normalizes the CIC response.
        FilterSpecification;

        %GainFilter Scalar that forms the gain stage
        GainFilter;

        %InputNumericType Numerictype  of input
        InputNumericType;

        %IsFilterDesignAvailable Flag is true if a filter design is available
        IsFilterDesignAvailable;

        %MinimumOrderDesign Minimum order design flag. Can be set to true
        %or false
        %   This property applies when you set the FilterSpecification
        %   property to 'Design parameters'.
        MinimumOrderDesign;

        %OrderStage2 Order of second filter stage
        %   This property applies when you set the FilterSpecification
        %   property to 'Design parameters' and the MinimumOrderDesign
        %   property to false.
        OrderStage2;

        %OutputNumericType Numerictype of output
        OutputNumericType;

        %PassbandRipple Passband ripple in dB
        %   This property applies when you set the FilterSpecification
        %   property to 'Design parameters' and the MinimumOrderDesign
        %   property to true.
        PassbandRipple;

        %StopbandAttenuation Stopband attenuation in dB
        %   This property applies when you set the FilterSpecification
        %   property to 'Design parameters' and the MinimumOrderDesign
        %   property to true.
        StopbandAttenuation;

        %StopbandFrequency Stopband frequency in Hertz
        %   This property applies when you set the FilterSpecification
        %   property to 'Design parameters' and the StopbandFrequencySource
        %   property to 'Property'.
        StopbandFrequency;

        %StopbandFrequencySource Source of stopband frequency
        %   This property can be set to 'Auto' or 'Property'. This property
        %   applies when you set the FilterSpecification property to
        %   'Design parameters'.
        StopbandFrequencySource;

        %pCICCompFilter Handle to an mfilt object that forms the CIC compensator
        %stage
        pCICCompFilter;

        %pCICFilter Handle to an mfilt object that forms the CIC stage
        pCICFilter;

        %pCascadeFilter Handle to an mfilt object containing the cascade response
        pCascadeFilter;

        %pCascadeFilterStopbandFrequency Stopband frequency of the cascade
        %response. This property will be used to verify attenuation in the
        %stopband of the cascade response.
        pCascadeFilterStopbandFrequency;

        %pFCICNulls Vector containing the frequency locations (in Hertz) of
        %the nulls of the CIC stage.
        pFCICNulls;

        %pFsStage1 Operating sampling frequency of first filter stage in
        %Hertz
        pFsStage1;

        %pFsStage2 Operating sampling frequency of second filter stage in
        %Hertz
        pFsStage2;

        %pFsStage3 Operating sampling frequency of third filter stage in
        %Hertz
        pFsStage3;

        %pFstopStage2 Stopband frequency of second filter stage in Hertz
        pFstopStage2;

        %pGainFilter Handle to a dfilt object that forms the gain stage
        pGainFilter;

        %pM1 Interpolation or decimation factor for first filter stage
        pM1;

        %pM2 Interpolation or decimation factor for second filter stage
        pM2;

        %pM3 Interpolation or decimation factor for third filter stage
        pM3;

        %pNumMagRespMeasPoints Number of frequency points used to measure
        %magnitude response.
        pNumMagRespMeasPoints;

        %pPassBandRippleReductionFactor Factor to reduce passband ripple when
        %designing minimum order filters.
        pPassBandRippleReductionFactor;

        %pPassbandFrequency Passband frequency in Hertz
        pPassbandFrequency;

        %pStopbandAttenuationStep Step to increase the attenuation when designing
        %minimum order filters. Must be in dB.
        pStopbandAttenuationStep;

    end
end
