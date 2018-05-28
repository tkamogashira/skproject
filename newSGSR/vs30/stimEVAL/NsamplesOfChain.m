function varargout=NsamplesOfChain(durs, samP, singleOutput);

% function varargout=NsamplesOfSeries(durs);
% returns number of samples of consecutive portions
% of a stimulus in such a way that the total number
% of samples is independent of the distribution
% of the various durations and is only determined by 
% their sum (the total duration).
% durs is vector containing the durations in ms of the
% different portions of the stimulus. SamP is the
% sample period in us.
% This way of determining the # samples of different portions
% is less sensitive for individual rounding errors,
% which cumulate if the different sizes are 
% computed independently.

if nargin<3,
   singleOutput = 0;
end

borders = cumsum(durs);
lastSam = [0 round(borders*1e3/samP)];
Nsam = diff(lastSam);
if singleOutput,
   varargout{1} = Nsam;
else,
   N = min(length(durs), nargout);
   for ii=1:N, varargout(ii) = {Nsam(ii)}; end;
end




