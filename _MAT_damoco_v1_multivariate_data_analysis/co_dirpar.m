function dirin=co_dirpar(Fcoef1, Fcoef2)
% DAMOCO Toolbox, function CO_DIRPAR, version 17.01.11
% Given the protophases theta1, theta2, this functions 
% returns the directionality index dirin, computed via 
% the partial derivatives of the coupling function with 
% respect to the external protophase.
% 
% Form of call:     dirin=co_dirpar(Fcoef1, Fcoef2)
%                  
% Input:
%       Fcoef1, Fcoef2:  Fourier coefficients for the model of phase
%                        dynamics for both systems
% Output:
%       dirin:           directionality index
%
S=size(Fcoef1); or=(S(1)-1)/2;
NP1=0;
NP2=0;
for n= -or : or;
    for m= -or : or;
        NP1 = NP1 + abs(1i*m*Fcoef1(n+or+1,m+or+1))^2;
        NP2 = NP2 + abs(1i*m*Fcoef2(n+or+1,m+or+1))^2;
    end;
end;
nrm1=sqrt(NP1);
nrm2=sqrt(NP2);
if nrm1+nrm2 < 0.02
    disp('Warning: the coupling is very weak or the systems are not coupled!');
    disp('Result on directionality index may be not reliable');
end
dirin= (nrm1 - nrm2) / (nrm1 + nrm2);
end
