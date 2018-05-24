function SACtot = SACmaker(C,b,m, display, normalize, ds, icorr)
% SACmaker. Makes the SAC of a number of spike trains.
% SACmaker(cell array C,binwidth b,min/max m,display,normalize,dataset ds, icorr ic)
% C = a vector of cells, each cell contains one vector with spike times
%
% b = binwidth
% m = maximum delay
% display = display the SAC, it should be 'yes' or 'no'.
%
% normalize = if the SAC should be normalized, als 'yes' or 'no'.
% the normalizing procedure is being done by dividing by
% N*(N-1)*r^2*dt*D (according to Louage et al., 2004)
%   N=number of presentations
%   r=average firing rate (if there are different noise tokens
% used in a dataset, the rate of the first group is taken)
%   dt = binwidth
%   D = stimulus duration
%
% dataset ds = the dataset used
% icorr ic = interaural correlation, should be 1 or -1
%
%
%TF 25/08/2005

nc=numel(C);

for i=1:nc
    %D is used in the following block to avoid the diagonal terms (shuffling)
    if i>1 & i<nc,  D = [C(1:(i-1)) C((i+1):nc)];
    elseif i==1, D = [C(2:nc)];
    elseif i==nc, D = [C(1:(nc-1))];
    end
    corr = corr2Trains(C{i}, [D{:}], b,m);
    
    if i==1 %the first time, extract also the borders of the bins from corr
        SACtot = corr;
    else % next times, just add the new value for each bin with the existing value
        SACtot(:,3)=SACtot(:,3)+corr(:,3);
    end
    
    disp(i);
end

if isequal(normalize,'yes')
    %compute average rate
    g=getrate(ds);
    if
    
    
    %compute normalizing factor (see Louage et al., 2004)
    nfactor = (ds.reps)*(ds.reps-1)*b*ds.burstDur*(rate^2);
    SACtot(:,3)=SACtot(:,3)/nfactor;
elseif isequal(normalize,'no')
    disp('The SAC has not been normalized');
else
    error('The input argument normalize has to be ''yes'' or ''no''.');
end

if isequal(display,'yes')
    [nr c] = size(SACtot);
    for i=1:nr
        fill([SACtot(i,1), SACtot(i,1), SACtot(i,2), SACtot(i,2)], [SACtot(i,3), 0, 0, SACtot(i,3)], 'b');
        hold on;
    end
    title(['SAC of ' int2str(nc) ' spike trains of dataset ' ds.seqID ' at ' int2str(ds.spl) ' dB SPL']);
    hold off;
elseif ~isequal(display,'yes')
    error('the input argument ''display'' has to be ''yes'' or ''no''');
end
    