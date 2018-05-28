function [pos, hit] = rwalk(x0, N, Xabs, Xref, p_up);
% rwalk - simulation of random walk.
%   rwalk(x0, N, Xref, Xabs);

if nargin<5, p_up=0.5; end % unbiased random walk

% convert x positions to 1-based # steps from Xabs(1)
iabs(1) = 1;
iabs(2) = 1+Xabs(2)-Xabs(1);
i0 = 1-Xabs(1);
iref = 1+Xref-Xabs(1);
% prob to step up
% increase up-prob when approoaching reflector wall
Pup(iabs(1):iabs(2)) = linspace(1,p_up, iabs(2)-iabs(1)+1); 
Pup(iabs(2):iref) = p_up; % constant prob
% fill position history with all initial positions
pos = i0*ones(1,N);

qq = rand(1,N); % random numbers determining the fate of the walker
hit = [];
% now take steps
for istep=1:N-1,
   pup = Pup(pos(istep));
   if (qq(istep)<pup),
      pos(istep+1) = pos(istep) + 1; 
   else,
      pos(istep+1) = pos(istep) - 1; 
   end
   if pos(istep+1)==iref,
      hit = [hit istep];
      % reset pos
      pos(istep+1) = i0;
   end
end

% revert positions to true pos
pos = pos - i0;

