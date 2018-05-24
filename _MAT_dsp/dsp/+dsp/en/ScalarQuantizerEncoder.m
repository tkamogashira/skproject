classdef ScalarQuantizerEncoder< handle
%ScalarQuantizerEncoder Encode each input value by associating it with
%index value of quantization region
%   HSQE = dsp.ScalarQuantizerEncoder returns a scalar quantizer encoder
%   System object, HSQE, that maps each input value to a quantization
%   region by comparing the input value to the user-specified boundary
%   points. Then, the object outputs the index of the associated region.
%
%   HSQE = dsp.ScalarQuantizerEncoder('PropertyName', PropertyValue, ...)
%   returns a scalar quantizer encoder object, HSQE, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   INDEX = step(HSQE, INPUT) returns the INDEX of the quantization region
%   to which the INPUT belongs. The input data, boundary points, codebook
%   values, quantized output values, and the quantization error must have
%   the same data type whenever they are present.
%
%   [...] = step(HSQE, INPUT, BPOINTS) uses input BPOINTS as the boundary
%   points when the BoundaryPointsSource property is 'Input port'.
%
%   [...] = step(HSQE, INPUT, BPOINTS, CODEBOOK) uses input BPOINTS as the
%   boundary points and input CODEBOOK as the code book when the
%   BoundaryPointsSource property is 'Input port' and either the
%   CodewordOutputPort property or the QuantizationErrorOutputPort property
%   is true.
%
%   [..., CODEWORD] = step(HSQE, ...) outputs the CODEWORD values that
%   corresponds to each index value when the CodewordOutputPort property is
%   true.
%
%   [..., QERR] = step(HSQE, ...) outputs the quantization error QERR for
%   each input value when the QuantizationErrorOutputPort property is true.
%   The quantization error is the difference between the input value and
%   the quantized output value.
%
%   [..., CLIPSTATUS] = step(HSQE, ...) also returns output CLIPSTATUS as
%   the clipping status output port for each input value when the
%   Partitioning property is 'Bounded' and the ClippingStatusOutputPort
%   property is true. If an input value is outside the range defined by the
%   BoundaryPoints property, CLIPSTATUS will be true. When all input values
%   are inside the range, CLIPSTATUS will be false.
%
%   ScalarQuantizerEncoder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create scalar quantizer encoder object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ScalarQuantizerEncoder properties:
%
%   BoundaryPointsSource        - Source of boundary points
%   Partitioning                - Quantizer is bounded or unbounded
%   BoundaryPoints              - Boundary points of quantizer regions
%   SearchMethod                - Find quantizer index by linear or binary
%                                 search
%   TiebreakerRule              - Behavior when input is equal to boundary
%                                 point
%   CodewordOutputPort          - Enables output of codeword value
%   QuantizationErrorOutputPort - Enables output of quantization error
%   Codebook                    - Code book
%   ClippingStatusOutputPort    - Enables output of clipping status
%   OutputIndexDataType         - Data type of the index output
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.ScalarQuantizerEncoder.helpFixedPoint.
%
%   % EXAMPLE: Quantize varying fractional inputs between zero and five to
%   %          the closest integers and plot the results.
%       hsqe = dsp.ScalarQuantizerEncoder;
%       hsqe.BoundaryPoints = [-.001 .499 1.499 2.499 3.499 4.499 5.001];
%       hsqe.CodewordOutputPort = true;
%       hsqe.Codebook = [0 1 2 3 4 5];
%       input = (0:0.02:5)';
%       [index, quantizedValue] = step(hsqe, input);
%       plot(1:length(input), [input quantizedValue]);
%
%   See also dsp.ScalarQuantizerDecoder, dsp.VectorQuantizerEncoder,
%            dsp.ScalarQuantizerEncoder.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ScalarQuantizerEncoder
            %ScalarQuantizerEncoder Encode each input value by associating it with
            %index value of quantization region
            %   HSQE = dsp.ScalarQuantizerEncoder returns a scalar quantizer encoder
            %   System object, HSQE, that maps each input value to a quantization
            %   region by comparing the input value to the user-specified boundary
            %   points. Then, the object outputs the index of the associated region.
            %
            %   HSQE = dsp.ScalarQuantizerEncoder('PropertyName', PropertyValue, ...)
            %   returns a scalar quantizer encoder object, HSQE, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   INDEX = step(HSQE, INPUT) returns the INDEX of the quantization region
            %   to which the INPUT belongs. The input data, boundary points, codebook
            %   values, quantized output values, and the quantization error must have
            %   the same data type whenever they are present.
            %
            %   [...] = step(HSQE, INPUT, BPOINTS) uses input BPOINTS as the boundary
            %   points when the BoundaryPointsSource property is 'Input port'.
            %
            %   [...] = step(HSQE, INPUT, BPOINTS, CODEBOOK) uses input BPOINTS as the
            %   boundary points and input CODEBOOK as the code book when the
            %   BoundaryPointsSource property is 'Input port' and either the
            %   CodewordOutputPort property or the QuantizationErrorOutputPort property
            %   is true.
            %
            %   [..., CODEWORD] = step(HSQE, ...) outputs the CODEWORD values that
            %   corresponds to each index value when the CodewordOutputPort property is
            %   true.
            %
            %   [..., QERR] = step(HSQE, ...) outputs the quantization error QERR for
            %   each input value when the QuantizationErrorOutputPort property is true.
            %   The quantization error is the difference between the input value and
            %   the quantized output value.
            %
            %   [..., CLIPSTATUS] = step(HSQE, ...) also returns output CLIPSTATUS as
            %   the clipping status output port for each input value when the
            %   Partitioning property is 'Bounded' and the ClippingStatusOutputPort
            %   property is true. If an input value is outside the range defined by the
            %   BoundaryPoints property, CLIPSTATUS will be true. When all input values
            %   are inside the range, CLIPSTATUS will be false.
            %
            %   ScalarQuantizerEncoder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create scalar quantizer encoder object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ScalarQuantizerEncoder properties:
            %
            %   BoundaryPointsSource        - Source of boundary points
            %   Partitioning                - Quantizer is bounded or unbounded
            %   BoundaryPoints              - Boundary points of quantizer regions
            %   SearchMethod                - Find quantizer index by linear or binary
            %                                 search
            %   TiebreakerRule              - Behavior when input is equal to boundary
            %                                 point
            %   CodewordOutputPort          - Enables output of codeword value
            %   QuantizationErrorOutputPort - Enables output of quantization error
            %   Codebook                    - Code book
            %   ClippingStatusOutputPort    - Enables output of clipping status
            %   OutputIndexDataType         - Data type of the index output
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.ScalarQuantizerEncoder.helpFixedPoint.
            %
            %   % EXAMPLE: Quantize varying fractional inputs between zero and five to
            %   %          the closest integers and plot the results.
            %       hsqe = dsp.ScalarQuantizerEncoder;
            %       hsqe.BoundaryPoints = [-.001 .499 1.499 2.499 3.499 4.499 5.001];
            %       hsqe.CodewordOutputPort = true;
            %       hsqe.Codebook = [0 1 2 3 4 5];
            %       input = (0:0.02:5)';
            %       [index, quantizedValue] = step(hsqe, input);
            %       plot(1:length(input), [input quantizedValue]);
            %
            %   See also dsp.ScalarQuantizerDecoder, dsp.VectorQuantizerEncoder,
            %            dsp.ScalarQuantizerEncoder.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.ScalarQuantizerEncoder System
            %object fixed-point information
            %   dsp.ScalarQuantizerEncoder.helpFixedPoint displays
            %   information about fixed-point properties and operations of the
            %   dsp.ScalarQuantizerEncoder System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % Codeword and Error need to be connected to inport 1 - if they are
            % outputs
        end

    end
    methods (Abstract)
    end
    properties
        %BoundaryPoints Boundary points of quantizer regions
        %   Specify the boundary points of quantizer regions as a vector. The
        %   values of the vector must be in an ascending order. Let [p0 p1 p2
        %   p3 ... pN] denote the boundary points property in quantizer. If the
        %   quantizer is bounded, this property is used to specify [p0 p1 p2 p3
        %   ... pN]. If the quantizer is unbounded, this property is used to
        %   specify [p1 p2 p3 ... p(N-1)] and the System object sets p0=-Inf
        %   and pN = +Inf. This property is applicable when
        %   BoundaryPointsSource property is 'Property'. The default value of
        %   this property is 1:10. This property is tunable.
        BoundaryPoints;

        %BoundaryPointsSource Source of boundary points
        %   Specify how to determine the boundary points and codebook values as
        %   one of [{'Property'} | 'Input port'].
        BoundaryPointsSource;

        %ClippingStatusOutputPort Enables output of clipping status
        %   Set this property to true to output the clipping status. The output
        %   is a 1 when an input value is outside the range defined by the
        %   BoundaryPoints property. When the value is inside the range, the
        %   exception output is a 0. This property is applicable when the
        %   Partitioning property is 'Bounded'. The default value of this
        %   property is false.
        ClippingStatusOutputPort;

        %Codebook Code book
        %   Specify the code book as a vector of quantized output values that
        %   correspond to each region. If the Partitioning property is
        %   'Bounded' and the boundary points vector has length N, this
        %   property must be set to a vector of length N-1. If the Partitioning
        %   property is 'Unbounded' and the boundary points vector has length
        %   N, this property must be set to a vector of length N+1. This
        %   property is applicable when the BoundaryPointsSource property is
        %   'Property' and either the CodewordOutputPort property or the
        %   QuantizationErrorOutputPort property is true. The default value of
        %   this property is 1.5:9.5. This property is tunable.
        Codebook;

        %CodewordOutputPort Enables output of codeword value
        %   Set this property to true to output the codeword values that
        %   correspond to each index value. The default value of this property
        %   is false.
        CodewordOutputPort;

        %OutputIndexDataType Data type of the index output
        %   Specify the data type of the index output from the System object as
        %   one of ['int8' | 'uint8' | 'int16' | 'uint16' | {'int32'} |
        %   'uint32'].
        OutputIndexDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %Partitioning Quantizer is bounded or unbounded
        %   Specify the quantizer as one of [{'Bounded'} | 'Unbounded'].
        Partitioning;

        %QuantizationErrorOutputPort Enables output of quantization error
        %   Set this property to true to output the quantization error for each
        %   input value. The quantization error is the difference between the
        %   input value and the quantized output value. The default value of
        %   this property is false.
        QuantizationErrorOutputPort;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %SearchMethod Find quantizer index by linear or binary search
        %   Specify whether to find the appropriate quantizer index using a
        %   linear search or a binary search as one of [{'Linear'} | 'Binary'].
        %   The computational cost of the linear search method is of the order
        %   P and the computational cost of the binary search method is of the
        %   order log2(P), where P is the number of boundary points.
        SearchMethod;

        %TiebreakerRule Behavior when input is equal to boundary point
        %   Specify whether the input value is assigned to lower indexed region
        %   or higher indexed region when the input value is equal to boundary
        %   point as one of [{'Choose the lower index'} | 'Choose the higher
        %   index'].
        TiebreakerRule;

        pBoundaryPointsBounded;

        pBoundaryPointsUnbounded;

    end
end
