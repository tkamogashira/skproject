function [paramNew, simControlFlags] = HelperUnpackUDP
%HELPERUNPACKUDP Unpack contents of UDP packet from tuning UI
% Function to resolve the UDP packet received from Parameter Tuning UI
% into parameter values, reset flag and stop simulation flag.
% Input:
%         none
% Output:
%         paramNew        - Array of parameter values received from the UI
%         simControlFlags - Structure containing flags for simulation
%                           control. These include the following:
%                           resetObj: Flag to reset the System object. 
%                                     If true, the object needs to be reset
%                           pauseSim: Flag to pause the simulation. If 
%                                     true, the simulation needs to be 
%                                     paused.
%                           stopSim:  Flag to stop the simulation. If true,
%                                     the simulation needs to be stopped
%
% This function HelperUnpackUDP is only in support of
% HelperCreateParamTuningUI. It may change in a future release.
%
% Example:
%         % obj is a System object with a tunable parameter 'Position'
%         obj = dsp.TimeScope('Position', [100 100 560 420]);
%         
%         % Define parameters to be tuned
%         param(1).Name = 'X-Position';
%         param(1).InitialValue = obj.Position(1);
%         param(1).Limits = [0, 400];
% 
%         % Create UI to tune the Position parameter
%         hUI = HelperCreateParamTuningUI(param);
% 
%         while(1)  % Continue until 'Stop Simulation' button is pressed
%             [paramNew, simControlFlags] = HelperUnpackUDP(); 
%                    % Obtain new values for parameter through UDP Receive
% 
%             if simControlFlags.stopSim      % Check if simulation needs to be stopped
%                 break;
%             end
%             if simControlFlags.pauseSim
%                 drawnow;
%                 continue;
%             end
%             if ~isempty(paramNew)
%                 if simControlFlags.resetObj     % Check if object needs to be reset
%                     reset(obj);
%                 end
% 
%                 obj.Position(1) = paramNew(1);  % Change Parameter value
%             end
% 
%             % Now that the parameter is tuned, call the STEP function
%             x = randn;
%             step(obj, x);
%         end
%       
%         % Cleanup
%         close(hUI);      % Close the tuning UI
%         release(obj);     % Release the System object

% Copyright 2013 The MathWorks, Inc.

persistent hUDPReceiver resetSwitch pauseSwitch

if isempty(hUDPReceiver)
    % UDP Receiver
    hUDPReceiver = dsp.UDPReceiver('MessageDataType','double',...
                            'ReceiveBufferSize',400);
    resetSwitch = false;
    pauseSwitch = false;
end

simControlFlags.resetObj = false;
simControlFlags.pauseSim = pauseSwitch;
simControlFlags.stopSim  = false;

paramNew = step(hUDPReceiver);
if isempty(paramNew)
    return;
else
    % paramNew has new values for parameters for the first N elements,
    % where N is the number of parameters tuned in the UI. The last three
    % elements correspond to the Reset, Pause Simulation and Stop
    % Simulation buttons.
    if length(paramNew) < 4  % check for sporadic UDP input from other sources
        paramNew = [];
        return;
    end
    if paramNew(end-2) ~= resetSwitch  % Reset System object
        simControlFlags.resetObj = true;
        resetSwitch = ~resetSwitch;
    end
    if paramNew(end-1) ~= pauseSwitch  % Pause simulation
        pauseSwitch = ~pauseSwitch;
        simControlFlags.pauseSim = pauseSwitch;
    end
    if paramNew(end)                   % Stop simulation
        simControlFlags.stopSim = true;
    end
    paramNew = paramNew(1:end-3, 1);   % Parameter values
end