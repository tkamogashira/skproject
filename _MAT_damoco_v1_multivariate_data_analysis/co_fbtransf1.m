function [phi,arg,sigma] = co_fbtransf1(theta,nfft,alpha,ngrid)
% DAMOCO Toolbox, function CO_FBTRANSF1, version 17.01.11
% Fourier series based transformation 
% protophase theta --> phase phi for one oscillator.
%
% Form of call:  co_fbtransf1(theta,nfft,alpha,ngrid); 
%                co_fbtransf1(theta,nfft,alpha); 
%                co_fbtransf1(theta,nfft)
%                co_fbtransf1(theta)
% Input parameters:  
%                theta is the protophase
%                nfft: max number of Fourier harmonics, 
%                      default value is 80
%                alpha: smoothing coefficient, by default alpha=0.05
% Output:  phi = co_fbtransf1(...) if only transformation is required.
% Output:  [phi,arg,sigma] = co_fbtransf1(...) if also the transformation
%          function sigma is required; it can be plotted as
%          plot(arg,sigma); sigma is computed on the grid.
%          Default grid size is 50.
if nargin < 4, ngrid=50; end
if nargin < 3, alpha=0.05; end
if nargin < 2, nfft=80; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spl=zeros(nfft,1);  % Fourier coefficients 1,...,nfft
al2=alpha*alpha; 

npt=length(theta);
for k=1:nfft        % computing Fourier coefficients
 Spl(k)=sum(exp(-1i*k*theta))/npt;
end

phi=theta;     % Transformation theta --> phi
if nargout==3  % sigma is computed along with the transformation
  arg=0:(ngrid-1); arg=arg*pi*2/(ngrid-1); arg=arg';
  sigma=ones(ngrid,1);
  for k=1:nfft
      kernel=exp(-0.5*k*k*al2); 
      sigma=sigma + kernel*2*real(Spl(k)*exp(1i*k*arg));
      phi=phi+kernel*2*imag(Spl(k)*(exp(1i*k*theta)-1)/k);
  end
else           % only transformation is required
    for k=1:nfft
      phi=phi+exp(-0.5*k*k*al2)*2*imag(Spl(k)*(exp(1i*k*theta)-1)/k);
    end
end      
end
