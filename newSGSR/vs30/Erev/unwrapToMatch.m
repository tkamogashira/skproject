function ph = unwrapToMatch(x,ph,xMatch,phMatch);
% unwrapToMatch - unwrap phase values to match a given phase curve
%   ph = unwrapToMatch(x, ph, xMatch, phMatch) unwraps the phase values ph
%   in such a way that the phase curve (x -> ph) matches the "example phase curve"
%   (xMatch -> phMatch) as well as possible.
%   Nan values in phMatch are ignored.
%
%   NOTE: phase values are in cycles!!

% ---interpolate phMatch values to obtain match-phase at x values.
xMatch = xMatch(:).'; % row vector
phMatch = phMatch(:).'; % row vector
% remove NaNs from example curve
iok = find(~isnan(phMatch));
xMatch = xMatch(iok); 
phMatch = phMatch(iok);
% sort match curve
[xMatch, isort] = sort(xMatch);
phMatch = phMatch(isort);
% make sure match curve has enough of a range to include x values
[xmin, xmax] = minmax(xMatch);
if xmin>min(x),
   xMatch = [min(x) xMatch];
   phMatch = [phMatch(1) phMatch]; % repeat first value - what else?
end
if xmax<max(x),
   xMatch = [xMatch max(x)];
   phMatch = [phMatch phMatch(end)]; % repeat last value - what else?
end
phGoal = interp1(xMatch, phMatch, x); 

% "unwrapping" means adding an integer number of cycles to each ph value in such
% a way that the absolute difference with the corresponding phGoal value is minimal.
% A little consideration yields the following simple solution:
ph = ph + round(phGoal-ph);















