%% Multiband Dynamic Range Compression
%
% This example shows how to simulate a digital audio multiband dynamic
% range compression system.
%

% Copyright 2013 The MathWorks, Inc.

%% Introduction
%
% Dynamic range compression reduces the dynamic range of a signal by
% attenuating the level of strong peaks, while leaving weaker peaks
% unchanged. Compression has applications in audio recording, mixing, and
% in broadcasting.
%
% Multiband compression compresses different audio frequency bands
% separately, by first splitting the audio signal into multiple bands and
% then passing each band through its own independently adjustable
% compressor. Multiband compression is widely used in audio mastering and
% is often included in audio workstations.
%
% The multiband compressor in this example first splits an audio signal
% into different bands using a multiband crossover filter. Linkwitz-Riley
% crossover filters are used to obtain an overall allpass frequency
% response. Each band is then compressed using a separate dynamic range
% compressor. Key compressor characteristics, such as the compression
% ratio, the attack and release time, the threshold and the knee width, are
% independently tunable for each band. The effect of compression on the
% dynamic range of the signal is showcased.

%% Linkwitz-Riley Crossover Filters
%
% A Linkwitz-Riley crossover filter consists of a combination of a lowpass
% and highpass filter, each formed by cascading two lowpass or highpass
% Butterworth filters. Summing the response of the two filters yields a
% gain of 0 dB at the crossover frequency, so that the crossover acts like
% an allpass filter (and therefore introducing no distortion in the audio
% signal).
%
% <matlab:edit('dspdemo.LinkwitzRileyFilter') dspdemo.LinkwitzRileyFilter>
% implements a Linkwitz-Riley System object. Here is an example where an
% eighth order Linkwitz-Riley crossover is used to filter a signal. Notice
% that the lowpass and highpass sections each have a -6 dB gain at the
% crossover frequency. The sum of the lowpass and highpass sections is
% allpass. 
Fs = 44.1e3;
% Linkwitz-Riley filter
hlr = dspdemo.LinkwitzRileyFilter(  'FilterOrder',8,...
                                    'SampleRate',Fs,...
                                    'CrossoverFrequency',5e3);
% Transfer function estimator                                
htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
                                    'SpectralAverages',20);
frameLength = 1024;
hplot = dsp.ArrayPlot(...
                 'PlotType','Line',...
                 'YLimits', [-40 1],...
                 'YLabel','Magnitude (dB)',...
                 'SampleIncrement',  (Fs/2)/(frameLength/2+1),...
                 'XLabel','Frequency (Hz)',...
                 'Title','Eighth order Linkwitz-Riley Crossover Filter',...
                 'ShowLegend', true);
for i=1:50
    in = randn(1024,1);
    % Return lowpass and highpass responses of the crossover filter
    [ylp,yhp] = step(hlr,in);
    % sum the responses
    y = ylp+yhp;
    v = step(htfe,repmat(in,1,3),[ylp yhp y]);
    step(hplot,20*log10(abs(v))); 
end

%% Multiband Crossover Filters
%
% <matlab:edit('dspdemo.MultibandCrossoverFilter')
% dspdemo.MultibandCrossoverFilter> implements a multiband crossover filter
% by combining Linkwitz-Riley crossover filters and allpass filters in a 
% tree-like structure. The filter divides the spectrum into multiple bands 
% such that their sum is a perfect allpass filter. 
%
% The example below shows a four-band crossover filter formed of eighth 
% order Linkwitz-Riley crossover filters. Notice the allpass response of 
% the sum of the four bands.
Fs = 44100;
hCrossOver = dspdemo.MultibandCrossoverFilter ...
                                 ('NumBands',4,...
                                  'CrossoverFrequencies',[2e3 5e3 10e3],...
                                  'SampleRate' , Fs);
htfe = dsp.TransferFunctionEstimator...
                                 ('FrequencyRange','onesided',...
                                  'SpectralAverages',20);
L = 2^14;
hplot = dsp.ArrayPlot('PlotType','Line',...
                      'XOffset',0,...
                      'YLimits',[-120 5], ...
                      'SampleIncrement', .5 * Fs/(L/2 + 1 ),...
                      'YLabel','Frequency Response (dB)',...
                      'XLabel','Frequency (Hz)',...
                      'Title','Four-Band Crossover Filter',...
                      'ShowLegend',true);
for i=1:10
   in = randn(L,1);
   % Split the signal into four bands
   [ylp,ybp1,ybp2,yhp] = step(hCrossOver,in);
   y = ylp + ybp1 + ybp2 + yhp;
   z  = step(htfe,repmat(in,1,5),[ylp,ybp1,ybp2,yhp,y]);
   step(hplot,20*log10(abs(z)))   
