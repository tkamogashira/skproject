classdef DynamicRangeBase < matlab.System
%DynamicRangeExpander Base class for dynamic range Compressor and expander
    
    %#codegen
    %#ok<*EMCLS>
    
 % Copyright 2013 The MathWorks, Inc.
   
    properties (Nontunable)
        %SampleRate Sample rate of input
        %   Specify the sample rate of the input in Hertz as a finite
        %   numeric scalar. The default is 44100 Hz.
        SampleRate = 44100;
    end
    
    properties
        %Threshold Operation threshold
        %   Specify the threshold, in dB, above which gain adjustment
        %   starts. The default is -10 dB.
        Threshold        = -10;
        %KneeWidth  Knee width
        %   Specify the gain controller knee width in dB. The default is 4.
        KneeWidth        = 4;
        %MakeUpGain Make-up gain
        %   Specify the make-up gain, in dB, at the output. The default is 
        %   0.
        MakeUpGain       = 0;
        %AttackTime Attack time
        %   Specify the attack time in sec as a scalar real value greater
        %   than or equal to 0. The attack time is defined as the time it
        %   takes the envelope detector to rise from 10% to 90% of its
        %   final value. The default is 50 msec.
        AttackTime = 50e-3;
        %ReleaseTime Release time
        %   Specify the release time in sec as a scalar real value greater
        %   than or equal to 0. The release time is defined as the time it
        %   takes the envelope detector to drop from 90% to 10% of its
        %   final value. The default is 100 msec.
        ReleaseTime = 100e-3;
    end
    
    properties (Access = private, Nontunable)
        %pNumChannels Cached number of input channels
        pNumChannels;
    end
    
    properties  (Access = private)
        %pAlphaA Attack forgetting factor
        pAlphaA
        %pAlphaR Release forgetting factor
        pAlphaR
        %pLevelDetectionState Level state
        pLevelDetectionState;
        % pPropChanged true if proerty changed since last call to step
        pPropChanged = false;
    end
    
    %--------------------------------------------------------------------------
    % Public methods
    %--------------------------------------------------------------------------
    methods
        % Constructor
        function obj = DynamicRangeBase(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    %--------------------------------------------------------------------------
    % Abstract Protected methods
    %--------------------------------------------------------------------------
    methods (Abstract, Access = public)
        % Abstract methods.
        computeGain(~,~);
    end
    
    %--------------------------------------------------------------------------
    % Protected methods
    %--------------------------------------------------------------------------
    methods(Access = protected)
        
        function setupParameters(obj)
            % Map the attack and release times to the forgetting factors
            obj.pAlphaA = exp(-log(9)/(obj.AttackTime * obj.SampleRate));
            obj.pAlphaR = exp(-log(9)/(obj.ReleaseTime * obj.SampleRate));
            % Set pPropChanged flag
            obj.pPropChanged = true;
        end
        
        function processTunedPropertiesImpl(obj)
            setupParameters(obj);
        end
        
        function [y,yLevel,propChanged] = stepImpl(obj, x)
            
            xabs = abs(x);
            
            % Detect signal level
            yLevel = detectLevel(obj,xabs);
            
            % Convert to dB
            ydB = 10 * log10(yLevel + eps);
            
            % Compute gain
            G = computeGain(obj,ydB);
            
            %Convert to linear
            gain = 10.^((G + obj.MakeUpGain)/10);
            y = gain .* x;
            propChanged = obj.pPropChanged;
            obj.pPropChanged = false;
            
        end
        
        function no = getNumOutputsImpl(~)
            no = 3;
        end
        
        function setupImpl(obj, x)
            % Cache number of input channels
            obj.pNumChannels = size(x,2);
            setupParameters(obj);
        end
        
        function  resetImpl(obj)
            % Reset state
            obj.pLevelDetectionState = zeros(1,obj.pNumChannels);
        end
        
    end
    
    methods (Access = protected)
        
        function yout = detectLevel(obj,x)
            % Smooth Branching Level Detector
            y = zeros(length(x)+1,obj.pNumChannels);
            y(1,:) = obj.pLevelDetectionState;
            
            % Cache parameter values for performance
            alphaA = obj.pAlphaA;
            alphaR = obj.pAlphaR;
            betaA = 1 - alphaA;
            betaR = 1 - alphaR;
            
            L1 = size(x,1);
            L2 = obj.pNumChannels;
            for i=1:L1
                for j=1:L2
                    if x(i,j) > y(i,j) % attack
                        y(i+1,j) =  alphaA*y(i,j) + betaA*x(i,j);
                    else % release
                        y(i+1,j) =  alphaR*y(i,j) + betaR*x(i,j);
                    end
                end
            end
            yout = y(2:end,:);
            % Update state
            obj.pLevelDetectionState = y(end,:);
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                s.pNumChannels = obj.pNumChannels;
                s.pAlphaA = obj.pAlphaA;
                s.pAlphaR = obj.pAlphaR;
                s.pLevelDetectionState = obj.pLevelDetectionState;
            end
        end
        
        function loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                obj.pNumChannels = s.pNumChannels;
                obj.pAlphaA = s.pAlphaA;
                obj.pAlphaR = s.pAlphaR;
                obj.pLevelDetectionState = s.pLevelDetectionState;
            end
            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        
    end
    
end