function varargout = NsamplesofChain(durs,fs,singleOutput)
% NsamplesOfChain - sample counts for a chain of durations
%   Nsam = NsamplesofChain(Dur,Fsam) returns a vector Nsam of sample
%   counts corresponding to the durations [ms] in vector durs. Fsam is the
%   sample rate [kHz] of the waveforms. The sample counts are calculated 
%   based on the *total* length of all time intervals, sum(Dur), rather 
%   on the individual intervals. This method avoids cumulative errors in 
%   the rounding of individual time intervals. In particular, for two
%   different partionings Dur and Dur, the total #samples will be the same 
%   whenever sum(Dur)==sum(Dur).
%
%   [Nsam1, Nsam2 ..] = NsamplesofChain(Dur,Fsam) distributes the sample
%   counts corresponding to Dur(1), Dur(2), .. over the separate output 
%   values Nsam2, Nsam2 , .. . The number of output agrs must match
%   length(Dur).
%
%   Examples:
%     Nsam = NsamplesofChain([5 100 5 200],fs);
%     [Nriseon,Ntone,Nriseoff,Nsilence] = NsamplesofChain([5 100 5 200],fs);

if nargin<3,
    singleOutput = (nargout<2);
end

% The trick is simple: convert interval durations to interval boundaries;
% next convert these to cumulative sample indices; then to sample counts.
borders = cumsum(durs);
lastsamp = [0 round(borders*fs)]; %units: ms*kHz --> samples
Nsamp = diff(lastsamp);
if singleOutput == 1,
    varargout{1} = Nsamp;
else,
    if ~isequal(nargout, numel(durs)),
        error('Number of output arguments does not match length of Dur input arg.');
    end
    N = min(length(Nsamp),nargout); %see whether nargout limits output of all intervals
    for ii=1:N,
        varargout{ii} = Nsamp(ii);
    end
end


