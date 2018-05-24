classdef SineWave< handle
%SineWave Generate discrete sine wave
%   HSIN = dsp.SineWave returns a sine wave System object, HSIN, that
%   generates a multichannel real or complex sinusoidal signal, with
%   independent amplitude, frequency, and phase in each output channel.
%
%   HSIN = dsp.SineWave('PropertyName', PropertyValue, ...) returns a sine
%   wave object, HSIN, with each specified property set to the specified
%   value.
%
%   HSIN = dsp.SineWave(AMP, FREQ, PHASE, 'PropertyName', PropertyValue,
%   ...) returns a sine wave object, HSIN, with the Amplitude property set
%   to AMP, Frequency property set to FREQ, PhaseOffset property set to
%   PHASE and other specified properties set to the specified values.
%
%   A real sinusoidal signal is generated when the ComplexOutput property
%   is set to false, and is defined by an expression of the type
%
%   y = A*sin(2*pi*f*t + phi)
%
%   where you specify A in the Amplitude property, f (in Hertz) in the
%   Frequency property, and phi (in radians) in the PhaseOffset property. A
%   complex exponential signal is generated when the ComplexOutput property
%   is set to true, and is defined by an expression of the type
%
%   y = A*(cos(2*pi*f*t + phi) + j*sin(2*pi*f*t + phi))
%
%   For both real and complex sinusoids, the Amplitude, Frequency, and
%   PhaseOffset property values can be scalars or length-N vectors, where N
%   is the desired number of channels in the output. When you specify at
%   least one of these properties as a length-N vector, scalar values
%   specified for the other properties are applied to every channel.
%
%   Step method syntax:
%
%   Y = step(HSIN) produces the sine wave output Y.
%
%   SineWave methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create sine wave object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset to the beginning of the sine wave
%
%   SineWave properties:
%
%   Amplitude         - Amplitude of the sine wave
%   Frequency         - Frequency (Hz) of the sine wave
%   PhaseOffset       - Phase offset (rad) of the sine wave
%   ComplexOutput     - Indicates whether the waveform is complex or real
%   Method            - Method used to generate sinusoids
%   TableOptimization - Optimizes table of sine values for Speed or Memory
%   SampleRate        - Sample rate of output signal
%   SamplesPerFrame   - Number of samples per frame
%   OutputDataType    - Output data type
%
%   This System object supports fixed-point operations. For more
%   information, type dsp.SineWave.helpFixedPoint.
%
%   % EXAMPLE #1: Generate a sine wave of amplitude 2 and frequency 10Hz
%       hsin1 = dsp.SineWave(2, 10);
%       hsin1.SamplesPerFrame = 1000;
%       y = step(hsin1);
%       plot(y);
%
%   % EXAMPLE #2: Generate two sine waves offset by a phase of pi/2 radians
%       hsin2 = dsp.SineWave;
%       hsin2.Frequency = 10;
%       hsin2.PhaseOffset = [0 pi/2];
%       hsin2.SamplesPerFrame = 1000;
%       y = step(hsin2);
%       plot(y);
%
%   See also dsp.Chirp, dsp.NCO, dsp.SineWave.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=SineWave
            %SineWave Generate discrete sine wave
            %   HSIN = dsp.SineWave returns a sine wave System object, HSIN, that
            %   generates a multichannel real or complex sinusoidal signal, with
            %   independent amplitude, frequency, and phase in each output channel.
            %
            %   HSIN = dsp.SineWave('PropertyName', PropertyValue, ...) returns a sine
            %   wave object, HSIN, with each specified property set to the specified
            %   value.
            %
            %   HSIN = dsp.SineWave(AMP, FREQ, PHASE, 'PropertyName', PropertyValue,
            %   ...) returns a sine wave object, HSIN, with the Amplitude property set
            %   to AMP, Frequency property set to FREQ, PhaseOffset property set to
            %   PHASE and other specified properties set to the specified values.
            %
            %   A real sinusoidal signal is generated when the ComplexOutput property
            %   is set to false, and is defined by an expression of the type
            %
            %   y = A*sin(2*pi*f*t + phi)
            %
            %   where you specify A in the Amplitude property, f (in Hertz) in the
            %   Frequency property, and phi (in radians) in the PhaseOffset property. A
            %   complex exponential signal is generated when the ComplexOutput property
            %   is set to true, and is defined by an expression of the type
            %
            %   y = A*(cos(2*pi*f*t + phi) + j*sin(2*pi*f*t + phi))
            %
            %   For both real and complex sinusoids, the Amplitude, Frequency, and
            %   PhaseOffset property values can be scalars or length-N vectors, where N
            %   is the desired number of channels in the output. When you specify at
            %   least one of these properties as a length-N vector, scalar values
            %   specified for the other properties are applied to every channel.
            %
            %   Step method syntax:
            %
            %   Y = step(HSIN) produces the sine wave output Y.
            %
            %   SineWave methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create sine wave object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset to the beginning of the sine wave
            %
            %   SineWave properties:
            %
            %   Amplitude         - Amplitude of the sine wave
            %   Frequency         - Frequency (Hz) of the sine wave
            %   PhaseOffset       - Phase offset (rad) of the sine wave
            %   ComplexOutput     - Indicates whether the waveform is complex or real
            %   Method            - Method used to generate sinusoids
            %   TableOptimization - Optimizes table of sine values for Speed or Memory
            %   SampleRate        - Sample rate of output signal
            %   SamplesPerFrame   - Number of samples per frame
            %   OutputDataType    - Output data type
            %
            %   This System object supports fixed-point operations. For more
            %   information, type dsp.SineWave.helpFixedPoint.
            %
            %   % EXAMPLE #1: Generate a sine wave of amplitude 2 and frequency 10Hz
            %       hsin1 = dsp.SineWave(2, 10);
            %       hsin1.SamplesPerFrame = 1000;
            %       y = step(hsin1);
            %       plot(y);
            %
            %   % EXAMPLE #2: Generate two sine waves offset by a phase of pi/2 radians
            %       hsin2 = dsp.SineWave;
            %       hsin2.Frequency = 10;
            %       hsin2.PhaseOffset = [0 pi/2];
            %       hsin2.SamplesPerFrame = 1000;
            %       y = step(hsin2);
            %       plot(y);
            %
            %   See also dsp.Chirp, dsp.NCO, dsp.SineWave.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display dsp.SineWave System object fixed-point
            %               information
            %   dsp.SineWave.helpFixedPoint displays information about
            %   fixed-point properties and operations of the dsp.SineWave
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Amplitude Amplitude of the sine wave
        %   A length-N vector containing the amplitudes of the sine waves in
        %   each of N output channels, or a scalar to be applied to all N
        %   channels. The vector length must be the same as that specified for
        %   the Frequency and PhaseOffset properties. The default value of this 
        %   property is 1.
        Amplitude;

        %ComplexOutput Indicates whether the waveform is complex or real
        %   Set to true to set the complexity of the waveform to be complex.
        %   Otherwise, the waveform output is real. The default value of this
        %   property is false.
        ComplexOutput;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed numerictype
        %   object. This property is only applicable when the OutputDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],16).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %Frequency Frequency (Hz) of the sine wave
        %   A length-N vector containing frequencies, in Hertz, of the sine
        %   waves in each of N output channels, or a scalar to be applied to
        %   all N channels. The vector length must be the same as that
        %   specified for the Amplitude and PhaseOffset properties. You can
        %   specify positive, zero, or negative frequencies. The default value
        %   of this property is 100.
        Frequency;

        %Method Method used to generate sinusoids
        %   The sinusoids are generated by one of [{'Trigonometric function'} |
        %   'Table lookup' | 'Differential']. The trigonometric function method
        %   computes the sinusoid in the i'th channel, yi, by sampling the
        %   continuous function. The table lookup method precomputes the unique
        %   samples of every output sinusoid at the start of the simulation,
        %   and recalls the samples from memory as needed. The differential
        %   method uses an incremental algorithm. This algorithm computes the
        %   output samples based on the output values computed at the previous
        %   sample time (and precomputed update terms).
        Method;

        %OutputDataType Output data type
        %   Specify the output data type as one of [{'double'} | 'single' |
        %   'Custom'].
        OutputDataType;

        %PhaseOffset Phase offset (rad) of the sine wave
        %   A length-N vector containing the phase offsets, in radians, of the
        %   sine waves in each of N output channels, or a scalar to be applied
        %   to all N channels. The vector length must be the same as that
        %   specified for the Amplitude and Frequency properties. The default 
        %   value of this property is 0.
        PhaseOffset;

        %SampleRate Sample time of output signal
        %   Specify the sampling rate of the output in Hz as a positive numeric
        %   scalar. The default value is 1000.
        SampleRate;

        %SamplesPerFrame Number of samples per frame
        %   Specify the number of consecutive samples from each sinusoid to
        %   buffer into the output frame. The default value of this property is
        %   1.
        SamplesPerFrame;

        %TableOptimization Optimizes table of sine values for Speed or Memory
        %  Optimizes the table of sine values for one of [{'Speed'} |
        %  'Memory']. When optimized for speed, the table contains k elements,
        %  and when optimized for memory, the table contains k/4 elements,
        %  where k is the number of input samples in one full period of the
        %  sine wave. This property is only applicable when the
        %  Method property is 'Table lookup'. 
        TableOptimization;

    end
end
