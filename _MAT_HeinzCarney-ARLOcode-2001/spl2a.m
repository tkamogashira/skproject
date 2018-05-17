%
% Octave : a = spl2a(spl) : convert the spl to amplitude of the waveform
%
function a = spl2a(spl)
  a = 0.894 * 10.0.^((spl-90)./20);
%end;
