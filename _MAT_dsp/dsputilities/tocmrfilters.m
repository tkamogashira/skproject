function tocmrfilters
% Simulate and analyze multirate floating- and fixed-point filters
% ----------------------------------------------------------------
%
%   <a href="matlab:help dsp.CICDecimator             ">dsp.CICDecimator</a>               - Decimate input using Cascaded Integrator-Comb filter
%   <a href="matlab:help dsp.CICInterpolator          ">dsp.CICInterpolator</a>            - Interpolate signal using Cascaded Integrator-Comb filter
%   <a href="matlab:help dsp.DigitalDownConverter     ">dsp.DigitalDownConverter</a>       - Digitally downconvert input signal
%   <a href="matlab:help dsp.DigitalUpConverter       ">dsp.DigitalUpConverter</a>         - Digitally upconvert input signal
%   <a href="matlab:help dsp.DyadicAnalysisFilterBank ">dsp.DyadicAnalysisFilterBank</a>   - Dyadic analysis filter bank
%   <a href="matlab:help dsp.DyadicSynthesisFilterBank">dsp.DyadicSynthesisFilterBank</a>  - Reconstruct signals from subbands
%   <a href="matlab:help dsp.FIRDecimator             ">dsp.FIRDecimator</a>               - FIR polyphase decimator
%   <a href="matlab:help dsp.FIRInterpolator          ">dsp.FIRInterpolator</a>            - Polyphase FIR interpolator
%   <a href="matlab:help dsp.FIRRateConverter         ">dsp.FIRRateConverter</a>           - Sample rate converter
%   <a href="matlab:help dsp.SubbandAnalysisFilter    ">dsp.SubbandAnalysisFilter</a>      - Decompose signal into high-frequency and low-frequency subbands
%   <a href="matlab:help dsp.SubbandSynthesisFilter   ">dsp.SubbandSynthesisFilter</a>     - Reconstruct signal from high-frequency and low-frequency subbands
%   <a href="matlab:help mfilt                        ">mfilt</a>                          - Multirate filter implementation
%
% <a href="matlab: help dsp">DSP System Toolbox TOC</a>

%   Copyright 2010-2013 The MathWorks, Inc.
