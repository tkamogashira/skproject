%% Autoscaling and Curve Fitting
% Copyright 2006-2012 The MathWorks, Inc.

%% Application and Topics Covered
% The application envisioned for this example is automatic lane tracking on a
% road. We will show how to fit a polynomial to noisy data representing the
% lane boundary of the road ahead of a vehicle.
%
% The example uses this curve fitting application to illustrate several topics,
% including:
%
% * Fitting an arbitrary-order polynomial to noisy data using implicit matrix inversion
% * Converting a floating-point model to fixed point using autoscaling
% tools
% * Reducing computation and modeling of "off-line" computations
% using invariant signals
%
% In many curve fitting applications, the objective is to estimate the
% coefficients of a low-order polynomial. The polynomial is then used as a model for
% observed noisy data. For example, if a quadratic polynomial is to be used,
% there are three coefficients (_a_, _b_ and _c_) to estimate:
% 
% $$ax^2 + bx + c$$
% 
% The polynomial that fits best is defined as the one that minimizes
% the sum of the squared errors between itself and the noisy
% data. In order to solve this least squares problem, an overdetermined linear
% system is obtained and solved. An explicit matrix inverse is not actually
% required in order to solve the system.
% 
% This example will first illustrate
% some of these points in MATLAB(R), and then move to a Simulink(R) model.

