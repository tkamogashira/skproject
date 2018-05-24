function coeffs = actualdesign(this,hspecs)
%ACTUALDESIGN

%   Copyright 2009 The MathWorks, Inc.

setmaskspecs(hspecs);
Fs = hspecs.ActualDesignFs;

MaxF = Fs/2;
if MaxF > 80e3
    interpFactor = 200;
else
    interpFactor = 100;
end

interpType = 'log';

if MaxF < 63
    error(message('dsp:fdfmethod:lpnormaudioweightitur4684:actualdesign:InvalidSampFreq'));
end

% Interpolate points from 31.5 to 63, extrapolate from 0 to 31.5
Fv = linspace(0,63,interpFactor);
[F A] = interpfreqpoints(this,[31.5 63],[-29.9 -23.9],interpFactor, interpType,Fv);
A(A<-70) = -70;

% Interpolate points from 63 to 100
if MaxF > 63
    [Fv Av] = interpfreqpoints(this,[63 100],[-23.9 -19.8],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 100
    F = [F 200 400 800 1000 2000 3150 4000 5000 6300 7100 8000 9000];
    A = [A -13.8 -7.8 -1.9 0 5.6 9 10.5 11.7 12.2 12 11.4 10.1];
end

% Interpolate points from 10e3 to  12.5e3
if MaxF >= 10e3
    [Fv Av] = interpfreqpoints(this,[10e3 12.5e3],[8.1 0],interpFactor, interpType);
    F = [F Fv];
    A = [A Av];
end
% Interpolate points from 12.5e3 to 14e3
if MaxF > 12.5e3
    [Fv Av] = interpfreqpoints(this,[12.5e3 14e3],[0 -5.3],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end
% Interpolate points from 14e3 to 16e3
if MaxF > 14e3
    [Fv Av] = interpfreqpoints(this,[14e3 16e3],[-5.3 -11.7],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end
% Interpolate points from 16e3 to 20e3
if MaxF > 16e3
    [Fv Av] = interpfreqpoints(this,[16e3 20e3],[-11.7 -22.2],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end
if MaxF > 20000
    % Interpolate points from 20000 to 31500 and to Fs/2 Hz
    Fv = linspace(20000,MaxF,interpFactor);
    [Fv Av] = interpfreqpoints(this,[20000 31500],[-22.2 -42.7],interpFactor, interpType,Fv);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

% Keep frequency values within the Nyquist interval
F = F(F<=MaxF);
A = A(F<=MaxF);

% Make sure last frequency value is Fs/2
if ~isequal(F(end),MaxF)
    F(end+1) = MaxF;
    A(end+1) = A(end);
end

% Set weights
W = zeros(size(F));
idx = find(F>30 & F<200);
W(idx) = 20*ones(1,length(idx));
idx = find(F>15000);
W(idx) = fliplr(linspace(10,25,length(idx)));
W = W(F<=MaxF);
w = 10.^(W/20);

% Instantiate and setup the design objects for iirlpnorm arbmag filters
fmethodArbMag = fdfmethod.lpnormsbarbmag1;
fmethodArbMag.Weights = w;
fmethodArbMag.SOSScaleNorm = '';
hspecsArbMag = fspecs.sbarbmag;
hspecsArbMag.Frequencies = F/(Fs/2);
hspecsArbMag.Amplitudes = 10.^(A/20);

% Get coefficients
coeffs = getcoeffs(this,hspecs,hspecsArbMag,fmethodArbMag);

% [EOF]
