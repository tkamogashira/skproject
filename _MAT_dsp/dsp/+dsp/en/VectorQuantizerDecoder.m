classdef VectorQuantizerDecoder< handle
%VectorQuantizerDecoder Find vector quantizer codeword for given index
%value
%   HVQDEC = dsp.VectorQuantizerDecoder returns a vector quantizer decoder
%   System object, HVQDEC, that finds a vector quantizer codeword that
%   corresponds to given, zero-based index value. Each column of the
%   Codebook property represents a codeword.
%
%   HVQDEC = dsp.VectorQuantizerDecoder('PropertyName', PropertyValue, ...)
%   returns a System object HVQDEC with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Q = step(HVQDEC, I) returns the quantized output values Q corresponding
%   to the input indices I. The data type of I can be uint8, uint16,
%   uint32, int8, int16 or int32. The data type of Q is determined by
%   OutputDataType property.
%
%   Q = step(HVQDEC, I, C) uses input C as the codebook values when the
%   CodebookSource property is 'Input port'. The data type of C can be
%   double, single or fixed-point. The output Q has the same data type as
%   the codebook input C.
%
%   VectorQuantizerDecoder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create vector quantizer decoder object with same property
%              values
%   isLocked - Locked status (logical)
%
%   VectorQuantizerDecoder properties:
%
%   CodebookSource - Source of code book values
%   Codebook       - Code book
%   OutputDataType - Data type of codebook and quantized output
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.VectorQuantizerDecoder.helpFixedPoint.
%
%   % EXAMPLE: Given index values as an input, determine the corresponding
%   % vector quantized codewords for a specified codebook.
%       hvqdec = dsp.VectorQuantizerDecoder;
%       hvqdec.Codebook = [1 10 100;2 20 200;3 30 300];
%       indices = uint8([1 0 2 0]);
%       qout = step(hvqdec, indices)
%
%    See also dsp.VectorQuantizerEncoder, dsp.ScalarQuantizerDecoder,
%             dsp.VectorQuantizerDecoder.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=VectorQuantizerDecoder
            %VectorQuantizerDecoder Find vector quantizer codeword for given index
            %value
            %   HVQDEC = dsp.VectorQuantizerDecoder returns a vector quantizer decoder
            %   System object, HVQDEC, that finds a vector quantizer codeword that
            %   corresponds to given, zero-based index value. Each column of the
            %   Codebook property represents a codeword.
            %
            %   HVQDEC = dsp.VectorQuantizerDecoder('PropertyName', PropertyValue, ...)
            %   returns a System object HVQDEC with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Q = step(HVQDEC, I) returns the quantized output values Q corresponding
            %   to the input indices I. The data type of I can be uint8, uint16,
            %   uint32, int8, int16 or int32. The data type of Q is determined by
            %   OutputDataType property.
            %
            %   Q = step(HVQDEC, I, C) uses input C as the codebook values when the
            %   CodebookSource property is 'Input port'. The data type of C can be
            %   double, single or fixed-point. The output Q has the same data type as
            %   the codebook input C.
            %
            %   VectorQuantizerDecoder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create vector quantizer decoder object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   VectorQuantizerDecoder properties:
            %
            %   CodebookSource - Source of code book values
            %   Codebook       - Code book
            %   OutputDataType - Data type of codebook and quantized output
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.VectorQuantizerDecoder.helpFixedPoint.
            %
            %   % EXAMPLE: Given index values as an input, determine the corresponding
            %   % vector quantized codewords for a specified codebook.
            %       hvqdec = dsp.VectorQuantizerDecoder;
            %       hvqdec.Codebook = [1 10 100;2 20 200;3 30 300];
            %       indices = uint8([1 0 2 0]);
            %       qout = step(hvqdec, indices)
            %
            %    See also dsp.VectorQuantizerEncoder, dsp.ScalarQuantizerDecoder,
            %             dsp.VectorQuantizerDecoder.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.VectorQuantizerDecoder System
            %               object fixed-point information
            %   dsp.VectorQuantizerDecoder.helpFixedPoint displays
            %   information about fixed-point properties and operations of the
            %   dsp.VectorQuantizerDecoder System object.
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
        %   Specify quantized output values as a k-by-N matrix, where k >= 1
        %   and N >= 1. Each column of the codebook matrix is a codeword, and
        %   each codeword corresponds to an index value. This property is
        %   applicable when the CodebookSource property is 'Property'. The 
        %   default value of this property is 
        %           [1.5 13.3 136.4 6.8
        %            2.5 14.3 137.4 7.8
        %            3.5 15.3 138.4 8.8].
        %   This property is tunable.
        Codebook;

        %CodebookSource Source of code book values
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
