function [WavOut, PlayIdx] = SeqplayReview(Chan, N)
% SeqplayReview - plot "real" output of seqplay circuit: DEBUG circuit only
%    syntax: [WavOut, PlayIdx] = SeqplayReview(Chan, N)
%   Generates plot of data sent to OUT-Chan by Debug circuit.
%   Output data is collected in WavOut.
%   N indicates amount of samples to download. Default = PlayIdx.
%   Function written for debugging purposes. SeqplayDebug circuit should be 
%   loaded. Be quick, buffer will be overwritten!

SPinfo = SeqplayInfo;
Dev = SPinfo.Dev;
PlayIdx = sys3getpar('PlayIndexL', Dev);

if nargin<2,
   N = PlayIdx;
end

switch Chan,
case 'L',
   figure;
   WavOut = sys3read('PlayWavL', Dev, N);
   xplot(WavOut,'-o');
   title WavOutL;
case 'R',
   WavOut = sys3read('PlayWavR', Dev, N);
   xplot(WavOut+0.2,'r-o');
   title WavOutR;
end