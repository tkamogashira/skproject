function [H, tau] = ISIstat(spt, dt, maxDelay);
% ISIstat  - shifted autocorrelogram (SAC) based on all-order inter-spike intervals
%   Syntax: [H, Tau] = ISIstat(SPT, DT, maxDelay) 
%   Inputs:
%     SPT is array or cell array containing sorted (ascending) spike arrival times in ms
%     DT = binwidth in ms
%     maxDelay is the maximum delay in ms considered in computing the autocorrelation
%   Outputs:
%     H is histogram of inter-spike intervals in the specified range
%     Tau is vector containing the bincenters in ms; plot(tau,H) plots the SAC curve.
%
%   When SPT is a 1xNrep cell array, the individual cells are interpreted as the
%   spiketime collections of each repetion, and H is evaluated only across 
%   different repetitions.
%
%   When SPT is a NsubxNrep cell matrix, SPT{i,j} is interpreted as the collection
%   of sorted spike arrival times from the i-th repetition of the j-th subsequence,
%   and H is a cell array whose elements correspond to the different subsequences.
%
%   Example:
%     SPT = readspiketimes('A0128',16);  % SPT is 2x100 cell array, i.e. Nsub=2, Nrep=100
%     [H, tau] = ISIstat(SPT, 0.1, 10);  % binwidth = 0.1 ms; range = 0..10 ms
%     plot(tau, H{1}); hold on; plot(tau, H{2},'r'); % second subsequence in red
%
%   Notes: H is not normalized in any way; the histogram contains raw counts.
%          if speed is important, use ISIstat once with small binwidth and use
%            UPBIN to compute coarser histogram.

% MH Dec 2001

Nbin = round(maxDelay/dt); % # bins
Edges = dt*(0:Nbin); % Edges of histo used below
tau = dt*((1:Nbin)-0.5); % bin centers 

if iscell(spt), % Nsub x Nrep cell; use recursive calls
   [Nsub Nrep] = size(spt);
   if Nsub>1, % return cell array, one subseq per cell
      H = cell(Nsub,1);
      for isub=1:Nsub,
         H{isub,1} = ISIstat({spt{isub,:}}, dt, maxDelay);
      end
      return;
   end
   % single subseq, multiple reps from here
   H = ISIstat(sort(cat(2,spt{:})), dt, maxDelay); % merge & sort all reps
   % subtract "diagonal" (i.e., within-rep) terms 
   for irep=1:Nrep, % subtract within-rep terms
      H = H - ISIstat(spt{1, irep}, dt, maxDelay);
   end
   return
end

% single subseq, single rep from here, i.e., spt is single vector.
H = 0*Edges; % zero-count histo
Nspike = length(spt);
for idt=1:Nspike-1, % compare spike times with those shifted by itd positions
   newDTs = spt(1+idt:end)-spt(1:end-idt); % ISI's >= 0 always <- spt is sorted
   dH = histc(newDTs, Edges); % bin the ISI's
   if isempty(dH), break; end; % dH is empty in case spt is empty (bug in histc)
   if sum(dH)==0, break; end; % no intervals within range of interest -> ready
   H = H + dH;
end
H = H(1:end-1); % remove final garbage bin (see help histc)


