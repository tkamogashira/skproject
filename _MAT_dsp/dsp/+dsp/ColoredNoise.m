classdef ColoredNoise < matlab.System
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

%#codegen
%#ok<*EMCA>
   
    properties (Nontunable)
        %InverseFrequencyPower  Power of inverse frequency
        %   Specify alpha in the 1/f^alpha spectral characteristic of the
        %   generated noise sequence over its entire frequency range.
        %   InverseFrequencyPower can be any value in the interval [-2,2].
        %   The default value is 1 (pink noise).
        InverseFrequencyPower  = 1;
        %SamplesPerFrame Number of samples per output frame
        %   Specify the number of samples to buffer into each output frame.
        %   The default value is 1024.
        SamplesPerFrame = 1024;
        %NumChannels Number of output channels
        %   Specify the number of output channels as an integer.
        %   The default value is 1.
        NumChannels = 1;        
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
        RandomStream = 'Global stream';
        %Seed Initial seed
        %   Specify the initial seed of a mt19937ar random number generator
        %   algorithm as a double precision, real, nonnegative integer
        %   scalar. This property applies when you set the RandomStream
        %   property to 'mt19937ar with seed'. The Seed is to re-initialize
        %   the mt19937ar random number stream in the reset method.
        %   The default value is 67.
        Seed = 67;
        %OutputDataType Output data type
        %   Specify the output data type as one of 'double' | 'single'.
        %   The default value is 'double'.
        OutputDataType = 'double';
    end
    
    properties (Constant, Hidden)
        OutputDataTypeSet = matlab.system.StringSet({...
            'double', ...
            'single'});
        RandomStreamSet = matlab.system.StringSet({...
            'Global stream', ...
            'mt19937ar with seed'});
    end

    properties (Access = private)
        %pFilterCoef Holds the AR filter denominator coefficients computed
        %  within setupImpl and used within stepImpl
        pFilterCoef;
        %pFilterStates Holds internal filter states within a vector of size
        %  (63 x 1)
        pFilterStates;
        % Random number generator state
        pWNState;
    end
    
    methods
        % Constructor
        function obj = ColoredNoise(varargin)
            setProperties(obj, nargin, varargin{:}, ...
                'InverseFrequencyPower', ...
                'SamplesPerFrame', ...
                'NumChannels');
        end
        
        function set.SamplesPerFrame(obj, val)
            validateattributes(val, ...
                {'numeric'}, ...
                {'nonnegative', 'integer', 'scalar'}, ...
                'set.SamplesPerFrame', ...
                'SamplesPerFrame');
            obj.SamplesPerFrame = val;
        end
        
        function set.NumChannels(obj, val)
            validateattributes(val, ...
                {'numeric'}, ...
                {'positive', 'integer', 'scalar'}, ...
                'set.NumChannels', ...
                'NumChannels');
            obj.NumChannels = val;
        end        

        function set.InverseFrequencyPower(obj, val)
            validateattributes(val, ...
                {'numeric'}, ...
                {'real', 'scalar', '>=', -2, '<=', 2}, ...
                'set.InverseFrequencyPower ', ...
                'InverseFrequencyPower ');
            obj.InverseFrequencyPower  = val;
        end
        
        function set.Seed(obj, val)
            validateattributes(val, ...
                {'double'}, ...
                {'real', 'scalar', 'integer', 'nonnegative', 'finite'}, ...
                'set.Seed', ...
                'Seed');
            obj.Seed = val;
        end
    end

    methods (Access=protected)

        function N = getNumInputsImpl(~)
            % stepImpl has no input beyond obj
            N = 0;
        end

        function N = getNumOutputsImpl(~)
            % stepImpl has one output
            N = 1;
        end
        
        function flag = isInactivePropertyImpl(obj, prop)
            % Seed is unused when RandomStream is set to 'Global stream'
            flag = false;
            if strcmp(prop, 'Seed')
                if strcmp(obj.RandomStream, 'Global stream')
                    flag = true;
                end
            end
        end
      
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);

            % Save private properties
            if isLocked(obj)
                s.pFilterCoef = obj.pFilterCoef;
                s.pFilterStates = obj.pFilterStates;
                s.pWNState = obj.pWNState;
            end
        end
        
        function loadObjectImpl(obj, s, wasLocked)
            % Re-load private properties
            if wasLocked
                obj.pFilterCoef = s.pFilterCoef;
                obj.pFilterStates = s.pFilterStates;
                obj.pWNState = s.pWNState;
            end
            
            % Call base class method
            loadObjectImpl@matlab.System(obj, s, wasLocked);
        end

        function setupImpl(obj,varargin)
            % The AR filter denominator is given by the following formula:
            % den(0)=1, den(k)= (k-1-alpha/2)*den(k-1)/k, where alpha is
            % the inverse frequency power.
            % Reference:
            % N. Jeremy Kasdin
            % Discrete Simulation of Colored Noise and Stochastic Processes
            % and 1/f^alpha Power Law Noise Generation.
            % IEEE, 1995.
            den = zeros(1, 64, obj.OutputDataType);
            den(1) = 1;
            for idx = 2:64
                den(idx) = (idx - 2 - obj.InverseFrequencyPower/2) * ...
                           den(idx-1) / (idx-1);
            end
            
            obj.pFilterCoef = den;
            
            obj.pFilterStates = zeros(length(obj.pFilterCoef)-1,...
                                      obj.NumChannels, obj.OutputDataType);
        end

        function resetImpl(obj)
            obj.pFilterStates = zeros(length(obj.pFilterCoef)-1,...
                                      obj.NumChannels, obj.OutputDataType);
                                  
            if ~isempty(coder.target)
                obj.pWNState = eml_rand_mt19937ar('preallocate_state');
                if strcmp(obj.RandomStream, 'mt19937ar with seed')
                    obj.pWNState = eml_rand_mt19937ar('seed_to_state',...
                                       obj.pWNState, obj.Seed);
                end
            elseif strcmp(obj.RandomStream, 'mt19937ar with seed')
                stream = RandStream('mt19937ar', 'seed', obj.Seed);
                % Log randstream state
                obj.pWNState = stream.State;
            end
        end

        function out = stepImpl(obj,varargin)
            % Noise (random number) generation
            if strcmp(obj.RandomStream, 'Global stream')
                whiteNoise = randn(obj.SamplesPerFrame, obj.NumChannels,...
                                   obj.OutputDataType);
            elseif isempty(coder.target)
                stream = RandStream('mt19937ar');
                % Retrieve previous state
                stream.State = obj.pWNState;
                whiteNoise = randn(stream, obj.SamplesPerFrame,...
                                   obj.NumChannels, obj.OutputDataType);
                % Log randstream state
                obj.pWNState = stream.State;
            else
                allRandData = coder.nullcopy(zeros(obj.SamplesPerFrame,...
                                   obj.NumChannels, obj.OutputDataType));
                state = obj.pWNState;
                for colIdx = 1:obj.NumChannels
                    % Noise is generated column-wisely
                    for rowIdx = 1:obj.SamplesPerFrame
                        [state, allRandData(rowIdx, colIdx)] = ...
                            eml_rand_mt19937ar('generate_normal', state,...
                                   obj.OutputDataType);
                    end
                end
                obj.pWNState = state;

                whiteNoise = allRandData;
            end

            % Create colored noise
            [out, obj.pFilterStates] = filter(1, obj.pFilterCoef,...
                                              whiteNoise,...
                                              obj.pFilterStates);
        end
    end
    
    methods(Static, Access = protected)
        function groups = getPropertyGroupsImpl
            param = matlab.system.display.Section( ...
                'Title', 'Parameters', ...
                'PropertyList', {'InverseFrequencyPower', ...
                'SamplesPerFrame', 'NumChannels', 'OutputDataType'});
            
            pRandStream = matlab.system.display.internal.Property( ...
                'RandomStream', ...
                'IsGraphical', false, ...
                'UseClassDefault', false, ...
                'Default', 'mt19937ar with seed');
            
            randomization = matlab.system.display.Section( ...
                'Title', 'Randomization', ...
                'PropertyList', {pRandStream, 'Seed'});
            
            groups = [param randomization];
        end
    end
end
