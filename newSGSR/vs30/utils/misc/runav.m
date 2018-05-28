function X = runav(X,N, ignoreNans)
% RUNAV - running average

if nargin<3, ignoreNans=0; end;

if isempty(X), return; end

if size(X,1)>1 && size(X,2)>2
    Y = 0*X; % same size
    for icol=1:size(X,2)
        Y(:,icol) = runav(X(:,icol), N);
    end
    X = Y;
    return;
end

iscol = size(X,1)>1;
X = X(:);

if ignoreNans
   XX = X(~isnan(X));
   XX = XX(:);
   if isempty(XX)
       return;
   end;
   X = XX;
end;

L = length(X);

M = round(N/2);
N = 2*M+1;

h = hanning(N);
h = h/sum(h);

X = [repmat(X(1),M,1); X ; repmat(X(end),M,1)];
X = conv(X,h);

% excess samples: 2*M + 2*M 
X = X(2*M+(1:L));

if ignoreNans
   Y(isnan(X)) = nan;
   Y(~isnan(X)) = X;
   X = Y;
end

if iscol
   X = X(:);
else
   X = X(:).';
end
