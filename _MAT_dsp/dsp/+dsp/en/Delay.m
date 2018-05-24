classdef Delay< handle
%Delay  Delay input by specified number of samples or frames
%   HDELAY = dsp.Delay returns a System object, HDELAY, to delay the input
%   by a specified number of samples or frames.
%
%   HDELAY = dsp.Delay('PropertyName', PropertyValue, ...) returns a delay
%   System object, HDELAY, with each specified property set to the
%   specified value.
%
%   HDELAY = dsp.Delay(LEN, 'PropertyName', PropertyValue, ...) returns a
%   delay System object, HDELAY, with the Length property set to LEN and
%   other specified properties set to the specified values.
%
%   Step method syntax:
%
%   Y = step(HDELAY, X) adds delay to input X to return output Y.
%
%   Y = step(HDELAY, X, R) adds delay to X, and selectively resets the
%   System object's state based on the value of reset input R and the value
%   of the ResetCondition property. This option is available when the
%   ResetInputPort property is true.
%
%   Delay methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create delay object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset delay states
%
%   Delay properties:
%
%   Units                       - Delay units as samples or frames
%   Length                      - Amount of delay
%   InitialConditionsPerChannel - Enables different initial conditions per
%                                 channel
%   InitialConditionsPerSample  - Enables different initial conditions per
%                                 sample
%   InitialConditions           - Initial output of System object
%   ResetInputPort              - Enables resetting delay states
%   ResetCondition              - Reset trigger setting for delay
%   FrameBasedProcessing        - Process input in frames or as samples
%
%   % EXAMPLE #1: Delay input by five samples
%      hdelay1 = dsp.Delay(5);
%      y = step(hdelay1, (1:10)');      % Output is [0 0 0 0 0 1 2 3 4 5]'
%
%   % EXAMPLE #2: Delay input by one frame
%      hdelay2 = dsp.Delay;
%      hdelay2.Units = 'Frames';
%      hdelay2.Length = 1;
%      y1 = step(hdelay2, (1:10)');     % Output is zeros(10,1)
%      y2 = step(hdelay2, (11:20)');    % Output is (1:10)'
%
%   See also dsp.VariableIntegerDelay, 
%            dsp.VariableFractionalDelay.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=Delay
            %Delay  Delay input by specified number of samples or frames
            %   HDELAY = dsp.Delay returns a System object, HDELAY, to delay the input
            %   by a specified number of samples or frames.
            %
            %   HDELAY = dsp.Delay('PropertyName', PropertyValue, ...) returns a delay
            %   System object, HDELAY, with each specified property set to the
            %   specified value.
            %
            %   HDELAY = dsp.Delay(LEN, 'PropertyName', PropertyValue, ...) returns a
            %   delay System object, HDELAY, with the Length property set to LEN and
            %   other specified properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HDELAY, X) adds delay to input X to return output Y.
            %
            %   Y = step(HDELAY, X, R) adds delay to X, and selectively resets the
            %   System object's state based on the value of reset input R and the value
            %   of the ResetCondition property. This option is available when the
            %   ResetInputPort property is true.
            %
            %   Delay methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create delay object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset delay states
            %
            %   Delay properties:
            %
            %   Units                       - Delay units as samples or frames
            %   Length                      - Amount of delay
            %   InitialConditionsPerChannel - Enables different initial conditions per
            %                                 channel
            %   InitialConditionsPerSample  - Enables different initial conditions per
            %                                 sample
            %   InitialConditions           - Initial output of System object
            %   ResetInputPort              - Enables resetting delay states
            %   ResetCondition              - Reset trigger setting for delay
            %   FrameBasedProcessing        - Process input in frames or as samples
            %
            %   % EXAMPLE #1: Delay input by five samples
            %      hdelay1 = dsp.Delay(5);
            %      y = step(hdelay1, (1:10)');      % Output is [0 0 0 0 0 1 2 3 4 5]'
            %
            %   % EXAMPLE #2: Delay input by one frame
            %      hdelay2 = dsp.Delay;
            %      hdelay2.Units = 'Frames';
            %      hdelay2.Length = 1;
            %      y1 = step(hdelay2, (1:10)');     % Output is zeros(10,1)
            %      y2 = step(hdelay2, (11:20)');    % Output is (1:10)'
            %
            %   See also dsp.VariableIntegerDelay, 
            %            dsp.VariableFractionalDelay.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %FrameBasedProcessing Process input in frames or as samples
        %  Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
        %  property to false to enable sample-based processing. The default value
        %  of this property is true.
        FrameBasedProcessing;

        %InitialConditions Initial output of System object
        %   Specify the initial output(s) of the System object. This property can
        %   be set to a scalar, vector, matrix or cell array of MATLAB built-in
        %   numeric data type, depending on the values of the
        %   FrameBasedProcessing, InitialConditionsPerChannel,
        %   InitialConditionsPerSample and Units properties. The default value of
        %   this property is 0.
        %   If the FrameBasedProcessing property is false, and the input is
        %   an N-D array, the dimensions of this property value must be as
        %   follows:
        %   * If the InitialConditionsPerChannel and InitialConditionsPerSample
        %   properties are both false, the property value must be a scalar.
        %   * If the InitialConditionsPerChannel property is true and the
        %   InitialConditionsPerSample property is false, the value must have the
        %   same dimensions as the input.
        %   * If the InitialConditionsPerChannel property is false and the
        %   InitialConditionsPerSample property is true, the value must be a
        %   vector of length equal to the Length property value.
        %   * If the InitialConditionsPerChannel and InitialConditionsPerSample
        %   properties are both true, the property value must be a cell array of
        %   the same size as the input signal. Each cell of the cell array
        %   represents the delay values for one channel, and must be a vector of
        %   length equal to the Length property value.
        %
        %   If the FrameBasedProcessing property is true, and the input is
        %   an M-by-N matrix, the dimensions of this property value must be as
        %   follows:
        %   * If the InitialConditionsPerChannel and InitialConditionsPerSample
        %   properties are both false, the property value must be a scalar.
        %   * If the InitialConditionsPerChannel property is true and the
        %   InitialConditionsPerSample property is false, the value must be a
        %   vector of length N.
        %   * If the InitialConditionsPerChannel property is false, the
        %   InitialConditionsPerSample property is true, and the Units property is
        %   'Frames', the value must be a vector of length equal to the product of
        %   M and the Length property value.
        %   * If the InitialConditionsPerChannel property is false, the
        %   InitialConditionsPerSample property is true, and the Units property is
        %   'Samples', the value must be a vector of length equal to the Length
        %   property value.
        %   * If the InitialConditionsPerChannel and InitialConditionsPerSample
        %   properties are both true, the property value must be a cell array of
        %   size N. Each cell of the cell array represents the delay values for
        %   one channel. If the Units property is 'Frames', each cell must be a
        %   vector of length equal to the product of M and the Length property
        %   value. If the Units property is 'Samples', each cell must be a vector
        %   of length equal to the Length property value.
        InitialConditions;

        %InitialConditionsPerChannel Enables different initial conditions per
        %                            channel
        %   Set this property to true to specify different initial conditions per
        %   channel. The default value is false.
        InitialConditionsPerChannel;

        %InitialConditionsPerSample Enables different initial conditions per
        %                           sample
        %   Set this property to true to specify different initial conditions per
        %   sample. The default value is false.
        InitialConditionsPerSample;

        %Length Amount of delay
        %   Specify amount of delay to apply to the input signal. This property
        %   can be set to a scalar, a vector or an array containing non-negative
        %   integer(s) depending on the value of the FrameBasedProcessing property.
        %   If the FrameBasedProcessing property is false, the value can be
        %   one of the following:
        %   * a scalar by which to delay all input channels equally
        %   * an N-D array of the same dimensions as the input, whose values
        %   specify the number of sample intervals to delay each channel of the
        %   input.
        %   If the FrameBasedProcessing property is true, the value can be
        %   one of the following:
        %   * a scalar integer by which to equally delay all channels
        %   * a vector whose length is equal to the number of input columns
        %   (channels).
        %   The default value of this property is 1.
        Length;

        %ResetCondition Reset trigger setting for delay
        %   Specify the event to reset the delay as one of [ 'Rising edge' |
        %   'Falling edge' | 'Either edge' | {'Non-zero'} ]. The System object
        %   resets the delay based on the values of this property and the reset
        %   input to the step method. This property is applicable when the
        %   ResetInputPort property is true.
        ResetCondition;

        %ResetInputPort Enables resetting delay states
        %   Specify when the System object should reset the delay states. By
        %   default, the value of this property is false, and the object does not
        %   reset the delay states. When this property is set to true, a reset
        %   control input is provided to the step method, and the ResetCondition
        %   property becomes applicable. The object resets the delay states based
        %   on the values of the ResetCondition property and the reset input to
        %   the step method.
        ResetInputPort;

        %Units Delay units as samples or frames
        %   Specify the delay units as one of [{'Samples'} | 'Frames']. This
        %   property is applicable when the FrameBasedProcessing property is
        %   true.
        Units;

    end
end
