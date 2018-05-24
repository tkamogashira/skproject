classdef AllpassFilter< handle
%AllpassFilter Single-section or cascaded allpass filter with
%   Minimum-multiplier, Wave Digital Filter or Lattice structure
%
%   HAP = dsp.AllpassFilter returns an allpass filter System object(TM), 
%   HAP, that filters each channel of the input signal independently using 
%   an allpass filter with the default structure and coefficients.
%
%   HAP = dsp.AllpassFilter('PropertyName', PropertyValue, ...) returns an
%   allpass System object, HAP, with each specified property set to a
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HAP, X) filters the real or complex input signal X using the
%   specified filter to produce the output Y. Each column of X is treated 
%   and filtered independently as a separate channel over time.
%
%   AllpassFilter methods:
%
%   step                - See above description for use of this method.
%   release             - Allow changes to non-tunable properties' values
%                         and input characteristics.
%   clone               - Create an allpass filter object with the same 
%                         property values and internal states.
%   isLocked            - Locked status (logical).
%   reset               - Reset the internal states to initial conditions.
%
%   AllpassFilter properties:
%
%   AllpassCoefficients - Coefficients used with 'Minimum multiplier'
%                         structure.
%   WDFCoefficients     - Coefficients used with 'Wave Digital Filter'
%                         structure.
%   LatticeCoefficients - Coefficients used with 'Lattice' structure.
%   Structure           - Internal allpass filter structure
%   InitialConditions   - Initial value(s) of filter states.
%
%   This System object supports several filter analysis methods. For more
%   information, type dsp.AllpassFilter.helpFilterAnalysis.
%
%   % EXAMPLE: Use a Regalia shelving structure with a first-order 
%   % allpass filter to boost frequency components of a random signal below
%   % 10 kHz by 6 dB
% 
%     Fs = 48000;    % in Hz
%     wc = 2*pi*10000;
%     Vo = 2;        % 6 dB
%     c = -(2-wc/Fs)/(2+wc/Fs);
%     frameLength = 1024;
%     w = (2*pi*Fs/frameLength)*(0:frameLength/2);
%     AExp = nan(size(w.')); AExp(w < wc) = 2; AExp(w > wc) = 1;
%     hAP = dsp.AllpassFilter('AllpassCoefficients',  c);
%     hTFE = dsp.TransferFunctionEstimator('FrequencyRange','onesided',... 
%         'SpectralAverages',2); 
%     hPlot = dsp.ArrayPlot('PlotType','Line','YLimits', [-5 10],... 
%         'YLabel','Magnitude (dB)','SampleIncrement', Fs/frameLength,... 
%         'XLabel','Frequency (Hz)','Title',...
%         'Magnitude Response, Actual (1) and Target (2)',...
%         'ShowLegend', true); 
%     Niter = 300;
%     for k = 1:Niter
%         in = randn(frameLength, 1);
%         shelvedOut = -(1-Vo)/2 * step(hAP, in) + (1+Vo)/2 * in;
%         Txy = step(hTFE, in, shelvedOut);
%         step(hPlot, db([Txy, AExp]))
%     end
%
%   See also dsp.BiquadFilter, dsp.IIRFilter, dsp.TransferFunctionEstimator

 
%   Copyright 2013 The MathWorks, Inc.

    methods
        function out=AllpassFilter
            % Support name-value pair arguments
        end

        function convertToDFILT(in) %#ok<MANU>
            % Returns equivalent dfilt to current object.
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % Specify the number of System inputs.
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % Specify the number of System outputs.
        end

        function hasDiscreteStateImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Re-load state if saved version was locked
        end

        function parseArithmetic(in) %#ok<MANU>
            % This overrides the same method of dsp.private.FilterAnalysis
        end

        function poly2wdf(in) %#ok<MANU>
            %poly2wdf Converts standard single-section allpass polynomial 
            % coefficients into Wave Digital Filter form.
            % Acceptable section orders are 1, 2 and 4. If the order is 4
            % then the first and third coefficents must be zeros. 
            % 
            %   % EXAMPLE: Convert a single-section dsp.AllpassFilter with
            %   % Minimum multiplier structure into an equivalent Wave 
            %   % Digital Filter form
            %   
            %   hReference = dsp.AllpassFilter(...
            %       'AllpassCoefficients', [0.1 0.2]);
            %   cPolycoeffs = hReference.AllpassCoefficients;
            %   wdfcoeffs = dsp.AllpassFilter.poly2wdf(cPolycoeffs{1});
            %   hWDFVersion = dsp.AllpassFilter(...
            %     'Structure', 'Wave Digital Filter', ...
            %     'WDFCoefficients', wdfcoeffs);
            %   % Display both filters in fvtool and verify all main
            %   % responses are equal
            %   fvtool(hReference, hWDFVersion)
            % 
            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
            % Cache initial conditions and internal states.
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Default implementaion saves all public properties
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
            % Cast complexity of input to that of output. Then
            % process in place.
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Invoked at first call to setup/step, and then every time the
            % input dimensions change
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Sanity checks already perfomed within set methods for
            % - AllpassCoefficients
            % - WDFCoefficients
            % - LatticeCoefficients
        end

        function wdf2poly(in) %#ok<MANU>
            %wdf2poly Converts single-section Wave Digital Filter allpass 
            % coefficients into standard polynomial form.
            % Acceptable section orders are 1, 2 and 4. If the order is 4
            % then the second and fourth coefficents must be zeros. 
            % 
            %   % EXAMPLE: Convert a single-section dsp.AllpassFilter with
            %   % Wave Digital Filter structure into an equivalent Minimum
            %   % multiplier form.
            %   
            %   hReference = dsp.AllpassFilter(...
            %       'Structure', 'Wave Digital Filter', ...
            %       'WDFCoefficients', [0.1 0.2]);
            %   cWdfcoeffs = hReference.WDFCoefficients;
            %   polycoeffs = dsp.AllpassFilter.wdf2poly(cWdfcoeffs{1});
            %   hMMVersion = dsp.AllpassFilter(...
            %       'AllpassCoefficients', polycoeffs);
            %   % Display both filters in fvtool and verify all main
            %   % responses are equal
            %   fvtool(hReference, hMMVersion)           
            %
            % Reference: 
            % M. Lutovac, D. Tosic, B. Evans.
            % Filter Design for Signal Processing using MATLAB and
            % Mathematica. Prentice Hall, 2001.
        end

    end
    methods (Abstract)
    end
    properties
        %AllpassCoefficients Allpass polynomial coefficients
        %   Specify the real allpass polynomial filter coefficients. This
        %   property is only applicable when the Structure property is set
        %   to 'Mininimum multiplier'. The value of this property can be
        %   either a row vector (single-section configuration) or a cell
        %   array with as many cells as filter sections. The default value 
        %   for this property is [-2^(-1/2), 1/2]. This property is 
        %   tunable.
        AllpassCoefficients;

        %InitialConditions Initial value(s) of the filter states
        %   Specify the initial value of the internal filter states. 
        %   The default value of this property is 0. Acceptable values
        %   include numeric scalar, numeric 1-D or 2-D array, and cell 
        %   array with as many cells as filter sections. The numeric scalar
        %   is used for all filter states, and the numeric 1-D or 2-D array
        %   is single-section only. The inner dimensions should match 
        %   exactly those of the internal filter states
        InitialConditions;

        %LatticeCoefficients Lattice allpass coefficients
        %   Specify the real or complex allpass coefficients as lattice
        %   reflection coefficients form. This property is only applicable 
        %   when the Structure property is set to 'Lattice'. The value of 
        %   this property can be either a row vector (single-section 
        %   configuration) or a cell array with as many cells as filter 
        %   sections. The default value for this property is 
        %   [-2^(1/2)/3, 1/2]. This propery is tunable.
        LatticeCoefficients;

        %Structure Internal allpass structure
        %   Specify the internal allpass filter implementation structure as
        %   one of {'Minimum multiplier' | 'Wave Digital Filter' |
        %   'Lattice'}. Each structure uses a different coefficients set,
        %   independently stored in the corresponding object property
        Structure;

        %WDFCoefficients Wave Digital Filter allpass coefficients
        %   Specify the real allpass coefficients in Wave Digital Filter
        %   form. This property is only applicable when the Structure 
        %   property is set to 'Wave Digital Filter'. The value of this 
        %   property can be either a row vector (single-section 
        %   configuration) or a cell array with as many cells as filter 
        %   sections. Acceptable section orders are 1, 2 and 4. If the 
        %   order is 4, then the second and fourth coefficents must be 
        %   zeros. All elements must have absolute value <= 1. The default
        %   value for this property is [1/2, -2^(1/2)/3]. This property is
        %   tunable.
        WDFCoefficients;

    end
end
