function RI = RandomInt(Nmax, varargin);
% RandomInt - random integer array
%   RandomInt(Nmax) returns an random integer between 1 and Nmax. 
%  
%   RandomInt(Nmax, [N M]) is an NxM matrix random integer
%   with entries between 1 and Nmax. To obtain higher-dimensional arrays, 
%   use RandomInt(Nmax, [dim1 dim2 dim3 ..]) or, equivalently,
%   RandomInt(Nmax, dim1, dim2, dim3..)
%
%   Note that RandomInt calls RAND and therefore changes RAND's state.
%
%   See also RAND, SetRandState.


RI = ceil(Nmax*(rand(varargin{:})));


