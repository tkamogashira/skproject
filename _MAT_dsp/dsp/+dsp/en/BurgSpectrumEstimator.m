classdef BurgSpectrumEstimator< handle
%BurgSpectrumEstimator Parametric spectral estimation using the Burg method
%   HBURGSPEST = dsp.BurgSpectrumEstimator returns a System object,
%   HBURGSPEST, that estimates the power spectral density (PSD) of the
%   input frame using the Burg method. The object fits an autoregressive
%   (AR) model to the signal by minimizing (least squares) the forward and
%   backward prediction errors while constraining the AR parameters to
%   satisfy the Levinson-Durbin recursion.
%
%   HBURGSPEST = dsp.BurgSpectrumEstimator('PropertyName', PropertyValue,
%   ...) returns a burg spectrum estimator object, HBURGSPEST, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HBURGSPEST, X) outputs Y, a spectral estimate of input X,
%   using Burg spectrum estimation method.
%
%   BurgSpectrumEstimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create burg spectrum estimator object with same property
%              values
%   isLocked - Locked status (logical)
%
%   BurgSpectrumEstimator properties: 
%
%   EstimationOrderSource - Source of estimation order
%   EstimationOrder       - Order of AR model
%   FFTLengthSource       - Source of FFT length
%   FFTLength             - FFT length as power-of-two integer value
%   SampleRate            - Sample rate of input time series
%
%   % EXAMPLE: Spectrum estimation using BurgSpectrumEstimator System 
%   % object.
%      x = randn(100,1);
%      hburgspest = dsp.BurgSpectrumEstimator('EstimationOrder', 4);
%      y = filter(1,[1 1/2 1/3 1/4 1/5],x); % Fourth order AR filter
%      p = step(hburgspest, y);          % Uses default FFT length of 256
%      plot([0:255]/256, p);
%      title('Burg Method Spectral Density Estimate');
%      xlabel('Normalized frequency'); ylabel('Power/frequency');
%
%   See also dsp.BurgAREstimator.

 
%   Copyright 1995-2011 The MathWorks, Inc.

    methods
        function out=BurgSpectrumEstimator
            %BurgSpectrumEstimator Parametric spectral estimation using the Burg method
            %   HBURGSPEST = dsp.BurgSpectrumEstimator returns a System object,
            %   HBURGSPEST, that estimates the power spectral density (PSD) of the
            %   input frame using the Burg method. The object fits an autoregressive
            %   (AR) model to the signal by minimizing (least squares) the forward and
            %   backward prediction errors while constraining the AR parameters to
            %   satisfy the Levinson-Durbin recursion.
            %
            %   HBURGSPEST = dsp.BurgSpectrumEstimator('PropertyName', PropertyValue,
            %   ...) returns a burg spectrum estimator object, HBURGSPEST, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HBURGSPEST, X) outputs Y, a spectral estimate of input X,
            %   using Burg spectrum estimation method.
            %
            %   BurgSpectrumEstimator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create burg spectrum estimator object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   BurgSpectrumEstimator properties: 
            %
            %   EstimationOrderSource - Source of estimation order
            %   EstimationOrder       - Order of AR model
            %   FFTLengthSource       - Source of FFT length
            %   FFTLength             - FFT length as power-of-two integer value
            %   SampleRate            - Sample rate of input time series
            %
            %   % EXAMPLE: Spectrum estimation using BurgSpectrumEstimator System 
            %   % object.
            %      x = randn(100,1);
            %      hburgspest = dsp.BurgSpectrumEstimator('EstimationOrder', 4);
            %      y = filter(1,[1 1/2 1/3 1/4 1/5],x); % Fourth order AR filter
            %      p = step(hburgspest, y);          % Uses default FFT length of 256
            %      plot([0:255]/256, p);
            %      title('Burg Method Spectral Density Estimate');
            %      xlabel('Normalized frequency'); ylabel('Power/frequency');
            %
            %   See also dsp.BurgAREstimator.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function releaseImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Check the input signal data type and error out if the data type is
            % not floating point
        end

        function validatePropertiesImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %EstimationOrder Order of AR model 
        %   Specify the order of AR model as a real positive integer. This
        %   property is applicable when EstimationOrderSource is 'Property'.
        %   The default value of this property is 6.
        EstimationOrder;

        %EstimationOrderSource Source of estimation order
        %   Specify how to determine estimator order as one of ['Auto' |
        %   {'Property'}]. If this property is set to 'Auto', the estimation
        %   order is assumed to be one less than the length of the input
        %   vector.
        EstimationOrderSource;

        %FFTLength FFT length as power-of-two integer value
        %   Specify the FFT length as a power-of-two numeric scalar. This
        %   property is applicable when the FFTLengthSource property is
        %   'Property'. The default value of this property is 256.
        FFTLength;

        %FFTLengthSource Source of FFT length
        %   Specify how to determine the FFT length as one of ['Auto' |
        %   {'Property'}]. If this property is set to 'Auto', the FFT length is
        %   assumed to be one more than the estimation order. Note that the FFT
        %   length must be a power-of-two integer value.
        FFTLengthSource;

        %SampleRate Sample rate of input time series
        %   Specify the sampling rate of the original input time series as a
        %   positive numeric scalar. The default value of this property is 1.
        SampleRate;

    end
end
