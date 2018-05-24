function setfreqpoints(this, hspecs)
%SETFREQPOINTS
%   SETFREQPOINTS(this, Fs) sets normalized frequency values in the Fspec
%   property and linear attenuation values in the Aspec property. The frequency
%   points and attenuation values follow the ITU-R 468-4 standard.

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
MaxF = Fs/2;
if MaxF > 80e3
    interpFactor = 200;
else
    interpFactor = 100;
end

interpType = 'log';

if MaxF < 63
    error(message('dsp:fdfmethod:abstractarbmagaudioweightitur4684:setfreqpoints:InvalidSampFreq'));
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
% Interpolate points from 20000 to 31500 and to Fs/2 Hz
if MaxF > 20000
    Fv = linspace(20000,MaxF,interpFactor);
    [Fv Av] = interpfreqpoints(this,[20000 31500],[-22.2 -42.7],interpFactor, interpType,Fv);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

% Keep frequency points within the Nyquist interval
F = F(F<=MaxF);
A = A(F<=MaxF);

% Make sure last frequency point is Fs/2
if ~isequal(F(end),MaxF)
    F(end+1) = MaxF;
    A(end+1) = A(end);
end

% Set the Fspec, and Aspec private properties
this.Fspec = (F/(Fs/2));
this.Aspec = 10.^(A/20);

% Set the reference private property to an attenuation of 12.2 dB at 6300 Hz
this.RefAtten = 10^(12.2/20);
this.RefFreq = 6300;


% [EOF]
