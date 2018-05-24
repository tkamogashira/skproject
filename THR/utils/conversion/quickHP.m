function X = quickHP(dt, X,DT);
% quickHP - quick & dirty detrend fcn
%   quickHP(dt, X,DT)
%    dt: sample period in ms
%    X: data array or matrix (columns are time sequences)
%   DT: smoothing interval. If DT==inf, X is returned as is.

if isinf(DT), % no filtering
    return; 
end

MX = samesize(mean(X),X);
X = X - MX;
X = MX + X - smoothen(X,DT,dt);



