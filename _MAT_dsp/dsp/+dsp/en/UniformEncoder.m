classdef UniformEncoder< handle
%UniformEncoder Quantize and encode floating-point input into integer output
%   HUE = dsp.UniformEncoder returns a System object, HUE, that quantizes
%   floating-point input samples and encodes them as integers using
%   2n-level quantization, where n is an integer.
%
%   HUE = dsp.UniformEncoder('PropertyName', PropertyValue, ...) returns an
%   uniform encoder System object, HUE, with each specified property set to
%   the specified value.
%
%   HUE = dsp.UniformEncoder(PEAKVALUE, NUMBITS, 'PropertyName',
%   PropertyValue, ...) returns a uniform encoder System object, HUE, with
%   PeakValue property set to PEAKVALUE, NumBits property set to NUMBITS
%   and other specified properties set to the specified values.
%
%   The System object performs the following two operations on each
%   floating-point sample in the input vector or matrix: 1. Quantizes the
%   value using the same precision 2. Encodes the quantized floating-point
%   value to an integer value. The System object operations adhere to the
%   definition for uniform encoding specified in ITU-T Recommendation
%   G.701.
%
%   Step method syntax:
%
%   Y = step(HUE, X) quantizes and encodes the input X to Y. Input X can
%   be real or complex, double or single precision. The output data types
%   that the System object uses are shown in the table below.
%       +-----------------------------------------------+
%       |  NumBits  | Unsigned integer | Signed integer |
%       |-----------+------------------+----------------|
%       |  2 to 8   |       uint8      |      int8      |
%       |  9 to 16  |       uint16     |      int16     |
%       |  17 to 32 |       uint32     |      int32     |
%       +-----------------------------------------------+
%
%   UniformEncoder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create uniform encoder object with same property values
%   isLocked - Locked status (logical)
%
%   UniformEncoder properties:
%
%   PeakValue      - Largest input amplitude to be encoded
%   NumBits        - Number of bits needed to represent the output
%   OutputDataType - Data type of output
%
%   % EXAMPLE: Use UniformEncoder System object to encode a sequence.
%       hue = dsp.UniformEncoder;
%       hue.PeakValue = 2;
%       hue.NumBits = 4;
%       hue.OutputDataType = 'Signed integer';
%       x = [-1:0.01:1]'; % Create an input sequence
%       x_encoded = step(hue, x);
%       plot(x, x_encoded,'.'); 
%       xlabel('Input'); ylabel('Encoded Output'); grid
%       
%   See also dsp.UniformDecoder.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=UniformEncoder
            %UniformEncoder Quantize and encode floating-point input into integer output
            %   HUE = dsp.UniformEncoder returns a System object, HUE, that quantizes
            %   floating-point input samples and encodes them as integers using
            %   2n-level quantization, where n is an integer.
            %
            %   HUE = dsp.UniformEncoder('PropertyName', PropertyValue, ...) returns an
            %   uniform encoder System object, HUE, with each specified property set to
            %   the specified value.
            %
            %   HUE = dsp.UniformEncoder(PEAKVALUE, NUMBITS, 'PropertyName',
            %   PropertyValue, ...) returns a uniform encoder System object, HUE, with
            %   PeakValue property set to PEAKVALUE, NumBits property set to NUMBITS
            %   and other specified properties set to the specified values.
            %
            %   The System object performs the following two operations on each
            %   floating-point sample in the input vector or matrix: 1. Quantizes the
            %   value using the same precision 2. Encodes the quantized floating-point
            %   value to an integer value. The System object operations adhere to the
            %   definition for uniform encoding specified in ITU-T Recommendation
            %   G.701.
            %
            %   Step method syntax:
            %
            %   Y = step(HUE, X) quantizes and encodes the input X to Y. Input X can
            %   be real or complex, double or single precision. The output data types
            %   that the System object uses are shown in the table below.
            %       +-----------------------------------------------+
            %       |  NumBits  | Unsigned integer | Signed integer |
            %       |-----------+------------------+----------------|
            %       |  2 to 8   |       uint8      |      int8      |
            %       |  9 to 16  |       uint16     |      int16     |
            %       |  17 to 32 |       uint32     |      int32     |
            %       +-----------------------------------------------+
            %
            %   UniformEncoder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create uniform encoder object with same property values
            %   isLocked - Locked status (logical)
            %
            %   UniformEncoder properties:
            %
            %   PeakValue      - Largest input amplitude to be encoded
            %   NumBits        - Number of bits needed to represent the output
            %   OutputDataType - Data type of output
            %
            %   % EXAMPLE: Use UniformEncoder System object to encode a sequence.
            %       hue = dsp.UniformEncoder;
            %       hue.PeakValue = 2;
            %       hue.NumBits = 4;
            %       hue.OutputDataType = 'Signed integer';
            %       x = [-1:0.01:1]'; % Create an input sequence
            %       x_encoded = step(hue, x);
            %       plot(x, x_encoded,'.'); 
            %       xlabel('Input'); ylabel('Encoded Output'); grid
            %       
            %   See also dsp.UniformDecoder.
        end

    end
    methods (Abstract)
    end
    properties
        %NumBits Number of bits needed to represent the output
        %   Specify the number of bits needed to represent the integer output
        %   as an integer value between 2 and 32. The number of levels at which
        %   the System object quantizes the floating-point input is 2^NumBits.
        %   The default value of this property is 8.
        NumBits;

        %OutputDataType Data type of output
        %   Specify the data type of the System object's output as [{'Unsigned
        %   integer'} | 'Signed integer']. Unsigned outputs are uint8, uint16,
        %   or uint32, while signed outputs are int8, int16, or int32. The
        %   quantized inputs are linearly (uniformly) mapped to the
        %   intermediate integers in the range [0, 2^(B-1)] when this property
        %   is 'Unsigned integer', and in the range of [-2^(B-1), 2^(B-1)-1]
        %   when this property is 'Signed integer', where B is specified in the
        %   NumBits property.
        OutputDataType;

        %PeakValue Largest input amplitude to be encoded
        %   Specify the largest input amplitude to be encoded, as a
        %   non-negative numeric scalar. Real or imaginary input values greater
        %   than (1-2^(1-NumBits))*PeakValue or less than -PeakValue saturate
        %   (independently for complex inputs) at those limits, where B is
        %   specified in the NumBits property. The default value of this
        %   property is 1.
        PeakValue;

    end
end
