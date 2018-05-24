function corr = corr2Trains(A, B, b, m)

% corr2Trains(train A, train B, binwidth b, max/min m)
% 
% Correlates two spike trains by measuring the time intervals between the spikes
% from A and B. The trains must be column vectors from spike times in msec.
% The result is given as a matrix [X Y Z], each row represents a bin:
% X = column vector of the left borders of the bins of the correlogram
% Y = column vector of the right borders of the bins of the correlogram
% Z = column vector of the number of measured time intervals the bin contains
%
% m is the minimum and maximum value for the delay.
%
% delay is regarded as from B with reference to A, for example a positive delay
% means that a spike in B occurs after a spike in A.
%
% the central bin is centered at zero
%
% a measured interval is placed in the closest bin with respect to zero,
% e.g.: an interval of 2 msec will be placed in the bin from 0 to 2 msec, and
% not in the bin from 2 to 4 msec,
% but an interval of -2 msec will be placed in the bin from -2 to 0 msec, and
% not in the bin from -4 to -2 msec.
%
% TF 25/08/05

% checking input arguments
if ~mod(m,b)==0
    disp('max/min m moet een veelvoud zijn van binwidth b');
    return;
end

% creating ouput argument corr and filling the first 2 columns (X and Y)
nrbins = 2*(m/b)+1;
corr = zeros(nrbins, 3);
corr(:,1)=(-1*(m+(b/2)):b:m-(b/2))';
corr(:,2)=(-1*(m-(b/2)):b:m+(b/2))';

na = numel(A);
nb = numel(B);

for i=1:na
    currspikeA=A(i);
    for j=1:nb
        currspikeB=B(j);
        %compute delay
        delay=currspikeB-currspikeA;
        %put delay in corr-matrix
        currRow = findRow(delay, corr);
        if currRow~=-1
            corr(currRow,3) = corr(currRow,3) + 1;
        end
    end
end

%-------------------------------------------------------------------------------
function r = findRow(d, corr)

%finds row in the corrmatrix where the delay d should be put
%returns -1 if d is bigger than min/max m or smaller than -m
%
% a measured interval is placed in the closest bin with respect to zero,
% e.g.: an interval of 2 msec will be placed in the bin from 0 to 2 msec, and
% not in the bin from 2 to 4 msec,
% but an interval of -2 msec will be placed in the bin from -2 to 0 msec, and
% not in the bin from -4 to -2 msec.

corrsize = size(corr);
nrbins = corrsize(1);

if d<corr(1,1)|d>corr(nrbins,2)
    r=-1;
    return;
end

if d>=0 %this check for positivity of is necessary to place d always in the closest bin to zero
    for i=1:nrbins
        if d>=corr(i,1) & d<=corr(i,2)
            r = i;
            break;
        end
    end
    return;
else
    for i=0:nrbins-1
        if d>=corr(nrbins-i,1) & d<=corr(nrbins-i,2)
            r = nrbins-i;
            break;
        end
    end
end
