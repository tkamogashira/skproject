function d = Duration(W);
% Waveform/Duration - Duration of waveform(s)
%   Duration(W) or W.Duration is the duration [ms] of waveform object W.
%   For arrays, D=Duration(W) is an array with D(k) = Duration(W(k)).

if isempty(W), d=[]; return; end

Fsam = W(1).Fsam;
d = [W.NsamPlay]*1e3/Fsam; % samples -> s -> ms
d = reshape(d,size(W)); 

