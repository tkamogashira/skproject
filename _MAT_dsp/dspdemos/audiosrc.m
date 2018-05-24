%% Audio Sample-Rate Conversion 
% This example shows how to use a multistage/multirate approach to sample
% rate conversion between different audio sampling rates.

% Copyright 1999-2013 The MathWorks, Inc. 

%% Converting the Sampling Rate from 44.1 KHz to 96 KHz
% The first step to convert an audio signal sampled at 44.1 kHz (CD
% quality) to an audio signal sampled at 96 kHz (DVD quality) is to setup
% an audio file reader to stream the original (source) audio signal. In
% this example an OGG file is used, but it can easily be replaced with any
% (MP3, FLAC, WAV, M4A) audio file as long as it is sampled at 44.1 kHz.

% Here you create a System object to read from an audio file and
% determine the file's audio sampling rate.
frameSize = 14700; 
AR = dsp.AudioFileReader('handel.ogg', ...
    'SamplesPerFrame', frameSize, ...
    'OutputDataType', 'double');

fileInfo = info(AR);
inFs = fileInfo.SampleRate; % Input Fs assumed to be 44.1 kHz

%% Setting up the Sample Rate Converter
% The (two-sided) bandwidth of interest (i.e. the frequency band that
% contains audio information) covers the range [-20 kHz, 20 kHz]. In other 
% words, the two-sided bandwidth of interest is 40 kHz. The input signal is
% sampled at 44.1 kHz and the output signal will be sampled at 96 kHz

SRC = dspdemo.SampleRateConverter('Bandwidth',40e3,'SampleRateIn',inFs,...
    'SampleRateOut',96e3);


%% Analysis of the Filters Involved in the Conversion
% To understand the role of each filter, use getFilters to get a structure
% which contains each filter stage used for the conversion.

filts = getFilters(SRC);
hfv = fvtool(filts.Stage1,filts.Stage2,'Fs',[44.1e3*160 96e3]);
hfv.FrequencyRange        = 'Specify freq. vector';
hfv.FrequencyVector       = linspace(0,4*96e3+24.1e3,1e3);
hfv.NormalizeMagnitudeto1 = 'on';
legend(hfv,'Sample-rate converter','Halfband interpolator');

%%
% The sample-rate converter preserves the band of interest between 0 and 20
% kHz. It then supresses all spectral replicas up to a very high value 
% (160*44.1e3). The decimation by 147 results in a new spectral replica 
% centered at multiples of 48 kHz and spanning a band between +/-20kHz from
% those multiples. The role of the interpolation-by-2 filter is to suppress 
% evry other replica, conserving only the replicas centered at multiples of
% 96 kHz.

%% Create an Audio File Writer for the Converted Signal
% Once the signal has been converted to 96 kHz, you can write it back to an
% audio file using an AudioFilterWriter. 

% Here you create a System object to write a FLAC audio file
AW = dsp.AudioFileWriter('handel.flac',...
    'FileFormat','FLAC',....
    'SampleRate',SRC.SampleRateOut);

%% Main Processing Loop
while ~isDone(AR)
    sig = step(AR);      % Read audio input
    sig = step(SRC,sig); % Convert sample-rate   
    step(AW, sig);       % Write output audio
end
 
%% Release File Reader/Writer
release(AR);
release(AW);

%% Converting the Sampling Rate from 96 KHz to 44.1 KHz
% In order to convert from 96 kHz to 44.1 kHz, the reverse steps can be
% taken. First, a decimate-by-2 halfband filter can be used to convert from
% 96 kHz to 48 kHz. Next, a sample-rate converter with an interpolation
% factor of 147 and a decimation factor of 160 can be used to obtain the
% 44.1 kHz signal. A significant difference is that the transition width
% for both filters can now be 8 kHz. As before, the first thing is to
% create an AudioFileReader. Possible designs for the 2 filters
% are:

% Here you create a System object to read from an audio file and
% determine the file's audio sampling rate.
frameSize = 16000; 
AR = dsp.AudioFileReader('handel.flac', ...
    'SamplesPerFrame', frameSize, ...
    'OutputDataType', 'double');

fileInfo = info(AR);
inFs = fileInfo.SampleRate; 

SRC = dspdemo.SampleRateConverter('Bandwidth',40e3,'SampleRateIn',96e3,...
    'SampleRateOut',44.1e3);

% Here you create a System object to write an OGG audio file
AW = dsp.AudioFileWriter('handel_new.ogg',...
    'FileFormat','OGG',....
    'SampleRate',SRC.SampleRateOut);

%% Main Processing Loop
while ~isDone(AR)
    sig = step(AR);  % Read audio input
    sig = step(SRC,sig); % Convert sample-rate    
    step(AW, sig);  % Write output audio
end
 
%% Release File Reader/Writer
release(AR);
release(AW);

displayEndOfDemoMessage(mfilename)
