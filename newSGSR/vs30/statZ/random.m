function r = random(name,a,b,c,d,e)
%RANDOM Generates random numbers from a named distribution.
%   R = RANDOM(NAME,A,M,N) returns an M-by-N array of random
%   numbers from the named distribution with parameter A.
%   R = RANDOM(NAME,A,B,M,N) returns an M-by-N array of random
%   numbers from the named distribution with parameters A, and B.
%   R = RANDOM(NAME,A,B,C,M,N) returns an M-by-N array of random
%   numbers from the named distribution with parameters A, B, and C.
%
%   The name can be: 'beta' or 'Beta', 'bino' or 'Binomial',
%   'chi2' or 'Chisquare','exp' or 'Exponential', 'f' or 'F', 
%   'gam' or 'Gamma','geo' or 'Geometric','hyge' or 'Hypergeometric',
%   'logn' or 'Lognormal','nbin' or 'Negative Binomial',
%   'ncf' or 'Noncentral F','nct' or 'Noncentral t',
%   'ncx2' or 'Noncentral Chi-square'
%   'norm' or 'Normal','poiss' or 'Poisson','rayl' or 'Rayleigh',
%   't' or 'T','unif' or 'Uniform','unid' or 'Discrete Uniform',
%   'weib' or 'Weibull'.
% 
%   The default value for both M and N is 1.

%   RANDOM calls many specialized routines that do the calculations. 

%   D. Zwillinger 5-91, B. Jones 10-92
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:46:29 $

if ~isstr(name), 
   error('The first argument must be the name of a probability distribution.'); 
end

% define the default parameter values (i.e., array dimensions)

% Determine, and call, the appropriate subroutine 
if     strcmp(deblank(name),'beta') | strcmp(deblank(name),'Beta')
      if nargin == 3
       r = betarnd(a,b);
   elseif nargin == 4
       r = betarnd(a,b,c);
   elseif nargin == 5
       r = betarnd(a,b,c,d);
   else
      error('BETARND called with incorrect number of inputs.');
   end 
   
