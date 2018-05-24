classdef UniformDecoder< handle
%UniformDecoder Decode integer input into floating-point output
%   HUD = dsp.UniformDecoder returns a System object, HUD, that performs
%   the inverse operation of the dsp.UniformEncoder System object, and
%   reconstructs quantized floating-point values from encoded integer
%   input. This System object adheres to the definition for uniform
%   decoding specified in ITU-T Recommendation G.701.
%
%   HUD = dsp.UniformDecoder('PropertyName', PropertyValue, ...) returns a
%   uniform decoder System object, HUD, with each specified property set to
%   the specified value.
%
%   HUD = dsp.UniformDecoder(PEAKVALUE, NUMBITS, 'PropertyName',
%   PropertyValue, ...) returns a uniform decoder System object, HUD, with
%   PeakValue property set to PEAKVALUE, NumBits property set to NUMBITS
%   and other specified properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HUD, X) reconstructs quantized floating-point output Y from
%   the encoded integer input X. Input X can be real or complex values of
%   the following six integer data types: uint8, uint16, uint32, int8,
%   int16, or int32.
%
%   UniformDecoder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create uniform decoder object with same property values
%   isLocked - Locked status (logical)
%
%   UniformDecoder properties:
%
%   PeakValue      - Largest amplitude represented in encoded input
%   NumBits        - Number of bits used to encode the input data
%   OverflowAction - Behavior when integer input is out-of-range
%   OutputDataType - Output data type as single or double
%
%   % EXAMPLE: Use UniformDecoder System object to decode an encoded
%   %          sequence.
%       hue = dsp.UniformEncoder;
%       hue.PeakValue = 2;
%       hue.NumBits = 4;
%       hue.OutputDataType = 'Signed integer';
%       x = (0:0.25:2)'; % Create an input sequence
%       hud = dsp.UniformDecoder;
%       hud.PeakValue = 2;
%       hud.NumBits = 4;
%       x_encoded = step(hue, x);
%       % Check that the last element has been saturated.
%       x_decoded = step(hud, x_encoded);
%       
%   See also dsp.UniformEncoder.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=UniformDecoder
            %UniformDecoder Decode integer input into floating-point output
            %   HUD = dsp.UniformDecoder returns a System object, HUD, that performs
            %   the inverse operation of the dsp.UniformEncoder System object, and
            %   reconstructs quantized floating-point values from encoded integer
            %   input. This System object adheres to the definition for uniform
            %   decoding specified in ITU-T Recommendation G.701.
            %
            %   HUD = dsp.UniformDecoder('PropertyName', PropertyValue, ...) returns a
            %   uniform decoder System object, HUD, with each specified property set to
            %   the specified value.
            %
            %   HUD = dsp.UniformDecoder(PEAKVALUE, NUMBITS, 'PropertyName',
            %   PropertyValue, ...) returns a uniform decoder System object, HUD, with
            %   PeakValue property set to PEAKVALUE, NumBits property set to NUMBITS
            %   and other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HUD, X) reconstructs quantized floating-point output Y from
            %   the encoded integer input X. Input X can be real or complex values of
            %   the following six integer data types: uint8, uint16, uint32, int8,
            %   int16, or int32.
            %
            %   UniformDecoder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create uniform decoder object with same property values
            %   isLocked - Locked status (logical)
            %
            %   UniformDecoder properties:
            %
            %   PeakValue      - Largest amplitude represented in encoded input
            %   NumBits        - Number of bits used to encode the input data
            %   OverflowAction - Behavior when integer input is out-of-range
            %   OutputDataType - Output data type as single or double
            %
            %   % EXAMPLE: Use UniformDecoder System object to decode an encoded
            %   %          sequence.
            %       hue = dsp.UniformEncoder;
            %       hue.PeakValue = 2;
            %       hue.NumBits = 4;
            %       hue.OutputDataType = 'Signed integer';
            %       x = (0:0.25:2)'; % Create an input sequence
            %       hud = dsp.UniformDecoder;
            %       hud.PeakValue = 2;
            %       hud.NumBits = 4;
            %       x_encoded = step(hue, x);
            %       % Check that the last element has been saturated.
            %       x_decoded = step(hud, x_encoded);
            %       
            %   See also dsp.UniformEncoder.
        end

    end
    methods (Abstract)
    end
    properties
        %NumBits Number of input bits used to encode the data
        %   Specify the number of bits used to encode the input data as an
        %   integer value between 2 and 32. The value of this property can be
        %   less than the total number of bits supplied by the input data type.
        %   To correctly decode values encoded with the UniformEncoder System
        %   object, set the NumBits property in both System objects to the same
        %   value. Type help dsp.UniformEncoder.NumBits for more information.
        %   The default value of this property is 3.
        NumBits;

        %OutputDataType Output data type as single or double
        %   Specify the data type of the output as one of ['single' |
        %   {'double'}].
        OutputDataType;

        %OverflowAction Behavior when integer input is out-of-range 
        %   Specify the System object's behavior when the integer input is
        %   outside the range representable by NumBits property value as one of
        %   [{'Saturate'} | 'Wrap'].
        OverflowAction;

        %PeakValue Largest amplitude represented in encoded input
        %   Specify the largest amplitude represented in the encoded input as a
        %   non-negative numeric scalar. To correctly decode values encoded
        %   with the UniformEncoder System object, set this property in both
        %   System objects to the same value. Type help
        %   dsp.UniformEncoder.PeakValue for more information. The default
        %   value of this property is 1.
        PeakValue;

    end
end
