function [q1,q2,omeg1,omeg2,Nrmq1,Nrmq2,sigma1,sigma2]=...
    co_itersolv(f1,f2,niter,showiter)
% DAMOCO Toolbox, function CO_ITERSOLV, version 17.01.11
% Given two coupling functions of the protophases, computed on the grid,
% this function returns frequencies and true coupling functions of phases. 
%
% Form of call: 
%         [q1,q2,omeg1,omeg2,Nrmq1,Nrmq2,sigma1,sigma2]=
%                         co_itersolv(f1,f2,niter,showiter)
% Input:  f1(theta1,theta2) and f2(theta2,theta1) are coupling
%         functions in terms of protophases;
%         niter: number of iterations for solving equations for sigma, omega
%         showiter: results of iterations are shown if showiter > 0 .
% Output: q1(phi1,phi2) and q2(phi2,phi1) are coupling functions
%         in terms of phases.
% All functions are computed on the grid.
%
ngrid=max(size(f1)); ng1=ngrid-1;
pi2=pi+pi; dth=pi2/ng1;  % integration step
sigma1=ones(ngrid,1); sigma2=ones(ngrid,1); % initial values for 
%                                             transformation functions 

for i=1:niter
    sig1int=zeros(ngrid,1); sig2int=zeros(ngrid,1); % integrals in Eq.~(A1)
    for n=1:ngrid        % f1=f1(theta1,theta2),   f2=f2(theta2,theta1)
        sig1int(n)=dth*trapz(sigma1.*f2(n,:)');  % sig1int is a function of theta2 
        sig2int(n)=dth*trapz(sigma2.*f1(n,:)');  % sig2int is a function of theta1 
    end
    omeg1 = 1 / (trapz(1./sig2int) * dth);
    omeg2 = 1 / (trapz(1./sig1int) * dth);
    sigma1=(pi2*omeg1)./sig2int;
    sigma2=(pi2*omeg2)./sig1int;
    if showiter>0
        disp(['iteration ' num2str(i) ': omega1=' num2str(omeg1)...
            ' omega2=' num2str(omeg2)]);
        %disp(['For check: integral of sigma1/2pi = ' num2str(trapz(0:pi2/(ngrid-1):pi2,sigma1)/pi2)]);
        %disp(['For check: integral of sigma2/2pi = ' num2str(trapz(0:pi2/(ngrid-1):pi2,sigma2)/pi2)]);
    end
end    
for n=1:ngrid   % Chain rule: dphi/dt = dphi/dtheta*dtheta/dt=sigma*dtheta/dt
    for m=1:ngrid    
        f1(n,m)=sigma1(n)*f1(n,m);  
        f2(n,m)=sigma2(n)*f2(n,m);   
    end
end
% True phases, corresponding to the theta points on the regular grid;
% the phi points are on irregular grid!
phi1=cumtrapz(sigma1)*dth; phi2=cumtrapz(sigma2)*dth;

next=5;  % extending both irregularly spaced phases using periodicity
[phi1ext,f1ext]=extmatr(f1,phi1,ngrid,next,ng1); % Extending both f1,f2 
[phi2ext,f2ext]=extmatr(f2,phi2,ngrid,next,ng1); % functions using periodicity

[m1,m2]=meshgrid(phi1ext,phi2ext);          % irregular grid, where the function is given      
phireg=(0:ngrid-1).*dth;                    % regular grid of phi where the function should be computed
[xi,yi]=meshgrid(phireg,phireg);

%q1 = interp2(m1, m2, f1ext, xi, yi,'linear');  % True functions obtained via interpolation to regular grid
%q2 = interp2(m1, m2, f2ext, xi, yi,'linear');
q1 = interp2(m1, m2, f1ext, xi, yi,'spline');  % True functions obtained via interpolation to regular grid
q2 = interp2(m1, m2, f2ext, xi, yi,'spline');
%q1 = interp2(m1, m2, f1ext, xi, yi);  % True functions obtained via interpolation to regular grid
%q2 = interp2(m1, m2, f2ext, xi, yi);
% 
% norm of the functions
Nrmq1=sqrt(trapz(trapz((q1(1:end-1)-omeg1).^2)))/(ngrid-1);
Nrmq2=sqrt(trapz(trapz((q2(1:end-1)-omeg2).^2)))/(ngrid-1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [phiext,fext]=extmatr(f,phi,ngrid,next,ng1)
%
pi2=pi+pi;
%
phiext=[zeros(1,next) phi' zeros(1,next)];
phiext(1:next)=phi(end-next:end-1)-pi2;
phiext(end-next+1:end)=phi(2:next+1)+pi2;
%
% period is ng1
%
grext=ngrid+2*next;
fext=zeros(grext,grext); 
fext(next+1:next+ngrid,next+1:next+ngrid)=f;               % copy center
fext(1:next,1:next)=fext(1+ng1:next+ng1,1+ng1:next+ng1);   % left down corner
fext(1:next,1+next+ngrid:grext)=fext(1+ng1:next+ng1,1+next+ngrid-ng1:grext-ng1); % left upper corner
fext(1:next,1+next:next+ngrid)=fext(1+ng1:next+ng1,1+next:next+ngrid);   % rest of the left side
fext(1+next+ngrid:grext,1+next:next+ngrid)=...
    fext(1+next+ngrid-ng1:grext-ng1,1+next:next+ngrid);   % left side to right
fext(next:next+ngrid,1:next)=fext(next:next+ngrid,1+ng1:next+ng1); % center down
fext(next:next+ngrid,1+next+ngrid:grext)=...
    fext(next:next+ngrid,1+next+ngrid-ng1:grext-ng1); % center up
end