elseif strcmp(deblank(name),'bino') | strcmp(deblank(name),'Binomial')  
      if nargin == 3
       r = binornd(a,b);
   elseif nargin == 4
       r = binornd(a,b,c);
   elseif nargin == 5
       r = binornd(a,b,c,d);
   else
      error('BINORND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'chi2') | strcmp(deblank(name),'Chisquare')  
      if nargin == 2
       r = chi2rnd(a);
   elseif nargin == 3
       r = chi2rnd(a,b);
   elseif nargin == 4
       r = chi2rnd(a,b,c);
   else
      error('CHI2RND called with incorrect number of inputs.');
   end 

elseif strcmp(deblank(name),'exp') | strcmp(deblank(name),'Exponential')   
      if nargin == 2
       r = exprnd(a);
   elseif nargin == 3
       r = exprnd(a,b);
   elseif nargin == 4
       r = exprnd(a,b,c);
   else
      error('EXPRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'f') | strcmp(deblank(name),'F')     
      if nargin == 3
       r = frnd(a,b);
   elseif nargin == 4
       r = frnd(a,b,c);
   elseif nargin == 5
       r = frnd(a,b,c,d);
   else
      error('FRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'gam') | strcmp(deblank(name),'Gamma')   
      if nargin == 3
       r = gamrnd(a,b);
   elseif nargin == 4
       r = gamrnd(a,b,c);
   elseif nargin == 5
       r = gamrnd(a,b,c,d);
   else
      error('GAMRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'geo') | strcmp(deblank(name),'Geometric')   
      if nargin == 2
       r = geornd(a);
   elseif nargin == 3
       r = geornd(a,b);
   elseif nargin == 4
       r = geornd(a,b,c);
   else
      error('GEORND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'hyge') | strcmp(deblank(name),'Hypergeometric')  
      if nargin == 4
       r = hygernd(a,b,c);
   elseif nargin == 5
       r = hygernd(a,b,c,d);
   elseif nargin == 6
       r = hygernd(a,b,c,d,e);
   else
      error('HYGERND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'logn') | strcmp(deblank(name),'Lognormal'),
      if nargin == 3
       r = lognrnd(a,b);
   elseif nargin == 4
       r = lognrnd(a,b,c);
   elseif nargin == 5
       r = lognrnd(a,b,c,d);
   else
      error('LOGNRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'nbin') | strcmp(deblank(name),'Negative Binomial'),
      if nargin == 3
       r = nbinrnd(a,b);
   elseif nargin == 4
       r = nbinrnd(a,b,c);
   elseif nargin == 5
       r = nbinrnd(a,b,c,d);
   else
      error('NBINRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'ncf') | strcmp(deblank(name),'Noncentral F'),
      if nargin == 4
       r = ncfrnd(a,b,c);
   elseif nargin == 5
       r = ncfrnd(a,b,c,d);
   elseif nargin == 6
       r = ncfrnd(a,b,c,d,e);
   else
      error('NCFRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'nct') | strcmp(deblank(name),'Noncentral T'),
      if nargin == 3
       r = nctrnd(a,b);
   elseif nargin == 4
       r = nctrnd(a,b,c);
   elseif nargin == 5
       r = nctrnd(a,b,c,d);
   else
      error('NCTRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'ncx2')| strcmp(deblank(name),'Noncentral Chi-square'),  
      if nargin == 3
       r = ncx2rnd(a,b);
   elseif nargin == 4
       r = ncx2rnd(a,b,c);
   elseif nargin == 5
       r = ncx2rnd(a,b,c,d);
   else
      error('NCX2RND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'norm')  | strcmp(deblank(name),'Normal'), 
      if nargin == 3
       r = normrnd(a,b);
   elseif nargin == 4
       r = normrnd(a,b,c);
   elseif nargin == 5
       r = normrnd(a,b,c,d);
   else
      error('NORMRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'poiss') | strcmp(deblank(name),'Poisson'),
      if nargin == 2
       r = poissrnd(a);
   elseif nargin == 3
       r = poissrnd(a,b);
   elseif nargin == 4
       r = poissrnd(a,b,c);
   else
      error('POISSRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'rayl') | strcmp(deblank(name),'Rayleigh'),
      if nargin == 2
       r = raylrnd(a);
   elseif nargin == 3
       r = raylrnd(a,b);
   elseif nargin == 4
       r = raylrnd(a,b,c);
   else
      error('RAYLRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'t') | strcmp(deblank(name),'T')     
      if nargin == 2
       r = trnd(a);
   elseif nargin == 3
       r = trnd(a,b);
   elseif nargin == 4
       r = trnd(a,b,c);
   else
      error('TRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'unid') | strcmp(deblank(name),'Discrete Uniform')
      if nargin == 2
       r = unidrnd(a);
   elseif nargin == 3
       r = unidrnd(a,b);
   elseif nargin == 4
       r = unidrnd(a,b,c);
   else
      error('UNIDRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'unif')  | strcmp(deblank(name),'Uniform'),  
      if nargin == 3
       r = unifrnd(a,b);
   elseif nargin == 4
       r = unifrnd(a,b,c);
   elseif nargin == 5
       r = unifrnd(a,b,c,d);
   else
      error('UNIFRND called with incorrect number of inputs.');
   end 
elseif strcmp(deblank(name),'weib') | strcmp(deblank(name),'Weibull')  
      if nargin == 3
       r = weibrnd(a,b);
   elseif nargin == 4
       r = weibrnd(a,b,c);
   elseif nargin == 5
       r = weibrnd(a,b,c,d);
   else
      error('WEIBRND called with incorrect number of inputs.');
   end 
else   
    error('Sorry, the Statistics Toolbox does not support this distribution.'); 
end
