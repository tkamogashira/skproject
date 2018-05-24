function setfreqpoints(this, hspecs)
%SETFREQPOINTS
%   SETFREQPOINTS(this, Fs) sets normalized frequency values in the Fspec
%   property and linear attenuation values in the Aspec property. The frequency
%   points and attenuation values follow the ITU-T 0.41 standard.

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
MaxF = Fs/2;
if MaxF > 80e3
    interpFactor = 200;
else
    interpFactor = 100;
end

interpType = 'log';

if MaxF < 50
    error(message('dsp:fdfmethod:abstractarbmagaudioweightitut041:setfreqpoints:InvalidSampFreq'));
end

% Set attenuation at 0 Hz
F = 0;
A = -85;
% Interpolate points from 16.66 to 50 Hz
[Fv Av] = interpfreqpoints(this,[16.66 50],[-85 -63],interpFactor, interpType);
F = [F Fv];
A = [A Av];

if MaxF > 50
    % Interpolate points from 50 to 100 Hz
    [Fv Av] = interpfreqpoints(this,[50 100],[-63 -41],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end
if MaxF > 100
    % Interpolate points from 100 to 200 Hz
    [Fv Av] = interpfreqpoints(this,[100 200],[-41 -21],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end
if MaxF > 200
    % Interpolate points from 200 to 300 Hz
    [Fv Av] = interpfreqpoints(this,[200 300],[-21 -10.6],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end
if MaxF >= 400
    F = [F (400:100:1000)];
    A = [A -6.3 -3.6 -2.0 -0.9 0 0.6 1.0];
end

if MaxF >= 1200
    % Interpolate points from 1200 to 1400 Hz
    [Fv Av] = interpfreqpoints(this,[1200 1400],[0 -0.9],2*interpFactor, interpType);
    F = [F Fv];
    A = [A Av];
end

if MaxF > 1400
    % Interpolate points from 1400 to 1600 Hz
    [Fv Av] = interpfreqpoints(this,[1400 1600],[-0.9 -1.7],2*interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 1600
    % Interpolate points from 1600 to 1800 Hz
    [Fv Av] = interpfreqpoints(this,[1600 1800],[-1.7 -2.4],2*interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 1800
    % Interpolate points from 1800 to 2000 Hz
    [Fv Av] = interpfreqpoints(this,[1800 2000],[-2.4 -3],2*interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF >= 2500
    % Interpolate points from 2500 to 3000 Hz
    [Fv Av] = interpfreqpoints(this,[2500 3000],[-4.2 -5.6],2*interpFactor, interpType);
    F = [F Fv];
    A = [A Av];
end

if MaxF > 3000
    % Interpolate points from 3000 to 3500 Hz
    [Fv Av] = interpfreqpoints(this,[3000 3500],[-5.6 -8.5],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 3500
    % Interpolate points from 3500 to 4000 Hz
    [Fv Av] = interpfreqpoints(this,[3500 4000],[-8.5 -15],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 4000
    % Interpolate points from 4000 to 4500 Hz
    [Fv Av] = interpfreqpoints(this,[4000 4500],[-15 -25],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 4500
    % Interpolate points from 4500 to 5000 Hz
    [Fv Av] = interpfreqpoints(this,[4500 5000],[-25 -36],interpFactor, interpType);
    F = [F Fv(2:end)];
    A = [A Av(2:end)];
end

if MaxF > 5000
    % Interpolate points from 5000 to 6000 and to Fs/2 Hz
    Fv = linspace(5000,MaxF,interpFactor);
    [Fv Av] = interpfreqpoints(this,[5000 6000],[-36 -43],interpFactor, interpType,Fv);
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

% Set the reference private property to an attenuation of 0 dB at 800 Hz
this.RefAtten = 1;
this.RefFreq = 800;


% [EOF]
