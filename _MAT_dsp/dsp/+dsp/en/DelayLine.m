classdef DelayLine< handle
%DelayLine Rebuffer sequence of inputs with one-sample shift
%   HDELAYLINE = dsp.DelayLine returns a delay line System object,
%   HDELAYLINE, that buffers the input samples into a sequence of
%   overlapping or underlapping matrix outputs.
%
%   HDELAYLINE = dsp.DelayLine('PropertyName', PropertyValue, ...) returns
%   a delay line System object, HDELAYLINE, with each specified property
%   set to the specified value.
%
%   HDELAYLINE = dsp.DelayLine(DELAYSIZE, INITIAL, 'PropertyName',
%   PropertyValue, ...) returns a delay line System object, HDELAYLINE,
%   with the Length property set to DELAYSIZE, InitialConditions property
%   set to INITIAL and other specified properties set to the specified
%   values.
%
%   Step method syntax:
%
%   Y = step(HDELAYLINE, X) returns the delayed version of input X. Y is an
%   output matrix with the same number of rows as the delay line size. Each
%   column of X is treated as a separate channel. The System object
%   rebuffers a sequence of Mi-by-N matrix inputs into a sequence of
%   Mo-by-N matrix outputs, where Mo is the output frame size specified by
%   the Length property. Depending on whether Mo is greater than, less
%   than, or equal to the input frame size, Mi, the output frames can be
%   underlapped or overlapped. Each of the N input channels is rebuffered
%   independently. When Mo > Mi, the output frame overlap is the difference
%   between the output and input frame size, Mo-Mi. When Mo < Mi, the
%   output is underlapped; the System object discards the first Mi-Mo
%   samples of each input frame so that only the last Mo samples are
%   buffered into the corresponding output frame. When Mo = Mi, the output
%   data is identical to the input data, but is delayed by the latency of
%   the System object.
%
%
%   Y = step(HDELAYLINE, X, EN) selectively outputs the delayed version of
%   input X depending on the logical input EN when the
%   EnableOutputInputPort property is set to true. If EN is false, use the
%   HoldPreviousValue property to specify if the System object should hold
%   the previous output value(s).
%
%   DelayLine methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create delay line object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states to initial conditions
%
%   DelayLine properties:
%
%   Length                - Number of rows in output matrix
%   InitialConditions     - Initial System object output
%   DirectFeedthrough     - Enables passing input data to output without
%                           extra frame delay
%   EnableOutputInputPort - Enables selective output linearization
%   HoldPreviousValue     - Whether to hold previous value on the output
%
%   % EXAMPLE: Use DelayLine System object with a delay line size of 4 samples.
%       hdelayline = dsp.DelayLine( ...
%                        'Length', 4, ...
%                        'DirectFeedthrough', true, ...
%                        'InitialConditions', -2, ...
%                        'EnableOutputInputPort', true, ...
%                        'HoldPreviousValue', true ...
%                        );
%       en = logical([1 1 0 1 0]);
%       y = zeros(4,5);
%       for ii = 1:5
%           y(:,ii) = step(hdelayline, ii, en(ii));
%       end
%
%   See also dsp.Delay.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=DelayLine
            %DelayLine Rebuffer sequence of inputs with one-sample shift
            %   HDELAYLINE = dsp.DelayLine returns a delay line System object,
            %   HDELAYLINE, that buffers the input samples into a sequence of
            %   overlapping or underlapping matrix outputs.
            %
            %   HDELAYLINE = dsp.DelayLine('PropertyName', PropertyValue, ...) returns
            %   a delay line System object, HDELAYLINE, with each specified property
            %   set to the specified value.
            %
            %   HDELAYLINE = dsp.DelayLine(DELAYSIZE, INITIAL, 'PropertyName',
            %   PropertyValue, ...) returns a delay line System object, HDELAYLINE,
            %   with the Length property set to DELAYSIZE, InitialConditions property
            %   set to INITIAL and other specified properties set to the specified
            %   values.
            %
            %   Step method syntax:
            %
            %   Y = step(HDELAYLINE, X) returns the delayed version of input X. Y is an
            %   output matrix with the same number of rows as the delay line size. Each
            %   column of X is treated as a separate channel. The System object
            %   rebuffers a sequence of Mi-by-N matrix inputs into a sequence of
            %   Mo-by-N matrix outputs, where Mo is the output frame size specified by
            %   the Length property. Depending on whether Mo is greater than, less
            %   than, or equal to the input frame size, Mi, the output frames can be
            %   underlapped or overlapped. Each of the N input channels is rebuffered
            %   independently. When Mo > Mi, the output frame overlap is the difference
            %   between the output and input frame size, Mo-Mi. When Mo < Mi, the
            %   output is underlapped; the System object discards the first Mi-Mo
            %   samples of each input frame so that only the last Mo samples are
            %   buffered into the corresponding output frame. When Mo = Mi, the output
            %   data is identical to the input data, but is delayed by the latency of
            %   the System object.
            %
            %
            %   Y = step(HDELAYLINE, X, EN) selectively outputs the delayed version of
            %   input X depending on the logical input EN when the
            %   EnableOutputInputPort property is set to true. If EN is false, use the
            %   HoldPreviousValue property to specify if the System object should hold
            %   the previous output value(s).
            %
            %   DelayLine methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create delay line object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states to initial conditions
            %
            %   DelayLine properties:
            %
            %   Length                - Number of rows in output matrix
            %   InitialConditions     - Initial System object output
            %   DirectFeedthrough     - Enables passing input data to output without
            %                           extra frame delay
            %   EnableOutputInputPort - Enables selective output linearization
            %   HoldPreviousValue     - Whether to hold previous value on the output
            %
            %   % EXAMPLE: Use DelayLine System object with a delay line size of 4 samples.
            %       hdelayline = dsp.DelayLine( ...
            %                        'Length', 4, ...
            %                        'DirectFeedthrough', true, ...
            %                        'InitialConditions', -2, ...
            %                        'EnableOutputInputPort', true, ...
            %                        'HoldPreviousValue', true ...
            %                        );
            %       en = logical([1 1 0 1 0]);
            %       y = zeros(4,5);
            %       for ii = 1:5
            %           y(:,ii) = step(hdelayline, ii, en(ii));
            %       end
            %
            %   See also dsp.Delay.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %DirectFeedthrough Enables passing input data to output without
        %   extra frame delay When this property is set to true, the input data
        %   is not delayed by an extra frame before it is available at the
        %   output buffer. Instead, the input data is available immediately at
        %   the output. Otherwise, there is one frame delay on output. The
        %   default value of this property is false.
        DirectFeedthrough;

        %EnableOutputInputPort Enables selective output linearization
        %   System object internally uses a circular buffer, even though the
        %   output is linear. This means, for valid output, data from the
        %   circular buffer has to be linearized. When you set this property to
        %   true, the System object uses an additional logical input to
        %   determine whether or not a valid output needs to be computed. If
        %   the input value is 1, the System object's output is linearized, and
        %   thus is valid. Otherwise, the output is not linearized, and is
        %   invalid. This allows the System object to be more efficient when
        %   the tapped Delay Line's output is not required for each step. When
        %   you set this property to false the output is always linearized and
        %   valid. The default value of this property is false.
        EnableOutputInputPort;

        %HoldPreviousValue Hold previous valid value for invalid output
        %   If you set this property to true, the most recent valid value is
        %   held on the output. Otherwise, the signal on the output is invalid
        %   data. This property is only applicable when the
        %   EnableOutputInputPort property is set to true. The default value of
        %   this property is false.
        HoldPreviousValue;

        %InitialConditions Initial System object output
        %   The value of the System object's initial output, a scalar, vector,
        %   or matrix. When the System object's output is a vector, the
        %   InitialConditions property can be set to a vector of the same size,
        %   or a scalar value to be repeated across all elements of the initial
        %   output. When the System object's output is a matrix, the
        %   InitialConditions property can be set to a matrix of the same size,
        %   a vector (of length equal to the number of matrix rows) to be
        %   repeated across all columns of the initial output, or a scalar to
        %   be repeated across all elements of the initial output. The default
        %   value of this property is 0.
        InitialConditions;

        %Length Number of rows in output matrix
        %   Specify the number of rows in output matrix as a scalar positive
        %   integer. The default value of this property is 64.
        Length;

    end
end
