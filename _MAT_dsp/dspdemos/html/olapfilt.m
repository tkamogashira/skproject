%% Overlap-Add/Save
% This example shows how to filter a sinusoid using the Overlap-Add and
% Overlap-Save FFT blocks.
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('olapfilt');
sim('olapfilt');
%%
bdclose olapfilt

%%
% The overlap-add algorithm filters the input signal in the frequency
% domain. The input is divided into non-overlapping blocks which are
% linearly convolved with the FIR filter coefficients. The linear
% convolution of each block is computed by multiplying the discrete Fourier
% transforms (DFTs) of the block and the filter coefficients, and computing
% the inverse DFT of the product. For filter length |M| and FFT size |N|,
% the last |M-1| samples of the linear convolution are added to the first
% |M-1| samples of the next input sequence. The first |N-M+1| samples of
% each summation result are output in sequence.
%
% The overlap-save algorithm also filters the input signal in the frequency
% domain. The input is divided into overlapping blocks which are circularly
% convolved with the FIR filter coefficients. The circular convolution of
% each block is computed by multiplying the DFTs of the block and the
% filter coefficients, and computing the inverse DFT of the product. For
% filter length |M| and FFT size |N|, the first |M-1| points of the
% circular convolution are invalid and discarded. The remaining |N-M+1|
% points which are equivalent to the true convolution are "unrolled" as
% output by the Unbuffer block.

%% References
% Overlap-Add Algorithm: Proakis and Manolakis, *Digital Signal Processing*, 3rd ed, Prentice-Hall, Englewood Cliffs, NJ, 1996, pp. 430 - 433.
%
% Overlap-Save Algorithm: Oppenheim and Schafer, *Discrete-Time Signal Processing*, Prentice-Hall, Englewood Cliffs, NJ, 1989, pp. 558 - 560.
