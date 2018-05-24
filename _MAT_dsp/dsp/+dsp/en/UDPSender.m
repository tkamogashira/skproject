classdef UDPSender< handle
%UDPSender Send UDP packets to the network
%   HUDPS = dsp.UDPSender returns a System object, HUDPS, that sends UDP
%   packets to a specified port.
%
%   HUDPS = dsp.UDPSender('PropertyName', PropertyValue, ...) returns a UDP
%   sender System object, HUDPS, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   step(HUDPS, PACKET) sends one UDP packet, PACKET, to the network.
%
%   UDPSender methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes, and
%              release UDP socket
%   clone    - Create UDP sender object with same property values
%   isLocked - Locked status (logical)
%
%   UDPSender properties:
%
%   RemoteIPAddress   - Remote address to which to send data
%   RemoteIPPort      - Remote port to which to send data
%   LocalIPPortSource - Source of the LocalIPPort property
%   LocalIPPort       - Local port from which to send data
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
%   See also dsp.UDPReceiver

 
%   Copyright 2010-2013 The MathWorks, Inc.

    methods
        function out=UDPSender
            %UDPSender Send UDP packets to the network
            %   HUDPS = dsp.UDPSender returns a System object, HUDPS, that sends UDP
            %   packets to a specified port.
            %
            %   HUDPS = dsp.UDPSender('PropertyName', PropertyValue, ...) returns a UDP
            %   sender System object, HUDPS, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   step(HUDPS, PACKET) sends one UDP packet, PACKET, to the network.
            %
            %   UDPSender methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes, and
            %              release UDP socket
            %   clone    - Create UDP sender object with same property values
            %   isLocked - Locked status (logical)
            %
            %   UDPSender properties:
            %
            %   RemoteIPAddress   - Remote address to which to send data
            %   RemoteIPPort      - Remote port to which to send data
            %   LocalIPPortSource - Source of the LocalIPPort property
            %   LocalIPPort       - Local port from which to send data
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
            %   See also dsp.UDPReceiver
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %LocalIPPort Local port from which to send data
        %   Specify the port from which to send data. This property is
        %   available when the LocalIPPortSource property is set to 'Auto'.
        %   The default value of this property is 25000.
        LocalIPPort;

        %LocalIPPortSource Source of the LocalIPPort property
        %   Specify how the port on the host is determined. A value of 'Auto'
        %   indicates that a port is picked dynamically from the list of
        %   available ports, and a value of 'Property' indicates that the value
        %   of the LocalIPPort property should be used. The default value of
        %   this property is 'Auto'.
        LocalIPPortSource;

        %RemoteIPAddress Remote address to which to send data
        %   Specify the remote IP address to which the data will be sent. The
        %   default value of this property is '127.0.0.1', which is an IP
        %   address that corresponds to the host.
        RemoteIPAddress;

        %RemoteIPPort Remote port to which to send data
        %   Specify the port at the remote IP address to which the data will be
        %   sent. The default value of this property is 25000.
        RemoteIPPort;

    end
end
