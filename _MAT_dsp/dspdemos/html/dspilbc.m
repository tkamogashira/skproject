%% Internet Low Bitrate Codec (iLBC) for VoIP
% This example implements the Internet Low Bitrate Codec (iLBC) and
% illustrates its use. iLBC is designed for encoding and decoding
% speech for transmission via VoIP (Voice Over Internet Protocol).
%
% See http://www.iLBCfreeware.org for complete the documentation of the
% iLBC speech codec.

% Copyright 2005-2013 The MathWorks, Inc.

%% VoIP
% Voice over Internet Protocol is the family of technologies that allows IP
% networks to be used for voice applications such as telephony and
% teleconferencing. Compression is normally required to reduce the
% bandwidth requirements of these applications.  For efficiency, VoIP is
% often implemented using the lightweight but unreliable User Datagram
% Protocol (UDP). Packet loss correction is needed to maintain received
% voice quality over lossy networks.
%% Basic iLBC Design and Performance
% iLBC is designed for compression of speech to be transmitted over the
% Internet.  Thus, its algorithms are only meant to cover the narrow
% frequency range of 90-4000 Hz and it implements perceptual coding tuned
% to normal speech.  All input signals to the iLBC encoder must be Pulse
% Code Modulated (PCM) speech signals sampled at exactly 8000 Hz with
% 16-bit samples ranging from -32768 to +32767.
%
% iLBC is defined for two different transmission rates, with a packet
% of data being encoded either after every 30ms or after every 20ms of
% speech. The advantage of encoding every 30ms is that the encoded data
% rate is lower: 13.33 kbit/sec as opposed to 15.20 kbit/sec for 20ms
% frames. However, encoding every 30ms leads to 50% more delay in the
% received speech, which can cause undesirable latency.
%
% Since all inputs to iLBC must be 8000 Hz, 16-bit PCM speech, the 
% input rate is (8000 Hz) * (16 bits) = 128 kbit/sec.  Thus, iLBC 
% compresses the speech to 10.4% and 11.9% of the original data-rate for
% 13.33 kbit/sec and 15.20 kbit/sec modes, respectively.  
%
% In addition to encoding to low data transmission rates, iLBC provides a
% framework for easily implementing Packet Loss Correction (PLC) systems.
% The codec is meant for real-time speech over the Internet, but the 
% Internet is subject to random delays in routing information in real-time,
% which renders many packets useless to the iLBC decoder.  The job of a PLC
% is to interpolate the speech for missing packets based on the packets 
% before and immediately after the missing one.  Though iLBC does not 
% define a specific PLC algorithm, this example implements a simple PLC for
% illustration.  

%% The iLBC Example Model
% The model shown below reads in a speech signal and, after passing through
% iLBC, plays the output with the default audio device.
%%
open_system dspilbc
%%
bdclose dspilbc

%% Using the iLBC Example Model
% The top level of this example model consists of just a handful of simple
% blocks. The basic operation is to load a speech signal and pass it to the
% iLBC Encoder block to convert it to a stream of iLBC packets.  Next, the
% packets are sent through a simulated lossy channel, which causes random
% packets to be set to all zeros.  Finally, the packets are sent to the
% iLBC Decoder block to be converted back into a speech signal, which is
% then played.  In addition, there is a manual switch that can be toggled
% as the model runs to compare the original speech signal with the decoded
% signal.
% 
% Double clicking on the configuration block in the upper right corner
% of the model brings up a dialog, where it is possible to change the data 
% transmission rate to one of the two iLBC modes (13.33 kbit/sec or 15.20
% kbit/sec).  The decoder's transmission rate must be set to the same as
% the encoder, or else an error will occur.  In addition, the user may
% specify whether to use double or single precision for all internal
% calculations in the encoder and decoder.
% 
% Double clicking on the Lossy Channel subsystem brings up a dialog that
% allows the percentage of lost packets to be set.  The iLBC Decoder's
% Packet Loss Concealment algorithm is tuned to correct for 0-10% packet
% loss.  Packet loss rates higher than 10% will be easily audible.
%
% The iLBC encoder and decoder blocks are implemented as subsystems in this
% model. In order to accommodate a level of reuse, they also make use of a
% example library, which can be found at <matlab:dspilbclib
% dspilbclib.mdl>.  This library contains four helper blocks used by the
% encoder and decoder.  Feel free to open the library and look under the
% blocks to see how iLBC was implemented in Simulink(R).