function [Ao, B] = StaComp(A,B, fn);
% StaComp - compare contents of two struct arrays
%   [Ao, Bo] = StaComp(A,B) , where A and B are struct arrays with the same
%   fields, returns struct array Ao containing those elements in A which
%   do not occur in B and vice versa in Bo.

if nargin<3, fn = ''; end

if isempty(fn), 
   FNS = fieldnames(A);
   fn = FNS{1};
end

fnchar = isequal('char', class(getfield(A(1), fn)));
if fnchar, 
   Bfnval = eval(['{B.' fn '}']); 
else, % assume numeric value
   Bfnval = eval(['[B.' fn ']']); 
end

[Ao, Bo] = deal([]);
ibhad = [];
for ii=1:length(A),
   ii
   Ai = A(ii);
   fnval = eval(['Ai.' fn]);
   if fnchar, ib = strmatch(fnval, Bfnval, 'exact'); 
   else, ib = find(fnval==Bfnval);
   end
   keepAi = 1; % assume that Ai is not replicated in B
   for iib=ib(:)',
      if isequal(B(iib), Ai), % forget Ai and B(iib)
         keepAi = 0;
         ibhad = [ibhad iib];
      end
   end
   if keepAi, Ao = [Ao, Ai]; end
end
B(ibhad) = [];


