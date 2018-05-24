function tocfiltering
% Single- and multi-rate filter implementations
% ---------------------------------------------
%
%   <a href="matlab:help dsp.AdaptiveLatticeFilter        ">dsp.AdaptiveLatticeFilter</a>          - Compute output, error, and weights using adaptive lattice filter algorithm
%   <a href="matlab:help dsp.AffineProjectionFilter       ">dsp.AffineProjectionFilter</a>         - Compute output, error, and weights using affine projection adaptive algorithm
%   <a href="matlab:help dsp.AllpassFilter                ">dsp.AllpassFilter</a>                  - Model allpass filters
%   <a href="matlab:help dsp.AllpoleFilter                ">dsp.AllpoleFilter</a>                  - Model allpole filters
%   <a href="matlab:help dsp.BiquadFilter                 ">dsp.BiquadFilter</a>                   - Model biquadratic IIR (SOS) filters
%   <a href="matlab:help dsp.BlockLMSFilter               ">dsp.BlockLMSFilter</a>                 - Compute output, error and weights using Block LMS adaptive filter algorithm
%   <a href="matlab:help dsp.CICDecimator                 ">dsp.CICDecimator</a>                   - Decimate signal using Cascaded Integrator-Comb filter
%   <a href="matlab:help dsp.CICInterpolator              ">dsp.CICInterpolator</a>                - Interpolate signal using Cascaded Integrator-Comb filter
%   <a href="matlab:help dsp.CoupledAllpassFilter         ">dsp.CoupledAllpassFilter</a>           - Model single-rate coupled allpass filters
%   <a href="matlab:help dsp.DigitalFilter                ">dsp.DigitalFilter</a>                  - Filter each channel of input over time using discrete-time filter implementations
%   <a href="matlab:help dsp.DyadicAnalysisFilterBank     ">dsp.DyadicAnalysisFilterBank</a>       - Decompose signals into subbands with smaller bandwidths and slower sample rates
%   <a href="matlab:help dsp.DyadicSynthesisFilterBank    ">dsp.DyadicSynthesisFilterBank</a>      - Reconstruct signals from subbands with smaller bandwidths and slower sample rates
%   <a href="matlab:help dsp.FastTransversalFilter        ">dsp.FastTransversalFilter</a>          - Compute output, error, and weights using fast transversal filter adaptive algorithm
%   <a href="matlab:help dsp.FilteredXLMSFilter           ">dsp.FilteredXLMSFilter</a>             - Compute output, error, and weights using filtered xlms adaptive algorithm
%   <a href="matlab:help dsp.FIRDecimator                 ">dsp.FIRDecimator</a>                   - Filter and downsample input signals
%   <a href="matlab:help dsp.FIRFilter                    ">dsp.FIRFilter</a>                      - Model finite impulse response (FIR) filters
%   <a href="matlab:help dsp.FIRInterpolator              ">dsp.FIRInterpolator</a>                - Upsample and filter input signals
%   <a href="matlab:help dsp.FIRRateConverter             ">dsp.FIRRateConverter</a>               - Upsample, filter and downsample input signals
%   <a href="matlab:help dsp.FrequencyDomainAdaptiveFilter">dsp.FrequencyDomainAdaptiveFilter</a>  - Compute output, error, and weights using frequency domain adaptive algorithm
%   <a href="matlab:help dsp.IIRFilter                    ">dsp.IIRFilter</a>                      - Model infinite impulse response (IIR) filters
%   <a href="matlab:help dsp.KalmanFilter                 ">dsp.KalmanFilter</a>                   - Estimate measurements and states of a system in presence of white noise using Kalman filter
%   <a href="matlab:help dsp.LMSFilter                    ">dsp.LMSFilter</a>                      - Compute output, error, and weights using LMS adaptive algorithm 
%   <a href="matlab:help dsp.NotchPeakFilter              ">dsp.NotchPeakFilter</a>                - Second-order notch and peak IIR filter 
%   <a href="matlab:help dsp.ParametricEQFilter           ">dsp.ParametricEQFilter</a>             - Second-order parametric equalizer IIR filter 
%   <a href="matlab:help dsp.RLSFilter                    ">dsp.RLSFilter</a>                      - Compute output, error, and weights using RLS adaptive algorithm 
%   <a href="matlab:help dsp.SubbandAnalysisFilter        ">dsp.SubbandAnalysisFilter</a>          - Decompose signal into high-frequency subband and low-frequency subband
%   <a href="matlab:help dsp.SubbandSynthesisFilter       ">dsp.SubbandSynthesisFilter</a>         - Reconstruct signal from high-frequency subband and low-frequency subband
%
% <a href="matlab: help dsp">DSP System Toolbox TOC</a>

%   Copyright 2010-2013 The MathWorks, Inc.
