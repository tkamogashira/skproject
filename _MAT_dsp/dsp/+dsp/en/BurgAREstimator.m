classdef BurgAREstimator< handle
%BurgAREstimator  Autoregressive model parameter estimation using Burg
%method
%   HBURGAREST = dsp.BurgAREstimator returns a Burg AR estimator System
%   object, HBURGAREST, that performs parametric AR estimation using the
%   Burg maximum entropy method.
%
%   HBURGAREST = dsp.BurgAREstimator('PropertyName', PropertyValue, ...)
%   returns a Burg AR estimator object, HBURGAREST, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   [A, G] = step(HBURGAREST, X) computes the normalized estimate of the AR
%   model parameters to fit the input, X, in the least square sense. The
%   input X must be a column vector. Output A is a column vector that
%   contains the normalized estimate of the AR model polynomial
%   coefficients in descending powers of z, and the scalar G is the AR
%   model gain.
%
%   [K, G] = step(HBURGAREST, X) returns K, a column vector containing the
%   AR model reflection coefficients when the KOutputPort property is true
%   and the AOutputPort property is false.
%
%   [A, K, G] = step(HBURGAREST, X) returns the AR model polynomial
%   coefficients A, reflection coefficients K, and the scalar gain G when
%   the AOutputPort and KOutputPort properties are both true.
%
%   BurgAREstimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Burg AR estimator object with same property values
%   isLocked - Locked status (logical)
%
%   BurgAREstimator properties:
%
%   AOutputPort           - Enables output of polynomial coefficients
%   KOutputPort           - Enables output of reflection coefficients
%   EstimationOrderSource - Source of estimation order
%   EstimationOrder       - Order of AR model
%
%   % EXAMPLE: Use BurgAREstimator System object to estimate parameters of
%   % AR model.
%       rs = RandStream.create('mrg32k3a'); 
%       noise = randn(rs, 100,1);  % Normalized white Gaussian noise
%       x = filter(1,[1 1/2 1/3 1/4 1/5],noise);
%       hburgarest = dsp.BurgAREstimator(...
%           'EstimationOrderSource', 'Property', ...
%           'EstimationOrder', 4);
%       [a, g] = step(hburgarest, x);
%       x_est = filter(g, a, x);
%       plot(1:100,[x x_est]);
%       title('Original and estimated signals'); 
%       legend('Original', 'Estimated');
%
%   See also dsp.LevinsonSolver.

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=BurgAREstimator
            %BurgAREstimator  Autoregressive model parameter estimation using Burg
            %method
            %   HBURGAREST = dsp.BurgAREstimator returns a Burg AR estimator System
            %   object, HBURGAREST, that performs parametric AR estimation using the
            %   Burg maximum entropy method.
            %
            %   HBURGAREST = dsp.BurgAREstimator('PropertyName', PropertyValue, ...)
            %   returns a Burg AR estimator object, HBURGAREST, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   [A, G] = step(HBURGAREST, X) computes the normalized estimate of the AR
            %   model parameters to fit the input, X, in the least square sense. The
            %   input X must be a column vector. Output A is a column vector that
            %   contains the normalized estimate of the AR model polynomial
            %   coefficients in descending powers of z, and the scalar G is the AR
            %   model gain.
            %
            %   [K, G] = step(HBURGAREST, X) returns K, a column vector containing the
            %   AR model reflection coefficients when the KOutputPort property is true
            %   and the AOutputPort property is false.
            %
            %   [A, K, G] = step(HBURGAREST, X) returns the AR model polynomial
            %   coefficients A, reflection coefficients K, and the scalar gain G when
            %   the AOutputPort and KOutputPort properties are both true.
            %
            %   BurgAREstimator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Burg AR estimator object with same property values
            %   isLocked - Locked status (logical)
            %
            %   BurgAREstimator properties:
            %
            %   AOutputPort           - Enables output of polynomial coefficients
            %   KOutputPort           - Enables output of reflection coefficients
            %   EstimationOrderSource - Source of estimation order
            %   EstimationOrder       - Order of AR model
            %
            %   % EXAMPLE: Use BurgAREstimator System object to estimate parameters of
            %   % AR model.
            %       rs = RandStream.create('mrg32k3a'); 
            %       noise = randn(rs, 100,1);  % Normalized white Gaussian noise
            %       x = filter(1,[1 1/2 1/3 1/4 1/5],noise);
            %       hburgarest = dsp.BurgAREstimator(...
            %           'EstimationOrderSource', 'Property', ...
            %           'EstimationOrder', 4);
            %       [a, g] = step(hburgarest, x);
            %       x_est = filter(g, a, x);
            %       plot(1:100,[x x_est]);
            %       title('Original and estimated signals'); 
            %       legend('Original', 'Estimated');
            %
            %   See also dsp.LevinsonSolver.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AOutputPort Enables output of polynomial coefficients
        %   Set this property to true to output the polynomial coefficients, A,
        %   of the AR model computed by the System object. The default value of
        %   this property is true. At least one of AOutputPort and KOutputPort
        %   properties must be true.
        AOutputPort;

        %EstimationOrder Order of AR model 
        %   Set the AR model estimation order to a real positive integer. This
        %   property is applicable when EstimationOrderSource is 'Property'.
        %   The default value of this property is 4.
        EstimationOrder;

        %EstimationOrderSource Source of estimation order
        %   Specify how to determine estimator order as one of [{'Auto'} |
        %   'Property']. If this property is set to 'Auto', the estimation
        %   order is assumed to be one less than the length of the input
        %   vector.
        EstimationOrderSource;

        %KOutputPort Enables output of reflection coefficients
        %   Set this property to true to output the reflection coefficients, K,
        %   of the AR model computed by the System object. The default value of
        %   this property is false. At least one of AOutputPort and KOutputPort
        %   properties must be true.
        KOutputPort;

    end
end
