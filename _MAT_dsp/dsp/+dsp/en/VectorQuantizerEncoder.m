classdef VectorQuantizerEncoder< handle
%VectorQuantizerEncoder Perform vector quantization encoding
%   HVQENC = dsp.VectorQuantizerEncoder returns a vector quantizer encoder
%   System object, HVQENC, that finds for each given input column vector, a
%   zero-based index of the nearest codeword. The object finds the nearest
%   codeword by computing a distortion based on Euclidean or weighted
%   Euclidean distance.
%
%   HVQENC = dsp.VectorQuantizerEncoder('PropertyName',PropertyValue, ...)
%   returns a vector quantizer encoder object, HVQENC, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   INDEX = step(HVQENC, INPUT) returns INDEX, a scalar or column vector
%   representing the quantization region(s) to which INPUT belongs. INPUT
%   can be a column vector of size k-by-1 or an M multichannel matrix of
%   dimensions k-by-M, where k is the length of each codeword in the
%   codebook. All inputs to the object can be of real floating-point or
%   fixed-point values and must be of the same data type. The output index
%   values can be signed or unsigned integers.
%
%   INDEX = step(HVQENC, ..., CODEBOOK) uses the codebook given in input
%   CODEBOOK, a k-by-N matrix with N codewords each of length k. This
%   option is available when the CodebookSource property is 'Input port'.
%
%   INDEX = step(HVQENC, ..., WEIGHTS) uses the input vector WEIGHTS to
%   emphasize or de-emphasize certain input values when calculating the
%   distortion measure. WEIGHTS must be a vector of length equal to the
%   number of rows of INPUT. This option is available when the
%   DistortionMeasure property is 'Weighted squared error' and the
%   WeightsSource property is 'Input port'.
%
%   [..., CODEWORD] = step(HVQENC, ...) outputs the CODEWORD values that
%   correspond to each index value when the CodewordOutputPort property is
%   true.
%
%   [..., QERR] = step(HVQENC, ...) outputs the quantization error QERR for
%   each input value when the QuantizationErrorOutputPort property is true.
%
%   VectorQuantizerEncoder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create vector quantizer encoder object with same property
%              values
%   isLocked - Locked status (logical)
%
%   VectorQuantizerEncoder properties:
%
%   CodebookSource              - Source of codebook values
%   Codebook                    - Codebook
%   DistortionMeasure           - Distortion calculation method
%   WeightsSource               - Source of weighting factor
%   Weights                     - Weighting factor
%   TiebreakerRule              - Behavior when an input column vector is
%                                 equidistant from two codewords
%   CodewordOutputPort          - Enables output of codeword value
%   QuantizationErrorOutputPort - Enables output of quantization error
%   OutputIndexDataType         - Data type of the index output
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.VectorQuantizerEncoder.helpFixedPoint.
%
%   % EXAMPLE: Find indices of nearest codewords based on Euclidean 
%   %          distances.
%       hvqenc = dsp.VectorQuantizerEncoder(...
%           'Codebook', [-1 -1 1 1;1 -1 -1 1], ...
%           'CodewordOutputPort', true, ...
%           'QuantizationErrorOutputPort', true, ...
%           'OutputIndexDataType', 'uint8');
%       % Generate an input signal with some additive noise
%       x = sign(rand(2,40)-0.5) + 0.1*randn(2,40);
%       [ind, cw, err] = step(hvqenc, x);
%       plot(cw(1,:), cw(2,:), 'rO', x(1,:), x(2,:), 'g.');
%       legend('Quantized', 'Inputs', 'location', 'best');
%
%   See also dsp.VectorQuantizerDecoder,
%   dsp.ScalarQuantizerEncoder,
%   dsp.VectorQuantizerEncoder.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=VectorQuantizerEncoder
            %VectorQuantizerEncoder Perform vector quantization encoding
            %   HVQENC = dsp.VectorQuantizerEncoder returns a vector quantizer encoder
            %   System object, HVQENC, that finds for each given input column vector, a
            %   zero-based index of the nearest codeword. The object finds the nearest
            %   codeword by computing a distortion based on Euclidean or weighted
            %   Euclidean distance.
            %
            %   HVQENC = dsp.VectorQuantizerEncoder('PropertyName',PropertyValue, ...)
            %   returns a vector quantizer encoder object, HVQENC, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   INDEX = step(HVQENC, INPUT) returns INDEX, a scalar or column vector
            %   representing the quantization region(s) to which INPUT belongs. INPUT
            %   can be a column vector of size k-by-1 or an M multichannel matrix of
            %   dimensions k-by-M, where k is the length of each codeword in the
            %   codebook. All inputs to the object can be of real floating-point or
            %   fixed-point values and must be of the same data type. The output index
            %   values can be signed or unsigned integers.
            %
            %   INDEX = step(HVQENC, ..., CODEBOOK) uses the codebook given in input
            %   CODEBOOK, a k-by-N matrix with N codewords each of length k. This
            %   option is available when the CodebookSource property is 'Input port'.
            %
            %   INDEX = step(HVQENC, ..., WEIGHTS) uses the input vector WEIGHTS to
            %   emphasize or de-emphasize certain input values when calculating the
            %   distortion measure. WEIGHTS must be a vector of length equal to the
            %   number of rows of INPUT. This option is available when the
            %   DistortionMeasure property is 'Weighted squared error' and the
            %   WeightsSource property is 'Input port'.
            %
            %   [..., CODEWORD] = step(HVQENC, ...) outputs the CODEWORD values that
            %   correspond to each index value when the CodewordOutputPort property is
            %   true.
            %
            %   [..., QERR] = step(HVQENC, ...) outputs the quantization error QERR for
            %   each input value when the QuantizationErrorOutputPort property is true.
            %
            %   VectorQuantizerEncoder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create vector quantizer encoder object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   VectorQuantizerEncoder properties:
            %
            %   CodebookSource              - Source of codebook values
            %   Codebook                    - Codebook
            %   DistortionMeasure           - Distortion calculation method
            %   WeightsSource               - Source of weighting factor
            %   Weights                     - Weighting factor
            %   TiebreakerRule              - Behavior when an input column vector is
            %                                 equidistant from two codewords
            %   CodewordOutputPort          - Enables output of codeword value
            %   QuantizationErrorOutputPort - Enables output of quantization error
            %   OutputIndexDataType         - Data type of the index output
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.VectorQuantizerEncoder.helpFixedPoint.
            %
            %   % EXAMPLE: Find indices of nearest codewords based on Euclidean 
            %   %          distances.
            %       hvqenc = dsp.VectorQuantizerEncoder(...
            %           'Codebook', [-1 -1 1 1;1 -1 -1 1], ...
            %           'CodewordOutputPort', true, ...
            %           'QuantizationErrorOutputPort', true, ...
            %           'OutputIndexDataType', 'uint8');
            %       % Generate an input signal with some additive noise
            %       x = sign(rand(2,40)-0.5) + 0.1*randn(2,40);
            %       [ind, cw, err] = step(hvqenc, x);
            %       plot(cw(1,:), cw(2,:), 'rO', x(1,:), x(2,:), 'g.');
            %       legend('Quantized', 'Inputs', 'location', 'best');
            %
            %   See also dsp.VectorQuantizerDecoder,
            %   dsp.ScalarQuantizerEncoder,
            %   dsp.VectorQuantizerEncoder.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.VectorQuantizerEncoder System
            %object fixed-point information
            %   dsp.VectorQuantizerEncoder.helpFixedPoint displays
            %   information about fixed-point properties and operations of the
            %   dsp.VectorQuantizerEncoder System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % Codeword and Error need to be connected to inport 1 - if they are
            % outputs
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   input' | {'Same as product'} | 'Custom'].
        AccumulatorDataType;

        %Codebook Codebook
        %   Specify the codebook to which the input column vector or matrix is
        %   compared, as a k-by-N matrix. Each column of the codebook matrix is
        %   a codeword, and each codeword corresponds to an index value. The
        %   codeword vectors must have the same number of rows as the input. The
        %   first codeword vector corresponds to an index value of 0, the second
        %   codeword vector corresponds to an index value of 1, and so on.    
        %   This property is applicable when CodebookSource property is
        %   'Property'. The default value of this property is
        %           [1.5 13.3 136.4 6.8
        %            2.5 14.3 137.4 7.8
        %            3.5 15.3 138.4 8.8].
        %   This property is tunable.
        Codebook;

        %CodebookSource Source of codebook values
        %   Specify how to determine the codebook values as one of
        %   [{'Property'} | 'Input port'].
        CodebookSource;

        %CodewordOutputPort Enables output of codeword value
        %   Set this property to true to output the codeword vectors nearest to
        %   the input column vectors. The default value of this property is
        %   false.
        CodewordOutputPort;

        %CustomAccumulatorDataType Accumulator  word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'.
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'.
        %
        %   See also numerictype.
        CustomProductDataType;

        %DistortionMeasure Distortion calculation method
        %   Specify how to calculate the distortion as one of [{'Squared
        %   error'} | 'Weighted squared error']. If this property is set to
        %   'Squared error', the System object calculates the distortion by
        %   evaluating the Euclidean distance between the input column vector
        %   and each codeword in the codebook. Otherwise, the object calculates
        %   the distortion by evaluating a weighted Euclidean distance using a
        %   weighting factor to emphasize or deemphasize certain input values.
        DistortionMeasure;

        %OutputIndexDataType Data type of the index output
        %   Specify the data type of the index output as one of ['int8' |
        %   'uint8' | 'int16' | 'uint16' | {'int32'} | 'uint32'].
        OutputIndexDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of [{'Same as
        %   input'} | 'Custom'].
        ProductDataType;

        %QuantizationErrorOutputPort Enables output of quantization error
        %   Set this property to true to output the quantization error value
        %   that results when the System object represents the input column
        %   vector by the nearest codeword. The default value of this property
        %   is false.
        QuantizationErrorOutputPort;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %TiebreakerRule Behavior when an input column vector is equidistant from
        %                        two codewords
        %   Specify whether to represent the input column vector by the lower index
        %   valued codeword or higher indexed valued codeword when an input
        %   column vector is equidistant from two codewords. This property can
        %   be set to one of [{'Choose the lower index'} | 'Choose the higher
        %   index'].
        TiebreakerRule;

        %Weights Weighting factor
        %   Specify the weighting factor as a vector of length equal to the
        %   number of rows of the input. This property is applicable when the
        %   DistortionMeasure property is 'Weighted squared error' and
        %   WeightsSource property is 'Property'. The default value of this
        %   property is [1 1 1]. This property is tunable.
        Weights;

        %WeightsSource Source of weighting factor 
        %   Specify how to determine weighting factor as one of [{'Property'} |
        %   'Input port']. This property is applicable when the
        %   DistortionMeasure property is 'Weighted squared error'.
        WeightsSource;

    end
end
