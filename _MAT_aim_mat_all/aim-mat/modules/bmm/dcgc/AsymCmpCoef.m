%
%  Asymmetric Compensation Coefficients of the IIR gammachirp
%  Toshio Irino
%  14 Apr. 99
%
%  Edit this file for consistensy since these values would change. 
%  MakeAsymCmpFilters.m  AsymCmpFrsp.m
%   
%  function [coef_r, coef_th, coef_fn, coef0] = AsymCmpCoef(c,coef0,NumFilt),
%  INPUT   c: array of c values
%          coef0: vector of 6 coefficients.
%          NumFilt: default 4   
%  OUTPUT  coef_r : coefficients for r
%          coef_th: coefficients for th
%          coef_fn: coefficients for fn
%   
function [coef_r, coef_th, coef_fn, coef0] = AsymCmpCoef(c,coef0,NumFilt),

if nargin < 2 | length(coef0) == 0,  % default
%  coef0 = [1.35, -0.19, 0.292, -0.004, 0.058, 0.0018]; 
%  coef0 = [1.35, -0.19, 0.292, -0.004, 0.058*4, 0.0018*4]; % n compensation 
  coef0 = [1.35, -0.19, 0.29, -0.0040, 0.23, 0.0072]; % n compensation 
end;
if nargin < 3, NumFilt = 4; end;

c = c(:);
NumCh = length(c);
coef_r  = zeros(NumCh,NumFilt); 
coef_th = zeros(NumCh,NumFilt); 
coef_fn = zeros(NumCh,NumFilt);

for Nfilt = 1:NumFilt,
  coef_r(1:NumCh,Nfilt)  = (coef0(1) + coef0(2)*abs(c)) * Nfilt;
  coef_th(1:NumCh,Nfilt) = (coef0(3) + coef0(4)*abs(c)) * 2^(Nfilt-1);
  coef_fn(1:NumCh,Nfilt) = (coef0(5) + coef0(6)*abs(c)) * Nfilt;
end;






