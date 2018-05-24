function ph=cunwrap(ph, varargin)
% cunwrap - unwrap phase data expressed in cycles
%    cunwrap(Ph, ..) unwraps a phase vector Ph that is expressed in
%    cycles instead of radians. Any trailing input args are passed to
%    unwrap. Any NaN elements in Ph are ignored in the unwrapping process
%    and are returned unchanged.
%   
%    See also unwrap, ucunwrap, cangle, DelayPhase.

% delegate the work to unwrap


phnan = nan(size(ph)); % nan template
% remove nans
[ph, iok] = denan(ph);
% delegate unwrapping work to unwrap
ph = unwrap(2*pi*ph,varargin{:})/2/pi;
% re-insert nans
phnan(iok) = ph;
ph = phnan;


