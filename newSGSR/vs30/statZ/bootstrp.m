function [bootstat, bootsam] = bootstrp(nboot,bootfun,varargin)
%BOOTSTRP Bootstrap statistics.
%   BOOTSTRP(NBOOT,BOOTFUN,...) draws NBOOT bootstrap data samples and
%   analyzes them using the function, BOOTFUN. NBOOT must be a
%   positive integer. BOOTSTRAP passes the (data) extra arguments to BOOTFUN.
%
%   [BOOTSTAT,BOOTSAM] = BOOTSTRP(...) Each row of BOOTSTAT contains
%   the results of BOOTFUN on one bootstrap sample. If BOOTFUN
%   returns a matrix, then this output is converted to a long
%   vector for storage in BOOTSTAT. BOOTSAM is a matrix of indices
%   into the row 

%   Reference:
%      Efron, Bradley, & Tibshirani, Robert, J.
%      "An Introduction to the Bootstrap", 
%      Chapman and Hall, New York. 1993.

%   B.A. Jones 9-27-95, ZP You 8-13-98
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.6 $  $Date: 1998/08/13 20:49:29 $

% Initialize matrix to identify scalar arguments to bootfun.
la = length(varargin);
scalard = zeros(la,1); db = cell(la,1);

% find out the size information in varargin.
n = 1;
for k = 1:la
   [row,col] = size(varargin{k});
   if max(row,col) == 1
      scalard(k) = 1;
   end
   if row == 1 & col ~= 1
      row = col;
      varargin{k} = varargin{k}(:);
   end
   n = max(n,row);
end

% Create index matrix of bootstrap samples.
bootsam = unidrnd(n,n,nboot);

% Get result of bootfun on actual data and find its size. 
thetafit = feval(bootfun,varargin{:});
[ntheta ptheta] = size(thetafit);

% Initialize a matrix to contain the results of all the bootstrap calculations.
bootstat = zeros(nboot,ntheta*ptheta);

% Do bootfun - nboot times.
for bootiter = 1:nboot
   for k = 1:la
      if scalard(k) == 0
         db{k} = varargin{k}(bootsam(:,bootiter));
      else
         db{k} = varargin{k};
      end
   end
   tmp = feval(bootfun,db{:});
   bootstat(bootiter,:) = (tmp(:))';
end
