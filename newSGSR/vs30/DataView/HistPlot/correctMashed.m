function [ spt1, spt2 ] = correctMashed(spt, reduceRes)
% correctMashed - seperate a mashed spiketrain into two spiketrains.
% The original spiketrain spt is binned with 50 microsec bins and then two
% vectors, with 50 microsec resolution, are created.
% The first contains one spike for each bin which contains one or more
% spikes, the second contains the number of ommited spikes for each bin.

if nargin<2
    reduceRes = true;
end

spt1 = [];
spt2 = [];
endTime = ceil( spt(end) / 0.05) * 0.05;
prevTime = -0.1; %Make sure zero is included
if reduceRes
    for time = 0.05:0.05:endTime
        numSpikes = length(spt( (spt>prevTime) & (spt<=time) ));
        if numSpikes > 0
            spt1 = [ spt1 time ];
            spt2 = [ spt2 ones(1,numSpikes-1).*time ];
        end
        prevTime = time;
    end
else % Do not reduce the resolution to 50 microsec but keep the orig 1 microsec
    for time = 0.05:0.05:endTime
        lower = find(spt>prevTime, 1, 'first');
        upper = find(spt<=time, 1, 'last');
        spikes = nonzeros(spt(lower:upper))';
        if numel(spikes)>=1
            spt1 = [spt1 spikes(1)];
            if numel(spikes)>=2
                spt2 = [spt2 spikes(2:end)];
            end
        end
        prevTime = time;
    end
end
