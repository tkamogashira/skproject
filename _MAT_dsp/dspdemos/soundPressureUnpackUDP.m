function [filtNum, resetFilt, stopSim, changeFile, audioSource] = ...
                                                   soundPressureUnpackUDP()
% Function to create a UI to tune the parameters of algorithm components.
% Output:
%         filtNum     - Variable to store the filter in use. Can take
%                       values from 0 to 2.
%         resetFilt   - Flag to reset the filter. If true, the filter 
%                       configuration will change.
%         stopSim     - Flag to stop the simulation. If true, the
%                       simulation needs to be stopped.
%         changeFile  - Flag to change the audio source. If true, the audio
%                       source configuration will change.
%         audioSource - Variable to store the audio source in use. Can take
%                       values from 0 to 2.
     
persistent hUDPReceiver prevFiltNum prevAudioSource

if isempty(hUDPReceiver)
    % UDP Receiver
    hUDPReceiver = dsp.UDPReceiver('MessageDataType','double', ...
                            'ReceiveBufferSize',200);
                        
    prevFiltNum = 0;
    prevAudioSource = 0;
end

resetFilt = false;

packetUDP = step(hUDPReceiver);

if isempty(packetUDP)
    % The received UDP packet doesn't come from the UI. The configuration
    % should not change.
    stopSim = false;
    changeFile = false;
    filtNum = prevFiltNum;
    audioSource = prevAudioSource;
    return;
else
    % The received UDP packet comes from the UI. There is a change in the 
    % configuration.
    stopSim = packetUDP(1);
    filtNum = packetUDP(2);
    changeFile = packetUDP(3);
    audioSource = packetUDP(4);
    % If the audio source or the filter is changing, the filter needs to be
    % reset.
    if (filtNum~=prevFiltNum) || (audioSource~=prevAudioSource)
        resetFilt = true;
    end
    prevFiltNum = filtNum;
    prevAudioSource = audioSource;
end
