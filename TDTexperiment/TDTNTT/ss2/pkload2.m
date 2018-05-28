function [peakmat, reg, srate]=pkload2(pkfname, ch, Idx)
%PKLOAD2 -- Load peak waveforms from a "peak" file.
%Use MEX file PKLOAD2.DLL
%	Modified for the up-versioned PK format "FORMAT Pk0501 "
%
%	Input variables:
%	pkfname: File name of the PK file.
%	ch: Channel number
%	Idx: Indeces to peaks in MATLAB format (Optional).  Default: all peaks
%
%	Output variables:
%	peakmat: peak matrix (n-by-#peak, each column for one peak)
%	reg: peak register (#peak-by-2)
%	srate: sampling rate (Hz)
%
%	Usage: [peakmat, reg, srate]=pkload2(pkfname, ch, Idx)
%	by SF, 06/08/01, modified from PKLOAD.C

