classdef CoupledAllpassPair< handle
    methods
        function out=CoupledAllpassPair
        end

        function areOutputsReal(in) %#ok<MANU>
            % Get complexity info for allpass filters and beta multipliers
        end

        function arePreGainOutputsReal(in) %#ok<MANU>
            % One branch at a time - first number 1
        end

        function createAllpassBranch(in) %#ok<MANU>
        end

        function createBranchFilters(in) %#ok<MANU>
        end

        function getActiveCoeffsInBranch(in) %#ok<MANU>
        end

        function getBranches(in) %#ok<MANU>
            %getBranches Return internal allpass branches
            %   Return copies of the internal allpass branches, as a
            %   two-field structure. Each branch is an instance of
            %   dsp.AllpassFilter
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function hasDiscreteStateImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isPropertyActive(in) %#ok<MANU>
        end

        function isSecondBranchInferred(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Re-load state if saved version was locked
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Propagate coefficients changes to child objects
        end

        function propagateRelevantCoefficientsToBranches(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Default implementaion saves all public properties
        end

        function setActiveCoefficientsForBranch(in) %#ok<MANU>
        end

        function setDiscreteStateImpl(in) %#ok<MANU>
        end

        function setPrivateGainMultiplierFcnHandles(in) %#ok<MANU>
            % Define function handles for phase gain multipliers
        end

        function setupImpl(in) %#ok<MANU>
            % Create branch filter System objects and store in private
            % properties obj.PrivFilter1 and obj.PrivFilter2
        end

        function stepImpl(in) %#ok<MANU>
        end

        function supportsComplexCoefficients(in) %#ok<MANU>
        end

        function validateCurrentInputs(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Invoked at first call to setup/step, and then every time the
            % input dimensions change
        end

    end
    methods (Abstract)
    end
    properties
        %AllpassCoefficients1 Allpass polynomial coefficients of branch 1
        %   Specify the polynomial filter coefficients for the first
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Mininimum multiplier'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[0 0.5]}. This property is tunable.
        AllpassCoefficients1;

        %AllpassCoefficients2 Allpass polynomial coefficients of branch 2
        %   Specify the polynomial filter coefficients for the second
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Mininimum multiplier'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[]}. This property is tunable.
        AllpassCoefficients2;

        %Beta Coupled phase gain
        %   Specify the value of the phasor gain used in complex conjugate
        %   forms in each of the two branches, respectively, in complex 
        %   coefficient configurations.
        %   This property is only applicable when the selected Structure 
        %   property supports complex coefficients.
        %   The absolute value of this property should be 1 and its
        %   default value is 1. This property is tunable.
        Beta;

        % ComplexConjugateCoefficients Allows inferring the coefficients
        %   of the second allpass branch as complex conjugate of the first.
        %   When the input signal is real this triggers the use of an
        %   optimized structural realization. This property is only enabled
        %   if the currently selected structure supports complex
        %   coefficients, and it should only be used the filter
        %   coefficients are actually complex.
        ComplexConjugateCoefficients;

        %Delay Delay length in samples for branch 1
        %   Specify the delay length in number of samples for branch 1,
        %   when the latter operates as a pure delay.
        %   This property is only applicable when the PureDelayBranch
        %   property is set to true.
        Delay;

        %Gain1 Independent Branch 1 Phase Gain
        %   Specify the value of the independent phase gain applied to
        %   branch 1.
        %   This property can only accept values equal to '1', '-1', '0+1i'
        %   and '0-1i'. The default value for this property is '1'. 
        %   This property is nontunable.
        Gain1;

        %Gain2 Independent Branch 2 Phase Gain
        %   Specify the value of the independent phase gain applied to
        %   branch 2.
        %   This property can only accept values equal to '1', '-1', '0+1i'
        %   and '0-1i'. The default value for this property is '1'. 
        %   This property is nontunable.
        Gain2;

        %LatticeCoefficients1 Lattice coefficients of branch 1
        %   Specify the allpass lattice coefficients for the first
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Lattice'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[0.5 0]}. This property is tunable.
        LatticeCoefficients1;

        %LatticeCoefficients2 Lattice coefficients of branch 2
        %   Specify the allpass lattice coefficients for the second
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Lattice'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[]}. This property is tunable.
        LatticeCoefficients2;

        OnlyExecuteTopBranch;

        PureDelayBranch;

        Structure;

        %WDFCoefficients1 Wave Digital Filter coefficients of branch 1
        %   Specify the Wave Digital Filter coefficients for the first
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Wave Digital Filter'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[0.5 0]}. This property is tunable.
        WDFCoefficients1;

        %WDFCoefficients2 Wave Digital Filter coefficients of branch 2
        %   Specify the Wave Digital Filter coefficients for the second
        %   allpass branch. 
        %   This property is only applicable when the Structure property is
        %   set to 'Wave Digital Filter'. The value of this property can 
        %   be either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is {[]}. This property is tunable.
        WDFCoefficients2;

    end
end
