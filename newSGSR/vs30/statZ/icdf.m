function x = icdf(name,p,a,b,c)
%ICDF   Computes a chosen inverse cumulative distribution function.
%   X = ICDF(NAME,P,A) returns the named inverse cumulative distribution
%   function, which uses parameter A, at the the values in X.
%   X = ICDF(NAME,P,A,B) returns the named cumulative distribution
%   function, which uses parameters A and B, at the the values in X.
%   Similarly for X = ICDF(NAME,P,A,B,C).
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
%   ICDF calls many specialized routines that do the calculations. 

%   D. Zwillinger 3-91, B. Jones 10-92
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.4 $  $Date: 1997/11/29 01:45:42 $

if nargin<2, error('Not enough input arguments'); end

if ~isstr(name), error('First argument must be distribution name'); end

if nargin<5, d=0; end 
if nargin<4, c=0; end 
if nargin<3, b=0; end 

if     strcmp(name,'beta') | strcmp(name,'Beta'),  
    x = betainv(p,a,b);
elseif strcmp(name,'bino') | strcmp(name,'Binomial'),  
    x = binoinv(p,a,b);
elseif strcmp(name,'chi2') | strcmp(name,'Chisquare'), 
    x = chi2inv(p,a);
elseif strcmp(name,'exp') | strcmp(name,'Exponential'),   
    x = expinv(p,a);
elseif strcmp(name,'f') | strcmp(name,'F'),     
    x = finv(p,a,b);
elseif strcmp(name,'gam') | strcmp(name,'Gamma'),   
    x = gaminv(p,a,b);
elseif strcmp(name,'geo') | strcmp(name,'Geometric'),   
    x = geoinv(p,a);
elseif strcmp(name,'hyge') | strcmp(name,'Hypergeometric'),  
    x = hygeinv(p,a,b,c);
elseif strcmp(name,'logn') | strcmp(name,'Lognormal'),
    x = logninv(p,a,b);
elseif strcmp(name,'nbin') | strcmp(name,'Negative Binomial'), 
   x = nbininv(p,a,b);    
elseif strcmp(name,'ncf') | strcmp(name,'Noncentral F'),
    x = ncfinv(p,a,b,c);
elseif strcmp(name,'nct') | strcmp(name,'Noncentral T'),  
    x = nctinv(p,a,b);
elseif strcmp(name,'ncx2') | strcmp(name,'Noncentral Chi-square'), 
    x = ncx2inv(p,a,b);
elseif strcmp(name,'norm') | strcmp(name,'Normal'), 
    x = norminv(p,a,b);
elseif strcmp(name,'poiss') | strcmp(name,'Poisson'),
    x = poissinv(p,a);
elseif strcmp(name,'rayl') | strcmp(name,'Rayleigh'),
    x = raylinv(p,a);
elseif strcmp(name,'t') | strcmp(name,'T'),     
    x = tinv(p,a);
elseif strcmp(name,'unid') | strcmp(name,'Discrete Uniform'),  
    x = unidinv(p,a);
elseif strcmp(name,'unif')  | strcmp(name,'Uniform'),  
    x = unifinv(p,a,b);
elseif strcmp(name,'weib') | strcmp(name,'Weibull'),  
    x = weibinv(p,a,b);
else   
error('Sorry, the statistics toolbox does not support this distribution.'); 
end 
