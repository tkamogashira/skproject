classdef HDLIFFT< handle
% Compute the inverse fast Fourier transform(IFFT) of a complex input.
% The input should be sent in natural order.
% The output will be in bit-reversed order.
% The FFT implementation is a fully-pipelined Radix-2 algorithm 
% optimized for HDL code generation.
%
%   HDLIFFT = dsp.HDLIFFT returns a System object, HDLIFFT, that
%   calculates the inverse complex fast Fourier transform (IFFT) of a 
%   complex input. HDLIFFT is optimized for HDL code generation.
%
%   HDLIFFT = dsp.HDLIFFT('PropertyName', PropertyValue, ...) returns 
%   a inverse fast Fourier transform object, HDLIFFT, with each 
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   [Y, startOut, endOut, validOut] = step(HDLIFFT, X, validIn) 
%   computes the IFFT, Y, of input X along the first dimension of X, of
%   length N. When the FFTLengthSource property is'Auto', the length of
%   the IFFT is N and should be a power of 2.
%   When the FFTLengthSource property is 'Property', then the length of
%   the IFFT is determined by the FFTLength property and can be any 
%   positive integer value of power 2 (8 <= N <= 2^16).
%   validIn, indicates the valid X samples, validOut indictes valid 
%   output samples, startOut indicates start of the output frame and
%   endOut indicates end of the output frame.
%
%   HDLIFFT methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create fast Fourier transform object with same property
%              values
%   isLocked - Locked status (logical)
%
%   HDLIFFT properties:
%
%   Normalize         - Enables dividing output by FFT length
%   FFTLengthSource   - Source of FFT length: Property, Auto
%   FFTLength         - IFFT length as an integer value
%   RoundingMethod    - Rounding methods:'Ceiling','Convergent',
%                       'Floor','Nearest','Round','Zero'                              
%   OverflowAction    - Overflow action: 'Wrap', 'Saturate'  
%   ValidInputPort    - Indicates valid input data (optional)                              
%   StartOutputPort   - Indicates beginning of output frame (optional)                                
%   EndOutputPort     - Indicates end of output frame (optional)                                
%
%   %EXAMPLE: Use FFT to analyze the energy content in a sequence. Set
%   %the FFT coefficients which represent less than 0.1% of the total  
%   %energy to 0 and reconstruct the sequence using IFFT. 
%    Fs = 40; L = 128;
%    t = (0:L-1)'/Fs;  
%    x = sin(2*pi*10*t) + 0.75*cos(2*pi*15*t); 
%    y = x + .5*randn(size(x));  % Adding noise signal
%    hfft = dsp.HDLFFT('FFTLengthSource', 'Auto');
%    hifft = dsp.HDLIFFT('FFTLengthSource','Auto', 'Normalize', true);
%    % Run the FFT for three frames to bypass the initial latency.
%    X = complex(zeros(3*L, 1));
%    XValidOut = false(3*L, 1);
%    for loop = 1: L:3*L
%        [XR(loop:loop+L-1), XvalidOut(loop:loop+L-1)] = step(hfft, complex(x), true(128,1));
%    end
%    % removing invalid data
%    XR = XR (XvalidOut == 1); 
%    %The output of the FFT is in bit reversed order and it should be
%    %put in natural order.
%    X = XR(bitrevorder([0:1:L-1]) + 1);
%    [XX, ind] = sort(abs(transpose(X(1:L))),1,'descend');
%    XXn = sqrt(cumsum(XX.^2))/norm(XX);
%    ii = find(XXn > 0.999, 1);
%    disp(['Number of FFT coefficients that represent 99.9% of the ', ...
%    'total energy in the sequence: ', num2str(ii)]);  
% 
%    XXt = complex(zeros(L,1));
%    XXt(ind(1:ii)) = X(ind(1:ii));
%    % Run the IFFT for three frames to bypass the initial latency.
%    xt=complex(zeros(3*L,1));
%    xtValidOut = false(3*L, 1);
%    for loop = 1: L:3*L
%        [xtr(loop:loop+L-1), xtValidOut(loop:loop+L-1)] = step(hifft, complex(XXt), true(128,1));
%    end
%    % removing invalid data
%    xtr = xtr (xtValidOut == 1);
%    %The output of the FFT is in bit reversed order and it should be
%    %put in natural order.
%    xt = xtr(bitrevorder([0:1:L-1]) + 1);
%    %Verify the reconstructed signal matches the original
%    norm(x-transpose(xt(1:L)))
%
%   See also dsp.HDLFFT, dsp.HDLIFFT.helpFixedPoint.

     
    %   Copyright 2011-2013 The MathWorks, Inc.

    methods
        function out=HDLIFFT
            % Compute the inverse fast Fourier transform(IFFT) of a complex input.
            % The input should be sent in natural order.
            % The output will be in bit-reversed order.
            % The FFT implementation is a fully-pipelined Radix-2 algorithm 
            % optimized for HDL code generation.
            %
            %   HDLIFFT = dsp.HDLIFFT returns a System object, HDLIFFT, that
            %   calculates the inverse complex fast Fourier transform (IFFT) of a 
            %   complex input. HDLIFFT is optimized for HDL code generation.
            %
            %   HDLIFFT = dsp.HDLIFFT('PropertyName', PropertyValue, ...) returns 
            %   a inverse fast Fourier transform object, HDLIFFT, with each 
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   [Y, startOut, endOut, validOut] = step(HDLIFFT, X, validIn) 
            %   computes the IFFT, Y, of input X along the first dimension of X, of
            %   length N. When the FFTLengthSource property is'Auto', the length of
            %   the IFFT is N and should be a power of 2.
            %   When the FFTLengthSource property is 'Property', then the length of
            %   the IFFT is determined by the FFTLength property and can be any 
            %   positive integer value of power 2 (8 <= N <= 2^16).
            %   validIn, indicates the valid X samples, validOut indictes valid 
            %   output samples, startOut indicates start of the output frame and
            %   endOut indicates end of the output frame.
            %
            %   HDLIFFT methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create fast Fourier transform object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   HDLIFFT properties:
            %
            %   Normalize         - Enables dividing output by FFT length
            %   FFTLengthSource   - Source of FFT length: Property, Auto
            %   FFTLength         - IFFT length as an integer value
            %   RoundingMethod    - Rounding methods:'Ceiling','Convergent',
            %                       'Floor','Nearest','Round','Zero'                              
            %   OverflowAction    - Overflow action: 'Wrap', 'Saturate'  
            %   ValidInputPort    - Indicates valid input data (optional)                              
            %   StartOutputPort   - Indicates beginning of output frame (optional)                                
            %   EndOutputPort     - Indicates end of output frame (optional)                                
            %
            %   %EXAMPLE: Use FFT to analyze the energy content in a sequence. Set
            %   %the FFT coefficients which represent less than 0.1% of the total  
            %   %energy to 0 and reconstruct the sequence using IFFT. 
            %    Fs = 40; L = 128;
            %    t = (0:L-1)'/Fs;  
            %    x = sin(2*pi*10*t) + 0.75*cos(2*pi*15*t); 
            %    y = x + .5*randn(size(x));  % Adding noise signal
            %    hfft = dsp.HDLFFT('FFTLengthSource', 'Auto');
            %    hifft = dsp.HDLIFFT('FFTLengthSource','Auto', 'Normalize', true);
            %    % Run the FFT for three frames to bypass the initial latency.
            %    X = complex(zeros(3*L, 1));
            %    XValidOut = false(3*L, 1);
            %    for loop = 1: L:3*L
            %        [XR(loop:loop+L-1), XvalidOut(loop:loop+L-1)] = step(hfft, complex(x), true(128,1));
            %    end
            %    % removing invalid data
            %    XR = XR (XvalidOut == 1); 
            %    %The output of the FFT is in bit reversed order and it should be
            %    %put in natural order.
            %    X = XR(bitrevorder([0:1:L-1]) + 1);
            %    [XX, ind] = sort(abs(transpose(X(1:L))),1,'descend');
            %    XXn = sqrt(cumsum(XX.^2))/norm(XX);
            %    ii = find(XXn > 0.999, 1);
            %    disp(['Number of FFT coefficients that represent 99.9% of the ', ...
            %    'total energy in the sequence: ', num2str(ii)]);  
            % 
            %    XXt = complex(zeros(L,1));
            %    XXt(ind(1:ii)) = X(ind(1:ii));
            %    % Run the IFFT for three frames to bypass the initial latency.
            %    xt=complex(zeros(3*L,1));
            %    xtValidOut = false(3*L, 1);
            %    for loop = 1: L:3*L
            %        [xtr(loop:loop+L-1), xtValidOut(loop:loop+L-1)] = step(hifft, complex(XXt), true(128,1));
            %    end
            %    % removing invalid data
            %    xtr = xtr (xtValidOut == 1);
            %    %The output of the FFT is in bit reversed order and it should be
            %    %put in natural order.
            %    xt = xtr(bitrevorder([0:1:L-1]) + 1);
            %    %Verify the reconstructed signal matches the original
            %    norm(x-transpose(xt(1:L)))
            %
            %   See also dsp.HDLFFT, dsp.HDLIFFT.helpFixedPoint.
        end

        function getHeaderImpl(in) %#ok<MANU>
        end

        function getIconImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.HDLIFFT System object fixed-point information
            %   dsp.HDLIFFT.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.HDLIFFT
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
