classdef CoupledAllpassFilter< handle
%CoupledAllpassFilter Coupled allpass IIR filter
%    
%   HCA = dsp.CoupledAllpassFilter returns a coupled allpass filter
%   System object(TM), HCA, that filters each channel of the input signal 
%   independently. This filtering process uses a coupled allpass filter 
%   with the default inner structures and coefficients.
%
%   HCA = dsp.CoupledAllpassFilter('PropertyName', PropertyValue, ...) 
%   returns a coupled allpass filter System object, HCA, with each 
%   specified property set to the specified value.
%
%   HCA = dsp.CoupledAllpassFilter(AllpassCoefficients1, 
%   AllpassCoefficient2) returns a coupled allpass filter System 
%   object, HCA, with 'Structure' set to 'Minimum multiplier'. The allpass 
%   coefficients for each of the two branches are set to each of the two 
%   specified values, respectively.
%
%   HCA = dsp.CoupledAllpassFilter(Structure, Coefficients1, Coefficient2) 
%   returns a coupled allpass filter System object, HCA, with
%   'Structure' set to the specified value (choice of 'Minimum multiplier',
%   'Wave Digital Filter' or 'Lattice'). The coefficients relevant to the
%   specified structure are set to the values provided.
%
%   Step method syntax:
%
%   Y = step(HCA, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. Each column of X is treated 
%   and filtered independently as a separate channel over time.
%
%   [Y, YPC] = step(HCA, X) Also returns YPC, the power-complementary
%   signal to primary output Y.
%
%   CoupledAllpassFilter methods:
%
%   step                - See preceding description for use of this method
%   release             - Allow changes to non-tunable properties' values
%                         and input characteristics
%   clone               - Create a coupled allpass filter object
%                         with the same property values and internal
%                         states
%   isLocked            - Locked status (logical)
%   reset               - Reset the internal states to zero
%   getBranches         - Return a structure with a copy of the two
%                         internal allpass filter branches
%
%   CoupledAllpassFilter properties:
%
%   Structure               - Structural realization of both internal
%                             allpass filter branches
%   AllpassCoefficients1    - Coefficients used for first branch when
%                             Structure is set to 'Minimum multiplier'
%   WDFCoefficients1        - Coefficients used for first branch when
%                             Structure is set to 'Wave Digital Filter'
%   LatticeCoefficients1    - Coefficients used for first branch when
%                             Structure is set to 'Lattice'
%   Delay                   - Delay length for first branch when
%                             PureDelayBranch is set to true
%   Gain1                   - Phase gain for first branch
%   AllpassCoefficients2    - Coefficients used for second branch when
%                             Structure is set to 'Minimum multiplier'
%   WDFCoefficients2        - Coefficients used for second branch when                          
%                             Structure is set to 'Wave Digital Filter'
%   LatticeCoefficients2    - Coefficients used for second branch when
%                             Structure is set to 'Lattice'
%   Gain2                   - Phase gain for second branch
%   Beta                    - Coupled phase gain
%   PureDelayBranch         - Replaces allpass filter in first branch with
%                             pure delay
%   ComplexConjugateCoefficients    - Enables providing complex
%                             coefficients for only the first branch. The
%                             coefficients for the second branch are
%                             automatically inferred as complex conjugate 
%                             values of the first branch coefficients
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.CoupledAllpassFilter.helpFilterAnalysis.
%
%   % EXAMPLE: Realize a Butterworth lowpass filter of order 3 using
%   % a coupled allpass structure with inner minimum multiplier structure
% 
%     Fs = 48000;    % in Hz 
%     Fc = 12000;    % in Hz 
%     frameLength = 1024;
%     [b, a] = butter(3, 2*Fc/Fs);
%     AExp = [freqz(b,a, frameLength/2); NaN];
%     [c1, c2] = tf2ca(b, a); 
%     Hca = dsp.CoupledAllpassFilter(c1(2:end), c2(2:end)); 
%     hTFE = dsp.TransferFunctionEstimator('FrequencyRange','onesided',... 
%         'SpectralAverages',2); 
%     hPlot = dsp.ArrayPlot('PlotType','Line','YLimits', [-40 5],... 
%         'YLabel','Magnitude (dB)','SampleIncrement', Fs/frameLength,... 
%         'XLabel','Frequency (Hz)','Title',...
%         'Magnitude Response, Actual (1) and Expected (2)',...
%         'ShowLegend', true); 
%     Niter = 200;
%     for k = 1:Niter 
%         in = randn(frameLength, 1); 
%         out = step(Hca, in); 
%         A = step(hTFE, in, out);
%         step(hPlot,db([A, AExp])); 
%     end
%
%   See also dsp.AllpassFilter, dsp.BiquadFilter, dsp.IIRFilter

 
%   Copyright 2012-2013 The MathWorks, Inc.

    methods
        function out=CoupledAllpassFilter
            % Accepts name-value pair arguments, as well as two different
            % syntaxes for value-only arguments.
        end

        function convertToDFILT(in) %#ok<MANU>
            % Returns equivalent dfilt to current object.
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

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function hasDiscreteStateImpl(in) %#ok<MANU>
        end

        function infoImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isSecondBranchInferred(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Re-load state if saved version was locked
        end

        function parseArithmetic(in) %#ok<MANU>
            % This overrides the same method of dsp.private.FilterAnalysis
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
            % Propagate coefficients changes to child objects
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

        function setupImpl(in) %#ok<MANU>
            % Enables structural optimization if coefficients are complex
            % conjugate of each other and input signal is real
            % ... And setup relevant branches accordingly
        end

        function stepImpl(in) %#ok<MANU>
        end

        function supportsComplexCoefficients(in) %#ok<MANU>
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
        %   property is set to true. This property is tunable.
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

        % PureDelayBranch Replaces the allpass filter in the first branch
        %   with a pure delay. When PureDelayBranch is set to true, the
        %   property holding the coefficients for the first allpass branch
        %   is disabled and Delay becomes enabled.
        %   This property should be used for better performance, when one
        %   of the two allpass branches is known to be a pure delay (e.g.
        %   for halfband filter designs)
        PureDelayBranch;

        %Structure Internal structure of allpass branches
        %   Specify the internal structure of allpass branches as
        %   one of {'Minimum multiplier' | 'Wave Digital Filter' |
        %   'Lattice'}. Each structure uses a different pair of 
        %   coefficient values, independently stored in the relevant 
        %   object property.
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
