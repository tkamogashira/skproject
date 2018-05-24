function idx = MakeIdx(Bgn, End)
%MAKEIDX    make index vector from limits
%   MAKEIDX(Bgn, End) creates an index vector from the
%   vectors Bgn and End. Bgn and End are vectors containing
%   low and high indices of segments to be addressed.
%
%   MAKEIDX returns the vector [Bgn(1):End(1), Bgn(2):End(2), ...
%   Bgn(end):End(end)].

%B. Van de Sande 15-06-2004

if (nargin ~= 2), error('Wrong number of input arguments.'); end
if any(fix(Bgn) ~= Bgn) | any(fix(End) ~= End), error('Bgn and End must contain integers.'); end
if ~isequal(length(Bgn), length(End)), error('Bgn and End must have same length.'); end
if any((End-Bgn) < 0), error('Bgn elements must be less than End.'); end

N = length(Bgn);

Run  = End-Bgn+1;   %Length of each run ...
Last = cumsum(Run); %Last index of each run ...

idx = ones(1, Last(end)); %Preallocate space ...
idx(1) = Bgn(1);          %Poke in first value ...
idx(1+Last(1:end-1)) = Bgn(2:N)-End(1:N-1); %Poke in jumps ...
idx = cumsum(idx);