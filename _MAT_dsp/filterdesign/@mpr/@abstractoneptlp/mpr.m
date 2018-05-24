function b = mpr(this)
%MPR   Implement the MPR algorithm

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Here's an interesting case when looking at number of iterations vs
% density factor vs accuracy of convergence (relative difference threshold)
% Suppose rel_diff_thresh is changed to 1e-8 below (in the code).
% N=99;
% ws=19;
% H=mpr.oneptlp_t2(N,ws,16);b=mpr(H); % Design doesn't converge relative
%                                     % difference reaches rock bottom at
%                                     % 8.7942e-05. Even allowing more
%                                     % iterations would not help. 1e-8 is
%                                     % too small a threshold for convergence
% H=mpr.oneptlp_t2(N,ws,32);b=mpr(H); % By increasing the density factor,
%                                     % the design converges in 12
%                                     % iterations ans the relative
%                                     % difference is 1.3445e-16


maxiter = 30; % Maximum number of iterations allowed

% Relative difference threshold. This value is influenced by the density
% factor. The reason has to do with example above
rel_diff_thresh = str2num(['1e-',num2str(floor(log2(this.DensityFactor)))]); 

% In this check we could use the following suggested in Antoniou instead:
% while((rel_difference(this)>1e-8)&&this.iter<maxiter)
% but it is equivalent and requires a little more computation
while (norm((this.analyticerr-this.measurederr)/this.measurederr,inf) > rel_diff_thresh) &&...
        (this.iter < maxiter),    
    iterate(this);
end

if (norm((this.analyticerr-this.measurederr)/this.measurederr,inf) > rel_diff_thresh) &&...
        (this.iter == maxiter),
    warning(message('dsp:mpr:abstractoneptlp:mpr:nonConvergence'));
end

b = determine_impresp(this);


% [EOF]
