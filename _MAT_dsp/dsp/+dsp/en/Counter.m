classdef Counter< handle
%Counter Count up or down through specified range of numbers
%   HCOUNTER = dsp.Counter returns a System object, HCOUNTER, that counts
%   up or down based on input count events.
%
%   HCOUNTER = dsp.Counter('PropertyName', PropertyValue, ...) returns a
%   counter System object, HCOUNTER, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   [CNT, HIT] = step(HCOUNTER, EVENT, RESET) increments, decrements, or
%   resets the internal counter as specified by the values of the EVENT and
%   RESET inputs. The output argument CNT denotes the present value of the
%   count and the argument HIT is a logical value indicating whether the
%   count has reached any of the values specified by the HitValues
%   property. A trigger event in the EVENT input causes the counter to
%   increment or decrement. A trigger event in the RESET input resets the
%   counter to its initial state.
%
%   CNT = step(HCOUNTER, EVENT, RESET) returns the present value of the
%   count when the CountOutputPort property is true and the HitOutputPort
%   property is false.
%
%   HIT = step(HCOUNTER, EVENT, RESET) returns a logical value indicating
%   whether the count has reached any of the values specified by the
%   HitValues property. This is applicable when the HitOutputPort property
%   is true and the CountOutputPort property is false.
%
%   [...] = step(HCOUNTER, EVENT) increments or decrements the internal
%   counter when the EVENT input matches the event specified in the
%   CountEventCondition property and the ResetInputPort property is false.
%
%   [...] = step(HCOUNTER) increments or decrements the free-running
%   internal counter when the CountEventInputPort property is false and the
%   ResetInputPort property is false.
%
%   [...] = step(HCOUNTER, RESET) increments or decrements the free-running
%   internal counter resettable by the RESET input when the
%   CountEventInputPort property is false.
%
%   [...] = step(HCOUNTER, ..., MAX) increments or decrements the internal
%   counter and uses MAX as the maximum value for the counter when the
%   CounterSizeSource property is 'Input port'.
%
%   Counter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create counter object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset counter to InitialCount
%
%   Counter properties:
%
%   Direction           - Counts up or down
%   CountEventInputPort - Add input to specify a count event
%   CountEventCondition - Condition that increments, decrements, or resets
%                         the internal counter
%   CounterSizeSource   - Source of counter size data type
%   CounterSize         - Range of integer values to count through
%   MaximumCount        - Counter's maximum value
%   InitialCount        - Counter's initial value
%   CountOutputPort     - Output the count
%   HitOutputPort       - Output the hit events
%   HitValues           - Values whose occurrence in count produce a true
%                         hit output
%   ResetInputPort      - Add input to enable internal counter reset
%   SamplesPerFrame     - Number of samples in each output frame
%   CountOutputDataType - Data type of count output
%
%   % EXAMPLE: Use Counter System object for counting from 0 to 5. 
%       hcounter = dsp.Counter('MaximumCount', 5, ...
%                                     'CountOutputPort', true, ... 
%                                     'HitOutputPort', false, ... 
%                                     'ResetInputPort', false);
%       sgnl = [0 1 0 1 0 1 0 1 0 1 0 1 ];
%       for ii = 1:length(sgnl)
%           %  count at every rising edge of the input signal.
%           cnt(ii) = step(hcounter, sgnl(ii)); 
%       end
%       cnt 

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Counter
            %Counter Count up or down through specified range of numbers
            %   HCOUNTER = dsp.Counter returns a System object, HCOUNTER, that counts
            %   up or down based on input count events.
            %
            %   HCOUNTER = dsp.Counter('PropertyName', PropertyValue, ...) returns a
            %   counter System object, HCOUNTER, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   [CNT, HIT] = step(HCOUNTER, EVENT, RESET) increments, decrements, or
            %   resets the internal counter as specified by the values of the EVENT and
            %   RESET inputs. The output argument CNT denotes the present value of the
            %   count and the argument HIT is a logical value indicating whether the
            %   count has reached any of the values specified by the HitValues
            %   property. A trigger event in the EVENT input causes the counter to
            %   increment or decrement. A trigger event in the RESET input resets the
            %   counter to its initial state.
            %
            %   CNT = step(HCOUNTER, EVENT, RESET) returns the present value of the
            %   count when the CountOutputPort property is true and the HitOutputPort
            %   property is false.
            %
            %   HIT = step(HCOUNTER, EVENT, RESET) returns a logical value indicating
            %   whether the count has reached any of the values specified by the
            %   HitValues property. This is applicable when the HitOutputPort property
            %   is true and the CountOutputPort property is false.
            %
            %   [...] = step(HCOUNTER, EVENT) increments or decrements the internal
            %   counter when the EVENT input matches the event specified in the
            %   CountEventCondition property and the ResetInputPort property is false.
            %
            %   [...] = step(HCOUNTER) increments or decrements the free-running
            %   internal counter when the CountEventInputPort property is false and the
            %   ResetInputPort property is false.
            %
            %   [...] = step(HCOUNTER, RESET) increments or decrements the free-running
            %   internal counter resettable by the RESET input when the
            %   CountEventInputPort property is false.
            %
            %   [...] = step(HCOUNTER, ..., MAX) increments or decrements the internal
            %   counter and uses MAX as the maximum value for the counter when the
            %   CounterSizeSource property is 'Input port'.
            %
            %   Counter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create counter object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset counter to InitialCount
            %
            %   Counter properties:
            %
            %   Direction           - Counts up or down
            %   CountEventInputPort - Add input to specify a count event
            %   CountEventCondition - Condition that increments, decrements, or resets
            %                         the internal counter
            %   CounterSizeSource   - Source of counter size data type
            %   CounterSize         - Range of integer values to count through
            %   MaximumCount        - Counter's maximum value
            %   InitialCount        - Counter's initial value
            %   CountOutputPort     - Output the count
            %   HitOutputPort       - Output the hit events
            %   HitValues           - Values whose occurrence in count produce a true
            %                         hit output
            %   ResetInputPort      - Add input to enable internal counter reset
            %   SamplesPerFrame     - Number of samples in each output frame
            %   CountOutputDataType - Data type of count output
            %
            %   % EXAMPLE: Use Counter System object for counting from 0 to 5. 
            %       hcounter = dsp.Counter('MaximumCount', 5, ...
            %                                     'CountOutputPort', true, ... 
            %                                     'HitOutputPort', false, ... 
            %                                     'ResetInputPort', false);
            %       sgnl = [0 1 0 1 0 1 0 1 0 1 0 1 ];
            %       for ii = 1:length(sgnl)
            %           %  count at every rising edge of the input signal.
            %           cnt(ii) = step(hcounter, sgnl(ii)); 
            %       end
            %       cnt 
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CountEventCondition Condition that increments, decrements, or resets 
        %                    the internal counter
        %   Specify the event at the count event input that will increment or
        %   decrement the counter as one of ['Rising edge' | 'Falling edge' |
        %   'Either edge' | {'Non-zero'}]. When the ResetInputPort and
        %   CountEventInputPort properties are true, the specified event on the
        %   reset input port will reset the counter. This property is
        %   applicable when the CountEventInputPort property is true.
        CountEventCondition;

        %CountEventInputPort Add input to specify a count event 
        %   Set this property to true to enable a count event input for the
        %   internal counter. The internal counter increments or decrements
        %   whenever the count event input satisfies the condition specified in
        %   the CountEventCondition property. When this property is set to
        %   false, the internal counter is free-running, that is, it increments
        %   or decrements on every call to the step method. The default value
        %   of this property is true.
        CountEventInputPort;

        %CountOutputDataType Data type of count output
        %   Specify the data type of the count output, CNT, as one of
        %   [{'double'} | 'single' | 'int8' | 'uint8' | 'int16' | 'uint16' |
        %   'int32' | 'uint32']. This property is applicable when the
        %   CountOutputPort property is true.
        CountOutputDataType;

        %CountOutputPort Output the count
        %   Set this property to true to enable outputting the internal count.
        %   The default value of this property is true.
        CountOutputPort;

        %CounterSize Range of integer values to count through
        %   Specify the range of integer values to count through before
        %   recycling to zero, as one of ['8 bits' | '16 bits' | '32 bits' |
        %   {'Maximum'}]. This property is applicable when the
        %   CounterSizeSource property is 'Property'.
        CounterSize;

        %CounterSizeSource Source of counter size data type
        %   Specify the source of the counter size data type as one of
        %   [{'Property'} | 'Input port'].
        CounterSizeSource;

        %Direction Counts up or down
        %   Specify the counter direction as [{'Up'} | 'Down']. This property
        %   is tunable.
        Direction;

        %HitOutputPort Output the hit events
        %   Set this property to true to enable outputting the hit events. The
        %   HitOutputPort type is logical. The default value of this property
        %   is true.
        HitOutputPort;

        %HitValues Values whose occurrence in count produce a true hit 
        %          output
        %   Specify an integer scalar or a vector of integers, any of whose
        %   occurrences in the count should be flagged by a true at the HIT
        %   output. This property is applicable when the HitOutputPort property
        %   is set to true. This property is tunable.
        HitValues;

        %InitialCount Counter's initial value
        %   Specify the counter's initial value. The default value of this
        %   property is 0. This property is tunable.
        InitialCount;

        %MaximumCount Counter's maximum value
        %   Specify the counter's maximum value as a numeric scalar value. This
        %   property is applicable when the CounterSizeSource property is
        %   'Property' and the CounterSize property is 'Maximum'. The default
        %   value of this property is 255. This property is tunable.
        MaximumCount;

        %ResetInputPort Add input to enable internal counter reset
        %   Set this property to true to enable resetting the internal counter.
        %   When this property is set to true, a reset input must be specified
        %   to the step method. The counter is reset when the reset input
        %   receives the event specified by the CountEventCondition property,
        %   or when the reset input is not zero if the CountEventInputPort
        %   property is false.
        ResetInputPort;

        %SamplesPerFrame Number of samples in each output frame
        %   Specify the number of samples in each output frame. This property
        %   is applicable when the CountEventInputPort is set to false,
        %   indicating a free-running counter. The default value of this
        %   property is 1.
        SamplesPerFrame;

    end
end
