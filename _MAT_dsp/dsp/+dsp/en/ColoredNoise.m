classdef ColoredNoise< handle
%ColoredNoise Generate a colored noise signal
%  HCN = dsp.ColoredNoise returns a colored noise object, HCN, that
%  outputs a noise signal one sample or frame at a time, with a 1/f^aplha
%  spectral characteristic over its entire frequency range. Typical values
%  for alpha are: alpha = 1 (pink noise), alpha = 2 (brownian noise).
%
%  HCN = dsp.ColoredNoise('PropertyName',PropertyValue,...) returns a
%  colored noise object, HCN, with each specified property set to a
%  specified value.
%
%  HCN = dsp.ColoredNoise(POW,SAMP,CHAN,'PropertyName',PropertyValue)
%  returns a colored noise object, HCN, with InverseFrequencyPower property
%  set to POW, SamplesPerFrame property set to SAMP, NumChannels property
%  set to CHAN and other specified properties set to specified values.
%
%  The ColoredNoise object uses the default MATLAB random stream. Reset
%  the default stream for repeatable simulations. Type 'help RandStream'
%  for more information.
%
%  Step method syntax:
%
%  Y = step(HCN) outputs one sample or frame of data, Y.
%
%  ColoredNoise methods:
%
%  step     - Generate colored noise signal
%  release  - Allow property value and input characteristics changes
%  clone    - Create colored noise object with same property values
%  isLocked - Locked status (logical)
%  reset    - Reset the generator internal states and the random number
%             stream if the RandomStream property is set to
%             'mt19937ar with seed'
%
%  ColoredNoise properties:
%
%  InverseFrequencyPower - Define alpha, inverse frequency power in
%                          spectral characteristic 1/f^alpha.
%  SamplesPerFrame       - Number of samples per output frame
%  NumChannels           - Number of output channels
%  RandomStream          - Source of random number stream
%  Seed                  - Initial seed of mt19937ar random number stream
%  OutputDataType        - Output data type
%
%  % EXAMPLE: Define a pink noise generator to output 2 channels of 1024
%  % noise samples and compute the power spectrum of the averaged signal 
%  % using a spectrum analyzer:
%
%    Hpink = dsp.ColoredNoise(1, 1024, 2);
%    Hsa   = dsp.SpectrumAnalyzer('SpectrumType', 'Power density',...
%                           'PlotAsTwoSidedSpectrum', false,...
%                           'FrequencyScale', 'Log',...
%                           'OverlapPercent', 50,...
%                           'Window', 'Hamming',...
%                           'YLimits', [-50,5],...
%                           'SpectralAverages',50);
%
%    tic,
%    while toc < 30
%        % Run for 30 seconds
%        pink = step(Hpink);     % pink is a 1024-by-2 frame of samples     
%        step(Hsa, pink);
%    end
%
%
%  For more information see the <a href="matlab:web([docroot,'\dsp\examples\octave-band-and-fractional-octave-band-filters.html'])">Octave-Band and Fractional Octave-Band Filters Example</a>.

 
%  Copyright 2014 The MathWorks, Inc.

    methods
        function out=ColoredNoise
            %ColoredNoise Generate a colored noise signal
            %  HCN = dsp.ColoredNoise returns a colored noise object, HCN, that
            %  outputs a noise signal one sample or frame at a time, with a 1/f^aplha
            %  spectral characteristic over its entire frequency range. Typical values
            %  for alpha are: alpha = 1 (pink noise), alpha = 2 (brownian noise).
            %
            %  HCN = dsp.ColoredNoise('PropertyName',PropertyValue,...) returns a
            %  colored noise object, HCN, with each specified property set to a
            %  specified value.
            %
            %  HCN = dsp.ColoredNoise(POW,SAMP,CHAN,'PropertyName',PropertyValue)
            %  returns a colored noise object, HCN, with InverseFrequencyPower property
            %  set to POW, SamplesPerFrame property set to SAMP, NumChannels property
            %  set to CHAN and other specified properties set to specified values.
            %
            %  The ColoredNoise object uses the default MATLAB random stream. Reset
            %  the default stream for repeatable simulations. Type 'help RandStream'
            %  for more information.
            %
            %  Step method syntax:
            %
            %  Y = step(HCN) outputs one sample or frame of data, Y.
            %
            %  ColoredNoise methods:
            %
            %  step     - Generate colored noise signal
            %  release  - Allow property value and input characteristics changes
            %  clone    - Create colored noise object with same property values
            %  isLocked - Locked status (logical)
            %  reset    - Reset the generator internal states and the random number
            %             stream if the RandomStream property is set to
            %             'mt19937ar with seed'
            %
            %  ColoredNoise properties:
            %
            %  InverseFrequencyPower - Define alpha, inverse frequency power in
            %                          spectral characteristic 1/f^alpha.
            %  SamplesPerFrame       - Number of samples per output frame
            %  NumChannels           - Number of output channels
            %  RandomStream          - Source of random number stream
            %  Seed                  - Initial seed of mt19937ar random number stream
            %  OutputDataType        - Output data type
            %
            %  % EXAMPLE: Define a pink noise generator to output 2 channels of 1024
            %  % noise samples and compute the power spectrum of the averaged signal 
            %  % using a spectrum analyzer:
            %
            %    Hpink = dsp.ColoredNoise(1, 1024, 2);
            %    Hsa   = dsp.SpectrumAnalyzer('SpectrumType', 'Power density',...
            %                           'PlotAsTwoSidedSpectrum', false,...
            %                           'FrequencyScale', 'Log',...
            %                           'OverlapPercent', 50,...
            %                           'Window', 'Hamming',...
            %                           'YLimits', [-50,5],...
            %                           'SpectralAverages',50);
            %
            %    tic,
            %    while toc < 30
            %        % Run for 30 seconds
            %        pink = step(Hpink);     % pink is a 1024-by-2 frame of samples     
            %        step(Hsa, pink);
            %    end
            %
            %
            %  For more information see the <a href="matlab:web([docroot,'\dsp\examples\octave-band-and-fractional-octave-band-filters.html'])">Octave-Band and Fractional Octave-Band Filters Example</a>.
        end

        function getNumInputsImpl(in) %#ok<MANU>
            % stepImpl has no input beyond obj
        end

        function getNumOutputsImpl(in) %#ok<MANU>
            % stepImpl has one output
        end

        function getPropertyGroupsImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % Seed is unused when RandomStream is set to 'Global stream'
        end

        function loadObjectImpl(in) %#ok<MANU>
            % Re-load private properties
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
            % Default implementaion saves all public properties
        end

        function setupImpl(in) %#ok<MANU>
            % The AR filter denominator is given by the following formula:
            % den(0)=1, den(k)= (k-1-alpha/2)*den(k-1)/k, where alpha is
            % the inverse frequency power.
            % Reference:
            % N. Jeremy Kasdin
            % Discrete Simulation of Colored Noise and Stochastic Processes
            % and 1/f^alpha Power Law Noise Generation.
            % IEEE, 1995.
        end

        function stepImpl(in) %#ok<MANU>
            % Noise (random number) generation
        end

    end
    methods (Abstract)
    end
    properties
        %InverseFrequencyPower  Power of inverse frequency
        %   Specify alpha in the 1/f^alpha spectral characteristic of the
        %   generated noise sequence over its entire frequency range.
        %   InverseFrequencyPower can be any value in the interval [-2,2].
        %   The default value is 1 (pink noise).
        InverseFrequencyPower;

        %NumChannels Number of output channels
        %   Specify the number of output channels as an integer.
        %   The default value is 1.
        NumChannels;

        %OutputDataType Output data type
        %   Specify the output data type as one of 'double' | 'single'.
        %   The default value is 'double'.
        OutputDataType;

        %RandomStream Random number source
        %   Specify the source of random number stream as one of
        %   'Global stream' | 'mt19937ar with seed'. If RandomStream is set
        %   to 'Global stream', the current global random number stream is
        %   used for normally distributed random number generation. If
        %   RandomStream is set to 'mt19937ar with seed', the mt19937ar
        %   algorithm is used for normally distributed random number
        %   generation, in which case the reset method re-initializes the
        %   random number stream to the value of the Seed property.
        %   The default value is 'Global stream'.
        RandomStream;

        %SamplesPerFrame Number of samples per output frame
        %   Specify the number of samples to buffer into each output frame.
        %   The default value is 1024.
        SamplesPerFrame;

        %Seed Initial seed
        %   Specify the initial seed of a mt19937ar random number generator
        %   algorithm as a double precision, real, nonnegative integer
        %   scalar. This property applies when you set the RandomStream
        %   property to 'mt19937ar with seed'. The Seed is to re-initialize
        %   the mt19937ar random number stream in the reset method.
        %   The default value is 67.
        Seed;

    end
end