%% Signal Model for the Road
% In order to test the algorithm, a continuously curving road model is
% used: a sinusoid that is contaminated with additive noise. By varying the
% frequency of the sinusoid in the model, you can stress the
% algorithm by different amounts. The following code
% simulates noisy sensor outputs using our road model:
%
%  % Model of roadway
%  Duration = 2;        % Distance that we look ahead
%  N = 25;              % Total number of sensors providing estimates of road boundary
%  Ts = Duration / N;   % Sample interval
%  FracPeriod = 0.5;    % Fraction of period of sinusoid to match
%  % y will contain the simulated sensor outputs
%  y = sin(2*pi* [0:(N-1)]' * (FracPeriod/N)) + sqrt(0.3) * randn(N,1);
FracPeriod=0.5;
N=25;
Duration = 2;
Ts = Duration / N;
y = sin(2*pi* (0:(N-1))' * (FracPeriod/N)) + sqrt(0.2) * randn(N,1);

%% Solving a Linear System Using Matrix Factorization
% In this example, the unknowns are the coefficients of each term in the polynomial.
% Since the polynomial that we will use as a model always starts from our current position
% on the road,
% the constant term in the polynomial is assumed to be zero and we only
% have to estimate the coefficients for the linear and higher-order terms.
% We will set up a matrix equation _Ax=y_ such that
%
% * _y_ contains the sensor outputs.
% * _x_ contains the polynomial coefficients that we need to obtain.
% * _A_ is a constant matrix related to the order of the polynomial and the
% locations of the sensors.
%
% We will solve the equation using the _QR_ factorization of _A_ as
% follows:
%
% $$Ax = QRx=y$$
%
% and
%
% $$x = pinv(A) * y = R^{-1}Q^T*y$$
% 
% where _pinv()_ represents pseudo-inverse. Given the matrix A, the
% following code can be used to implement a solution of this matrix equation.
% Factoring _A_ allows for easier solution of the system.
%
%  [Q, R] = qr(A);
%  z = Q' * y;
%  x = R \ z;
%  yhat = A * x;
%  plot(0:N-1,y,'k',0:N-1,yhat,'rs')
%
% For the sake of completeness we note that the Vandermonde matrix _A_ can be formed
% using the following code:
%
%  Npoly = 3; % Order of polynomial to use in fitting
%  v = [0:Ts:((N-1)*Ts)]';
%  A = zeros(length(v), Npoly);
%  for i = Npoly : -1 : 1
%      A(:,i) = v.^i;
%  end
%
% Since _A_ is constant, so are _Q_ and _R_. They can be precomputed.
% Therefore
% the only computation required as new sensor data is obtained is
% _x=R\(Q'*y)_.
%
% Once we have estimates of the polynomial coefficients, we can reconstruct
% the polynomial with whatever granularity we desire - we are not limited
% to reconstructing only at the points where we originally had data:
%
Npoly=2;
v = (0:Ts:((N-1)*Ts))';
A = zeros(length(v), Npoly);
for i = Npoly : -1 : 1
    A(:,i) = v.^i;
end
[Q, R] = qr(A);
z = Q' * y;
x = R \ z;

Ts2 = Ts/10;
v2 = (0:Ts2:(10*(N-1)*Ts2))';
A2 = zeros(length(v2), Npoly);
for i = Npoly : -1 : 1
    A2(:,i) = v2.^i;
end
yhat = A2 * x;
plot(v,y,'k.',v2,yhat,'r')
axis([0 N*Ts -3 3]); grid;
xlabel('Distance ahead of vehicle');
title('Estimate of lane boundary looking ahead of vehicle');

%% Moving to Simulink(R) and Preparing for Fixed-Point Implementation
% Next we reconstruct this problem and its solution in the Simulink
% environment. The ultimate deliverable that we have in mind is a fixed-point
% implementation of the run-time portion of the algorithm, suitable for
% deployment in an embedded environment.
%
% The model that implements this curve-fitting application is conceptually
% divided into four parts:
%
% * Data generation, which can be implemented in floating point, since this
% portion corresponds to sensors that will be independent of the curve
% fitting device.
% * Off-line computations, which can be implemented in floating point with
% invariant signals.
% * Run-time computations, which must be implemented in fixed-point.
% * Data visualization, which can be implemented in floating point.
%
% The example model is parameterized in the same manner as the MATLAB code above.
% To see the model's parameters, go to the model workspace, which is
% available from the Model Explorer. Select View > Model Explorer and Model
% Workspace (in the middle pane) and try the following:
%
% * Set the order of the polynomial to 1 (_Npoly=1_) and reinitialize the
% workspace. The model will now try to fit a straight line to the noisy
% input data.
% * Slow down the rate of curvature in the data by setting
% _FracPeriod_ to 0.3. The curve fit is even better now, since there is less
% curvature in the data.
%
% As it is our intent to implement this model using fixed-point arithmetic, one of
% the first questions must be whether the necessary components support
% fixed-point. The QR Factorization block in the
% DSP System Toolbox(TM) does not currently support fixed-point data types, so are we
% stuck? The answer is no. The matrix that is to be factored does not
% depend on run-time data. It only depends on things like the order of the
% polynomial, the sample time, and the observation window. Thus, we assume
% that the _A_ matrix will be factored "offline". Offline computations
% can be modeled in Simulink using invariant signals.
%
% A signal in Simulink becomes invariant by setting the sample time of the
% relevant source block to _Inf_, and turning on the *Inline parameters*
% optimization on the Configuration Parameters dialog.
% This model has sample time colors turned on (Display > Sample Time > 
% Colors). The magenta part of the model has infinite sample time - its output
% is computed once, before the model begins to simulate, and is then used by the rest of the
% model during run-time. The offline computations that it represents can actually be computed
% in floating point and then their output simply converted to fixed point for use
% by the rest of the model at run-time.
%
% Running the model produces output similar to that of the MATLAB code above,
% except that it runs continually. A snapshot of the model's output is
% shown below:
open_system('dspautoscale');
set_param('dspautoscale', 'StopTime', '2');
set_param('dspautoscale', 'DataTypeOverride', 'Double');
%set_param(sprintf('dspautoscale/Plotting linear estimates\nversus original data/Vector\nScope'),'YLabel','Linear regression: Floating point');
sim('dspautoscale');
%% Workflow for Floating-Point-to-Fixed-Point Conversion
% We will now work toward reimplementing this system using fixed-point data.
% Note that
% even if a fixed-point system is the ultimate deliverable, it is usually
% desirable to start by implementing it in floating point and then
% converting that functional implementation to fixed point. In the
% remainder of this example, we will illustrate this workflow by converting
% the model above from floating point to fixed point. The Fixed-Point Tool
% in Simulink facilitates this workflow. Open this tool from
% your model by selecting *Fixed-Point Tool...* from the *Analysis* menu. 
% The primary functionalities that we will be using are data type override 
% and autoscaling. Data type override is a convenient way to switch an 
% entire model or subsystem between floating-point and fixed-point 
% operation. Autoscaling automatically suggests desirable scaling for the 
% various fixed-point quantities in a model or subsystem.
% Scaling specifies the location of the binary point within
% the specified word size for each quantity.

% Using the functionality from the Fixed-Point Tool,
% typical steps for floating-point-to-fixed-point conversion are:
%
% * Set *Data type override* to |Double| for the model or subsystem.
% * Set *Fixed-point instrumentation mode* to |Minimums, maximums and overflows|.
% * Run the model to collect the simulation minima and maxima.
% * Click the *Propose fraction lengths* button.
% * Adjust proposed fraction lengths in the relevant column in the middle
% pane of the Fixed-Point Tool if desired.
% * Click the *Apply accepted fraction lengths* button.
% * Set *Data Type Override* to |Use local settings| 
% * Rerun the model and verify that its behavior is acceptable when using
% fixed-point data.
%
% We will now step through this workflow with our linear regression model.
%% Using Data Type Override with Fixed-Point Models
% It is often convenient
% to move back and forth between floating-point and fixed-point data types as you are
% optimizing a model for fixed-point behavior. It is generally desirable
% for the fixed-point behavior to match the floating-point behavior as
% closely as possible. To see the effect of data type override with the example model, try the following:
%
% * Open the Fixed-Point Tool and observe that it has set the
% *Data type override* to |Double|, which is the reason that the model currently runs
% with double precision floating-point data.
% * Set *Data type override* to |Use local settings| to use the data types
% originally specified for each subsystem.
% * Run the model, and note that it now uses fixed-point data types in the run-time
% portion of the model that we wish to embed.
% The output results are now incorrect, as illustrated in the plot below.
% Also, numerous warnings are written to the MATLAB command window.
% The incorrect results and the warnings are both due to the fact that the model
% is not yet properly configured for fixed-point execution.
set_param('dspautoscale','IntegerOverflowMsg','none');
%set_param(sprintf('dspautoscale/LDL Solver: Subsystem\nimplementation/LDL Factorization1'),'errmode','Ignore');
%set_param(sprintf('dspautoscale/LDL Solver: Library\nblock implementation'),'errmode','Ignore');
set_param('dspautoscale', 'DataTypeOverride', 'UseLocal');
%set_param(sprintf('dspautoscale/Plotting linear estimates\nversus original data/Vector\nScope'),'YLabel','Linear regression: Fixed-point, before autoscaling');
sim('dspautoscale');
%% Proposing Optimized Fixed-Point Settings and Autoscaling the Model
% Once you run the model with fixed-point data, you can observe that the model
% is not properly scaled. Let's try to fix that.
%
% Configuration of fixed-point systems is a challenging task. Each fixed-point quantity
% must have its signedness, word length, and fraction length (binary point
% location) set. In many cases, the word length and signedness are known,
% but the binary point must be located. In DSP System Toolbox, we use
% the quantity fraction length to set binary point location.
% Fraction length is the number of bits to the right of the binary point.
%
% In order to set the scaling you can follow the general procedure outlined
% in the "Workflow for Floating-Point-to-Fixed-Point Conversion" section
% above. Specifically,
%
% * In the Fixed-Point Tool, set the model's *Data type override* to |Double| and its *Fixed-point instrumentation mode* to |Minimums, maximums, and overflows|.
% * Run the model. You will have to manually stop the model if the stop
% time is still set to |Inf|.
% * Click the *Propose fraction lengths* button on the Fixed-Point Tool.
% * Accept or reject each proposed fraction length in the middle pane of the Fixed-Point Tool.
% Before accepting, note that the entries in the proposed fraction length column (*ProposedDT*) are editable.
% The initially proposed fraction length is the largest possible
% value that does not
% produce overflow with the current data, thus providing maximum resolution
% while avoiding overflows. Extra head room can optionally be incorporated using
% the *Percent safety margin* parameters on the Fixed-Point Tool.
% * Click the *Apply accepted fraction lengths* button on the Fixed-Point Tool
% to apply accepted fraction lengths back into the model.
% Each accepted fraction length is modified on the relevant block's dialog.
% In order to allow the accepted fraction lengths to take effect in the model,
% note that block's fixed-point settings cannot be set to inherited
% modes such as |Same as input| or |Inherit via internal rule|, but rather
% must be set to an explicit mode such as |Binary point scaling|.
% * After autoscaling, set *Data type override* back to |Use local settings| and run
% the model again. The fixed-point results are now similar to those we observed
% using floating-point.
fxptdlg('dspautoscale');
set_param('dspautoscale', 'DataTypeOverride', 'Double');
sim('dspautoscale');
fxptui.cb_scalepropose;
fxptui.cb_scaleapply;
set_param('dspautoscale', 'DataTypeOverride', 'UseLocal');
%set_param(sprintf('dspautoscale/Plotting linear estimates\nversus original
%data/Vector\nScope'),'YLabel','Linear regression: Fixed-point, after autoscaling');
sim('dspautoscale');
%%
close all hidden;
bdclose dspautoscale;

% LocalWords:  Autoscaling autoscaling QRx yhat Vandermonde Npoly YLabel
% LocalWords:  Workflow workflow functionalities minima maxima errmode
% LocalWords:  signedness DT