end

%% Dynamic Range Compression
% <matlab:edit('dspdemo.DynamicRangeCompressor')
% dspdemo.DynamicRangeCompressor> is a dynamic range compressor System
% object. The input signal is compressed when it exceeds the specified
% threshold. The amount of compression is controlled by the specified
% compression ratio. The attack and release times determine how quickly the
% compressor starts or stops compressing. The knee width provides a smooth
% transition for the compressor gain around the threshold. Finally, a
% make-up gain can be applied at the output of the compressor. This make-up
% gain amplifies both strong and weak peaks equally.
%
% The static compression characteristic of the compressor depends on the
% compression ratio, the threshold and the knee width. The example below
% illustrates the static compression characteristic for different values of
% the knee width.
xdB    = (-10:0.01:5).';
hcomp = dspdemo.DynamicRangeCompressor('Threshold',-3,...
                                       'CompressionRatio',5);
% Vary the knee width and record the static compression characteristic                                 
hcomp.KneeWidth = 0;
y0dB = xdB + computeGain(hcomp,xdB);
hcomp.KneeWidth = 5;
y5dB = xdB + computeGain(hcomp,xdB);
hcomp.KneeWidth = 10;
y10dB = xdB + computeGain(hcomp,xdB);
hplot = dsp.ArrayPlot(...
  'SampleIncrement',.01,...
  'PlotType','Line',...
  'XOffset',-10,...
  'XLabel','Input (dB)',...
  'YLabel','Output (dB)',...
  'YLimits',[-10 0],...
  'Title','Static Compression Characteristic for Different Knee Widths',...
  'ShowLegend',true);
step(hplot,[y0dB y5dB y10dB]);
%%
% The compressor's attack time is defined as the time (in sec) it takes for
% the compressor's envelope detector to rise from 10% to 90% of its final
% value when the signal level exceeds the threshold. The compressor's
% release time is defined as the time (in sec) it takes the compressor's
% envelope detector to drop from 90% to 10% its final value when the signal
% level drops below the threshold. The example below illustrates the signal
% envelope for different release and attack times:
%
Fs = 44100;
% Construct a simple step-like input
x = [ones(Fs,1);zeros(Fs,1)];
hcomp = dspdemo.DynamicRangeCompressor('SampleRate',Fs,'KneeWidth',0);
% Vary the attack and release times of the compressor, and record the
% output envelope. 
hcomp.AttackTime =  0.01; 
hcomp.ReleaseTime = .02;
[~,yen1] = step(hcomp,x);
reset(hcomp);
hcomp.AttackTime =  0.05; 
hcomp.ReleaseTime = .1;
[~,yen2] = step(hcomp,x);
reset(hcomp);
hcomp.AttackTime =  0.2; 
hcomp.ReleaseTime = .4;
[~,yen3] = step(hcomp,x);
hplot = dsp.TimeScope(...
       'SampleRate',Fs,...
       'PlotType','Line',...
       'YLabel','Compressor Gain',...
       'YLimits',[0 1],...
       'Title','Signal Envelope for different attack and Release times',...
       'ShowLegend',true,...
       'TimeSpan',2,...
       'ShowGrid',true);
step(hplot,[x yen1 yen2 yen3]);
%%
% The example below illustrates the effect of dynamic range compression on
% an audio signal. The compession threshold is set to -10 dB, and the
% compression ratio is 5.
Fs = 22050;
hread = dsp.AudioFileReader('speech_dft.mp3');
hcomp = dspdemo.DynamicRangeCompressor('SampleRate',Fs,...
                                       'Threshold',-10,...
                                       'CompressionRatio',5);
hplot = dsp.TimeScope('YLimits',[-1 1],...
                      'SampleRate',22050,...
                      'TimeSpanOverrunAction','Scroll',...
                      'BufferLength',5e5,...
                      'TimeSpan',5,...
                      'ShowGrid',true,...
                      'ShowLegend',true,...
                      'Title','Uncompressed versus Compressed Audio');
while ~isDone(hread)
    x = step(hread);
    y = step(hcomp,x);
    step(hplot,[x,y]);
