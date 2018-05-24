classdef SignalSource< handle
%SignalSource Import variable from MATLAB workspace
%   HSR = dsp.SignalSource returns a MATLAB variable reader System object,
%   HSR, that outputs the variable one sample or frame at a time.
%
%   HSR = dsp.SignalSource('PropertyName', PropertyValue, ...) returns a
%   MATLAB variable reader System object, HSR, with each specified property
%   set to the specified value.
%
%   HSR = dsp.SignalSource(SIGNAL, SAMPLESPERFRAME, 'PropertyName',
%   PropertyValue, ...) returns a MATLAB variable reader System object,
%   HSR, with the Signal property set to SIGNAL, the SamplesPerFrame
%   property set to SAMPLESPERFRAME, and other specified properties set to
%   the specified values.
%
%   Step method syntax:
%
%   Y = step(HSR) outputs one sample or frame of data, Y, from each column
%   of the specified signal.
%
%   SignalSource methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create signal reader object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset to the beginning of the signal
%   isDone   - True if last sample or frame of signal has been output
%
%   SignalSource properties:
%
%   Signal          - Value of, or variable containing the signal
%   SamplesPerFrame - Number of samples per output frame
%   SignalEndAction - Action after final signal values are generated
%
%   % EXAMPLE #1: Create a SignalSource System object to output one
%   % sample at a time.
%       hsr1 = dsp.SignalSource;
%       hsr1.Signal = randn(1024, 1);
%       y1 = zeros(1024,1);
%       idx = 1;
%       while ~isDone(hsr1)
%         y1(idx) = step(hsr1);  
%         idx = idx+1;
%       end
%
%   % EXAMPLE #2: Create a SignalSource System object to output vectors.
%       hsr2 = dsp.SignalSource(randn(1024, 1), 128);
%       y2 = step(hsr2);  % y2 is a 128-by-1 frame of samples
%
%   See also dsp.SignalSink.

 
%   Copyright 2007-2013 The MathWorks, Inc.

    methods
        function out=SignalSource
            %SignalSource Import variable from MATLAB workspace
            %   HSR = dsp.SignalSource returns a MATLAB variable reader System object,
            %   HSR, that outputs the variable one sample or frame at a time.
            %
            %   HSR = dsp.SignalSource('PropertyName', PropertyValue, ...) returns a
            %   MATLAB variable reader System object, HSR, with each specified property
            %   set to the specified value.
            %
            %   HSR = dsp.SignalSource(SIGNAL, SAMPLESPERFRAME, 'PropertyName',
            %   PropertyValue, ...) returns a MATLAB variable reader System object,
            %   HSR, with the Signal property set to SIGNAL, the SamplesPerFrame
            %   property set to SAMPLESPERFRAME, and other specified properties set to
            %   the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HSR) outputs one sample or frame of data, Y, from each column
            %   of the specified signal.
            %
            %   SignalSource methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create signal reader object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset to the beginning of the signal
            %   isDone   - True if last sample or frame of signal has been output
            %
            %   SignalSource properties:
            %
            %   Signal          - Value of, or variable containing the signal
            %   SamplesPerFrame - Number of samples per output frame
            %   SignalEndAction - Action after final signal values are generated
            %
            %   % EXAMPLE #1: Create a SignalSource System object to output one
            %   % sample at a time.
            %       hsr1 = dsp.SignalSource;
            %       hsr1.Signal = randn(1024, 1);
            %       y1 = zeros(1024,1);
            %       idx = 1;
            %       while ~isDone(hsr1)
            %         y1(idx) = step(hsr1);  
            %         idx = idx+1;
            %       end
            %
            %   % EXAMPLE #2: Create a SignalSource System object to output vectors.
            %       hsr2 = dsp.SignalSource(randn(1024, 1), 128);
            %       y2 = step(hsr2);  % y2 is a 128-by-1 frame of samples
            %
            %   See also dsp.SignalSink.
        end

        function getDiscreteStateImpl(in) %#ok<MANU>
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function isDoneImpl(in) %#ok<MANU>
            %isDone True if last sample or frame of signal has been output
            %   isDone(OBJ) returns true if the SignalSource object, OBJ, has
            %   output the last sample or frame of the signal. If the
            %   SignalEndAction property is set to 'Cyclic repetition', this method
            %   returns true every time the last signal sample or frame is output,
            %   and false otherwise. If the SignalEndAction property is set to 'Set
            %   to zero' or 'Hold final value', this method always returns true
            %   once the object has output the last signal sample or frame. 
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Save the public properties
        end

        function setDiscreteStateImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
            % reset the pDoneStatus if cycling
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %SamplesPerFrame Number of samples per output frame
        %   Specify the number of samples to buffer into each output frame.
        %   This property must be 1 when you specify a 3-D array in the Signal
        %   property. The default value of this property is 1.
        SamplesPerFrame;

        %Signal Value of, or variable containing the signal
        %   Specify the name of the MATLAB workspace variable from which to
        %   import the signal, or a valid MATLAB expression specifying the
        %   signal. The default value of this property is (1:10)'.
        Signal;

        %SignalEndAction Action after final signal values are generated
        %   Specify the output after all of the specified signal samples have
        %   been generated as one of [{'Set to zero'} | 'Hold final value' |
        %   'Cyclic repetition'].
        SignalEndAction;

        pDoneStatus;

        pPointer;

    end
end
