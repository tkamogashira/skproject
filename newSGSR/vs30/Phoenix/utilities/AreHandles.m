function [ah, h] = AreHandles(h);
% AreHandles - true if one or more valid handles.
%   AreHandles(h) returns true if all elements of h are valid handles.
%   If h is empty, false is returned by convention.
%   This function serves to circumvent the ackward logical
%   behavior of [].
%
%   [yesno, h] = AreHandles(h) also returns h the "purged" version of
%   h, containing only those values that are valid handles.
%
%   See also IsOneHandle.

ah = 0; % pessimist default
if numel(h)>=1,
   ah = all(ishandle(h));
end

if nargout>1,
   if ~isempty(h),
      h = h(find(ishandle(h)));
   end
end




