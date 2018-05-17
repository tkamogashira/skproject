function [Fcoef1, Fcoef2, f1, f2]=co_fexp2(theta1,theta2,or,safr,ngrid)
% DAMOCO Toolbox, function CO_FEXP2, version 17.01.11
% Given two protophases, the function yields the coupling functions 
% f1(theta1,theta2) and f2(theta2,theta1) via fitting a Fourier series. 
%
% Form of call: 
%          [Fcoef1,Fcoef2,f1,f2]=co_fexp2(theta1,theta2,or,safr,ngrid)
%          [Fcoef1,Fcoef2]=co_fexp2(theta1,theta2,or,safr,ngrid)
%          [Fcoef1,Fcoef2]=co_fexp2(theta1,theta2,or,safr) 
% Input:   theta1: protophase of the 1st system,
%          theta2: protophase of the 2nd system ('external'),
%          or:     maximal order of Fourier expansion,
%          safr:   sampling frequency,
%          ngrid:  size of the grid for function computation, 
%                  by default ngrid =  100
% Output:  Fcoef1,Fcoef2 are Fourier coefficients of the coupling functions
%          f1,f2 are the functions, computed on a grid                
%          
theta1 = unwrap(theta1);    theta2 = unwrap(theta2);
A = zeros(4*or+1, 4*or*1);                          % This matrix contains the coefficients A(n+k),(m+l) 
                                                    % for the linear system of equations for the coefficients Fn,m. 
or2=2*or;  or21=or2+1;  or1=or+1;
Dtheta1 = safr*( theta1(3:end)-theta1(1:end-2) )/2; % Derivative of theta1
Dtheta2 = safr*( theta2(3:end)-theta2(1:end-2) )/2; % Derivative of theta2
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
B1 = zeros(or21*or21);    % This vector contains the coefficients B1n,m for the linear equation system for
                          % the coefficients F2n,m of the protophase theta1
B2 = B1;                  % This vector contains the coefficients B2n,m for the linear equation system for
                          % the coefficients F1n,m of the protophase theta2                                        
C = B1;                   % The elements of the matrix A are reorganized in C to match the requirements of the 
                          % MATLAB function to solve systems of linear equations
ind=1; 
for n = -or : or
    i1_1=(n+or)*or21; 
    for m = -or : or
        i1=i1_1+m+or1; i4=m+or21;
        tmp=exp(-1i*( n*theta1 + m*theta2) );
        B1(ind)= mean(Dtheta1.* tmp);
        B2(ind)= mean(Dtheta2.* tmp);
        ind=ind+1;
        for r = -or : or
            i3=(r+or)*or21 +or1; i2=(n-r)+or21;
            for s = -or : or;     % Elements of the matrix A are reorganized in C 
                C(i1,i3 + s) = A(i2,i4-s);                                                      
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%       Solving the system of linear equations to obtain the coefficients Fnm
fc1 = conj(C) \ B1;    
fc2 = conj(C) \ B2; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%         Reorganizing the Fourier cofficients fc in the matrix Fcoef
Fcoef1 = zeros(or21,or21); Fcoef2 = Fcoef1;
for n = 1 : or21
    k=(n-1)*or21;
    for m = 1 : or21
        Fcoef1(n, m)=fc1(k+m);    
        Fcoef2(n, m)=fc2(k+m);   
    end
end
Fcoef2 = Fcoef2.';      % Reorganizing the matrix Fcoef2 to match our convention
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%       Computing the coupling functions f1,f2 on a grid, if required
if nargout == 4;
    if nargin == 4; ngrid=100; end;     %Default value
    [Y,X]=meshgrid(2*pi*(0:ngrid-1)/(ngrid-1),2*pi*(0:ngrid-1)/(ngrid-1));    
    f1 = zeros(ngrid,ngrid); f2=f1;
    for n = -or : or
        for m = -or : n
            tmp=exp(1i*n*X + 1i*m*Y);
            f1 = f1 + 2*real( Fcoef1(n+or1, m+or1) * tmp);    
            f2 = f2 + 2*real( Fcoef2(n+or1, m+or1) * tmp); 
        end
    end
    f1 = f1-real(Fcoef1(or1, or1));           % Fcoef1(0,0) was added twice in the loop
    f2 = f2-real(Fcoef2(or1, or1));           % Fcoef2(0,0) was added twice in the loop
end
end
