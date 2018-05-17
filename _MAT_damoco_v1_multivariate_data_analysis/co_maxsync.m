function[M_SyncIn, maxind, n_theta1, m_theta2]=co_maxsync(theta1, theta2, or)
% DAMOCO Toolbox, function CO_MAXSYNC, version 17.01.11
% This function computes a matrix of  n:m synchronization indices, 
%           where n,m=1,...,or.
% It also determines the maximal index and corresponding values of n,m
% 
% Form of call: [M_SyncIn,maxind,m_theta1,m_theta2]=co_maxsync(theta1,theta2,or)
% INPUT     theta1:   Protophase of the 1st oscillator
%           theta2:   Protophase of the 2nd oscillator
%           or:       Maximal order to be considered 
%   
% OUTPUT    M_SyncIn: Matrix of  n:m synchronization indices, i.e. 
%                     M_SynIn(n,m) is the synchronization index of order n:m
%           maxind:   maximal synchronization index
%           n_theta1: the value of n, corresponding to the maximal 
%                     synchronization index
%           m_theta2: the value of m, corresponding to the maximal 
%                     synchronization index
%
M_SyncIn = zeros(or,or); maxind=0;
for n = 1 : or
    for m = 1 : or
        index=co_sync(theta1, theta2, n, m);  % Computing the matrix of synchronizations indices
        if index > maxind
            maxind=index; n_theta1=n; m_theta2=m;
        end
        M_SyncIn(n, m) = index;
    end
end
end

