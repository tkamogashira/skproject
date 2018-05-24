classdef LPCToLSF< handle
%LPCToLSF Convert linear prediction coefficients to line spectral
%frequencies
%   HLPC2LSF = dsp.LPCToLSF returns a System object, HLPC2LSF, that
%   converts linear prediction coefficients (LPCs) to line spectral
%   frequencies (LSFs).
%
%   HLPC2LSF = dsp.LPCToLSF('PropertyName', PropertyValue, ...) returns an
%   LPC to LSF System object, HLPC2LSF, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   LSF = step(HLPC2LSF, A) converts the LPC coefficients, A, to line
%   spectral frequencies, LSF, in the range (0 pi). The System object
%   operates along the columns of the input A.
%
%   [..., STATUS] = step(HLPC2LSF, A) also returns the status flag, STATUS,
%   indicating if the current output is valid when the ExceptionOutputPort
%   property is true.
%
%   LPCToLSF methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create LPC to LSF object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset LSF values used for overwriting invalid output
%
%   LPCToLSF properties:
%
%   NumCoarseGridPoints            - Number of coarse subintervals used for
%                                    finding roots (LSP values)
%   NumBisects                     - Value of bisection refinement used for
%                                    finding roots
%   ExceptionOutputPort            - Produces an output with the validity
%                                    status of the LSF output
%   OverwriteInvalidOutput         - Enables overwriting invalid output
%                                    with previous output
%   FirstOutputValuesSource        - Source of values for first output when
%                                    output is invalid
%   FirstOutputValues              - Value of the first output
%   NonUnityFirstCoefficientAction - Action to take when first LPC
%                                    coefficient is not 1
%
%   % EXAMPLE: Convert to LPC coefficients to LSF.
%       a = [1.0000  0.6149  0.9899  0.0000  0.0031 -0.0082]';
%       hlpc2lsf = dsp.LPCToLSF;
%       y = step(hlpc2lsf, a); % Convert to LSF coefficients
%
%   See also dsp.LSFToLPC, dsp.LPCToLSP.

 
%   Copyright 2009-2013 The MathWorks, Inc.

    methods
        function out=LPCToLSF
            %LPCToLSF Convert linear prediction coefficients to line spectral
            %frequencies
            %   HLPC2LSF = dsp.LPCToLSF returns a System object, HLPC2LSF, that
            %   converts linear prediction coefficients (LPCs) to line spectral
            %   frequencies (LSFs).
            %
            %   HLPC2LSF = dsp.LPCToLSF('PropertyName', PropertyValue, ...) returns an
            %   LPC to LSF System object, HLPC2LSF, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   LSF = step(HLPC2LSF, A) converts the LPC coefficients, A, to line
            %   spectral frequencies, LSF, in the range (0 pi). The System object
            %   operates along the columns of the input A.
            %
            %   [..., STATUS] = step(HLPC2LSF, A) also returns the status flag, STATUS,
            %   indicating if the current output is valid when the ExceptionOutputPort
            %   property is true.
            %
            %   LPCToLSF methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create LPC to LSF object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset LSF values used for overwriting invalid output
            %
            %   LPCToLSF properties:
            %
            %   NumCoarseGridPoints            - Number of coarse subintervals used for
            %                                    finding roots (LSP values)
            %   NumBisects                     - Value of bisection refinement used for
            %                                    finding roots
            %   ExceptionOutputPort            - Produces an output with the validity
            %                                    status of the LSF output
            %   OverwriteInvalidOutput         - Enables overwriting invalid output
            %                                    with previous output
            %   FirstOutputValuesSource        - Source of values for first output when
            %                                    output is invalid
            %   FirstOutputValues              - Value of the first output
            %   NonUnityFirstCoefficientAction - Action to take when first LPC
            %                                    coefficient is not 1
            %
            %   % EXAMPLE: Convert to LPC coefficients to LSF.
            %       a = [1.0000  0.6149  0.9899  0.0000  0.0031 -0.0082]';
            %       hlpc2lsf = dsp.LPCToLSF;
            %       y = step(hlpc2lsf, a); % Convert to LSF coefficients
            %
            %   See also dsp.LSFToLPC, dsp.LPCToLSP.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %ExceptionOutputPort Produces an output with the validity status of
        %                    the LSF output
        %   Set this property to true to return a second output that
        %   indicates whether the computed LSF values are valid. The output
        %   is a vector of length equal to the number of channels; logical
        %   values of 1 indicate valid output and logical values of 0
        %   indicate invalid output. The LSF outputs are invalid when the
        %   System object fails to find all the LSF values or when the
        %   input LPCs are unstable. The default value of this property is
        %   false.
        ExceptionOutputPort;

        %FirstOutputValues Value of the first output
        %   Specify a numeric vector of LSF values for overwriting an
        %   invalid first output. The length of this vector must be one
        %   less than the length of the input LPC vector. For multichannel
        %   inputs, this property can be set to a matrix with the same
        %   number of channels as the input, or one vector that will be
        %   applied to every channel. The default value of this property is
        %   an empty vector. This property is applicable when the
        %   OverwriteInvalidOutput property is true and the
        %   FirstOutputValuesSource property is 'Property'.
        FirstOutputValues;

        %FirstOutputValuesSource Source of values for first output when
        %                        output is invalid
        %   Specify the source of values for the first output when the
        %   output is invalid, as one of [{'Auto'} | 'Property']. This
        %   property is applicable when the OverwriteInvalidOutput property
        %   is true. When this property is 'Auto', the System object uses a
        %   default value for the first output. This default value
        %   corresponds to the LSF representation of an allpass filter.  
        FirstOutputValuesSource;

        %NonUnityFirstCoefficientAction Action to take when first LPC 
        %                               coefficient is not 1
        %   Specify the action that the System object should take when the
        %   first coefficient of each channel of the LPC input is not 1, as
        %   one of [{'Replace with 1'} | 'Normalize'].        
        NonUnityFirstCoefficientAction;

        %NumBisects Value of bisection refinement used for finding roots
        %   Specify the root bisection refinement value, k, used in the
        %   Chebyshev polynomial root finding method, where each line
        %   spectral pair (LSP) output is within 1/(n*2^k) of the actual
        %   LSP value. Here n is the value of the NumCoarseGridPoints
        %   property, and the System object searches a maximum of k*(n-1)
        %   points for finding the roots. The NumBisects property value k,
        %   must be a positive scalar integer. The default value of this
        %   property is 4. This property is tunable.
        NumBisects;

        %NumCoarseGridPoints Number of coarse subintervals used for finding
        %                    roots (LSP values)
        %   Specify the number of coarse subintervals, n, used for finding
        %   line spectral pairs (LSP) values, as a positive scalar integer.
        %   LSPs, which are the roots of two particular polynomials related
        %   to the input LPC polynomial, always lie in the range (-1, 1).
        %   The System object finds these roots using the Chebyshev
        %   polynomial root finding method. To compute LSF outputs, the
        %   System object computes the arc cosine of the LSPs, outputting
        %   values ranging from 0 to pi radians. The object divides the
        %   interval (-1, 1) into n subintervals and looks for roots in
        %   each subinterval. If n is set to too small a number in relation
        %   to the LPC polynomial order, the object can fail to find some
        %   of the roots. The default value of this property is 64. This
        %   property is tunable.
        NumCoarseGridPoints;

        %OverwriteInvalidOutput Enables overwriting invalid output with
        %                       previous output
        %   Specify the action that the System object should take for
        %   invalid LSF outputs. When this property is set to true, the
        %   object overwrites the invalid output with the previous output.
        %   When this property is set to false, the object does not take
        %   any action on invalid outputs, and the outputs should be
        %   ignored.
        OverwriteInvalidOutput;

    end
end
