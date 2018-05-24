function [y,e,S] = adaptkalman(x,d,S)
%ADAPTKALMAN  Discrete-time Kalman filter.
%   Y = ADAPTKALMAN(X,D,S) applies a Kalman adaptive filter to the data 
%   vector X and the desired signal D. The filtered data is returned in Y.  
%   S is a structure that contains the Kalman filter information:
%
%   S.coeffs      - Kalman adaptive filter coefficients. 
%                   Should be initialized with the initial values for the
%                   FIR filter coefficients. Updated coefficients are
%                   returned if S is an output argument.
%   S.errcov      - The state error covariance matrix. 
%                   Should be initialized with the initial error state
%                   covariance matrix. Updated matrix is returned if S is 
%                   an output argument.
%   S.measvar     - Measurement noise variance. 
%   S.procov      - Process noise covariance. 
%   S.states      - States of the FIR filter. Optional field.
%                   If omitted, Defaults to a zero vector of length equal to  
%                   the filter order.
%   S.gain        - Kalman gain vector. Not required, but computed and returned 
%                   after every iteration.
%   S.iter        - Total number of iterations in adaptive filter run. Should
%                   not be initialized by the user.
%
%   [Y,E]   = ADAPTKALMAN(...) also returns the prediction error E.
%
%   [Y,E,S] = ADAPTKALMAN(...) returns the updated structure S.
%
%   In an application where the intermediate states are important, the function
%   can be called in a 'sample by sample mode' using a for loop.
%
%   for N = 1:length(X)
%       [Y(N),E(N),S] = ADAPTKALMAN(X(N),D(N),S);
%       % States (The fields of S) here may be modified here. 
%   end
% 
%   A More detailed example is presented in the end.
%
%   In lieu of assigning the structure fields manually, the INITKALMAN function  
%   can be called to populate the structure S.
%
%   EXAMPLE: System Identification for a 32nd length FIR filter (500 iterations).
%      x  = 0.1*randn(1,500); % Input to the filter
%      b  = fir1(31,0.5);     % FIR system to tbe identified
%      d  = filter(b,1,x);    % Desired signal
%      w0 = zeros(1,32);      % Initial filter coefficients
%      K0 = 0.5*eye(32);      % Initial state error correlation matrix
%      Qm = 2;                % Measurement noise covariance
%      Qp = 0.1*eye(32);      % Process noise covariance  
%      S = initkalman(w0,K0,Qm,Qp);
%      [y,e,S] = adaptkalman(x,d,S);
%      stem([b.',S.coeffs.']);
%      legend('Actual','Estimated');
%      title('System Identification of an FIR filter via Kalman filter');grid on;
%
%   See also INITKALMAN

%   References: 
%     [1] S. Haykin, "Adaptive Filter Theory", 3rd Edition,
%         Prentice Hall, N.J., 1996.
%     [2] A. H. Sayed and T. Kailath, "A state-space approach to RLS
%         adaptive filtering". IEEE Signal Processing Magazine, 
%         July 1994. pp. 18-60.  
%
%   Author(s): A. Ramasubramanian
%   Copyright 1999-2013 The MathWorks, Inc.

[S] = parse_inputs(x,d,S);

% Call adaptive FIR filter
[y,e,S] = adaptfirfilt(x,d,S,@updatekalman);


%--------------------------------------------------------------------------
function [S] = parse_inputs(x,d,S)

if ~isequal(length(x),length(d))
    error(message('dsp:adaptkalman:InvalidDimensions1'));
    return;
end

% Check if first iteration and do some parsing and error checking.
if ~isfield(S,'iter'),
    % Check if coeffs are initialized.
    if ~isfield(S,'coeffs')
        error(message('dsp:adaptkalman:InvalidDimensions2'));
        return; 
    end
    
    % Check if FIR filter initial conditions are specified.
    if ~isfield(S,'states')
        S.states = zeros(length(S.coeffs)-1,1);
    end
    % Make sure that FIR filter initial conditions are of correct length.
    if ~isequal(length(S.states),length(S.coeffs)-1),
       error(message('dsp:adaptkalman:InvalidDimensions3'));
       return;     
    end
    
    % Check if the state error covariance matrix is specified.
    if ~isfield(S,'errcov')
        error(message('dsp:adaptkalman:InvalidParam1'));
        return;
    end
    % Make sure that the initial state error covariance matrix 
    % is of right order.
    [M,N] = size(S.errcov);
    if ~isequal(M,N,length(S.coeffs))
       error(message('dsp:adaptkalman:InvalidDimensions4'));
        return;        
    end
    
    % Check if the measurement noise vriance is specified.
    if ~isfield(S,'measvar')
        error(message('dsp:adaptkalman:InvalidParam2'));
        return;
    end
    
    % Check if measurement noise variance is scalar.
    if ~(isnumeric(S.measvar) && length(S.measvar)==1)
        error(message('dsp:adaptkalman:InvalidParam3'));
        return;
    end
    
    % Check if process noise covariance is specified.
    if ~isfield(S,'procov')
        error(message('dsp:adaptkalman:InvalidParam4'));
        return;
    end

    % Check if process noise covariance matrix is of right order.
    [Mp,Np] = size(S.procov);
    if ~isequal(Mp,Np,length(S.coeffs))
        error(message('dsp:adaptkalman:InvalidDimensions5'));
        return;        
    end
    
    % Check if initial state error covariance matrix is hermitian symmeteric.
    if ~isequal(S.errcov,S.errcov')
        error(message('dsp:adaptkalman:CovMatrixNotSymmetric'));
        return;
    end

    
    % Complete structure assignment.
    S.iter = 0;  % Initialize iteration count.
    S.gain = []; % Will be assigned during the first iteration
    
end

% [EOF]
