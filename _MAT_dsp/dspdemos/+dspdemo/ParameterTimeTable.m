classdef ParameterTimeTable < matlab.System
%PARAMETERTIMETABLE Table for simulation parameters variation over time
% 
%   Step method syntax:
%
%   [currValues, haveValuesChanged] = step(HPTT) Returns the parameter
%   values for the current simulation time step in the structure
%   currValues, with as many fields as available varying parameters. The
%   logical output haveValuesChanged is true if the values in currValues
%   are different from the ones returned with the last call to step.
%   haveValuesChaged is always true for the first call to step. 
% 
%   ParameterTimeTable properties:
%
%   Time        - Vector with monotonically-increasing time values
%                 when changes in parameter values occurr. It is often
%                 The first element of Time must be 0
%   Values      - Vector of Structures, with as many fields as 
%                 parameters and as many elements as the length of the
%                 property Time
%   SampleRate  - Update rate. Indicates how often the step function
%                 is called. For frame-based processing,
%                 this should be set to Fs/frameLength
%
% Copyright 2013 The MathWorks, Inc.

    properties
        Time = 0
        Values = struct('Value', 1)
        SampleRate = 1
    end
    
    properties(Access = private)
        pTableIdx
        pMaxIdx
        pCurrTime
        pTick
        pCurrValues
        pSampleTime
    end
    
    methods
        function obj = ParameterTimeTable(varargin)
            setProperties(obj, nargin, varargin{:})
        end
    end
    methods(Access = protected)
        function validatePropertiesImpl(obj)
            % Time and Values need to have the same length
            if(length(obj.Time) ~= length(obj.Values))
                % Throw 'Time and Values must have the same length'
                coder.private.errorIf(true, ['dsp:demo',...
                    ':HelperParameterTimeTableTimeValueDiffLengths'])
            end
            % Time vector should start with 0
            if(obj.Time(1) ~= 0)
                % Throw 'Time(1) must be 0'
                coder.private.errorIf(true, ['dsp:demo',...
                    ':HelperParameterTimeTableTime1Nonzero'])
            end
        end
        function setupImpl(obj)
            obj.pMaxIdx = numel(obj.Values);
            obj.pCurrTime = 0;
            obj.pCurrValues = obj.Values(1);
            obj.pTableIdx = 0;
            obj.pSampleTime = 1/obj.SampleRate;
        end
        function resetImpl(obj)
            obj.pCurrTime = 0;
            obj.pCurrValues = obj.Values(1);
            obj.pTableIdx = 0;
        end
        function N = getNumInputsImpl(~)
            N = 0;
        end
        function N = getNumOutputsImpl(~)
            N = 2;
        end
        function [currentValues, valuesChanged] = stepImpl(obj)
            obj.pCurrTime = obj.pCurrTime + obj.pSampleTime;
            valuesChanged = false;
            tmp = find(obj.pCurrTime >= obj.Time, 1, 'last');
            if(tmp ~= obj.pTableIdx)
                valuesChanged = true;
                obj.pTableIdx = tmp;
                obj.pCurrValues = obj.Values(tmp);
            end
            
            currentValues = obj.pCurrValues;
        end
    end
end