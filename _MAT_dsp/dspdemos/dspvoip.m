%% Voice Over IP (VOIP)
% This example illustrates using the UDP Send and UDP Receive blocks to
% transmit audio data over a network.

% Copyright 2010-2011 The MathWorks, Inc. 

%% User Datagram Protocol (UDP)
% User Datagram Protocol (UDP) is part of the Internet Protocol (IP) suite.
% UDP provides efficient transmission of data, but does not guarantee
% reliability, data order, or data integrity. These characteristics make
% UDP suitable for streaming audio and video data, but not for binary files
% and similar situations where data loss is unacceptable.

%% Exploring the Example
% You can run this example entirely on one system. However, to demonstrate 
% UDP on a network, it is best to run the example on two networked 
% computers. If the second computer has Simulink software installed, you 
% can run the example on it directly. Otherwise, use Simulink(R) Coder(TM) 
% to generate a stand-alone executable that can run on the second computer.
% 
% First, run both the dspUDPEcho model and the dspUDPVoip model on a single
% computer. The models pass audio data to each other via the localhost
% port, 127.0.0.1.
% 
% The dspUDPVoip model transmits the audio data to dspUDPEcho. The
% dspUDPEcho model echoes the data back to dspUDPVoip, which outputs the
% signal on your audio speakers.
% 
% If you have a microphone, you can use the Manual Switch in the dspUDPVoip
% model to transmit live audio instead of the sine wave.
% 
% Having run the models on a single computer, copy dspUDPEcho to the second
% computer. In both models, update the IP address in UDP Send from
% 127.0.0.1 to the IP address of the opposite computer. When you run both
% models, they transmit audio signals to each other across the network.
%%

% Open both models and run simulatneously
open_system('dspUDPEcho');
open_system('dspUDPVoip');
set_param('dspUDPEcho', 'SimulationCommand', 'Start');
set_param('dspUDPVoip', 'SimulationCommand', 'Start');

% Let the models run for five seconds
pause(5);

% Stop the simulation
set_param('dspUDPVoip', 'SimulationCommand', 'Stop');
set_param('dspUDPEcho', 'SimulationCommand', 'Stop');

%%
% Close the models
bdclose dspUDPEcho
bdclose dspUDPVoip
%%

%% Debugging your Network Connection
% If you are unable to transmit the signal over the network, check the
% following items:
%
% * That your firewall is not blocking the IP port numbers you are using.
% If needed, consult your system administrator or operating system
% documentation.
% * That you are using a free IP port number. One not being in use by
% another application.
% * That the operating system is not restricting the port number to a
% privileged user. For example, Linux typically restricts ports below 1024
% for use by root user.
%
% If needed, please consult your system administrator or operating system
% for more information.

%% References
% <http://en.wikipedia.org/wiki/User_Datagram_Protocol The Wikipedia entry on UDP>
%
% Postel, J., *User Datagram Protocol*, http://tools.ietf.org/html/rfc768

%% Available Example Versions
% Audio Transmiter and Receiver: <matlab:dspUDPVoip dswpUDPVoip.mdl>
% 
% UDP Echo Subsystem: <matlab:dspUDPEcho dspUDPEcho.mdl>


displayEndOfDemoMessage(mfilename)
