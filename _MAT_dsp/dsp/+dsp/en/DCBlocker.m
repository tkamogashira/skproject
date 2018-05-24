classdef DCBlocker< handle
%DCBlocker Block DC component from input signal
%  H = dsp.DCBlocker returns a System object, H, that blocks the DC
%  component from each channel (i.e. column) of an input signal.  Operation
%  runs over time to continually estimate and remove the DC offset.
%
%  H = dsp.DCBlocker('PropertyName', PropertyValue, ...) returns a DC
%  blocker System object, H, with each specified property set to the
%  specified value.  You can specify additional name-value pair arguments
%  in any order as (Name1,Value1,...,NameN,ValueN).
%
%  Step method syntax:
%
%  Y = step(H, X) removes the DC component of the input X, returning the
%  result in Y.  X is a numeric, signed matrix, with time samples recorded
%  in rows and independent channels of data recorded in columns.
%
%  DCBlocker methods:
%
%   step     - See above description for use of this method
%   reset    - Reset internal states stored for mean computation
%   release  - Allow property value and input characteristics changes
%   clone    - Create DCBlocker object with same property values
%   isLocked - Locked status (logical)
%   fvtool   - Visualize lowpass filter used for DC blocking
%
%  DCBlocker properties:
%
%   Algorithm           - Algorithm for estimating DC offset
%   NormalizedBandwidth - Normalized bandwidth of lowpass IIR elliptic filter 
%   Order               - Order of lowpass IIR elliptic filter
%   Length              - Number of past input samples for FIR algorithm
%
%   % EXAMPLE: Remove a DC offset from a signal using 'FIR', 'IIR', and 
%   %'Subtract mean' techniques.  Loop to allow the IIR algorithm to converge.
%   t         = (0:0.001:100)';
%   x         = sin(30*pi*t) + 1;
%   hDCBlock1 = dsp.DCBlocker('Order', 6);  % IIR is default
%   hDCBlock2 = dsp.DCBlocker('Algorithm', 'FIR', 'Length', 100);
%   hDCBlock3 = dsp.DCBlocker('Algorithm', 'Subtract mean');
%   for idx = 1 : 100
%     range = (1:1000) + 1000*(idx-1);
%     y1 = step(hDCBlock1, x(range));
%     y2 = step(hDCBlock2, x(range));
%     y3 = step(hDCBlock3, x(range));
%   end
%   plot(t(1:1000),x(1:1000),...
%     t(1:1000),y1, ...
%     t(1:1000),y2, ...
%     t(1:1000),y3);
%   legend(sprintf('Input DC:%.3f',    mean(x)), ...
%     sprintf('IIR DC:%.3f',           mean(y1)), ...
%     sprintf('FIR DC:%.3f',           mean(y2)), ...
%     sprintf('Subtract mean DC:%.3f', mean(y3)));
%
%   See also dsp.FIRFilter, dsp.BiquadFilter.

   
%   Copyright 2013-2014 The MathWorks, Inc.

    methods
        function out=DCBlocker
            %DCBlocker Block DC component from input signal
            %  H = dsp.DCBlocker returns a System object, H, that blocks the DC
            %  component from each channel (i.e. column) of an input signal.  Operation
            %  runs over time to continually estimate and remove the DC offset.
            %
            %  H = dsp.DCBlocker('PropertyName', PropertyValue, ...) returns a DC
            %  blocker System object, H, with each specified property set to the
            %  specified value.  You can specify additional name-value pair arguments
            %  in any order as (Name1,Value1,...,NameN,ValueN).
            %
            %  Step method syntax:
            %
            %  Y = step(H, X) removes the DC component of the input X, returning the
            %  result in Y.  X is a numeric, signed matrix, with time samples recorded
            %  in rows and independent channels of data recorded in columns.
            %
            %  DCBlocker methods:
            %
            %   step     - See above description for use of this method
            %   reset    - Reset internal states stored for mean computation
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create DCBlocker object with same property values
            %   isLocked - Locked status (logical)
            %   fvtool   - Visualize lowpass filter used for DC blocking
            %
            %  DCBlocker properties:
            %
            %   Algorithm           - Algorithm for estimating DC offset
            %   NormalizedBandwidth - Normalized bandwidth of lowpass IIR elliptic filter 
            %   Order               - Order of lowpass IIR elliptic filter
            %   Length              - Number of past input samples for FIR algorithm
            %
            %   % EXAMPLE: Remove a DC offset from a signal using 'FIR', 'IIR', and 
            %   %'Subtract mean' techniques.  Loop to allow the IIR algorithm to converge.
            %   t         = (0:0.001:100)';
            %   x         = sin(30*pi*t) + 1;
            %   hDCBlock1 = dsp.DCBlocker('Order', 6);  % IIR is default
            %   hDCBlock2 = dsp.DCBlocker('Algorithm', 'FIR', 'Length', 100);
            %   hDCBlock3 = dsp.DCBlocker('Algorithm', 'Subtract mean');
            %   for idx = 1 : 100
            %     range = (1:1000) + 1000*(idx-1);
            %     y1 = step(hDCBlock1, x(range));
            %     y2 = step(hDCBlock2, x(range));
            %     y3 = step(hDCBlock3, x(range));
            %   end
            %   plot(t(1:1000),x(1:1000),...
            %     t(1:1000),y1, ...
            %     t(1:1000),y2, ...
            %     t(1:1000),y3);
            %   legend(sprintf('Input DC:%.3f',    mean(x)), ...
            %     sprintf('IIR DC:%.3f',           mean(y1)), ...
            %     sprintf('FIR DC:%.3f',           mean(y2)), ...
            %     sprintf('Subtract mean DC:%.3f', mean(y3)));
            %
            %   See also dsp.FIRFilter, dsp.BiquadFilter.
        end

        function fvtool(in) %#ok<MANU>
            % With fvtool, visualize the lowpass filter response used to estimate
            % DC.  Visualize the magnitude response, phase response, group delay,
            % impulse response, or pole-zero plot, and view the coefficients.
        end

        function getHeaderImpl(in) %#ok<MANU>
        end

        function getIconImpl(in) %#ok<MANU>
        end

        function getInputNamesImpl(in) %#ok<MANU>
        end

        function getOutputDataTypeImpl(in) %#ok<MANU>
        end

        function getOutputNamesImpl(in) %#ok<MANU>
        end

        function getOutputSizeImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % True if property should not be displayed
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function prepareFilter(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
            % Initialize internal values on first use.
        end

        function stepImpl(in) %#ok<MANU>
            % Block DC component of input signals
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Input must be numeric or fi.  Must be signed.
        end

    end
    methods (Abstract)
    end
    properties
        %Algorithm Algorithm for estimating DC offset
        %  Specify the DC offset estimating algorithm as one of 'IIR' | 'FIR' |
        %  'Subtract mean'.  The default is 'IIR'. You can visualize the IIR and
        %  FIR responses with the fvtool method.
        %
        %  'IIR' uses a recursive estimate based on a narrow, lowpass elliptic
        %  filter whose order is set using the Order property and whose bandwidth
        %  is set using the NormalizedBandwidth property. This algorithm may use
        %  less memory than FIR and be more efficient.
        %
        %  'FIR' uses a non-recursive, moving average estimate based on a finite
        %  number of past input samples that is set using the Length property.
        %  This algorithm may use more memory than IIR and be less efficient.
        %  
        %  'Subtract mean' computes the means of the columns of the input matrix,
        %  and subtracts the means from the input.  This method does not retain
        %  state between inputs.
        Algorithm;

        % Length  Number of past input samples for FIR algorithm
        % Specify the number of past inputs used to estimate the running mean.
        % This property applies when you set the Algorithm property to 'FIR'.
        % It must be a positive integer. The default value is 50.
        Length;

        %NormalizedBandwidth Normalized bandwidth of lowpass IIR elliptic filter
        %  Specify the normalized bandwidth of the IIR filter used to estimate
        %  the DC component of the input signal. This property applies when you
        %  set the Algorithm property to 'IIR'. It must be a real scalar greater
        %  than 0 and less than 1. The default value is 0.001.
        NormalizedBandwidth;

        % Order   Order of lowpass IIR elliptic filter
        % Used when Algorithm is 'IIR'.  Specify the order of a lowpass elliptic
        % filter that estimates the DC level.  This property applies when you set
        % the Algorithm property to 'IIR'.  It must be an integer greater than 3.
        % The default value is 6.
        Order;

        % pNumChannels Number of input channels
        pNumChannels;

    end
end
