classdef DownConverterFilterDesigner< handle
%dsp.private.DownConverterFilterDesigner Decimation filter cascade designer
%   This object designs a cascade of decimation filter System objects to be
%   used by the dsp.DigitalDownConverter class. The cascade consists of
%   four stages. When  FilterSpecification is 'Design parameters':
%
%   Stage1    = CIC decimator filter (this stage will be implemented as a
%               dsp.FIRDecimator System object when the Arithmetic property
%               is set to 'Double' or 'Single', or as a dsp.CICDecimator
%               System object when the Arithmetic property is set to
%               'fixed'.
%   Stage2    = CIC compensator decimation filter
%   Stage3    = halfband or lowpass decimation filter (this
%               stage may or may not be bypassed, depending on the property
%               settings of the object)
%   GainStage = Gain stage to normalize the gain of the CIC decimator.
%
%   When  FilterSpecification is 'Coefficients':
%
%   Stage1    = CIC decimator filter (this stage will be implemented as a
%               dsp.FIRDecimator System object when the Arithmetic property
%               is set to 'Double' or 'Single', or as a dsp.CICDecimator
%               System object when the Arithmetic property is set to
%               'fixed'.
%   Stage2    = FIR decimation filter
%   Stage3    = FIR decimation filter (this stage may or may not be
%               bypassed, depending on the property settings of the object)
%   GainStage = Gain stage to normalize the gain of the CIC decimator.

     
%   Copyright 2010-2013 The MathWorks, Inc.

    methods
        function out=DownConverterFilterDesigner
            %dsp.private.DownConverterFilterDesigner Decimation filter cascade designer
            %   This object designs a cascade of decimation filter System objects to be
            %   used by the dsp.DigitalDownConverter class. The cascade consists of
            %   four stages. When  FilterSpecification is 'Design parameters':
            %
            %   Stage1    = CIC decimator filter (this stage will be implemented as a
            %               dsp.FIRDecimator System object when the Arithmetic property
            %               is set to 'Double' or 'Single', or as a dsp.CICDecimator
            %               System object when the Arithmetic property is set to
            %               'fixed'.
            %   Stage2    = CIC compensator decimation filter
            %   Stage3    = halfband or lowpass decimation filter (this
            %               stage may or may not be bypassed, depending on the property
            %               settings of the object)
            %   GainStage = Gain stage to normalize the gain of the CIC decimator.
            %
            %   When  FilterSpecification is 'Coefficients':
            %
            %   Stage1    = CIC decimator filter (this stage will be implemented as a
            %               dsp.FIRDecimator System object when the Arithmetic property
            %               is set to 'Double' or 'Single', or as a dsp.CICDecimator
            %               System object when the Arithmetic property is set to
            %               'fixed'.
            %   Stage2    = FIR decimation filter
            %   Stage3    = FIR decimation filter (this stage may or may not be
            %               bypassed, depending on the property settings of the object)
            %   GainStage = Gain stage to normalize the gain of the CIC decimator.
        end

        function SystemObjectsToMfilt(in) %#ok<MANU>
            %Create mfilt filter objects and cascade for filter analysis
        end

        function checkPropertyValues(in) %#ok<MANU>
            %Verify that stopband frequency is within valid frequency range
        end

        function computeCICNullFrequencies(in) %#ok<MANU>
            % Compute frequency locations of CIC nulls
        end

        function computeFrequencySpecifications(in) %#ok<MANU>
            %Compute rate of operation and stopband frequencies for filter
            %sections.
        end

        function designCICDecimationFilter(in) %#ok<MANU>
            % Design a CIC decimation response and implement it as an FIR
            % filter when Arithmetic is 'double' or 'single', or as a CIC
            % filter when Arithmetic is 'fixed'. Output the gain of the CIC
            % filter.
        end

        function designFiltersMinOrder(in) %#ok<MANU>
            % Design cascade of minimum order decimation filters that meets
            % specifications.
        end

        function designFiltersSpecifiedCoefficients(in) %#ok<MANU>
            % Design the filter stages when user specifies the coefficients
        end

        function designFiltersSpecifiedOrders(in) %#ok<MANU>
            % Design cascade of decimation filters with specified orders,
            % passband and stopband frequencies.
        end

        function fvtool(in) %#ok<MANU>
            %fvtool Display response of filter cascade
        end

        function getDecimationFactors(in) %#ok<MANU>
            % If a design is available, return the decimation factors for
            % each stage
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify number of System inputs
        end

        function groupDelay(in) %#ok<MANU>
        end

        function isThirdStageBypassed(in) %#ok<MANU>
            % Ask if third stage has been bypassed or not
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setFilterSectionTypes(in) %#ok<MANU>
            %Determine if the third filter section is bypassed or not. If
            %not, then determine whether the third section should be a
            %halfband or a lowpass decimation filter. Set the decimation
            %factor values for each section.
        end

        function setupImpl(in) %#ok<MANU>
            % Initialize private properties to be used later
        end

        function visualizeFilterStages(in) %#ok<MANU>
            %visualizeFilterStages Display response of filter stages
            %   visualizeFilterStages(H) plots the magnitude response of the
            %   decimation filter stages and of the cascade response. If you set the
            %   FilterSpecification property to 'Design parameters' it also plots a
            %   mask based on the filter specifications.
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
        %CoefficientsStage3 Coefficients for third filter stage
        %   This property applies when FilterSpecification is
        %   'Coefficients'.
        CoefficientsStage3;

        %CoefficientsStage3DataType Data type of coefficients for stage 3
        %   This property applies when you set the FilterSpecification
        %   property to 'Coefficients'. Must be set to a signed and scaled
        %   numerictype object.
        CoefficientsStage3DataType;

        %DecimationFactor Decimation factor
        %   This property can be a scalar, a 1x2 vector, or a 1x3 vector.
        %   If it is a scalar, the decimation factor for each stage is
        %   computed automatically. If it is a 1x2 vector, the third filter
        %   stage is bypassed. The elements of the 1x2 vector specify the
        %   decimation factors for the first and second decimation stages.
        %   When FilterSpecification is set to 'Coefficients' the
        %   DecimationFactor property must be a vector.
        DecimationFactor;

        %OrderStage1 Order of first filter stage
        %   This property holds the number of CIC sections. This property
        %   applies when  FilterSpecification is 'Design parameters' and
        %   MinimumOrderDesign is false, or when FilterSpecification is
        %   'Coefficients'.
        OrderStage1;

        %OrderStage3 Order of third filter stage
        %   This property holds the order of the third filter stage. This
        %   property applies when  FilterSpecification is 'Design
        %   parameters' and MinimumOrderDesign is false.
        OrderStage3;

        %SampleRate Sample rate at the input of the filter cascade in Hertz
        SampleRate;

        %Stage3FilterSysObj Handle to System object that forms the third
        %stage
        Stage3FilterSysObj;

    end
end
