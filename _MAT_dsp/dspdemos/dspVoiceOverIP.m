%% Voice Over IP (VOIP)
% This example shows how to use the UDP Send and UDP Receive System objects
% to transmit audio data over a network.
%
%   Copyright 2010-2012 The MathWorks, Inc.

%% Introduction
% User Datagram Protocol (UDP) is part of the Internet Protocol (IP) suite.
% UDP provides efficient transmission of data, but does not guarantee
% reliability, data order, or data integrity. These characteristics make
% UDP suitable for streaming audio and video data, but not for binary files
% and similar situations where data loss is unacceptable. The following 
% block diagram shows the operations involved in the this example:
%
% <<dspUDPVoip_Snapshot_For_dspVoiceOverIP.png>>
%
% You can run this example entirely on one system. However, to use UDP on a
% network, it is best to run the example on two networked computers. If the
% second computer has MATLAB(R) installed, you can run the example on it
% directly. Otherwise, use MATLAB(R) Coder(TM) to generate a stand-alone
% executable that can run on the second computer.
%
% To start, run the following script on your computer. While the script is
% running, the UDPSender object transmits audio sine wave data to the
% UDPReceiver object via the localhost port, 127.0.0.1, and then outputs
% the signal on your audio speakers. If you have a microphone, you can
% change the value of useMicrophone to 'true' in order to transmit live
% audio instead of the sine wave.
% 
% Having run the script on a single computer, copy the script to the second
% computer. In both scripts, replace the IP address, 127.0.0.1, with the IP
% address of the opposite computer. When you run both scripts, the UDP
% objects transmit audio signals to each other across the network.

%% Initialization

% Initialize several configuration parameters.
useMicrophone   = false;
IP_address      = '127.0.0.1';
IP_port         = 30000;
sampleRate      = 44100;
nChannels       = 1;
freq            = [100 99];
samplesPerFrame = 512;

% Create System objects to send local information to a remote client.
if useMicrophone
    hLocalSource = dsp.AudioRecorder('SampleRate', sampleRate,...
        'NumChannels', nChannels); %#ok<UNRCH>
else
    hLocalSource = dsp.SineWave('SampleRate', sampleRate,...
        'Frequency', freq(1:nChannels),...
        'SamplesPerFrame', samplesPerFrame);
end
hRemoteSink = dsp.UDPSender('RemoteIPAddress', IP_address, ...
    'RemoteIPPort', IP_port);

% Create System objects to listen to data produced by the remote client.
hRemoteSource = dsp.UDPReceiver('LocalIPPort', IP_port,...
    'MaximumMessageLength', samplesPerFrame,...
    'MessageDataType', 'double');
hLocalSink  = dsp.AudioPlayer('SampleRate', sampleRate);

%% Stream Processing Loop
fiveSeconds = 5*sampleRate;
for i=1:(fiveSeconds/samplesPerFrame)
    % Connect the local source to the remote sink.
    % In other words, transmit audio data.
    localData = step(hLocalSource);
    step(hRemoteSink, localData(:));

    % Connect the remote source to the local sink
    % In other words, receive audio data.
    remoteData = step(hRemoteSource);
    if ~isempty(remoteData)
        step(hLocalSink, remoteData);
    end
end

%% Release
% Here you call the release method on the System objects to close any open
% files and devices.
release(hLocalSource);
release(hLocalSink);
release(hRemoteSource);
release(hRemoteSink);


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

%% Summary
% This example shows how to stream bidirectional audio over a UDP
% connection.

%% References
% <http://en.wikipedia.org/wiki/User_Datagram_Protocol The Wikipedia entry on UDP>
%
% Postel, J., *User Datagram Protocol*, http://tools.ietf.org/html/rfc768

displayEndOfDemoMessage(mfilename)
