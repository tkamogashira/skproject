function ie = isEnabled(h);
% ISENABLED - Test for enable property
%   ENABLED(X) returns 1 if the 'Enable' property of the object with
%   handle h is 'on', 0 otherwise.

if ~issinglehandle(h),
   error('Argument h must be single handle.')
end

ie = isequal('on', get(h,'Enable'));

