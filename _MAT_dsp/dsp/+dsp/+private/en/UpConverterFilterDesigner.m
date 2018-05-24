classdef UpConverterFilterDesigner< handle
%dsp.private.UpConverterFilterDesigner Interpolation filter cascade designer
%   This object designs a cascade of interpolation filter System objects to
%   be used by the dsp.DigitalUpConverter class. The cascade consists of
%   four stages.
%   When  FilterSpecification is 'Design parameters':
%
%   Stage1   = halfband or lowpass interpolation filter (this
%              stage may or may not be bypassed, depending on the property
%              settings of the object)
%   Stage2   = CIC compensator interpolation filter
%   Stage3   = CIC interpolator filter (this stage will be implemented as a
%              dsp.FIRInterpolator System object when the Arithmetic
%              property is set to 'double' or 'single', or as a
%              dsp.CICInterpolator System object when the Arithmetic
%              property is set to 'fixed'.
%  GainStage = Gain stage to normalize the gain of the CIC interpolator.
%
%  When  FilterSpecification is 'Coefficients':
%
%   Stage1   = FIR interpolation filter (this
%              stage may or may not be bypassed, depending on the property
%              settings of the object)
%   Stage2   = FIR interpolation filter
%   Stage3   = CIC interpolator filter (this stage will be implemented as a
%              dsp.FIRInterpolator System object when the Arithmetic
%              property is set to 'double' or 'single', or as a
%              dsp.CICInterpolator System object when the Arithmetic
%              property is set to 'fixed'.
%  GainStage = Gain stage to normalize the gain of the CIC interpolator.

     
    %   Copyright 2010-2012 The MathWorks, Inc.

    methods
        function out=UpConverterFilterDesigner
            %dsp.private.UpConverterFilterDesigner Interpolation filter cascade designer
            %   This object designs a cascade of interpolation filter System objects to
            %   be used by the dsp.DigitalUpConverter class. The cascade consists of
            %   four stages.
            %   When  FilterSpecification is 'Design parameters':
            %
            %   Stage1   = halfband or lowpass interpolation filter (this
            %              stage may or may not be bypassed, depending on the property
            %              settings of the object)
            %   Stage2   = CIC compensator interpolation filter
            %   Stage3   = CIC interpolator filter (this stage will be implemented as a
            %              dsp.FIRInterpolator System object when the Arithmetic
            %              property is set to 'double' or 'single', or as a
            %              dsp.CICInterpolator System object when the Arithmetic
            %              property is set to 'fixed'.
            %  GainStage = Gain stage to normalize the gain of the CIC interpolator.
            %
            %  When  FilterSpecification is 'Coefficients':
            %
            %   Stage1   = FIR interpolation filter (this
            %              stage may or may not be bypassed, depending on the property
            %              settings of the object)
            %   Stage2   = FIR interpolation filter
            %   Stage3   = CIC interpolator filter (this stage will be implemented as a
            %              dsp.FIRInterpolator System object when the Arithmetic
            %              property is set to 'double' or 'single', or as a
            %              dsp.CICInterpolator System object when the Arithmetic
            %              property is set to 'fixed'.
            %  GainStage = Gain stage to normalize the gain of the CIC interpolator.
        end

        function SystemObjectsToMfilt(in) %#ok<MANU>
            %Create mfilt filter objects and cascade for filter analysis
        end

        function checkPropertyValues(in) %#ok<MANU>
            %Verify that property values are within valid frequency ranges
        end

        function computeCICNullFrequencies(in) %#ok<MANU>
            % Compute frequency locations of CIC nulls
        end

        function computeFrequencySpecifications(in) %#ok<MANU>
            %Compute rate of operation and stopband frequencies for filter
            %sections.
        end

        function designCICInterpolationFilter(in) %#ok<MANU>
            % Design a CIC interpolation response and implement it as an FIR filter
            % when Arithmetic is ''double' or 'single', or as a CIC filter when
            % Arithmetic is 'fixed'. Output the gain of the CIC filter.
        end

        function designFiltersMinOrder(in) %#ok<MANU>
            % Design cascade of minimum order interpolation filters that meets
            % specifications.
        end

        function designFiltersSpecifiedCoefficients(in) %#ok<MANU>
        end

        function designFiltersSpecifiedOrders(in) %#ok<MANU>
            % Design cascade of interpolation filters with specified orders,
            % passband and stopband frequencies.
        end

        function fvtool(in) %#ok<MANU>
            %fvtool Display response of filter cascade
        end

        function getInterpolationFactors(in) %#ok<MANU>
            % If a design is available, return the interpolation factors for each
            % stage
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function groupDelay(in) %#ok<MANU>
        end

        function isFirstStageBypassed(in) %#ok<MANU>
            % Ask if first stage has been bypassed or not
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setFilterSectionTypes(in) %#ok<MANU>
            %Determine if the first filter section is bypassed or not. If not, then
            %determine whether the first section should be a halfband or a lowpass
            %interpolation filter. Set the interpolation factor values for each
            %section.
        end

        function setupImpl(in) %#ok<MANU>
            % Initialize private properties to be used later
        end

        function visualizeFilterStages(in) %#ok<MANU>
            %visualizeFilterStages Display response of filter stages
            %   visualizeFilterStages(H) plots the magnitude response of the
            %   interpolation filter stages and of the cascade response. If you set
            %   the FilterSpecification property to 'Design parameters' it also
            %   plots a mask based on the filter specifications.
            %
            %   hfvt = visualizeFilterStages(H) returns a handle to an fvtool
            %   object.
            %
            %   Call the fvtool method if you only want to visualize the cascade
            %   response.
        end

    end
    methods (Abstract)
    end
    properties
        %CoefficientsStage1 Coefficients for first filter stage
        %   This property applies when FilterSpecification is 'Coefficients'. Must
        %   be set to a signed and scaled numerictype object.
        CoefficientsStage1;

        %CoefficientsStage1DataType Data type of coefficients for stage 1
        %   This property applies when you set the FilterSpecification property to
        %   'Coefficients'.
        CoefficientsStage1DataType;

        %InterpolationFactor Interpolation factor
        %   This property can be a scalar, a 1x2 vector, or a 1x3 vector. If it is
        %   a scalar, the interpolation factor for each stage is computed
        %   automatically. If it is a 1x2 vector, the first filter stage is
        %   bypassed. The elements of the 1x2 vector specify the interpolation
        %   factors for the second and third interpolation stages. When
        %   FilterSpecification is set to 'Coefficients' the InterpolationFactor
        %   property must be a vector.
        InterpolationFactor;

        %OrderStage1 Order of first filter stage
        %   This property holds the order of the first filter stage. This property
        %   applies when  FilterSpecification is 'Design parameters' and
        %   MinimumOrderDesign is false.
        OrderStage1;

        %OrderStage3 Order of third filter stage
        %   This property holds the number of CIC sections. This property applies
        %   when  FilterSpecification is 'Design parameters' and
        %   MinimumOrderDesign is false, or when FilterSpecification is
        %   'Coefficients'.
        OrderStage3;

        %SampleRate Sample rate at the input of the filter cascade in Hertz
        SampleRate;

        %Stage1FilterSysObj Handle to System object that forms the first
        %stage
        Stage1FilterSysObj;

    end
end
