function biterror = pulseshapedemogetBER(Htx,Hrx,snr)
%pulseshapedemogetBER Bit Error Rate (BER) Measurement
%   BITERROR = pulseshapedemogetBER(Htx,Hrx,SNR) measures the bit error of a
%   communications system that uses a pulse shaping filter Htx at the
%   transmitter and a matched filter (or a downsampler) Hrx at the
%   receiver. We assume a 16-QAM modulation scheme and an additive white
%   Gaussian noise channel. The SNR (in dB) is specified as third input
%   argument.

%   Copyright 2011 The MathWorks, Inc.

n = 30e4;               % Number of bits to process
s = RandStream.create('mt19937ar', 'seed',223456); % seed for repeatability
prevStream = RandStream.setGlobalStream(s);
x = randi([0 1],n,1);  % Input binary data stream
M = 16;                 % Size of signal constellation
k = log2(M);            % Number of bits per symbol

% Convert the bits in x into k-bit symbols.
xsym = step(comm.BitToInteger(k),x);
Nxsym = length(xsym);

% Modulate using 16-QAM.
ymod = step(comm.RectangularQAMModulator(M),xsym);

% Transmit signal
ytx = localtransmit(Htx,ymod');

% Propagate across channel
hChan = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)',...
  'SNR', snr);
hChan.SignalPower = (ytx * ytx')/ length(ytx);
ytx = step(hChan, ytx);

% Receive signal
yrx = localreceive(ytx,Hrx,Nxsym);

% Demodulate signal
zsr = step(comm.RectangularQAMDemodulator(M),yrx');

% Undo the bit-to-symbol mapping performed earlier.
z = step(comm.IntegerToBit(k),zsr);

% Calculate bit error
[numerr,biterror] = biterr(x,z);
RandStream.setGlobalStream(prevStream); % Restore default stream

%--------------------------------------------------------------------------
function ytx = localtransmit(Htx,ymod)

% Shape and interpolate the signal
ytx = filter(Htx,[ymod zeros(1,impzlength(Htx))]);

% Group delay of the transmit filter
gdtx = grpdelay(Htx);

% Remove transient response
ytx(1:floor(gdtx(1))) = [];


%--------------------------------------------------------------------------
function yrx = localreceive(ytx,Hrx,Nxsym)

% Group delay of the matched filter
gdrx = grpdelay(Hrx);
gdrx = ceil(gdrx(1));

% Decimation Factor
M = prod(prod(getratechangefactors(Hrx)));


Nz = M*round(gdrx/M)-gdrx; % Synchronize
ytx = [zeros(1,Nz) ytx zeros(1,impzlength(Hrx))];

% Filter and down sample at the receiver
yrx = filter(Hrx,ytx);

% Remove transient response
start = (gdrx+Nz)/M;
yrx = yrx(start+1:start+Nxsym);

