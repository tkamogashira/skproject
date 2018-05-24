function [H, tags] = analyzeLogicFromSimulink(SimulinkData)
% analyzeLogicFromSimulink
%
% Takes in a Simulink Dataset and creates a Logic Analyzer display with the
% data provided. Returns a handle to the Logic Analyzer System object.

%   Copyright 2012-2013 The MathWorks, Inc.

% Input needs to be a Simulink Dataset
if ~isa(SimulinkData, 'Simulink.SimulationData.Dataset')
    error(message('dspshared:LogicAnalyzer:inputDataset'));
end

% Determine the number of inputs to the Logic Analyzer
numInputs = SimulinkData.numElements;

% Error if there are no elements in the Dataset
if (numInputs == 0)
    error(message('dspshared:LogicAnalyzer:noElementsInDataset'));
end

% Create a Logic Analyzer System object with the appropriate number of
% inputs. Use the name of the Dataset as the Title.
H = dsp.LogicAnalyzer(numInputs);
H.Name = SimulinkData.Name;

% All elements need to have the same sample time & time sets
defTime = SimulinkData.getElement(1).Values.Time;
defSampleTime = SimulinkData.getElement(1).Values.TimeInfo.Increment;

% Decimation of data can lead to a NaN sample time
% In this case, use the time difference between the first two samples
if ~isnan(defSampleTime)
    H.SampleTime = defSampleTime;
else
    H.SampleTime = defTime(2) - defTime(1);
end


cumulativeData = cell(1,numInputs);

tags = cell(1,numInputs);

% Go over the inputs one at a time
for ii = 1:numInputs
    % Gather this input element of the Dataset
    dsElement = SimulinkData.getElement(ii);
    
    % All elements must have the same sample time
    if (defSampleTime ~= dsElement.Values.TimeInfo.Increment)
        error(message('dspshared:LogicAnalyzer:sampleTimeInDataset'));
    end
    
    % All elements must have the same time set
    if (defTime ~= dsElement.Values.Time)
        error(message('dspshared:LogicAnalyzer:diffTimeSetsInDataset'));
    end

    % If the name of the element is empty, use a default name of Channel#
    inputName = dsElement.Name;
    if isempty(inputName)
        inputName = ['Channel' num2str(ii)];
    end
    
    % Add in the name & input channel for the wave
    % Collect the tag passed out - this can be used to modify the display
    tags{ii} = addWave(H, 'InputChannel', ii, 'Name', inputName);
    
    % Append the data to the previously gathered data
    % Remove singleton dimensions
    cumulativeData{ii} = squeeze(dsElement.Values.Data);
end

% Check to make sure 
if any(cellfun(@isempty, cumulativeData))
    error(message('dspshared:LogicAnalyzer:noDataGathered'));
end

% Add the data for all the signals - this can be done all at once, or one
% step at a time
step(H, cumulativeData{:});

% Set the time span to show all the data
H.TimeSpan = length(SimulinkData.getElement(1).Values.Time) * defSampleTime;

end % analyzelogicFromSimulink
