function [Fcoef,f]=co_fexp1(theta1,theta2,or,safr,ngrid)
% DAMOCO Toolbox, function CO_FEXP1, version 17.01.11
% Given two protophases, the function yields the coupling 
% function f(theta1,theta2) via fitting a Fouriers series. 
%
% Form of call: 
%          [Fcoef,f]=co_fexp1(theta1,theta2,or,safr,ngrid)
%          [Fcoef]=co_fexp1(theta1,theta2,or,safr,ngrid)
%          [Fcoef]=co_fexp1(theta1,theta2,or,safr) 
% Input:   theta1: protophase of the 1st system,
%          theta2: protophase of the 2nd system ('external'),
%          or:     maximal order of Fourier expansion,
%          safr:   sampling frequency,
%          ngrid:  size of the grid for function computation,
%                  by default ngrid =  100
% Output:  Fcoeff are Fourier coefficients of the coupling function
%          f is the function itself, computed on a grid
%
theta1 = unwrap(theta1);    theta2 = unwrap(theta2);
A = zeros(4*or+1, 4*or*1);                          % This matrix contains the coefficients A(n+k),(m+l) for the linear system of 
                                                    % equations to obtain the coefficients Fn,m. 
or2=2*or;  or21=or2+1; or1=or+1;
Dtheta1 = safr*( theta1(3:end)-theta1(1:end-2) )/2; % Derivative of theta1
% Elimination of the first and last points
theta1=theta1(2:end-1);  theta2=theta2(2:end-1); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Computing the coefficients of the matrix A using symmetries of the cofficients 
for n = -or2 : or2
    for m = -or2 : n
        A(n+or21, m+or21) =  mean(exp(1i*(n*theta1 + m*theta2) ));
        A(-n+or21, -m+or21)=conj(A(n+or21, m+or21));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   Computing the coefficients of the matrices Bnm
B = zeros(or21*or21);    % This vector contains the coefficients Bn,m for the linear system of equations to
                         % obtain the coefficients Fn,m  
C = B;                   % The elements of the matrix A are reorganized in C to match the requirements of the 
                         % MATLAB function to solve systems of lineare equations
ind=1; 
for n = -or : or
    i1_1=(n+or)*or21; 
    for m = -or : or
        i1=i1_1+m+or1; i4=m+or21;
        B(ind)= mean(Dtheta1.* exp(-1i*( n*theta1 + m*theta2) ));
        ind=ind+1;
        for r = -or : or
            i3=(r+or)*or21 +or1; i2=(n-r)+or21;
            for s = -or : or                  %  Elements of the matrix A are reorganized in C
                C(i1,i3 + s) = A(i2,i4-s);                                                      
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%       Solving the system of linear equations to obtain the coefficients Fnm
fc = conj(C) \ B;       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%         Reorganizing the Fourier cofficients fc in the matrix Fcoef
Fcoef=zeros(or21,or21);
for n = 0 : or2
    for m = 0 : or2
        Fcoef(n+1, m+1)=fc(n*or21 + m+1);    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%       Computing the coupling function f on a grid, if required
if nargout==2;
    if nargin ==4; ngrid=100; end;
    [Y,X]=meshgrid(2*pi*(0:ngrid-1)/(ngrid-1),2*pi*(0:ngrid-1)/(ngrid-1));    
    f=zeros(ngrid,ngrid);
    for n = -or : or
        for m = -or : n
            f = f + 2*real( Fcoef(n+or1, m+or1) * exp(1i*n*X + 1i*m*Y));      
        end
    end
    f = f-real(Fcoef(or1,or1));  % Fcoef(0,0) was added twice in the loop  
end       
end
