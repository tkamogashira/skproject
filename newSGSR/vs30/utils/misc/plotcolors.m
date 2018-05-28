function pc = plotcolors(ii);
% plotcolors - plotcolors as Nx3 matrix
pc = [0 0 1; 1 0 0; 0 1 0; 0 0 0; 1 1 0; 0 1 1; 1 0 1];
pc = repmat(pc,10,1);
if nargin>0,
   pc = pc(1+mod(ii-1, 7),:);
end