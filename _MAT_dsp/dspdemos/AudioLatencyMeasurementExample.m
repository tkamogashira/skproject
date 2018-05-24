%% Measuring Audio Latency
% This example shows how to measure the latency introduced in audio signals
% when using either the |dsp.AudioPlayer| and |dsp.AudioRecorder| System
% objects in MATLAB or |To Audio Device| and |From Audio Device| blocks in
% Simulink. The procedure presented here allows user to tune certain
% parameters that affect the latency value.  A list of these parameters is
% discussed later in the example.

% Copyright 2013 The MathWorks, Inc.

%% Introduction
% In broad terms, *latency* can be defined as the time it takes for the
% audio to be heard or recorded after it has been generated or played back,
% or vice versa. There are multiple factors that can influence this:
% 
% # Hardware being used: CPU, memory, sound card etc.
% # Audio drivers that are used to communicate with the sound card.
% # Algorithm complexity of audio processing between playback and
% recording.
% # Software being used to process the audio: MATLAB or Simulink in this
% case.
%
% This example shows you how to measure the overall latency, with focus on
% what parameters decide the latency effect of the last point in the above
% list. There are two flavors of this example: one uses the audio System
% objects in MATLAB and the other implements the same set-up in Simulink
% using the audio input and output blocks in DSP System Toolbox.
%
%% Experiment Set-up
% In this example, we measure the latency by playing an audio signal
% through |dsp.AudioPlayer| (or |To Audio Device| block), recording the
% played audio through |dsp.AudioRecorder| (or |From Audio Device| block)
% and measuring the delay through cross-correlation of the two signals. No
% other processing is done on the audio signal. A loopback cable is used to
% physically connect the audio-out port of the sound card to its audio-in
% port. The set-up is shown in the illustration below:
%
% <<MeasuringLatency1.png>>
%
% Another common application set-up may be to record audio live via a
% microphone, process it on the computer and play it back in a streaming
% fashion. However, note that even in that case the hardware interface
% latency will still be the same as the above set-up: a sum of latencies
% due to the player and the recorder.
%
%% Measuring Latency
% The function <matlab:edit('HelperMeasureAudioLatency')
% HelperMeasureAudioLatency> computes the audio latency of the above setup.
% Inputs to this function are:
% 
% * *plotFlag*: Set this to true if you want to visualize the input to
% |dsp.AudioPlayer| and the output from |dsp.AudioRecorder| objects.
% * *frameSize*: This is the number of samples of audio that constitute a
% single frame. This sets the *SamplesPerFrame* property of
% |dsp.AudioFileReader| object that reads the audio file to be played.
% * *bufferSize*: The value of this parameter is copied to the *BufferSize*
% property of |dsp.AudioPlayer| and |dsp.AudioRecorder| System objects.
% * *playerQueueSize* and *recoderQueueSize*:  These are the queue size (in
% samples) for the |dsp.AudioPlayer| and |dsp.AudioRecorder| System
% objects, respectively. These are mapped to the *QueueDuration* property
% of these objects through the equation: QueueDuration = QueueSize/(Sample
% Rate).
% * *playDuration*: Number of seconds to play the audio.
% * *useSimulink*: If this is set to true, the Simulink model
% <matlab:open('audiolatencymeasurement') audiolatencymeasurement> is used
% to measure the latency.
%
% Most of these inputs are the various parameters that affect audio latency
% in MATLAB or Simulink. These have been made as inputs so that the user
% can try different values and measure the latency for each set. The
% various sections in the |HelperMeasureAudioLatency| function are:
% 
% # *Initialization*: Default values for input parameters are assigned.
% Also, the audio System objects that will be used are created with
% appropriate parameter values.
% # *Loopback simulation*: For duration specified by the *playDuration*
% input, audio is read from a file and sent to the computer's audio-out
% port through |dsp.AudioPlayer|. Through the loopback cable and the
% audio-in port, this audio is read in using |dsp.AudioRecorder| object. In
% the case when the *useSimulink* input is true, the loopback simulation is
% performed through the Simulink model
% <matlab:open('audiolatencymeasurement') audiolatencymeasurement>. The
% signal read from the file and the one receiver by the recorder after
% loopback are both stored in a signal sink.
% # *Cross-correlation*: Using MATLAB's |xcorr| function, the
% cross-correlation between the audio signal sent to player and the one
% received by recorder is computed. The received signal will lag behind the
% played signal. The time shift that gives us maximum cross-correlation is
% decided as the latency of this set-up. Additionally, if the *plotFlag*
% input was true, the two audio signals are plotted in a figure so that the
% lag can be visually observed.
%
% <<MeasuringLatency3.png>>
%
%% Parameters in MATLAB/Simulink That Affect Latency
% *Frame size* 
% 
% This isn't an explicit property of the player or recorder System objects,
% but rather the number of samples that are passed to those objects in each
% call to their |step| method. The bigger the frame size, the longer you'll
% have to wait to collect those many samples.
% 
% *BufferSize*
% 
% The *BufferSize* is a property of both |dsp.AudioPlayer| and
% |dsp.AudioRecorder| System objects. Its value will be half the size of
% the sound card buffer. The lower the *BufferSize*, the quicker you can
% send samples to the sound card. However, it is a trade-off because small
% buffer can also easily underrun (for player) or overrun (for recorder).
%
% *QueueDuration*
% 
% Both |dsp.AudioPlayer| and |dsp.AudioRecorder| System objects have this
% property of *QueueDuration*. The queue is a storage space between the
% System object and the sound card buffer. Its main use is to help match
% the throughput of the algorithm in MATLAB and the device. In this regard,
% it can help prevent the above mentioned buffer underruns and overruns.
% Changing the *QueueDuration* usually has the most significant impact on
% latency. *QueueDuration* should be set to a value as low as possible to
% keep latency in check while not causing glitches in the audio.
%
% The same parameters are also applicable in the Simulink version that uses
% audio blocks instead of System objects. More details about *BufferSize*
% and *QueueDuration* can be found in the documentation of the System
% objects <matlab:doc('dsp.AudioPlayer') dsp.AudioPlayer> and
% <matlab:doc('dsp.AudioRecorder') dsp.AudioRecorder>, and the blocks
% <matlab:doc('ToAudioDevice') To Audio Device> and
% <matlab:doc('FromAudioDevice') From Audio Device>.
%
%% Sound Card and Drivers
% Apart from the above three parameters, latency is also affected by the
% sound card and drivers. For low-latency applications, it is recommended
% to use a low-latency sound card. Drivers also have can have an impact on
% latency. For example, on Windows(TM) platform, DirectSound creates an
% additional virtual device layer between the application and the sound
% card, increasing latency. On the other hand, ASIO(TM) drivers talk to the
% device directly which helps to reduce delays.

%% Sample Results
% Here are some results of running
% <matlab:edit('HelperMeasureAudioLatency') HelperMeasureAudioLatency> on
% different input parameters:
%
% latency = HelperMeasureAudioLatency(0, 4096, 256, 256, 256, 20, 0);
%
% Result: Latency of 34ms
%
% latency = HelperMeasureAudioLatency(1, 512, 512, 3072, 3072, 10, 1);
%
% Result: Latency of 108ms
%
% latency = HelperMeasureAudioLatency(1, 1024, 512, 2048, 2048, 20, 0);
%
% Result: Latency of 64ms. You can also zoom into the plot to see the delay
% between player and recorder waveforms.
%
% <<MeasuringLatency2.png>>
%
%% Summary
% We discussed the concept of latency in audio signals and demonstrated a
% way in MATLAB and Simulink to quantify it through experiment. We also
% covered the various parameters that influence audio latency in MATLAB and
% Simulink. Some sample results of running that experiment on a computer
% were presented at the end. Note that the values used in examples above
% were particular to one machine. Results will vary from one machine to the
% next. It is recommended that you follow the guidance above and try
% different values to find the best combination that suits your system and
% application.

displayEndOfDemoMessage(mfilename)