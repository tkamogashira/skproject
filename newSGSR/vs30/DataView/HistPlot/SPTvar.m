function [V1, V2, V12] = SPTvar(CostPerTime, spt1, spt2, isub);
% SPTVAR - variance of a collection of spike trains
%   V = SPTVAR(CostPerTime, SPT) computes the variance among a
%   set of spike trains SPT, which is a cell array containing 
%   spike trains as numerical vectors.
%   The computation is based on the Victor/Purpura spike train
%   metric (first variant, based on absolute timing) with 
%   temporal parameter CostPerTime (see SPTDIST).
%
%   Denoting the distance between spike trains i and j by D(i,j),
%   the variance is defined one-fourth the mean squared distance
%   across all ordered pairs i<j:
%
%     V = 0.25*Sum(D(i,j).^2)
%              i<j
%   
%   [V1,V2,V12] = SPTVAR(CPT, SPT1, SPT2) also computes the 
%   variance V12 across the spike train sets SPT1 and SPT2, that is,
%   the distances D(i1,i2) between all spike train pairs SPT1{i1} 
%   and SPT{i2} are considered:
%
%     V = 0.25*Sum(D(i1,i2).^2)
%             i1,i2
%   
%    V1 and V2 are simply SPTVAR(CPT, SPT1) and SPTVAR(CPT, SPT2),
%    that is, the within-set variances.
%
%    SPTVAR(CPT, DS, I), where DS is a dataset, computes the variance
%    of the subsequence (condition) I.
%
%    [V1,V2,V12] = SPTVAR(CPT, DS, [I1 I2]), where DS is a dataset, 
%    also computes the across-condition variance between subsequences
%    I1 and I2.

%    See also SPTDIST, SPTCORR, VAR

% extract spike trains from datasets if necessary
if isa(spt1, 'dataset'),
   if nargin<4, 
      isub = spt2; 
      spt2 = {}; 
   end
   spt1 = spt1.spt;
   spt1 = spt1(isub(1),:);
end
if nargin>2,
   if isa(spt2, 'dataset'),
      spt2 = spt2.spt;
      spt2 = spt2(isub(end),:);
   end
else, % no second set (note any isub value passed via spt2 is saved above)
   spt2 = {};
end

if isempty(spt2), % within-set variance (see help text)
   N = length(spt1);
   Npair = 0; V1 = 0;
   for itrain = 1:N,
      for jtrain = itrain+1:N,
         V1 = V1 + SPTdist(spt1{itrain}, spt1{jtrain}, CostPerTime).^2;
         Npair = Npair+1;
      end
   end
   V1 = V1./(4*Npair);
else, % two sets: within AND across-set variances (see help text)
   % first do the within-set ones by recursion
   V1 = SPTvar(CostPerTime, spt1);
   V2 = SPTvar(CostPerTime, spt2);
   % now the across set variance
   N1 = length(spt1);
   N2 = length(spt2);
   Npair = 0; V12 = 0;
   for itrain = 1:N1,
      for jtrain = 1:N2,
         V12 = V12 + SPTdist(spt1{itrain}, spt2{jtrain}, CostPerTime(:).').^2;
         Npair = Npair+1;
      end
   end
   V12 = V12./(4*Npair);
end






