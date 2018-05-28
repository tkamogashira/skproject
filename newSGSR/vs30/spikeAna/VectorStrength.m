function [R, alpha, Z] = VectorStrength(spt, freq, TW)
% VectorStrength - returns vectorstrength of spike collection
%   VectorStrength(spt, freq) returns complex R; spt in ms, freq in Hz
%
%   VectorStrength(spt, freq, TWindow) applies correction for 
%   non-integer number of in analysis window TW (in ms).
%   The phases are weighted inversely proportional to the number of times 
%   they were visited by the wrapping frequency. 
%
%   [R, alpha, Z] = VectorStrength(spt, freq) returns complex R and 
%   confidence level according to Rayleigh statistics

% ---------------- CHANGELOG -----------------------
%  Mon Jan 24 2011  Abel   
%   return calculated z-value as output

if nargin<3, TW = []; end

if length(spt)<2
   R = 0;
   alpha = 1;
   Z = 0;
   return
end
wrappedTimes = exp(2*pi*1i*1e-3*spt*freq);

if ~isempty(TW) % apply correction
   startPhase = TW(1)*1e-3*freq;
   endPhase = TW(2)*1e-3*freq;
   phases = angle(wrappedTimes)/2/pi; % in cycles
   wrappedTimes = wrappedTimes.*FracCycleWeight(phases, startPhase, endPhase-startPhase);
end

R = mean(wrappedTimes);
if nargout>1
	%by Abel: z as optional output
   [alpha, Z] = RayleighSign(R,length(spt));
end



