function Z = cosfit(dt, X, Freq, Trange);
% cosfit - fit sum of fixed-frequency cosines to real waveform
%   Z = cosfit(dt, X, Freq) fits to real array X a cosine function
%
%         A*cos(2*pi*freq*time+phi)
%
%   and returns the best fitting A and phi as a single complex number
%
%         Z = A*exp(2*i*phi).
%   
%   Freq is in Hz, dt is the sample period of X in ms.
%
%   If Freq is an array, X is fit to a sum of cosines and Z is an array
%   of the corresponding complex amplitudes.
%
%   cosfit(dt, X, Freq, [t0 t1]) restricts the fit to the time range
%   t0...t1 ms. Such a restricted analysis window does not affect the way 
%   the phase is referenced: regardless of the analysis window, the phase 
%   is expressed re the start of X.
%
%   See also FFT, cangle, ABS.

Trange = arginDefaults('Trange');
if ~isreal(X),
    error('Input argument X must be real.');
elseif ~isvector(X),
    error('Input argument X must be an array.');
end
if ~isvector(Freq),
    error('Input argument Freq must be an array.');
end
szFreq = size(Freq);
% analysis window 
Trange = replaceEmpty(Trange, [0 dt*(numel(X)-1)]); % default range: all of X
Time = Xaxis(X,dt); % time axis whose zero is at start of X
[i0 i1] = dealElements(round(Trange(:)/dt)+1); % time->indices
[X, Time] = columnize(X(i0:i1), Time(i0:i1));
Nsam = numel(X);

% remove any repeated freqs; store original positions for later reconstruction. 
[Freq, dum, J] = unique(Freq(:).'); 

% create model matrix
MM = [];
for omega = 2*pi*Freq*1e-3, % angular velocity in rad/ms
    if isequal(0,omega), % zero freq: DC offset 
        MM = [MM, ones(Nsam,1)];
    else, % nonzero freq: provide cos and sin components
        mmc = cos(omega*Time);
        mms = sin(omega*Time);
        mmc = mmc - mean(mmc);
        mms = mms - mean(mms);
        MM = [MM, mmc mms];
    end
end
%plot(Time, MM), dsize(MM,X)
%X = X-mean(X(:));
A = MM\X(:); % A are the optimal weight factors approximating X=MM*A
if isequal(0,Freq(1)), % add zero-values imag value for DC comp
    A = [[1;0]*A(1); A(2:end)];
end
% contract consecutive cos-sin pairs to single complex numbers
Z = A(1:2:end)-i*A(2:2:end);
% remap Z to match the original Freq array (including any doubles)
Z = Z(J);
Z = reshape(Z,szFreq);
    















