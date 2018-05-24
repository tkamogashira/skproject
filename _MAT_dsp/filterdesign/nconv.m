function y = nconv(b, N)
%NCONV Performs Nth-order convolution of the input vector.
%   Y = NCONV(B,N) convolves N-times the vector B by itself.
%
%   Inputs:
%     B    - Input vector
%     N    - Number of convolutions
%   Outputs:
%     Y    - Output vector
%
%   Example:
%        b = rand(1,4);
%        c = nconv(b, 3);
%
%   See also IIRFTRANSF and ZPKFTRANSF.

%   Author(s): Dr. Artur Krukowski, University of Westminster, London, UK.
%   Copyright 1999-2002 The MathWorks, Inc.

% --------------------------------------------------------------------
% Perform the parameter validity check

error(nargchk(1,2,nargin,'struct'));
ftransfargchk(b, 'Input vector', 'vector');

if nargin == 2,
   ftransfargchk(N, 'Parameter N', 'real', 'positive', 'int', 'scalar');
else
   N = 1;
end;


% ---------------------------------------------------------------------
% Calculate the mapping filter

if N == 0,

   y = 1.0;

else

   y = b;
   if N > 1
      for i=1:N-1, y = conv(y, b); end;
   end;

end;
