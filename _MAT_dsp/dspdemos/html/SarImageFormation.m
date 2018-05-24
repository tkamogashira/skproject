%% Synthetic Aperture Radar (SAR) Processing 
% SAR [1] is a technique for computing high-resolution radar returns that
% exceed the traditional resolution limits imposed by the physical size, or
% aperture, of an antenna.  SAR exploits antenna motion to synthesize a
% large "virtual" aperture, as if the physical antenna were larger than it
% actually is.  In this example, the SAR technique is used to form a
% high-resolution backscatter image of a distant area using an airborne
% radar platform.
%
%
% This model shows the following concepts:
% 
% # Processing of realistic, synthesized SAR data 
% # Implementation of important signal processing operations, including
% matched filtering 
% # Combining DSP System Toolbox(TM) blocks and MATLAB(R) code in a system
% context
%
% The model used in this example is based on a benchmark developed by
% MIT Lincoln Laboratory called the High-Performance Embedded Computing
% (HPEC) Challenge benchmark. The benchmark shows a simplified SAR
% processing chain. The simplifications made by this benchmark that differ
% from a real SAR system are given by MIT Lincoln Laboratory as follows
% [2]:
%  
% * The area under observation is at exactly 90 degrees from the aircraft
% flight path
% * The aperture is made equal to the cross-range (Y-dimension) of the area
% under observation
%
% The benchmark includes both image formation and pattern recognition. The
% Simulink(R) model only implements the 'genSARImage' image formation
% function (kernel #1) from the benchmark. See the HPEC Challenge
% benchmark web site [3] for more details.
%%

% Copyright 2007-2012 The MathWorks, Inc.

%%

open_system('SarImageFormation');

%% Examine Truth Data
% The SAR system is gathering data about a 6x8 grid of reflectors placed on
% the ground that is being imaged by an aircraft flying overhead. The final
% image produced by the MATLAB(R) code for the benchmark is shown here. The
% demonstration model reproduces this image.
imagesc(20*log10(abs(dspmodelvar('SarImageFormation','finalImage')).'),[0 60]);
colorbar;
title('Truth Image From Benchmark Code');

%% Examine Raw Sensor Data
% Examine the (synthetic) raw SAR data returns. A SAR system transmits a
% series of pulses, then collects a series of samples from the antenna for
% each transmitted pulse. It collects these samples into a single
% two-dimensional data set. The data set dimension corresponding to the
% samples collected in response to a single pulse is referred to as the
% _fast-time_ or _range_ dimension.  The other dimension is referred to as
% the _slow-time_ dimension. On the ground, the slow-time dimension
% corresponds to the direction of the plane's motion, also called the
% _cross-range_ dimension. The input to this model is a single collected
% data set representing the unprocessed data that comes from the sensor.
% This unprocessed data has no discernable patterns that would allow you to
% infer what is actually being viewed.
imagesc(20*log10(fftshift(abs(dspmodelvar('SarImageFormation','sRaw')))));
colorbar;
ylabel('Samples (fast-time)');xlabel('Pulses (slow-time)'); title('Spotlight SAR Returns');

%% Step 1: Digital Filtering and Spotlight SAR Processing
% The first subsystem in the model performs three operations.
% 
% * Fast-time filtering transforms the returns from each pulse into the
% frequency domain and convolves them with the expected return from a unit
% reflector. 
% * Digital spotlighting focuses the returns in cross-range.
% * Bandwidth expansion increases the cross-range resolution using FFTs and
% zero-padding in the image frequency domain.
% 
% Forward and inverse FFTs form the bulk of this portion of the processing.
% Equation numbers in the model refer to the equations in the benchmark
% description document [2].
open_system('SarImageFormation/Fast-time filter & Digital Spotlight');

%% Step 2: Two-Dimensional Matched Filtering
% Two-dimensional matched filtering convolves the output of the previous
% stage with the impulse response of an ideal point reflector. 
% Matched filtering is performed by multiplication in the frequency
% domain, which is equivalent to convolution in the spatial domain. 

open_system('SarImageFormation/Two-D Matched Filter');
%% Step 3: Polar-to-Rectangular Interpolation
% Run the model to process the data.  In the matched-filtered image,
% although the reflectors are all present, the returns from the nearest and
% farthest rows of reflectors in range are smeared. Furthermore, although
% the reflectors are evenly spaced on the ground, they are not evenly
% spaced in the processed image. Also, we wish to focus more on the area of
% the returns that actually contains objects.
%
% Polar-to-rectangular interpolation of the image corrects for these
% issues. When you run the model, the image on the left is the
% matched-filtered image (before interpolation), and the image on the right
% is the final output. Each of these images have been transformed to the
% spatial domain using a two-dimensional inverse FFT. The final output of
% the SAR system focuses on the 6x8 grid of reflectors and shows crisp
% peaks that are not smeared.

sim('SarImageFormation');

%% Polar-to-Rectangular Interpolation Details
% Polar-to-rectangular interpolation involves upsampling and interpolating
% to increase the range resolution of the output image. The interpolation
% operation takes the frequency-domain matched-filtered image as an input.
% It maps each row in the input image to several rows in the output image.
% The number of output rows to which each input row is mapped is determined
% by the number of sidelobes in the sinc function that is used for
% interpolation. The following figure shows, for each point in the matched
% filtered image, the central coordinate of the row it contributes to in
% the output image. The curvature in the figure shows the translation from
% a polar grid to a rectangular grid. The polar to rectangular
% interpolation is performed by MATLAB(R) code, which can effectively
% express the looping and indexing operations required with a minimum of
% temporary storage space.

figure(2);
contourf(idxout,50);
cb=colorbar;
xlabel('Cross-range'); ylabel('Range in source image');
ylabel(cb,'Range in destination image');
title('Interpolation Pattern');
clear cb;

%% References
% [1] Soumekh, Mehrdad. _Synthetic Aperture Radar Signal Processing With
% MATLAB Algorithms._ John Wiley and Sons, 1999.
%
% [2] MIT Lincoln Laboratory. "HPCS Scalable Synthetic Compact Application
% #3: Sensor Processing, Knowledge Formation, and Data I/O," Version 1.03,
% 15 March 2007.
%
% [3] MIT Lincoln Laboratory. "High-Performance Embedded Computing Challenge
% Benchmark."

