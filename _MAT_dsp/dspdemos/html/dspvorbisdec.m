%% Vorbis Decoder
% This example shows how to implement a Vorbis decoder, which is a
% freeware, open-source alternative to the MP3 standard. This audio
% decoding format supports the segmentation of encoded data into small
% packets for network transmission.
% 
% Copyright 2006-2013 The MathWorks, Inc.
%%
open_system('dspvorbisdec');
dspvorbisdec([], [], [], 'compile');
dspvorbisdec([], [], [], 'term');
%% Vorbis Basics
% The Vorbis encoding format [1] is an open-source lossy audio compression 
% algorithm similar to MPEG-1 Audio Layer 3, more commonly known as MP3. 
% Vorbis possesses many of the same features as MP3 while adding extra
% flexibility and functionality. 
%  
% Encoding starts with the framing of the original signal. Vorbis allows 
% the use of frames with different sizes. Therefore, Vorbis can adjust the 
% frequency resolution across the signal if needed. Unlike MP3, there are 
% no strictly enforced sampling frequencies and bit rates in the Vorbis
% format. The bit rate can vary throughout the entire signal for both
% Vorbis and MP3.
%  
% As with any lossy compression format, Vorbis performs transformation of a
% data frame. A psychoacoustic model is applied at the encoding stage. The
% model is not specified by the format and it is up to the developer of the
% encoder to ensure that the model provides significant data reduction
% while preserving most of the sound quality. 
%  
% The Modified Discrete Cosine Transform (MDCT) [2] and its inverse
% counterpart are used in Vorbis to convert a signal into the transform
% domain, where energy concentration occurs. The Vorbis encoder then splits
% the spectrum image of a frame into a rough approximation called the
% 'floor,' and a remainder called the 'residue.' 
%  
% The flexibility of the Vorbis format is illustrated by its use of
% different methods to represent and encode the floor and residue portions
% of the signal. The algorithm introduces 'modes' as a mechanism to specify
% these different methods and thereby code various frames differently. 
%  
% Vorbis uses Huffman coding to compress the data contained in the floor
% and residue portions. In this step, Vorbis allows more efficient coding
% than MP3. Vorbis uses a dynamic probability model rather than the static
% probability model of MPEG-1 Audio Layer 3. Specifically, Vorbis builds
% custom codebooks for any particular audio signal, which can differ for
% 'floor' and 'residue' and from frame to frame. 
%  
% After all Huffman encoding is complete, the frame data is bitpacked into
% a logical packet. In Vorbis, a series of such packets is always preceded
% by a header. The header contains all the information needed for correct
% decoding. This information includes a complete set of codebooks,
% descriptions of methods to represent the floor and residue, and the modes
% and mappings for multichannel support. The header can also include
% general information such as bit rates, sampling rate, song and artist
% names, etc.  
%  
% Vorbis provides its own format, known as 'Ogg,' to encapsulate logical
% packets into transport streams. The Ogg format provides mechanisms such
% as framing, synchronization, positioning, and error correction, which are
% necessary for data transfer over networks.
% 
%
%% Problem Overview and Design Details
% The Vorbis decoder in this example implements the specifications of the
% Vorbis I format. It represents a subset of a "full powered" Vorbis. The
% example model decodes any raw binary .ogg file with an encapsulated
% compressed mono or stereo audio signal at a  bit rate that might vary.
% The example model has the capability to decode and play back a wide
% variety of Vorbis audio files in real time provided that those files are
% correctly encapsulated into an Ogg transport filestream.
% 
% You can test this example with any Vorbis audio file by downloading an
% *.ogg file from such widely used resources as Wikipedia [3], where Vorbis
% is used as a primary format to store audio samples. To load the file into
% the model, replace the filename in the annotated code at the top level of
% the model with the name of the file to be tested. When this step is
% complete, click the annotated code to load the new audio file. The model
% is configured to notify you if the output sampling rate has been changed
% due to a change in the input data. In this case, the simulation needs to
% be restarted for a better listening experience.
%  
% In order to implement a Vorbis decoder in Simulink(R), some technical
% issues need to be addressed. One such consideration is the fact that
% logical data packets do not have any specified size. This example deals
% with this variable size issue by capturing a whole page of the Ogg
% bitstream by detecting the 'OggS' synchronization pattern. For practical
% purposes a page is assumed to be no larger than 5500 bytes. After
% obtaining a segmentation table at the beginning of the page, the model
% extracts logical packets from the remainder of the page. Asynchronous
% control over such a decoding sequence is implemented using the Stateflow
% chart 'Decode All Pages of Data' depicted below.
%
open_system('dspvorbisdec/Decode All Pages of Data');

%%
% Initially, the chart tries to capture the 'OggS' synchronization pattern
% persistently. After the pattern is detected the chart follows the
% decoding steps described above. Decoding the page is done in one call of
% the Simulink function 'decodePage'. This completes the decoding of the
% current page, and the model immediately goes back to detecting the 'OggS'
% sequence. The state 'ResetPageCounter' is added in parallel with the
% Stateflow algorithm described above to support the looping of the
% compressed input file for an unlimited number of iterations.
% 
% Data pages contain different types of information: header, codebooks, and
% audio signal data. The 'Read Setup Info,' 'Read the Header,' and 'Decode
% Audio' subsystems inside the 'decodePage' Simulink function are
% responsible for handling each of these different kinds of information. 
%  
% Due to the iterative nature of the Huffman decoding process, a text-based
% implementation in MATLAB(R) code provides a more natural implementation
% than does a block diagram-based implementation. Therefore, the decoding
% process is implemented using MATLAB Function blocks. All nontrivial
% bit-unpacking routines in the example are implemented with MATLAB code.
%  
% Frames in Vorbis can have two different sizes within the signal. This
% means that the IMDCT should be implemented to account for precise inverse
% transform of the floor and residue portions of the signal. For this part,
% the model employs signals with variable size to ensure that only the
% valid part of a frame is processed for every IMDCT call. The variably
% sized signals are denoted in the subsystem below by the dark, dashed
% signal lines.  In this example, the IMDCT is calculated using an FFT.
%
open_system('dspvorbisdec/Decode All Pages of Data/decodePage/Decode Audio/Decode an Audio Block/IMDCT (4.3.6-4.3.7)')
%%
bdclose dspvorbisdec
%%
% When the decoding process is concluded with an overlap-add operation, the
% output-ready data has a variable size in case of different frame lengths.  
% Such bursts of data should be properly written into a sink in a timely
% manner. For this purpose, a sample count is maintained.
%  
% The Output block in the top level of the model feeds the output of the
% Decode Audio block to the audio playback device on your system. We
% deliver a valid portion of the decoded signal as a variable sized signal
% (Ogg Vorbis is a variable bit rate codec) into the 'To Audio Device'
% block, which has been updated to accept such inputs.
%
%% References
% [1] Complete specification of the Vorbis decoder standard http://www.vorbis.com
%
% [2] http://en.wikipedia.org/wiki/Modified_discrete_cosine_transform
%
% [3] http://en.wikipedia.org/wiki/File:06_-_Vivaldi_Summer_mvt_3_Presto_-_John_Harrison_violin.ogg
