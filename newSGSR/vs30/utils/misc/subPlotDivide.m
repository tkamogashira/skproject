function [hh, NX, NY] = subPlotDivide(figh, N, xlab, XL, ylab);
% subPlotDivide - break up figure in at least N subplots and return axis handles
if nargin<3, xlab = ''; end
if nargin<4, XL = [0 1]; end
if nargin<5, ylab = ''; end
suppressYticks = (N>0);
N = abs(N);

figure(figh);
[NX NY FF] = factorsforsubplot(N);
NN = NX*NY;
for ii=1:NN,
   h = subplot(NX,NY,ii);
   xlim(h,XL);
   hh(ii) = h;
   if ii<=NN-NY, set(h, 'xticklabel', ''); 
   else, xlabel(xlab);
   end
   if suppressYticks & rem(ii,NY)~=1, 
      set(h, 'ytick', []); 
   else,
      if ~isempty(ylab),
         ylabel(ylab)
      end
   end
end

hh = hh(1:N);


