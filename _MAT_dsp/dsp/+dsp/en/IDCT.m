classdef IDCT< handle
%IDCT   Inverse discrete cosine transform (IDCT)
%   HIDCT = dsp.IDCT returns a System object, HIDCT, used to compute the
%   inverse discrete cosine transform of a real or complex input signal.
%
%   HIDCT = dsp.IDCT('PropertyName', PropertyValue, ...) returns an inverse
%   discrete cosine transform System object, HIDCT, with each specified
%   property set to the specified value.
%
%   The System object computes the DCT along each column for inputs, where
%   the columns must be of power-of-2 length.
%
%   Step method syntax:
%
%   Y = step(HIDCT, X) computes the inverse discrete cosine transform, Y,
%   of input X.
%
%   IDCT methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create inverse discrete cosine transform object with same
%              property values
%   isLocked - Locked status (logical)
%
%   IDCT properties:
%
%   SineComputation - Method to compute sines and cosines
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.IDCT.helpFixedPoint.
%
%   % EXAMPLE: Use DCT to analyze the energy content in a sequence. Set
%   % the DCT coefficients which represent less than 0.1% of the total  
%   % energy to 0 and reconstruct the sequence using IDCT. 
%       x = (1:128).' + 50*cos((1:128).'*2*pi/40);
%       hdct = dsp.DCT;
%       X = step(hdct, x);
%       [XX, ind] = sort(abs(X),1,'descend');
%       ii = 1;
%       while (norm([XX(1:ii);zeros(128-ii,1)]) <= 0.999*norm(XX))
%           ii = ii+1;
%       end
%       disp(['Number of DCT coefficients that represent 99.9% of the', ...
%       ' total energy in the sequence: ',num2str(ii)]);  
%
%       XXt = zeros(128,1);
%       XXt(ind(1:ii)) = X(ind(1:ii));
%       hidct = dsp.IDCT;
%       xt = step(hidct, XXt);
%       plot(1:128,[x xt]);
%       legend('Original signal','Reconstructed signal','location','best');
%
%   See also dsp.DCT, dsp.FFT, dsp.IFFT.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=IDCT
            %IDCT   Inverse discrete cosine transform (IDCT)
            %   HIDCT = dsp.IDCT returns a System object, HIDCT, used to compute the
            %   inverse discrete cosine transform of a real or complex input signal.
            %
            %   HIDCT = dsp.IDCT('PropertyName', PropertyValue, ...) returns an inverse
            %   discrete cosine transform System object, HIDCT, with each specified
            %   property set to the specified value.
            %
            %   The System object computes the DCT along each column for inputs, where
            %   the columns must be of power-of-2 length.
            %
            %   Step method syntax:
            %
            %   Y = step(HIDCT, X) computes the inverse discrete cosine transform, Y,
            %   of input X.
            %
            %   IDCT methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create inverse discrete cosine transform object with same
            %              property values
            %   isLocked - Locked status (logical)
            %
            %   IDCT properties:
            %
            %   SineComputation - Method to compute sines and cosines
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.IDCT.helpFixedPoint.
            %
            %   % EXAMPLE: Use DCT to analyze the energy content in a sequence. Set
            %   % the DCT coefficients which represent less than 0.1% of the total  
            %   % energy to 0 and reconstruct the sequence using IDCT. 
            %       x = (1:128).' + 50*cos((1:128).'*2*pi/40);
            %       hdct = dsp.DCT;
            %       X = step(hdct, x);
            %       [XX, ind] = sort(abs(X),1,'descend');
            %       ii = 1;
            %       while (norm([XX(1:ii);zeros(128-ii,1)]) <= 0.999*norm(XX))
            %           ii = ii+1;
            %       end
            %       disp(['Number of DCT coefficients that represent 99.9% of the', ...
            %       ' total energy in the sequence: ',num2str(ii)]);  
            %
            %       XXt = zeros(128,1);
            %       XXt(ind(1:ii)) = X(ind(1:ii));
            %       hidct = dsp.IDCT;
            %       xt = step(hidct, XXt);
            %       plot(1:128,[x xt]);
            %       legend('Original signal','Reconstructed signal','location','best');
            %
            %   See also dsp.DCT, dsp.FFT, dsp.IFFT.
        end

    end
    methods (Abstract)
    end
end