end
%% Simulink Version of the Multiband Dynamic Range Compression Example
% The following model implements the multiband dynamic range compression
% example:
model = 'multibanddynamiccompression';
open_system(model)
%%
% In this example, the audio signal is first divided into four bands using
% a multiband crossover filter. Each band is compressed using a separate
% compressor. The four bands are then recombined to form the audio output.
% The dynamic range of the uncompressed and compressed signals (defined as
% the ratio of the largest absolute value of the signal to the signal RMS)
% is computed. To hear the difference between the original and compressed
% audio signals, toggle the switch on the top level.
% 
% The multiband crossover filter and the dynamic range compressors are
% modeled using the <matlab:edit('dspdemo.MultibandCrossoverFilter')
% dspdemo.MultibandCrossoverFilter> and
% <matlab:edit('dspdemo.DynamicRangeCompressor')
% dspdemo.DynamicRangeCompressor> System objects used inside a MATLAB
% System block, respectively.
%
% The model integrates a Graphical User Interface (GUI) designed to
% interact with the simulation. The GUI allows you to tune parameters and
% the results are reflected in the simulation instantly. To launch the GUI
% that controls the simulation, click the 'Launch Parameter Tuning GUI'
% link on the model. For more information on the GUI, please refer to
% <matlab:edit('HelperCreateParamTuningGUI') HelperCreateParamTuningGUI>.
%
% The model generates code when it is simulated. Therefore, it must be
% executed from a folder with write permissions. 
currDir = pwd;  % Store the current directory address
addpath(currDir)
mexDir   = [tempdir 'multibanddynamiccompressionDir']; % Name of                                          
% temporary directory
if ~exist(mexDir,'dir')
    mkdir(mexDir);       % Create temporary directory
end
cd(mexDir);          % Change directory
set_param(model,'StopTime','(1/44100) * 8192 * 20');
sim(model);
cd(currDir);
%%
% Close the model:
bdclose(model)

%% MATLAB Version of the Multiband Dynamic Range Compression Example
% <matlab:edit('HelperMultibandCompressionSim')
% HelperMultibandCompressionSim> is the MATLAB function containing the
% multiband dynamic range compression example's implementation. It
% instantiates, initializes and steps through the objects forming the
% algorithm.
%
% The function <matlab:edit('HelperMultibandCompression')
% HelperMultibandCompression> wraps around
% <matlab:edit('HelperMultibandCompressionSim')
% HelperMultibandCompressionSim> and iteratively calls it. It also plots
% the uncompressed versus compressed audio signals.
%
% Plotting occurs when the 'plotResults' input to the function is 'true'.
%
% <matlab:run('HelperMultibandCompression') Execute
% HelperMultibandCompression> to run the simulation and plot the results on
% scopes. Note that the simulation runs for as long as the user does not
% explicitly stop it.
%
% HelperMultibandCompression launches a GUI designed to interact with the
% simulation. The GUI allows you to tune parameters and the results are
% reflected in the simulation instantly.
%
% MATLAB Coder can be used to generate C code for the function
% <matlab:edit('HelperMultibandCompressionSim')
% HelperMultibandCompressionSim>. In order to generate a MEX-file for your
% platform, execute the following:

currDir = pwd;  % Store the current directory address
mexDir   = [tempdir 'multibanddynamiccompressionDir']; % Name of                                          
% temporary directory
if ~exist(mexDir,'dir')
    mkdir(mexDir);       % Create temporary directory
end
cd(mexDir);          % Change directory
codegen('HelperMultibandCompressionSim');
%%
% By calling the wrapper function
% <matlab:edit('HelperMultibandCompression') HelperMultibandCompression>
% with |'true'| as an argument, the generated MEX-file can be used instead
% of |HelperMultibandCompressionSim| for the simulation. In this scenario,
% the GUI is still running inside the MATLAB environment, but the main
% processing algorithm is being performed by a MEX-file. Performance is
% improved in this mode without compromising the ability to tune
% parameters.
%
% <matlab:run('HelperMultibandCompression(true)') Click here> to call
% |HelperMultibandCompression| with |'true'| as argument to use the
% MEX-file for simulation. Again, the simulation runs till the user
% explicitly stops it from the GUI.

%% References
%
% [1] 'Digital Dynamic Range Compressor Design - Tutorial and Analysis',
%     Giannoulis, Dimitrios; Massberg, Michael; Reiss, Joshua D., JAES
%     Volume 60 Issue 6 pp. 399-408; June 2012
%
% [2] 'Complementary N-Band IIR Filterbank Based on 2-Band Complementary
%      Filters', Favrot, Alexis ; Faller, Christof, IWAENC 2010
%      Proceedings.
%
% [3] 'An Extension of the Linkwitz-Riley Crossover Filters for Audio
%      Systems and their Sampled Data Implementation', Harris, Fred; 
%      Venosa, Elettra ; Chen, Xiaofei ; Muthyala, Prafulla ; Dick, Chris, 
%      IWSSIP 2013 Proceedings.

displayEndOfDemoMessage(mfilename)