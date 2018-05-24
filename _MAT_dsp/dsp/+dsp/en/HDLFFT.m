classdef HDLFFT< handle
% Compute the fast Fourier transform(FFT) of a complex input.
% The input should be sent in natural order.
% The output will be in bit-reversed order.
% The FFT implementation is a fully-pipelined Radix-2 algorithm 
% optimized for HDL code generation.
%
%   HDLFFT = dsp.HDLFFT returns a System object, HDLFFT, 
%   that calculates the complex fast Fourier transform (FFT) of 
%   complex input. HDLFFT is optimized for HDL code generation.
%
%   HDLFFT = dsp.HDLFFT('PropertyName', PropertyValue, ...) returns a 
%   fast Fourier transform object, HDLFFT, with each specified property
%   set to the specified value.
%
%   Step method syntax:
%
%   [Y, startOut, endOut, validOut] = step(HDLFFT, X, validIn) 
%   computes the FFT, Y, of input X along the first dimension of X, of
%   length N. When the FFTLengthSource property is'Auto', the length of
%   the FFT is N and should be a power of 2.
%   When the FFTLengthSource property is 'Property', then the length of
%   the FFT is determined by the FFTLength property and can be any 
%   positive integer value of power 2 (8 <= N <= 2^16).
%   validIn, indicates the valid X samples, validOut indictes valid 
%   output samples, startOut indicates start of the output frame and
%   endOut indicates end of the output frame.
%
%   HDLFFT methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create fast Fourier transform object with same property
%              values
%   isLocked - Locked status (logical)
%
%   HDLFFT properties:
%
%   Normalize          - Enables dividing output by FFT length
%   FFTLengthSource    - Source of FFT length: Property, Auto
%   FFTLength          - FFT length as an integer value 
%   RoundingMethod     - Rounding methods: 'Ceiling','Convergent',
%                        'Floor','Nearest','Round','Zero'                             
%   OverflowAction     - Overflow action: 'Wrap', 'Saturate'  
%   ValidInputPort     - Indicates valid input data  (optional)                                
%   StartOutputPort    - Indicates beginning of output frame (optional)                                
%   EndOutputPort      - Indicates end of output frame (optional)                                
%
%   % EXAMPLE: Use FFT to find frequency components of a signal buried
%   %          in noise.
%      % Consider a signal with two sinusoids at 250 Hz and 340 Hz,
%      % sampled at 800 Hz and corrupted with additive zero-mean random
%      % noise.
%      Fs = 800; L = 1024;
%      t = (0:L-1)'/Fs;
%      x = sin(2*pi*250*t) + 0.75*cos(2*pi*340*t);
%      y = x + .5*randn(size(x));  % adding noise 
%      hfft = dsp.HDLFFT('FFTLengthSource', 'Auto');
%      % Run the FFT for three frames to bypass the initial latency
%      for loop = 1: L:3*L
%         [YR(loop:loop+L-1), validOut(loop:loop+L-1)] = step(hfft, complex(y), true(1024,1));
%      end
%      % removing invalid data
%      YR = YR (validOut == 1);
%      %The output of the FFT is in bit reversed order and it should be
%      %put in natural order.
%      Y = YR(bitrevorder([0:1:L-1]) + 1);
%      % Plot the single-sided amplitude spectrum
%      plot(Fs/2*linspace(0,1,512), 2*abs(Y(1:512)/1024));
%      title('Single-sided amplitude spectrum of noisy signal y(t)');
%      xlabel('Frequency (Hz)'); ylabel('|Y(f)|');
%
%   See also dsp.HDLIFFT, dsp.HDLFFT.helpFixedPoint. 

     
    %   Copyright 2011-2013 The MathWorks, Inc.

    methods
        function out=HDLFFT
            % Compute the fast Fourier transform(FFT) of a complex input.
            % The input should be sent in natural order.
            % The output will be in bit-reversed order.
            % The FFT implementation is a fully-pipelined Radix-2 algorithm 
            % optimized for HDL code generation.
            %
            %   HDLFFT = dsp.HDLFFT returns a System object, HDLFFT, 
            %   that calculates the complex fast Fourier transform (FFT) of 
            %   complex input. HDLFFT is optimized for HDL code generation.
            %
            %   HDLFFT = dsp.HDLFFT('PropertyName', PropertyValue, ...) returns a 
            %   fast Fourier transform object, HDLFFT, with each specified property
            %   set to the specified value.
            %
            %   Step method syntax:
            %
            %   [Y, startOut, endOut, validOut] = step(HDLFFT, X, validIn) 
            %   computes the FFT, Y, of input X along the first dimension of X, of
            %   length N. When the FFTLengthSource property is'Auto', the length of
            %   the FFT is N and should be a power of 2.
            %   When the FFTLengthSource property is 'Property', then the length of
            %   the FFT is determined by the FFTLength property and can be any 
            %   positive integer value of power 2 (8 <= N <= 2^16).
            %   validIn, indicates the valid X samples, validOut indictes valid 
            %   output samples, startOut indicates start of the output frame and
            %   endOut indicates end of the output frame.
            %
            %   HDLFFT methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create fast Fourier transform object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   HDLFFT properties:
            %
            %   Normalize          - Enables dividing output by FFT length
            %   FFTLengthSource    - Source of FFT length: Property, Auto
            %   FFTLength          - FFT length as an integer value 
            %   RoundingMethod     - Rounding methods: 'Ceiling','Convergent',
            %                        'Floor','Nearest','Round','Zero'                             
            %   OverflowAction     - Overflow action: 'Wrap', 'Saturate'  
            %   ValidInputPort     - Indicates valid input data  (optional)                                
            %   StartOutputPort    - Indicates beginning of output frame (optional)                                
            %   EndOutputPort      - Indicates end of output frame (optional)                                
            %
            %   % EXAMPLE: Use FFT to find frequency components of a signal buried
            %   %          in noise.
            %      % Consider a signal with two sinusoids at 250 Hz and 340 Hz,
            %      % sampled at 800 Hz and corrupted with additive zero-mean random
            %      % noise.
            %      Fs = 800; L = 1024;
            %      t = (0:L-1)'/Fs;
            %      x = sin(2*pi*250*t) + 0.75*cos(2*pi*340*t);
            %      y = x + .5*randn(size(x));  % adding noise 
            %      hfft = dsp.HDLFFT('FFTLengthSource', 'Auto');
            %      % Run the FFT for three frames to bypass the initial latency
            %      for loop = 1: L:3*L
            %         [YR(loop:loop+L-1), validOut(loop:loop+L-1)] = step(hfft, complex(y), true(1024,1));
            %      end
            %      % removing invalid data
            %      YR = YR (validOut == 1);
            %      %The output of the FFT is in bit reversed order and it should be
            %      %put in natural order.
            %      Y = YR(bitrevorder([0:1:L-1]) + 1);
            %      % Plot the single-sided amplitude spectrum
            %      plot(Fs/2*linspace(0,1,512), 2*abs(Y(1:512)/1024));
            %      title('Single-sided amplitude spectrum of noisy signal y(t)');
            %      xlabel('Frequency (Hz)'); ylabel('|Y(f)|');
            %
            %   See also dsp.HDLIFFT, dsp.HDLFFT.helpFixedPoint. 
        end

        function getHeaderImpl(in) %#ok<MANU>
        end

        function getIconImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.HDLFFT System object fixed-point information
            %   dsp.HDLFFT.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.HDLFFT
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Normalize Scale result by FFT length
        %   Enables dividing FFT outputs by FFT length. 
        %   Set this property to true if the output of FFT should be divided
        %   by FFT length. The default value of this property is false
        %   and no scaling occurs.
        Normalize;

    end
end
