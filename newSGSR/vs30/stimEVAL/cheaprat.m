function [d, n, rtol] = cheaprat(x, tol);
% cheaprat - more efficient rational approx than MatLab rat
%   cheaprat used using lower integers to approximate x as an integer fraction
%    within tolerance tol.
%    Also, cheaprat tries to fix the buggy behavior of rat; try rat(2/35,0.01)
%    function [d n rdev] = myrat(x, tol);
%    rdev = abs((x - d/n)/x), i.e., the relative error.

% cheaprat is slow - it may help to store previous values
persistent oldX oldTol oldD oldN;
if x==0, % clear old values to prevent overflow
   oldX = []; oldTol = []; oldD = []; oldN = [];
   d = 0; n = 1; rtol=0;
   return;
end

if ~isempty(oldX), % look if same thing has been asked before
   ii = find(oldX==x);
   if ~isempty(ii),
      jj = find(oldTol(ii)==tol);
      if ~isempty(jj),
         % disp(['tjakka! ' num2str(ii(jj))]);
         n = oldN(ii(jj));
         d = oldD(ii(jj));
         rtol = abs((x-d/n)/x);
         return;
      end
   end
end

[d n] = rat(x, tol);
rtol = abs(x-d./n)./abs(x);
trytol = tol;
while rtol<tol,
   trytol = trytol*2;
   [d n] = rat(x, trytol);
   rtol = abs(x-d./n)./abs(x);
   if trytol>1, break; end;
end
while rtol>tol,
   trytol = trytol/2;
   [d n] = rat(x, trytol);
   rtol = abs(x-d./n)./abs(x);
   if trytol<1e-11, break; end;
end

% store values for recycling
oldX = [oldX x];
oldTol = [oldTol tol];
oldD = [oldD d];
oldN = [oldN n];
% prevent cumulation of old values
if length(oldX)==2e3,
   oldX(1:500) = [];
   oldTol(1:500) = [];
   oldD(1:500) = [];
   oldN(1:500) = [];
end



