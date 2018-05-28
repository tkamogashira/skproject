function ih = isOneHandle(h);
% isOneHandle - true if a single valid handle.
%   isOneHandle(h) returns true if h is a single valid handle.
%   If h is empty, false is returned by convention.
%   This function serves to circumvent the ackward logical
%   behavior of [].
%
%   See also AreHandles.

ih = 0; % pessimist default
if numel(h)==1,
   ih = ishandle(h);
end





