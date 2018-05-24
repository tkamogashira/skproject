%% Dynamic Range Compression Using Overlap-Add Reconstruction
% This example shows how to compress the dynamic range of a
% signal by modifying the range of the magnitude at each frequency bin.
% This nonlinear spectral modification is followed by an overlap-add FFT
% algorithm for reconstruction. This system might be used as a speech
% enhancement system for the hearing impaired. The algorithm in this
% simulation is derived from a patented system for adaptive processing of
% telephone voice signals for the hearing impaired originally developed by
% Alvin M. Terry and Thomas P. Krauss at US West Advanced Technologies
% Inc., US patent number 5,388,185.
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('olamodel');
set_param('olamodel', 'StopTime', '2');
sim('olamodel');
%%
bdclose olamodel
%%
% This system decomposes the input signal into overlapping sections of
% length 256. The overlap is 192 so that every 64 samples, a new section is
% defined and a new FFT is computed. After the spectrum is modified and the
% inverse FFT is computed, the overlapping parts of the sections are added
% together. If no spectral modification is performed, the output is a
% scaled replica of the input. A reference for the overlap-add method used
% for the audio signal reconstruction is Rabiner, L. R. and R. W. Schafer.
% *Digital Processing of Speech Signals*. Englewood Cliffs, NJ: Prentice
% Hall, 1978, pgs. 274-277.
%
% Compression maps the dynamic range of the magnitude at each frequency bin
% from the range 0 to 100 dB to the range |ymin| to |ymax| dB. |ymin| and
% |ymax| are vectors in the MATLAB(R) workspace with one element for each
% frequency bin; in this case 256. The phase is not altered. This is a
% non-linear spectral modification. By compressing the dynamic range at
% certain frequencies, the listener should be able to perceive quieter
% sounds without being blasted out when they get loud, as in linear
% equalization.
%
% To use this system to demonstrate frequency-dependent dynamic range
% compression, start the simulation. After repositioning the input and
% output figures so you can see them at the same time, change the *Slider
% Gain* from 1 to 1000 to 10000. Notice the relative heights of the output
% peaks change as you increase the magnitude.
