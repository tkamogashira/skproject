function setfreqpoints(this, hspecs)
%SETFREQPOINTS
%   SETFREQPOINTS(this, Fs) sets normalized frequency values in the Fspec
%   property and linear attenuation values in the Aspec property. The frequency
%   points and attenuation values follow the Cmessage standard (Bell System
%   Technical Reference 41009).

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
MaxF = Fs/2;
if MaxF > 80e3
    interpFactor = 200;
else
    interpFactor = 100;
end
interpType = 'log';

if MaxF < 100
    error(message('dsp:fdfmethod:abstractarbmagaudioweightcmessage:setfreqpoints:InvalidSampFreq'));
end

% Set attenuation at 0 Hz
F = 0;
A = -70;
% Interpolate points from 60 to 100 Hz
[Fv Av] = interpfreqpoints(this,[60 100],[-55.7 -42.5],interpFactor,'linear');
F = [F Fv];
A = [A Av];

if MaxF > 100
    % Interpolate points from 100 to 200 Hz
    [Fv Av] = interpfreqpoints(this,[100 200],[-42.5 -25.1],interpFactor,'linear');
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF >= 300
    % Frequencies and attenuations from 300 to 3500 Hz
    Fv = [(300:100:1000) 1200 1300 1500 1800 2000 2500 2800 3000 3300 3500];
    F = [F Fv];
    A = [A -16.3 -11.2 -7.7 -5 -2.8 -1.3 -0.3 0 -0.4 -0.7 -1.2 -1.3 -1.1 -1.1 -2 -3 -5.1 -7.1];
end

if MaxF >= 4000
    % Interpolate points from 4000 to 4500 Hz
    [Fv Av] = interpfreqpoints(this,[4000 4500],[-14.6 -22.3],interpFactor,interpType);
    F = [F Fv];
    A = [A Av];
end

if MaxF > 4500
    % Interpolate points from 4500 to 5000 and to Fs/2 Hz
    fv = linspace(4500,MaxF,interpFactor);
    [Fv Av] = interpfreqpoints(this,[4500 5000],[-22.3 -28.7],interpFactor,interpType,fv);
    %Av(Av<-70) = -70;
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

% Set the reference private property to an attenuation of 1 at 1KHz
this.RefAtten = 1;
this.RefFreq = 1000;

% [EOF]
