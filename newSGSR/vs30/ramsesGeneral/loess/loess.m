function y = loess (xi,yi,x,alpha,lambda,weights,robust,collapse,dither)
% y = loess (xi, yi, ?x=unique(xi)?, ?alpha=0.1?, ?lambda=1?, ?weights=[]?,
%            ?robust=0?, ?collapse=0?, ?dither=0?)
%
% Returns the loess fit y(x) to data points yi(xi) having optional 
% weights (e.g., weights = 1/sigma_yi^2). The smoothing 
% parameter alpha (alpha<1) is the fraction of the total number 
% of data points to fit. Typically, alpha<<1 (so that the 
% fit is *local*). Uses a polynomial fit of order lambda. 
% Note that the data (xi,yi) do NOT need to be pre-sorted by xi,
% (but its a good idea to do so if you intend to plot the results!)
%
% The robust option computes an iterated robust loess fit.
% First, an initial (un-robust) loess fit is performed. The
% weights are then modified (based on the residuals to reduce
% the influence of outliers) and a new fit performed. 
% Ideally, the cycle of fitting and adjusting weights based on 
% residuals is iterated until the fit converges. 
% Here, the fit is iterated a total of robust times; 
% in practice robust=1 often suffices. If there are lots of
% data points, a robust fit can take a long time.
%
% The collapse option collapses all data points at the same
% value of xi and replaces the multiple yi by their median value.
% (We use the median not the mean in the hope that it'll be
% less sensitive to outliers.) Collapsing helps maintain 
% the 'local' character of the fit in cases where many xi have 
% multiple corresponding yi.
% (Note that the computation of the mean or median should take the weights
% into account and new weights should be computed using the variance.
% But we need to figure out what weights should be assigned to non-repeated
% values.)
%  
% The dither option dithers the xi randomly by dither percent
% using a Gaussian distribution. Dithering is an alternative
% solution to the 'duplicate xi problem' addressed by collapsing.
% If dither is set, collapse is unset.  
%
% Reference: 
%  Visualizing Data, William S. Cleveland
%  Hobart Press, 1993, pg 100ff
%
%  C.A. Shera
%

  if (nargin < 3 | isempty (x)),       x = unique(xi);           end;
  if (nargin < 4 | isempty (alpha)),   alpha = 0.1;              end;
  if (nargin < 5 | isempty (lambda)),  lambda = 1;               end;
  if (nargin < 6 | isempty (weights)), weights = ones(size(yi)); end;
  if (nargin < 7 | isempty (robust)),  robust = 0;               end;
  if (nargin < 8 | isempty (collapse)),collapse = 0;             end;
  if (nargin < 9 | isempty (dither)),  dither = 0;               end;

  if (dither), collapse=0; end
  
  % collapse repeated values...
  if (collapse)
    [sxi,I,J] = unique (xi);
    syi = zeros(size(sxi));
    wgt = zeros(size(sxi));
    for k = 1:length(sxi)
      avg_me = find (J==k);
      syi(k) = median (yi(avg_me));	% should use weights
      wgt(k) = mean (weights(avg_me));	% coarse
    end
    xi = sxi;
    yi = syi;
    weights = wgt;
  end

  % dither the xi...
  if (dither ~= 0)
    xi = xi .* (1 + dither*randn(size(xi))/100);
  end

%   
%  n = length (xi);
%  q = min (n, round (abs (alpha)*n));

  
  % do sanity control on the robust flag since
  % we later use it to control the iteration... 
  robust = round (abs (robust));

  weights = abs (weights);		% must be non-negative
  original_weights = weights;		% save for later

  if (~robust)
    % allocate some space for the fit...
    y = zeros (size (x));
  end

  
  % we dither the xi by a small random amount to prevent
  % there from being lots of repeated xi values, which can cause
  % havoc when trying to determine the q closest values...
  %  xi = xi .* (1 + 1e-6*randn(size(xi)));
  
  % iterate to obtain robust fits at the points xi...
  while (robust)
    robust = robust - 1;
    
    % do a normal loess fit at points xi (not x) using the current weights
    y = loess (xi,yi,xi,alpha,lambda,weights,0,collapse,dither);

    % compute residuals from fit...
    res = yi - y;
    
    % Compute bisquare robustness weighting function using the residuals...
    % Outliers (points with large residuals) receive a weighting near zero.
    mar = median (abs (res));		% median absolute residual
    u = res / (6*mar);

    % before iterating the fit, modify the original weights 
    % using the bisquare robustness weighting...
    weights = original_weights .* bisquare (u);
  end

  y = zeros (size(x));			% allocation
  
  % after this loop, robust is always zero...
  % Loop over x (not xi) ...
  for i = 1:length (x)
    % Compute the tricube weighting functions...
    % Points are weighted by their distance from x(i) using a 
    % variable window defined so that the qth most distant point 
    % has w=0. Except near the ends, the window will typically 
    % be roughly symmetric about x(i). Note that when determining 
    % the qth most distant point, we count points at the same xi 
    % as one. This differs from Cleveland's description, but is
    % more robust (and sensible?) in certain pathological cases.
    
    Delta = abs (xi-x(i));
    Delta_q = unique (Delta);		% sort array, removing duplicates
    n = length (Delta_q);
    q = min (n, round (abs (alpha)*n));
    
    % multiply in the tricube weighting...
    w = weights .* tricube (Delta/Delta_q(q));
    
    % Locate the points to fit...
    fit_me = find (w>0);

    % take care of various pathological cases...
    switch (length(fit_me))
     case 0
      warning ('loess: Empty window! Using NaN.');
      y(i) = NaN;
      continue;
     
     case 1
      warning ('loess: Single point in window! Skipping fit.');
      y(i) = yi(fit_me);
      continue;
     
     otherwise
      lam = min(lambda,length(fit_me)-1);
      if (lam ~= lambda)
	warning ('loess: Too few points in window! Reducing lambda.');
      end

      % Do the fit...
      if (lam==1)			
	% MUCH faster than polyfitw in linear case
	[a,b] = linear_fit (xi(fit_me),yi(fit_me),1./sqrt(w(fit_me)));
	y(i) = a + b*x(i);
      else
	p = polyfitw (xi(fit_me),yi(fit_me),lam,w(fit_me));
	y(i) = polyval (p,x(i));
      end
    end
  end
  return

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function T = tricube (u)
  u = abs (u);
  T = zeros (size (u));
  i = find (u<1);
  T(i) = (1-u(i).^3).^3;
  return

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function T = bisquare (u)
  u = abs (u);
  T = zeros (size (u));
  i = find (u<1);
  T(i) = (1-u(i).^2).^2;
  return



