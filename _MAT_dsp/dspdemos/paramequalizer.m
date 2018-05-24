function paramequalizer(audiofile)
%paramequalizer(audiofile)
%
%  Parametric equalizer algorithm code

%   Copyright 2008-2012 The MathWorks, Inc.

%#codegen

%% Declare Extrinsic functions
% List all the function calls that is used only in simulation and will be
% ignored for generating code and building an executable (as long as it doesn't 
% affect the output value) 
coder.extrinsic('uigetfile')
coder.extrinsic('drawnow')
coder.extrinsic('get')
coder.extrinsic('gcf')

if nargin == 0
    [fname pname] = uigetfile('*.*',  'Select an audio file');
    if isa(fname, 'double')
        disp('No audio file selected');
        return;
    end
    audiofile = [pname, fname];
end
%% Define and Initialize System Objects

% Define Audio File Reader object
hAudioIn = dsp.AudioFileReader(audiofile,...
    'SamplesPerFrame', 2048,'OutputDataType','single');

% Create audio player object
hAudioOut = dsp.AudioPlayer('SampleRate', 44100);

% Create UDP Rx object
hUDP = dsp.UDPReceiver('LocalIPPort',25000,'MaximumMessageLength', 13);

% Create biquad filter object
hfilt = dsp.BiquadFilter(...
    'SOSMatrixSource','Input port',...
    'ScaleValuesInputPort',false);

%% Audio Loop
% Press CTRL-C to stop the while loop when executing in MATLAB
N = 20;
K = 1;
% Define initial values of the parameters
Params = peqInitParams;
while ~isDone(hAudioIn) % Process entire audio file
    
    if K == N
        % Check for interrupt from the GUI - Not used in EXE generation
        drawnow
        if isempty(coder.target)
            if strcmp(get(gcf,'UserData'),'stop')
                %disp('Stopping Audio')
                break
            end
        end
        K = 1;
    end
    K = K+1;
    
    % read a frame from the audio file
    audio = step(hAudioIn);
    
    % Update filter if new UDP message arrives
    udpMsg = step(hUDP);
    if ~isempty(udpMsg)
        Params= unpackUDPmessage(udpMsg);
    end
    
    % Execute the parametric equalizer algorithm
    y1 = parameq_algorithm(hfilt, audio, Params');
    
    % Output processed audio to soundcard
    step(hAudioOut, y1);
end

if isempty(coder.target) % do this only in simulation
    release(hAudioIn);
    release(hAudioOut);
    release(hUDP);
end

end % END OF MAIN TESTBENCH FUNCTION

function audioOut = parameq_algorithm(hfilt, audioIn, filterDesignParams)
%#codegen
%PARAMEQ Parametric Equalizer
%  Implements a three band parametric equalizer. Coefficients are
%  slewed (smoothed) between current and target
%
%   audioIn:            Input to be filtered
%   filterDesignParams: Array of structures containing filter design
%                       parameters which are used to calculate filter coefficients.
%                       Elements of the structure are: G, G0, w0, Dw, GB
%  audioOut:            Filtered output
%  coeffs:              Current set of filter coefficients being applied
%
%% Transform Filter Parameters into Filter Coefficients
[Num_Tgt, Den_Tgt] = calculateCoeffs(filterDesignParams);
%% Apply filter to audio input
resetStates  = false;
audioOut= applyFilter(hfilt, audioIn, Num_Tgt, Den_Tgt, resetStates);
end
%% Calculate target filter coefficients based on filter design parameters
function [NumSOS, DenSOS]=calculateCoeffs(filterDesignParams)
%#codegen
NumSOS=coder.nullcopy(single(zeros(3,3)));
DenSOS=coder.nullcopy(single(zeros(2,3)));
for index = 1:3
    [Num,Den] = peq(filterDesignParams(index).G0, ...
        filterDesignParams(index).Gref,...
        filterDesignParams(index).F0,...
        filterDesignParams(index).BW,...
        filterDesignParams(index).GBW);
    NumSOS(1:3,index) = Num;
    DenSOS(1:2,index) = Den;
end
end

%% Apply filter to audio input
function out = applyFilter(hfilt, in, hznum, hzden, resetStates)
%#codegen


if resetStates
    reset(hfilt);
end
out=step(hfilt,in,hznum,hzden);

end

function [b, a] = peq(G, G0, w0, Dw, GB)
% Parametric EQ with matching gain at Nyquist frequency
% Usage:  [b, a] = peq(G0, G, w0, Dw, GB)
%
%  G0 = reference gain at DC in dB
%  G  = boost/cut gain in dB
%  GB = bandwidth gain in dB
%
%  w0 = center frequency in Hz
%  Dw = bandwidth in Hz
%  GB = gain bandwidth
%  b  = [b0; b1; b2] = numerator coefficients
%  a  = [    a1; a2] = denominator coefficients

% Specify that a C function call should always be generated (EMLC1)
coder.inline('never');

%Convert from Decibels to real values
G  = (10^(G/20));
GB = (10^(GB/20));
G0 = (10^(G0/20));
fs = single(48000);
%Convert absolute frequencies to rads/sec
w0 = w0*2*pi/fs;
Dw = Dw*2*pi/fs;

beta = sqrt((GB^2-G0^2)/(G^2-GB^2)) * tan(Dw/2);
%Approx of Beta for Fixed-point
%beta = (abs(GB-G0)/abs(G-GB)) * tan(Dw/2);

b = [(G0+G*beta)/(1+beta); -(2*G0*cos(w0))/(1+beta);  (G0-G*beta)/(1+beta)];
a = [-(2*cos(w0))/(1+beta); (1-beta)/(1+beta)];

end

%% Sub function to unpack UDP Packets
function P = unpackUDPmessage(Msg)
%#codegen

% Each UDP packet will be a 12 byte packet:
% 12 UINT8 packed array -
% 1st 4 bytes: indicates band #,
% 2nd 4 bytes: peq  param enum value;
% 3rd 4 bytes: indicates the actual single
% value of this parameter

persistent params

% Initialize the parameters based on an intialization file
if isempty(params)
    params = peqInitParams;
end

% Unpack the variable size UDP message and modify
% the appropriate parameter
if ~isempty(Msg)
    
    %paramEnum = typecast(Msg(1:4),'int32');
    bandNum = Msg(1); % 1st value is band index as uint8
    gainVal = typecast(Msg(2:5),'single');
    cfreqVal = typecast(Msg(6:9),'single');
    bandwVal = typecast(Msg(10:13),'single');
    
    params(bandNum).G0 = gainVal;
    params(bandNum).F0   = cfreqVal;
    params(bandNum).BW = bandwVal;
    params(bandNum).Gref   = single(0);
    params(bandNum).GBW = gainVal*0.707;
    
end

% Copy parameter state to output
P = params;
end

%%
function [params] = peqInitParams
%#codegen

P = struct('G0',single(8),'F0',single(100),'BW',single(200),'Gref',single(0),'GBW',single(4));

params = repmat(P,1,3);
params(1) = P;
params(2) = struct('G0',single(-3),'F0',single(2000),'BW',single(500),'Gref',single(0),'GBW',single(-1.5));
params(3) = struct('G0',single(2),'F0',single(6000),'BW',single(2000),'Gref',single(0),'GBW',single(1));

end



