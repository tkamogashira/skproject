classdef UDPReceiver< handle
%UDPReceiver Receive UDP packets from the network
%   HUDPR = dsp.UDPReceiver returns a System object, HUDPR, that receives
%   UPD packets from a specified port.
%
%   HUDPR = dsp.UDPReceiver('PropertyName', PropertyValue, ...) returns a
%   UDP receiver System object, HUDPR, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   PACKET = step(HUDPR) receives one UDP packet (PACKET) from the network.
%
%   UDPReceiver methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes, and
%              release UDP socket
%   clone    - Create UDP receiver object with same property values
%   isLocked - Locked status (logical)
%
%   UDPReceiver properties:
%
%   LocalIPPort          - Local port on which to receive data
%   RemoteIPAddress      - Address from which the data was sent
%   ReceiveBufferSize    - Maximum size of the internal buffer
%   MaximumMessageLength - Maximum size of the output message
%   MessageDataType      - Data type of the message
%
%   % EXAMPLE: Send a number of UDP packets, and calculate the number 
%   %          of successfully transmitted bytes.
%      hudpr = dsp.UDPReceiver;
%      hudps = dsp.UDPSender;
%      bytesSent = 0;
%      bytesReceived = 0;
%      dataLength = 128;
%      for k = 1:20
%        dataSent = uint8(255*rand(1,dataLength));
%        bytesSent = bytesSent + dataLength;
%        step(hudps, dataSent);
%        dataReceived = step(hudpr);
%        bytesReceived = bytesReceived + length(dataReceived);
%      end
%      release(hudps);
%      release(hudpr);
%      fprintf('Bytes sent:     %d\n', bytesSent);
%      fprintf('Bytes received: %d\n', bytesReceived);
%
%   See also dsp.UDPSender

 
%   Copyright 2010-2013 The MathWorks, Inc.

    methods
        function out=UDPReceiver
            %UDPReceiver Receive UDP packets from the network
            %   HUDPR = dsp.UDPReceiver returns a System object, HUDPR, that receives
            %   UPD packets from a specified port.
            %
            %   HUDPR = dsp.UDPReceiver('PropertyName', PropertyValue, ...) returns a
            %   UDP receiver System object, HUDPR, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   PACKET = step(HUDPR) receives one UDP packet (PACKET) from the network.
            %
            %   UDPReceiver methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes, and
            %              release UDP socket
            %   clone    - Create UDP receiver object with same property values
            %   isLocked - Locked status (logical)
            %
            %   UDPReceiver properties:
            %
            %   LocalIPPort          - Local port on which to receive data
            %   RemoteIPAddress      - Address from which the data was sent
            %   ReceiveBufferSize    - Maximum size of the internal buffer
            %   MaximumMessageLength - Maximum size of the output message
            %   MessageDataType      - Data type of the message
            %
            %   % EXAMPLE: Send a number of UDP packets, and calculate the number 
            %   %          of successfully transmitted bytes.
            %      hudpr = dsp.UDPReceiver;
            %      hudps = dsp.UDPSender;
            %      bytesSent = 0;
            %      bytesReceived = 0;
            %      dataLength = 128;
            %      for k = 1:20
            %        dataSent = uint8(255*rand(1,dataLength));
            %        bytesSent = bytesSent + dataLength;
            %        step(hudps, dataSent);
            %        dataReceived = step(hudpr);
            %        bytesReceived = bytesReceived + length(dataReceived);
            %      end
            %      release(hudps);
            %      release(hudpr);
            %      fprintf('Bytes sent:     %d\n', bytesSent);
            %      fprintf('Bytes received: %d\n', bytesReceived);
            %
            %   See also dsp.UDPSender
        end

    end
    methods (Abstract)
    end
    properties
        %LocalIPPort Local port on which to receive data
        %   Specify the port on which to receive data. The default value of
        %   this property is 25000.
        LocalIPPort;

        %MaximumMessageLength Maximum size of the output message
        %   Specify the size of the output message. If packets are received
        %   which exceed this value, their contents will be truncated. The
        %   default value of this property is 255.
        MaximumMessageLength;

        %MessageDataType Data type of the message
        %   Specify the data type of the message. The data type may be one of:
        %   ['double'|'single'|'int8'|'uint8'|'int16'|'uint16'|'int32' |
        %   'uint32' |'logical']. The default value of this property is 'uint8'.
        MessageDataType;

        %ReceiveBufferSize Maximum size of the internal buffer
        %   Specify the size of the buffer which receives UDP packets, in
        %   bytes. The default value of this property is 8 kilobytes.
        ReceiveBufferSize;

        %RemoteIPAddress Address from which the data was sent
        %   Specify the remote IP address from which to accept data. The
        %   default value of this property is '0.0.0.0', which indicates that
        %   data will be accepted from any remote IP address.
        RemoteIPAddress;

    end
end
