function [h, significance, ci] = ttest2(x,y,alpha,tail)
%TTEST2 Hypothesis test: Compares the averages of two samples.
%   [H,SIGNIFICANCE CI] = TTEST2(X,Y,ALPHA,TAIL) performs a t-test to  
%   determine whether two samples from a normal distribution
%   (with unknown but equal variances) could have the same mean. 
%
%   The null hypothesis is: "means are equal".
%   For TAIL =  0  the alternative hypothesis is: "means are not equal."
%   For TAIL =  1, alternative: "mean of X is greater than mean of Y."
%   For TAIL = -1, alternative: "mean of X is less than mean of Y."
%   TAIL = 0 by default.
%
%   ALPHA is desired significance level (ALPHA = 0.05 by default). 
%   SIGNIFICANCE is the probability of observing the given result by 
%   chance given that the null hypothesis is true. Small values of 
%   SIGNIFICANCE cast doubt on the validity of the null hypothesis.
%   H=0 => "Do not reject null hypothesis at significance level of alpha."
%   H=1 => "Reject null hypothesis at significance level of alpha."

%   References:
%      [1] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, section 13.4. (Table 13.4.1 on page 210)

%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.9 $  $Date: 1997/11/29 01:46:55 $

if nargin < 2, 
    error('Requires at least two input arguments'); 
end

[m1 n1] = size(x);
[m2 n2] = size(y);
if (m1 ~= 1 & n1 ~= 1) | (m2 ~= 1 & n2 ~= 1)
    error('Requires vector first and second inputs.');
end
 
if nargin < 4, 
    tail = 0; 
end 

if nargin < 3, 
    alpha = 0.05; 
end 

if (alpha <= 0 | alpha >= 1)
    fprintf('Warning: significance level must be between 0 and 1\n'); 
    h = NaN;
    sig = NaN;
    return;
end

dfx = length(x) - 1;
dfy = length(y) - 1;
dfe  = dfx + dfy;
msx = dfx * var(x);
msy = dfy * var(y);

difference = mean(x) - mean(y);
pooleds    = sqrt((msx + msy) * (1/(dfx + 1) + 1/(dfy + 1)) / dfe);

ratio   = difference / pooleds;

criticalvalue = tinv(1 - alpha / 2,dfe);
spread = criticalvalue * pooleds;

ci = [(difference - spread) (difference + spread)]; 

% Find the significance probability for the  tail = 1 test.
significance  = 1 - tcdf(ratio,dfe);
% Adjust the significance probability for other null hypotheses.
if tail == -1
    significance = 1 - significance;
elseif tail == 0
    significance = 2 * min(significance,1 - significance);
end

% Determine if the actual significance exceeds the desired significance
h = 0;
if significance <= alpha, 
    h = 1; 
end 

if isnan(significance), 
    h = NaN; 
end
