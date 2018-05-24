%FILTER Execute ("run") multirate filter.
%   Y = FILTER(Hm,X) filters the data X using the multirate filter
%   object Hm to create the filtered data Y. The final conditions are
%   stored in Hm.States.
%
%   If Hm.PersistentMemory is false (default), initial conditions
%   are set to zero before filtering. 
%
%   To use non-zero initial conditions, set Hm.PersistentMemory to true
%   and set Hm.States  with a vector of NSTATES(Hm) elements. If a scalar
%   is specified, it will be expanded to a vector of the correct length. 
%
%   If X is a matrix, each column is filtered as an independent channel. In
%   this case, initial conditions can be optionally specified for each
%   channel individually by setting Hm.States to a matrix of NSTATES(Hm)
%   rows and SIZE(X,2) columns.  If X is a multidimensional array, filter
%   operates on the first nonsingleton dimension.
%
%   FILTER(Hd,X,DIM) operates along the dimension DIM. If X is a vector or 
%   matrix and DIM is 1, every column of X is treated as a channel. If DIM
%   is 2, every row represents a channel.
%    
%   EXAMPLE:
%     Fs = 44.1e3;             % Original sampling frequency: 44.1kHz
%     n = [0:10239].';         % 10240 samples, 0.232 second long signal
%     x  = sin(2*pi*1e3/Fs*n); % Original signal, sinusoid at 1kHz
%     M = 2;                   % Decimation factor
%     Hm = mfilt.firdecim(M);  % We use the default filter
%
%     % No initial conditions
%     y1 = filter(Hm,x);       % PersistentMemory is false (default)
%     zf = Hm.States;          % Final conditions
%   
%     % Non-zero initial conditions
%     Hm.PersistentMemory = true;
%     Hm.States = 1;           % Uses scalar expansion
%     y2 = filter(Hm,x);
%     stem([y1(1:60) y2(1:60)])% Different sequences at the beginning
% 
%     % Streaming data
%     reset(Hm);               % Clear filter history
%     y3 = filter(Hm,x);       % Filter the entire signal in one block
%     reset(Hm);               % Clear filter history
%     yloop = [];
%     xblock = reshape(x,[2048 5]);
%     % Filtering the signal section by section is equivalent to filtering the
%     % entire signal at once.
%     for i=1:5,
%       yloop = [yloop; filter(Hm,xblock(:,i))];
%     end
% 
%   See also MFILT/NSTATES

%   Author: V. Pellissier
%   Copyright 1999-2006 The MathWorks, Inc.

% Help for the MFILT filter method.

% [EOF]
