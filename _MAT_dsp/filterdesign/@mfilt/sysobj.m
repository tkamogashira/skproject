%SYSOBJ Generate a filter System object
%   Hs = sysobj(Hd) generates a filter System object, Hs, based on the
%   mfilt object, Hd.
%
%   The supported structures are:
%
%   FIR decimator structures (sysobj generates a dsp.FIRDecimator System object):
%     Direct-form FIR polyphase decimator (mfilt.firdecim)
%     Direct-form transposed FIR polyphase decimator (mfilt.firtdecim)
%
%   FIR interpolator structures (sysobj generates a dsp.FIRInterpolator System object):
%     Direct-form FIR polyphase interpolator (mfilt.firinterp)
%     FIR linear interpolator (mfilt.linearinterp)
%
%   FIR sample-rate converter structures (sysobj generates a dsp.FIRRateConverter System object):
%     Direct-form FIR polyphase sample-rate converter (mfilt.firsrc)
%
%   CIC decimator structure (sysobj generates a dsp.CICDecimator System object):
%     Cascaded integrator-comb (CIC) decimator (cicdecim)
%
%   CIC interpolator structure (sysobj generates a dsp.CICInterpolator System object):
%     Cascaded integrator-comb (CIC) interpolator (mfilt.cicinterp)


%   Copyright 2011 The MathWorks, Inc.

% [EOF]
