classdef AnalyticSignal< handle
%AnalyticSignal Analytic signals of discrete-time inputs
%   HANLYTC = dsp.AnalyticSignal returns a System object, HANLYTC, that
%   computes the complex analytic signal corresponding to each channel of a
%   real M-by-N input matrix.
%
%   HANLYTC = dsp.AnalyticSignal('PropertyName', PropertyValue, ...)
%   returns an analytic signal System object, HANLYTC, with each specified
%   property set to the specified value.
%
%   HANLYTC = dsp.AnalyticSignal(FILTERORDER, 'PropertyName',
%   PropertyValue, ...) returns an analytic signal System object, HANLYTC,
%   with FilterOrder property set to FILTERORDER and other specified
%   properties set to the specified values.
%
%   The real part of the analytic signal in each channel is a replica of
%   the real input in that channel, and the imaginary part is the Hilbert
%   transform of the input. In the frequency domain, the analytic signal
%   retains the positive frequency content of the original signal while
%   zeroing-out negative frequencies and doubling the DC component. The
%   object computes the Hilbert transform using an equiripple FIR filter.
%
%   Step method syntax:
%
%   Y = step(HANLYTC, X) computes the analytic signal, Y, of the input X.
%
%   AnalyticSignal methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create analytic signal object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset filter states
%
%   AnalyticSignal properties:
%
%   FilterOrder          - Filter order used to compute Hilbert transform
%   FrameBasedProcessing - Process input in frames or as samples
%
%   % EXAMPLE: Compute the analytic signal of a sinusoidal input.
%       t = (-1:0.01:1)';
%       x = sin(4*pi*t); 
%       hanlytc = dsp.AnalyticSignal(200);   % Filter order = 200
%       y = step(hanlytc, x);
%       subplot(2,1,1), plot(t, x); 
%       title('Original Signal');
%       subplot(2,1,2), plot(t, [real(y) imag(y)]); 
%       title('Analytic signal of the input')
%       legend('Real signal', 'Imaginary signal', 'Location', 'best');
%
%   See also dsp.FFT, dsp.IFFT.

 
%   Copyright 1995-2011 The MathWorks, Inc.

    methods
        function out=AnalyticSignal
            %AnalyticSignal Analytic signals of discrete-time inputs
            %   HANLYTC = dsp.AnalyticSignal returns a System object, HANLYTC, that
            %   computes the complex analytic signal corresponding to each channel of a
            %   real M-by-N input matrix.
            %
            %   HANLYTC = dsp.AnalyticSignal('PropertyName', PropertyValue, ...)
            %   returns an analytic signal System object, HANLYTC, with each specified
            %   property set to the specified value.
            %
            %   HANLYTC = dsp.AnalyticSignal(FILTERORDER, 'PropertyName',
            %   PropertyValue, ...) returns an analytic signal System object, HANLYTC,
            %   with FilterOrder property set to FILTERORDER and other specified
            %   properties set to the specified values.
            %
            %   The real part of the analytic signal in each channel is a replica of
            %   the real input in that channel, and the imaginary part is the Hilbert
            %   transform of the input. In the frequency domain, the analytic signal
            %   retains the positive frequency content of the original signal while
            %   zeroing-out negative frequencies and doubling the DC component. The
            %   object computes the Hilbert transform using an equiripple FIR filter.
            %
            %   Step method syntax:
            %
            %   Y = step(HANLYTC, X) computes the analytic signal, Y, of the input X.
            %
            %   AnalyticSignal methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create analytic signal object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset filter states
            %
            %   AnalyticSignal properties:
            %
            %   FilterOrder          - Filter order used to compute Hilbert transform
            %   FrameBasedProcessing - Process input in frames or as samples
            %
            %   % EXAMPLE: Compute the analytic signal of a sinusoidal input.
            %       t = (-1:0.01:1)';
            %       x = sin(4*pi*t); 
            %       hanlytc = dsp.AnalyticSignal(200);   % Filter order = 200
            %       y = step(hanlytc, x);
            %       subplot(2,1,1), plot(t, x); 
            %       title('Original Signal');
            %       subplot(2,1,2), plot(t, [real(y) imag(y)]); 
            %       title('Analytic signal of the input')
            %       legend('Real signal', 'Imaginary signal', 'Location', 'best');
            %
            %   See also dsp.FFT, dsp.IFFT.
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Only floating point inputs are supported
        end

    end
    methods (Abstract)
    end
    properties
        %FilterOrder Filter order used to compute Hilbert transform
        %   Specify the order of the equiripple filter used in computing the
        %   Hilbert transform as an even integer scalar. The default value of
        %   this property is 100.
        FilterOrder;

        %FrameBasedProcessing Process input in frames or as samples
        %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %  property to false to enable sample-based processing. The default value
        %  of this property is true.
        FrameBasedProcessing;

    end
end
