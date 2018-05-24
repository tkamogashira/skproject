function Hs = sysobj(this,varargin)
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

% If an extra logical input equal to true is passed to the sysobj method,
% then sysobj returns a flag set to true if the System object conversion is
% supported for the mfilt class at hand, and to false if the conversion is
% not supported. This input is undocumented.
if nargin > 1
  validateattributes(varargin{1},{'logical'},{'scalar'},'','return flag input');
  if varargin{1}
    Hs = tosysobj(this,false);
    return;
  end
end

Hs = tosysobj(this,true);

% set the meta data until the end since the System object deletes the meta
% data every time a property is set
setsysobjmetadata(this,Hs);

% [EOF]
