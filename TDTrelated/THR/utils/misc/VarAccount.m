function V = VarAccount(Data, Fit, W);
% VarAccount - percentage variance accounted for
%     V = VarAccount(Data, Fit) returns the variance in array Data accounted 
%     for by model data Fit:
%
%        V = 100*(1-var(Data-Fit)/var(Data))
%
%     Data and Fit must have equal or compatible sizes. Note that V may be
%     negative, indicating that the Fit is worse than simply taking the
%     constant mean(Data) as a "model" for Data.
%    
%     V = VarAccount(Data, Fit, W) weights the individual datapoints
%     using the weight factors in W. That is, in the above formula the use
%     of VAR(X) is replaced by WVAR(X)=sum(W.*(X-Mu).^2)/(N-1), with
%     N = length(X) and weighted mean Mu = sum(W.*M)/sum(W).
%
%        V = 100*(1-var(Data-Fit)/var(Data))
%
%     Data and Fit must have equal or compatible sizes. Note that V may be
%     negative, indicating that the Fit is worse than simply taking the
%     constant mean(Data) as a "model" for Data.
%    
%   See also VAR, SameSize, SNR2W.

if nargin<3, W = 1; end

[Data, Fit, W] = SameSize(Data, Fit, W);
Q = local_mvar(Data(:)-Fit(:), W(:))/local_mvar(Data(:), W(:));
V = 100*(1-Q);

function mv = local_mvar(X,W);
% weighted variance; see help text of main function
Mu = sum(W.*X)/sum(W);
N = length(X);
mv = sum(W.*(X-Mu).^2)/(N-1);

