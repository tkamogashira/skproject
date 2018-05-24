classdef Chirp< handle
%Chirp Generate swept-frequency cosine (chirp) signal
%   HCHRP = dsp.Chirp returns a Chirp System object, HCHRP, that generates
%   a swept-frequency cosine signal with unity amplitude and continuous
%   phase.
%
%   HCHRP = dsp.Chirp('PropertyName', PropertyValue, ...) returns a Chirp
%   object, HCHRP, with each specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HCHRP) returns a swept-frequency cosine output, Y.
%
%   Chirp methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Chirp object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the Chirp System object states to initial conditions
%
%   Chirp properties:
%
%   Type             - Frequency sweep type
%   SweepDirection   - Sweep direction
%   InitialFrequency - Initial frequency (Hz)
%   TargetFrequency  - Target frequency (Hz)
%   TargetTime       - Target time (s)
%   SweepTime        - Sweep time (s)
%   InitialPhase     - Initial phase (rad)
%   SampleRate       - Sample rate of output signal
%   SamplesPerFrame  - Samples per output frame
%   OutputDataType   - Output data type
%
%   % EXAMPLE: Use Chirp System object to generate a bidirectional
%   %          swept chirp signal.
%       hchirp = dsp.Chirp ( 'SweepDirection','Bidirectional', ...
%                              'TargetFrequency', 25, ... 
%                              'InitialFrequency', 0,...
%                              'TargetTime', 1, ...
%                              'SweepTime', 1, ...
%                              'SamplesPerFrame', 400, ...
%                              'SampleRate', 400 ...
%                             );
%       plot(step(hchirp));
%
%   See also dsp.SineWave.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=Chirp
            %Chirp Generate swept-frequency cosine (chirp) signal
            %   HCHRP = dsp.Chirp returns a Chirp System object, HCHRP, that generates
            %   a swept-frequency cosine signal with unity amplitude and continuous
            %   phase.
            %
            %   HCHRP = dsp.Chirp('PropertyName', PropertyValue, ...) returns a Chirp
            %   object, HCHRP, with each specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCHRP) returns a swept-frequency cosine output, Y.
            %
            %   Chirp methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Chirp object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the Chirp System object states to initial conditions
            %
            %   Chirp properties:
            %
            %   Type             - Frequency sweep type
            %   SweepDirection   - Sweep direction
            %   InitialFrequency - Initial frequency (Hz)
            %   TargetFrequency  - Target frequency (Hz)
            %   TargetTime       - Target time (s)
            %   SweepTime        - Sweep time (s)
            %   InitialPhase     - Initial phase (rad)
            %   SampleRate       - Sample rate of output signal
            %   SamplesPerFrame  - Samples per output frame
            %   OutputDataType   - Output data type
            %
            %   % EXAMPLE: Use Chirp System object to generate a bidirectional
            %   %          swept chirp signal.
            %       hchirp = dsp.Chirp ( 'SweepDirection','Bidirectional', ...
            %                              'TargetFrequency', 25, ... 
            %                              'InitialFrequency', 0,...
            %                              'TargetTime', 1, ...
            %                              'SweepTime', 1, ...
            %                              'SamplesPerFrame', 400, ...
            %                              'SampleRate', 400 ...
            %                             );
            %       plot(step(hchirp));
            %
            %   See also dsp.SineWave.
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %InitialFrequency Initial frequency (Hz)
        %   Specify the initial instantaneous frequency in Hz for Linear,
        %   Quadratic, and Swept cosine sweeps of the output chirp signal. For
        %   Logarithmic sweeps, the InitialFrequency property value is one less
        %   than the actual initial frequency of the sweep. Also, when the
        %   sweep is Logarithmic, the InitialFrequency property must be set to
        %   a value less than the target frequency. This property is tunable.
        %   The default value is 1000 Hz.
        InitialFrequency;

        %InitialPhase Initial phase (rad)
        %   Specify initial phase of the output in radians at time equal zero.
        %   This property is tunable. The default value is 0 radians.
        InitialPhase;

        %OutputDataType Output data type
        %   Specify the output data type as one of [{'double'} | 'single'].
        OutputDataType;

        %SampleRate Sample rate of output signal
        %   Specify the sampling rate of the output in Hz as a positive numeric
        %   scalar. The default value is 8000.
        SampleRate;

        %SamplesPerFrame Samples per output frame
        %   Specify the number of samples to buffer into each output as a
        %   positive integer. The default value is 1.
        SamplesPerFrame;

        %SweepDirection Sweep direction
        %   Specify the sweep direction as one of [{'Unidirectional'} |
        %   'Bidirectional'].
        SweepDirection;

        %SweepTime Sweep time (s)
        %   If the sweep direction is Unidirectional, the sweep time in seconds
        %   is the period of the output frequency sweep. If the sweep direction
        %   is Bidirectional, the sweep time is half the period of the output
        %   frequency sweep. The sweep time should be no less than the target
        %   time. This property must be a positive numeric scalar and is
        %   tunable. The default value is 1 second.
        SweepTime;

        %TargetFrequency Target frequency (Hz)
        %   Specify the instantaneous frequency in Hz at the target time for
        %   Linear, Quadratic, and Logarithmic sweeps of the output chirp
        %   signal. For Swept cosine sweeps, the TargetFrequency property value
        %   is the instantaneous frequency of the output at half the target
        %   time. Also, when the sweep is Logarithmic, the TargetFrequency
        %   property must be set to a value greater than the initial frequency.
        %   This property is tunable. The default value is 4000 Hz.
        TargetFrequency;

        %TargetTime Target time (s)
        %   For Linear, Quadratic, and Logarithmic sweeps, specify the target
        %   time in seconds at which the target frequency is reached. For a
        %   Swept cosine sweep, this property specifies the time at which the
        %   sweep reaches 2*TargetFrequency - InitialFrequency Hz. The target
        %   time should not be greater than the sweep time. This property is
        %   tunable. The default value is 1 seconds.
        TargetTime;

        %Type Frequency sweep type
        %   Specify the frequency sweep type as one of ['Swept cosine' |
        %   {'Linear'} | 'Logarithmic' | 'Quadratic']. This property specifies
        %   how the output instantaneous frequency sweep varies over time.
        Type;

    end
end
