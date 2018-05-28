function [Nx, Ny, PC] = FactorsForSubPlot(N,XoverY);
% FactorsForSubPlot - find factors of a number for subplot division

if nargin<2, 
   XoverY=448/300;
end

Nxx = (N*XoverY)^0.5;
Nyy = (N/XoverY)^0.5;

minNx = max(1,round(Nxx*0.75));
minNy = max(1,round(Nyy*0.75));
maxNx = max(1,round(Nxx*1.25));
maxNy = max(1,round(Nyy*1.25));
tryNx = minNx:maxNx;
tryNy = minNy:maxNy;
NNx = length(tryNx);
NNy = length(tryNy);
empties = inf + zeros(NNx,NNy);
bkx = zeros(NNx,NNy);
bky = zeros(NNx,NNy);
for ix=1:NNx,
   for iy=1:NNy,
      empties(ix,iy) = local_rem(tryNx(ix),tryNy(iy),N);
      bkx(ix,iy) = ix;
      bky(ix,iy) = iy;
   end
end
[mm index] = min(empties(:).');
bkx = bkx(:).';
bky = bky(:).';
ix = bkx(index);
iy = bky(index);
Nx = tryNx(ix);
Ny = tryNy(iy);

PC = zeros(N,2);
for ii=1:Nx*Ny,
   PC(ii,1) = 1+rem(ii-1,Nx);
   PC(ii,2) = 1+floor((ii-1)/Nx);
end



%-------
function  rr=local_rem(Nx,Ny,N);
rr = Nx*Ny-N;
if rr<0, rr = inf; end;

