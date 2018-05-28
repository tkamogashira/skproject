function p = wpolyfit(x,y,w,N);
% WPOLYFIT - weighted polyfit 
%   wpolyfit(x,y,w,N) returns the N-th order 
%   polynomial that best describes y as a
%   function of x. The data are weighted by
%   weight factors w in such a way that
%   the effect of doubling the weight w(i) of
%   a given (x(i),y(i)) pair is approx equivalent to
%   duplicating the pair in the data.
%   Datapoints with zero weight are ignored.
%
%   Unlike polyfit, NaNs are returned whenever there 
%   are too few (significant) datapoints to fit a
%   unique polynomial.

% clip neg weights
w = max(0,w);
isig = find(w>0);
if length(isig)<=N, % not enough sign data to fit in sensible way
   p = nan*(0:N); 
   return;
end
[x,y,w] = deal(x(isig), y(isig), w(isig)); % only consider significant data
% col vectors please
[x,y,w] = deal(x(:),y(:),w(:));
dynRange = max(w)/min(w);
if dynRange>1000,
   error('Dynamic range of weights may not exceed 1000.');
end

w = round(w/min(w)); % now it's repetitions rather than weights
Nrep = max(w);
x = repmat(x,1,Nrep);
y = repmat(y,1,Nrep);
% NaNify those reps that are beyond the weight of that datapoint
for idat=1:size(x,1),
   x(idat, 1+w(idat):end) = nan;
   y(idat, 1+w(idat):end) = nan;
end
x = x.'; y = y.'; % adjoint -> reps are adjacent and look better
% remove NaNs
x = x(find(~isnan(x))).'; % row vector
y = y(find(~isnan(y))).'; % row vector
% now feed to polyfit
p = polyfit(x,y,N);




