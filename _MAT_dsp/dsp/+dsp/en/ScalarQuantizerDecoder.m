classdef ScalarQuantizerDecoder< handle
%ScalarQuantizerDecoder Convert each index value into quantized output value
%   HSQDEC = dsp.ScalarQuantizerDecoder returns a scalar quantizer decoder
%   System object, HSQDEC, that transforms zero-based input index values
%   into quantized output values. The set of all possible quantized output
%   values or codewords is defined by the specified codebook. Input index
%   values less than 0 are set to 0 and index values greater N-1 are set to
%   N-1. N is the length of the codebook vector.
%
%   HSQDEC = dsp.ScalarQuantizerDecoder('PropertyName', PropertyValue, ...)
%   returns a scalar quantizer decoder object, HSQDEC, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Q = step(HSQDEC, I) returns the quantized output values Q corresponding
%   to the input indices I. The data type of I can be uint8, uint16,
%   uint32, int8, int16 or int32. The data type of Q is determined by
%   OutputDataType property.
%
%   Q = step(HSQDEC, I, C) uses input C as the codebook values when the
%   CodebookSource property is 'Input port'. The data type of C can be
%   double, single or fixed-point. The output Q has the same data type as
%   the codebook input C.
%
%   ScalarQuantizerDecoder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create scalar quantizer decoder object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ScalarQuantizerDecoder properties:
%
%   CodebookSource - How to specify code book values
%   Codebook       - Code book
%   OutputDataType - Data type of codebook and quantized output
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.ScalarQuantizerDecoder.helpFixedPoint.
%
%   % EXAMPLE: Given a codebook and index values as inputs, determine the
%   %          corresponding output quantized values.
%       codebook = single([-2.1655 -1.3238 -0.7365 -0.2249 0.2726, ...
%           0.7844 1.3610 2.1599]);
%       indices = uint8([1 3 5 7 6 4 2 0]);
%       hsqdec = dsp.ScalarQuantizerDecoder;
%       hsqdec.CodebookSource = 'Input port';
%       qout = step(hsqdec, indices, codebook);
%
%   See also dsp.ScalarQuantizerEncoder,
%            dsp.ScalarQuantizerDecoder.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ScalarQuantizerDecoder
            %ScalarQuantizerDecoder Convert each index value into quantized output value
            %   HSQDEC = dsp.ScalarQuantizerDecoder returns a scalar quantizer decoder
            %   System object, HSQDEC, that transforms zero-based input index values
            %   into quantized output values. The set of all possible quantized output
            %   values or codewords is defined by the specified codebook. Input index
            %   values less than 0 are set to 0 and index values greater N-1 are set to
            %   N-1. N is the length of the codebook vector.
            %
            %   HSQDEC = dsp.ScalarQuantizerDecoder('PropertyName', PropertyValue, ...)
            %   returns a scalar quantizer decoder object, HSQDEC, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Q = step(HSQDEC, I) returns the quantized output values Q corresponding
            %   to the input indices I. The data type of I can be uint8, uint16,
            %   uint32, int8, int16 or int32. The data type of Q is determined by
            %   OutputDataType property.
            %
            %   Q = step(HSQDEC, I, C) uses input C as the codebook values when the
            %   CodebookSource property is 'Input port'. The data type of C can be
            %   double, single or fixed-point. The output Q has the same data type as
            %   the codebook input C.
            %
            %   ScalarQuantizerDecoder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create scalar quantizer decoder object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ScalarQuantizerDecoder properties:
            %
            %   CodebookSource - How to specify code book values
            %   Codebook       - Code book
            %   OutputDataType - Data type of codebook and quantized output
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.ScalarQuantizerDecoder.helpFixedPoint.
            %
            %   % EXAMPLE: Given a codebook and index values as inputs, determine the
            %   %          corresponding output quantized values.
            %       codebook = single([-2.1655 -1.3238 -0.7365 -0.2249 0.2726, ...
            %           0.7844 1.3610 2.1599]);
            %       indices = uint8([1 3 5 7 6 4 2 0]);
            %       hsqdec = dsp.ScalarQuantizerDecoder;
            %       hsqdec.CodebookSource = 'Input port';
            %       qout = step(hsqdec, indices, codebook);
            %
            %   See also dsp.ScalarQuantizerEncoder,
            %            dsp.ScalarQuantizerDecoder.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.ScalarQuantizerDecoder System
            %               object fixed-point information
            %   dsp.ScalarQuantizerDecoder.helpFixedPoint displays
            %   information about fixed-point properties and operations of the
            %   dsp.ScalarQuantizerDecoder System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % If the codebook comes from input port, output port will match
        end

    end
    methods (Abstract)
    end
    properties
        %Codebook Code book
        %   Specify the code book as a vector of quantized output values that
        %   correspond to each index value. This property is applicable when
        %   the CodebookSource property is 'Property'. The default value of
        %   this property is 1:10. This property is tunable.
        Codebook;

        %CodebookSource How to specify code book values
        %   Specify how to determine the code book values as one of
        %   [{'Property'} | 'Input port'].
        CodebookSource;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as a signed or unsigned
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype(true, 16).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %OutputDataType Data type of codebook and quantized output
        %   Specify the data type of the codebook and quantized output values
        %   as one of ['Same as input' | {'double'} | 'single' | 'Custom'].
        %   This property is applicable when the CodebookSource property is
        %   'Property'.
        OutputDataType;

    end
end
