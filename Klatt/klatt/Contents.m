% MATLAB speech synthesizer
%
% handsy.m    - GUI front end
% synth.m     - synthesize from HANDSY struct
%
% parcoef.m   - Convert stimulus parameters to synthesis parameters
% coewave.m   - Contert synthesis parameters to waveform
% parmcont.m  - Convert fields of HANDSY struct to tracks
% track.m     - Interpolate synthesis parameters
% getamp.m    - Convert dB intensity to amplitude
% setabc.m    - Convert formant frequency and bandwidth to filter coefficients
% changelen.m - Change duration of HANDSY struct
%
% grnwd.m     - Greenwood's (1990) cochlear frequency position function
% invgrnwd.m  - Inverse Greenwood equation
% grnwdspc.m  - Convert species name to cochlear frequency position coefficients
% cochn.m     - Cochlear normalized frequency
% invcochn.m  - Inverse cochlear normalized frequency
% cxform.m    - synthesize cochlear normalized stimulus
%
% fresp.m     - Frequency response given formant parameters
