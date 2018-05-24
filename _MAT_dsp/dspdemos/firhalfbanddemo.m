%% FIR Halfband Filter Design
% This example shows how to design FIR halfband filters. Halfband filters
% are widely used in multirate signal processing applications when
% interpolating/decimating by a factor of two. Halfband filters are
% implemented efficiently in polyphase form, because approximately half of
% its coefficients are equal to zero.
%
% Halfband filters have two important characteristics, the passband and
% stopband ripples must be the same, and the passband-edge and
% stopband-edge frequencies are equidistant from the halfband frequency
% pi/2.
%
% In this example we will design FIR halfband filters of a given order but
% also minimum-order and minimum-phase filters. Minimum-phase designs are
% particularly useful for perfect reconstruction 2 channel FIR filter
% banks.

% Copyright 1999-2012 The MathWorks, Inc.

%% Windowed-Impulse-Response Designs
% Windowed-impulse-response designs are obtained by simply specifying an
% even order and a window of appropriate (odd) length. In this case, the
% passband-edge frequency cannot be specified, rather it is a result of
% both the order and the window specified.
N = 90;                            % Filter order must be even
d = fdesign.halfband('Type','Lowpass','N',N);  
f = design(d,'window','Window','hamming','SystemObject',true);
%%
% One can verify that the passband/stopband ripples are the same
hfvt = fvtool(f, 'MagnitudeDisplay', 'Zero-phase','Color', [1 1 1]);
%%
% Impulse response showing every other coefficient equal to zero (except
% for the middle one)
set(hfvt, 'Analysis', 'Impulse');

%% Controlling the Transition Width
% In addition to the even order, one can specify the transition width of
% the filter. 
TW = 0.05; % Transition width
d = fdesign.halfband('Type','Lowpass','N,TW',N,TW);  
f1 = design(d,'equiripple','SystemObject',true); % Equiripple design    
f2 = design(d,'firls','SystemObject',true);      % Least-squares design
f3 = design(d,'kaiserwin','SystemObject',true);  % Kaiser-window design 
%%
% One can verify that the passband/stopband ripples are the same
hfvt = fvtool(f1,f2,f3,'Color','white', ...
    'MagnitudeDisplay', 'Magnitude');
legend(hfvt, 'Equiripple design', 'Least-squares design', ...
    'Kaiser-window design')
%%
% Impulse response still zero for every other coefficient
set(hfvt, 'Analysis', 'Impulse');

%% Controlling the Stopband Attenuation
% Alternatively, one can specify the order and the stopband attenuation.
% For example,
Ast  = 60; % Minimum stopband attenuation 
d  = fdesign.halfband('Type','Lowpass','N,Ast',N,Ast);        
f1 = design(d,'equiripple','SystemObject',true); % Equiripple design
f2 = design(d,'kaiserwin','SystemObject',true);  % Kaiser-window design
hfvt = fvtool(f1,f2,'Color','white');
legend(hfvt, 'Equiripple design', 'Kaiser-window design')
%%
% Passband-/stopband-edge frequencies are a result of design
set(hfvt, 'MagnitudeDisplay', 'Zero-phase');
%%
% Impulse response still zero for every other coefficient
set(hfvt, 'Analysis', 'Impulse');

%% Minimum-Order Designs
% Another way of designing equiripple halfband filters is by specifying
% both the transition width and stopband ripple. The order of the filter
% cannot be specified in this case (because there are only two degrees of
% freedom), instead a filter of minimum-order that meets the design
% specifications is obtained.
TW = 0.02; % Transition width
Ast = 40;  % 40 dB of attenuation in the stopband
d  = fdesign.halfband('Type','Lowpass','TW,Ast',TW,Ast); 
f1 = design(d,'equiripple','SystemObject',true); % Equiripple design
f2 = design(d,'kaiserwin','SystemObject',true);  % Kaiser-window design 
hfvt = fvtool(f1,f2,'Color','white');
legend(hfvt, 'Equiripple Design', 'Kaiser-window design')

%% Equiripple Designs with Increasing Stopband Attenuation
% If it is still desirable to have an increasing attenuation in the
% stopband, we can use design options for equiripple designs to achieve
% this. 
f1 = design(d,'equiripple','StopbandShape','1/f','StopbandDecay',4,...
    'SystemObject',true);        
f2 = design(d,'equiripple','StopbandShape','linear', ...
    'StopbandDecay',53.333,'SystemObject',true);        
hfvt = fvtool(f1,f2,'Color','white');
legend(hfvt,'Stopband decaying as (1/f)^4','Stopband decaying linearly')

%% Highpass Halfband Filters
% A highpass halfband filter can be obtained from a lowpass halfband filter
% by changing the sign of every second coefficient. Alternatively, one can
% directly design a highpass halfband by setting the 'Type' property to
% 'Highpass'.
d  = fdesign.halfband('Type','Highpass','TW,Ast',TW,Ast); 
f1 = design(d,'equiripple','StopbandShape','linear', ...
    'StopbandDecay',53.333,'SystemObject',true);        
hfvt = fvtool(f1,f2,'Color','white');
legend(hfvt, 'Highpass halfband filter', 'Lowpass halfband filter')

%% Minimum-Phase Equiripple Designs
% Minimum-phase designs are useful for 2 channel filter banks with perfect
% reconstruction composed solely of FIR filters. For this case, the
% minimum-phase filter is not in itself a halfband filter. Rather, it is a
% spectral factor of a halfband filter. 
N = 51;                       % Minimum-phase order must be odd 
TW = 0.04;                    % Transition width
d = fdesign.halfband('Type','Lowpass','N,TW',N,TW);  
f = design(d,'equiripple','MinPhase',true,'SystemObject',true);   
%%
% Notice that the passband and stopband ripples are different in this case
fvtool(f,'Color','white', 'MagnitudeDisplay', 'Zero-phase');

%%
% All zeros of the minimum-phase filter are inside the unit circle 
fvtool(f,'Color','white', 'Analysis', 'polezero');
%%
% The minimum-phase filter is not in itself a halfband filter since every
% other coefficient is not equal to zero
fvtool(f,'Color','white', 'Analysis', 'impulse');
%%
% The corresponding halfband filter can be obtained by convolving the
% impulse response with a reversed version of it (the maximum-phase
% spectral factor).
fmin = f.Numerator;           % Minimum-phase spectral factor
fmax = fliplr(fmin);          % Maximum-phase spectral factor
hhalf = conv(fmin,fmax);      % Halfband filter with non-negative zerophase
%%
% Impulse response is zero for every other coefficient
hfvt = fvtool(hhalf, 'Analysis', 'impulse','Color','white');

%%
% Halfband filter with non-negative zerophase
set(hfvt, 'Analysis', 'Magnitude', 'MagnitudeDisplay', 'Zero-phase');
%%
% See also <pr2chfilterbankdemo.html Perfect Reconstruction Two-channel
% Filter Bank>.

displayEndOfDemoMessage(mfilename)
