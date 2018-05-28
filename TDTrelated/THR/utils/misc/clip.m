function x = Clip(x, xmin, xmax);
% CLIP - clip values between a min and a max value
%    Clip(X, Xmin, Xmax) clips the elements of array X between the values 
%    Xmin and Xmax.
%
%    Clip(X, Xmin) is equivalent to Clip(X, Xmin, inf).
%
%    See also BETWIXT.

if nargin<3, xmax=inf; end;

if xmin>xmax,
    error('Lower limit Xmin exceeds upper limit Xmax.')
end

low = find(x<xmin);
high = find(x>xmax);
if ~isempty(low), x(low) = xmin; end;
if ~isempty(high), x(high) = xmax; end;
