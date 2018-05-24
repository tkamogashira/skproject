classdef NotchPeakFilter < matlab.System
    %NotchPeakFilter Second-order tunable notching and peaking IIR filter.
    %   H = dsp.NotchPeakFilter returns a second-order notching and peaking
    %   IIR filter which independently filters each channel of the input
    %   over time using a specified center frequency and 3 dB bandwidth.
    %   Both of these properties are specified in Hz and are tunable. Both
    %   of these values must be scalars between 0 and half the sample rate.
    %
    %   H = dsp.NotchPeakFilter('Name', Value, ...) returns a notch filter
    %   with each specified property name set to the specified value. You
    %   can specify additional name-value pair arguments in any order as
    %   (Name1,Value1,...,NameN,ValueN).
    %
    %   H = dsp.NotchPeakFilter('Specification', 'Quality factor and center
    %   frequency') specifies the quality factor (Q factor) of the
    %   notch/peak filter instead of the 3 dB bandwidth. The Q factor is
    %   defined as the center frequency/bandwidth. A higher Q factor
    %   corresponds to a narrower notch/peak. The Q factor should be a
    %   scalar value greater than 0. The Q factor is tunable.
    %
    %   H = dsp.NotchPeakFilter('Specification', 'Coefficients') specifies
    %   the coefficient values that affect bandwidth and center frequency
    %   directly rather than specifying the design parameters in Hz. This
    %   removes the trigonometry calculations involved when the properties
    %   are tuned. The CenterFrequencyCoefficient should be a scalar
    %   between -1 and 1, with -1 corresponding to 0 Hz and 1 corresponding
    %   to the Nyquist frequency. The BandwidthCoefficient should be a
    %   scalar betwen -1 and 1, with -1 corresponding to the largest 3 dB
    %   bandwidth and 1 corresponding to the smallest 3 dB bandwidth. Both
    %   coefficient values are tunable.
    %
    %   Step method syntax:
    %
    %   [Yn,Yp] = step(H, X) filters the real or complex input signal X
    %   using the specified filter to produce the notch filter output, Yn,
    %   and the peak filter output Yp. The filter processes each channel of
    %   the input signal (each column of X) independently over time. The
    %   peak filter output is optional and is computed efficiently using
    %   most of the same computation used to compute the notch filter.
    %
    %   NotchPeakFilter methods:
    %
    %   step               - See above description for use of this method
    %   release            - Allow property value and input characteristics
    %                        changes
    %   clone              - Create NotchPeakFilter object with same
    %                        property values
    %   isLocked           - Locked status (logical)
    %   reset              - Reset the internal states to initial 
    %                        conditions
    %   getBandwidth       - Convert quality factor or bandwidth
    %                        coefficient to bandwidth in Hertz
    %   getOctaveBandwidth - Bandwidth measured in number of octaves
    %   getCenterFrequency - Convert center freq. coefficient to Hertz
    %   getQualityFactor   - Convert bandwidth to quality factor 
    %   tf                 - Transfer function for notch/peak filter
    %
    %   NotchPeakFilter properties:
    %
    %   Specification              - Design parameters or Coefficients
    %   Bandwidth                  - 3 dB bandwidth in Hz
    %   CenterFrequency            - Center frequency of the notch filter
    %                                in Hz
    %   QualityFactor              - Quality (Q) factor
    %   SampleRate                 - Sample rate of input in Hz
    %   BandwidthCoefficient       - Bandwidth coefficient value (0 to 1)
    %   CenterFrequencyCoefficient - Center frequency coefficient (-1 to 1)
    %
    %   % EXAMPLE: Notch/Peak filter with center frequency of 5000 Hz and 3 
    %   % dB bandwidth of 500 Hz.
    %   h = dsp.NotchPeakFilter('CenterFrequency',5000,'Bandwidth',500);
    %   hscope =  dsp.SpectrumAnalyzer('SampleRate',44100,...
    %       'PlotAsTwoSidedSpectrum',false,'SpectralAverages',50);
    %   for i=1:5000
    %       y = step(h,randn(1024,1));
    %       step(hscope,y);
    %       if (i==2500)
    %           % Tune center frequency to 10000
    %           h.CenterFrequency = 10000;
    %       end
    %   end
    %   release(h)
    %   release(hscope)
    %
    %   See also dsp.BiquadFilter, iirnotch, iirpeak.
    
    % Copyright 2013 The MathWorks, Inc.
        
    %#codegen
    
    properties (Nontunable)
        %Specification Filter specification
        %   Set the specification as one of 'Bandwidth and center
        %   frequency' | 'Quality factor and center frequency' | 
        %   'Coefficients'. The default is 'Bandwidth and center
        %   frequency'.
        Specification = 'Bandwidth and center frequency';
        %SampleRate Sample rate of input
        %   Specify the sample rate of the input in Hertz as a finite
        %   numeric scalar. The default is 44100 Hz.
        SampleRate = 44100;
    end
    properties
        
        %BandwidthCoefficient Bandwidth Coefficient
        %   Specify the value that determines the filter's 3 dB bandwith as
        %   a finite numeric scalar between 0 and 1. 0 corresponds to the
        %   maximum 3 dB bandwidth (SampleRate/4). 1 corresponds to the
        %   minimum 3 dB bandwidth (0 Hz; i.e. an allpass filter). The
        %   default is 0.72654. This property is tunable.
        BandwidthCoefficient = 0.72654;
        %CenterFrequencyCoefficient Center Frequency Coefficient
        %   Specify the value that determines the filter's center frequency
        %   as a finite numeric scalar between -1 and 1. -1 corresponds to
        %   the minimum center frequency (0 Hz). 1 corresponds to the
        %   maximum center frequency (SampleRate/2 Hz). The default is 0
        %   which corresponds to SampleRate/4 Hz. This property is tunable.
        CenterFrequencyCoefficient = 0;            
        %Bandwidth 3 dB bandwidth
        %   Specify the filter's 3 dB bandwith as a finite positive numeric
        %   scalar in Hertz. The default is 2205 Hz. This property is
        %   tunable.
        Bandwidth = 2205;
        %QualityFactor Quality factor for notch/peak filter
        %   Specify the quality factor (Q factor) for both the notch and
        %   peak filter. The Q factor is defined as the center frequency
        %   divided by the bandwitdh. The default value is 5. This
        %   property is tunable.
        QualityFactor = 5;
        %CenterFrequency Notch/Peak center frequency
        %   Specify the filter's center frequency (for both the notch and
        %   the peak) as a finite positive numeric scalar in Hertz. The
        %   default is 11025 Hz. This property is tunable.
        CenterFrequency = 11025;        
    end
        
    properties (DiscreteState)
        % Define any discrete-time states
        States
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
    end
    
    properties (Access=private)
        privBandwidthCoefficient
        privCenterFrequencyCoefficient
        NumChannels = 1
    end
    
    properties(Constant, Hidden)
        SpecificationSet = matlab.system.StringSet( { ...
            'Coefficients', ...
            'Bandwidth and center frequency',...
            'Quality factor and center frequency'} );
    end
    
    methods
        function obj = NotchPeakFilter(varargin)
            %NotchPeakFilter Construct the NotchPeakFilter class.
            
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
            obj.NumChannels = -1;
        end
        
        function set.SampleRate(obj,Fs)
            coder.internal.errorIf(~isnumeric(Fs) || ~isscalar(Fs)...
                || ~isreal(Fs) || Fs <= 0, ['dsp:system',...
                ':NotchPeakFilter:sampleRate']);
            obj.SampleRate = Fs;
        end
        function set.Bandwidth(obj,bw)
            coder.internal.errorIf(~isnumeric(bw) || ~isscalar(bw)...
                || ~isreal(bw) || bw < 0, ['dsp:system',...
                ':NotchPeakFilter:BW']);            
            obj.Bandwidth = bw;
        end
        function set.CenterFrequency(obj,cf)
            coder.internal.errorIf(~isnumeric(cf) || ~isscalar(cf)...
                || ~isreal(cf) || cf < 0, ['dsp:system',...
                ':NotchPeakFilter:centerFreq']);
            
            obj.CenterFrequency = cf;
        end
        function set.QualityFactor(obj,Q)
            coder.internal.errorIf(~isnumeric(Q) || ~isscalar(Q) ||...
                 ~isreal(Q) || Q <= 0, ['dsp:system',...
                ':NotchPeakFilter:QFactor']);
            obj.QualityFactor = Q;
        end
        
        function set.BandwidthCoefficient(obj,bwc)
            coder.internal.errorIf(~isnumeric(bwc) || ~isscalar(bwc) ...
                || ~isreal(bwc) || (bwc <= -1 || bwc > 1), ['dsp:system',...
                ':NotchPeakFilter:BWCoeff']);            
            obj.BandwidthCoefficient = bwc;
        end
        function set.CenterFrequencyCoefficient(obj,cfc)
            coder.internal.errorIf(~isnumeric(cfc) || ~isscalar(cfc) ...
                || ~isreal(cfc) || (cfc < -1 || cfc > 1), ['dsp:system',...
                ':NotchPeakFilter:centerFreqCoeff']);
            obj.CenterFrequencyCoefficient = cfc;
        end
        
        function bw = getBandwidth(obj)  
            %BW = getBandwidth(obj) get 3 dB bandwidth
            %   BW = getBandwidth(obj) returns the 3 dB bandwidth for the
            %   notch/peak filter. If the Specification is set to 'Quality
            %   factor and center frequency', the 3 dB bandwidth is
            %   determined from the quality factor value. If the 
            %   Specification property is set to 'Coefficients', the 3 dB
            %   bandwidth is determined from the BandwidthCoefficient value
            %   and the sample rate.
            if strcmpi(obj.Specification,'Bandwidth and center frequency')
                bw = obj.Bandwidth;
            elseif strcmpi(obj.Specification,'Quality factor and center frequency')
                bw = obj.CenterFrequency/obj.QualityFactor;
            else
                Fs = obj.SampleRate;
                t = 2/(obj.BandwidthCoefficient + 1) - 1;
                bw = Fs/pi*atan(t);
            end
        end
                         
        function N = getOctaveBandwidth(obj) 
            %N = getOctaveBandwidth(obj) bandwidth in number of octaves
            %   N = getOctaveBandwidth(obj) returns the bandwidth of the
            %   notch/peak filter measured in number of octaves rather than
            %   Hz.
            Q = getQualityFactor(obj) ;           
            N = 2/log(2)*asinh(1/(2*Q));            
        end
        
        function Q = getQualityFactor(obj) 
            %Q = getQualityFactor(obj) get quality (Q) factor
            %   Q = getQualityFactor(obj) returns the quality factor (Q
            %   factor) for both the notch and peak filter. The Q factor is
            %   defined as the center frequency divided by the bandwitdh.
            if strcmpi(obj.Specification,'Bandwidth and center frequency')
                Q = obj.CenterFrequency/obj.getBandwidth;
            elseif strcmpi(obj.Specification,'Quality factor and center frequency')
                Q = obj.QualityFactor; 
            else
                Q = getCenterFrequency(obj)/getBandwidth(obj);
            end
        end                             
        
        function cf = getCenterFrequency(obj) 
            %CF = getCenterFrequency(obj) get center frequency
            %   CF = getCenterFrequency(obj) returns the center frequency
            %   for the notch/peak filter. If the Specification property is
            %   set to 'Coefficients', the center frequency is determined
            %   from the CenterFrequencyCoefficient value and the sample
            %   rate.
            if strcmpi(obj.Specification,'Coefficients')
                Fs = obj.SampleRate;
                cf = Fs/(2*pi)*acos(-obj.CenterFrequencyCoefficient);
            else
                cf = obj.CenterFrequency;
            end
        end

        function [b,a,b2,a2] = tf(obj)
            %[B,A,B2,A2] = tf(obj) Transfer function
            %   [B,A] = TF(obj) returns the vector of numerator
            %   coefficients B and the vector of denominator coefficients A
            %   for the equivalent transfer function corresponding to the
            %   notch filter.
            %
            %   [B,A,B2,A2] = TF(obj) returns the vector of numerator
            %   coefficients B2 and the vector of denominator coefficients
            %   A2 for the equivalent transfer function corresponding to
            %   the peak filter.
            Fs = obj.SampleRate;
            bw = getBandwidth(obj);       dw = 2*pi*bw/Fs;
            f0 = getCenterFrequency(obj); w0 = 2*pi*f0/Fs;
            beta = 1/(1 + tan(dw/2));
            a    = [1, -2*beta*cos(w0), 2*beta-1];
            a2   = a; % Same denominator for peak and notch
            b    = beta*[1, -2*cos(w0), 1];
            b2   = (1 - beta)*[1, 0, -1];
        end
    end
    
    methods (Access=protected)
        function setupImpl(obj, u)
            % Implement any tasks that need to be performed only once, such
            % as computation of constants or creation of child System objects
            
            obj.InputDataType  = class(u);          
            Nchan = size(u,2);
            obj.States = zeros(2,Nchan,'like',u);
            obj.NumChannels = Nchan;
                        
            processTunedPropertiesImpl(obj);
        end
        
        function resetImpl(obj)
            % Specify initial values for DiscreteState properties
            obj.States = zeros(size(obj.States),'like',obj.States);            
        end
        
        function [y_notch,y_peak] = stepImpl(obj, u)
            % Implement System algorithm. Calculate y as a function of
            % input u and state.
            w3dB = zeros(size(u),'like',u);
            
            % Cache states locally for speed
            z1 = obj.States(1,:);
            z2 = obj.States(2,:);
            
            % Cache 3dB and CF locally for speed
            G3dB = obj.privBandwidthCoefficient;
            Gcf  = obj.privCenterFrequencyCoefficient;
            
            % Scale by overall 1/2 gain
            s = .5*u;
            
            for k = 1:size(u,1)
                
                % 3 dB section
                o3dB = s(k,:) - z1;
                p3dB = G3dB.*o3dB;
                s3dB = s(k,:) + p3dB;
                
                % Center freq. section
                ocf = s3dB - z2;
                pcf = Gcf.*ocf;
                scf = s3dB + pcf;
                wcf = pcf + z2;
                
                % Output
                w3dB(k,:) = p3dB + z1;
                
                % Update States
                z2 = scf;
                z1 = wcf;
            end
            
            % Final Output
            y_notch = s + w3dB;
            if nargout > 1
                y_peak  = s - w3dB;
            end
            
            % Save states
            obj.States(1,:) = z1;
            obj.States(2,:) = z2;
        end
        
        function validateInputsImpl(obj,u)
            
            validateattributes(u, {'single', 'double'}, {'2d'},'','')%#ok<EMCA>
            if obj.NumChannels ~= -1
                coder.internal.errorIf(size(u,2) ~= obj.NumChannels, ['dsp:system',...
                    ':Shared:numChannels']);
            end
            
        end

        function validatePropertiesImpl(obj)

            Fs = obj.SampleRate;
            
            if strcmpi(obj.Specification,'Bandwidth and center frequency')
                % Center frequency must be between 0 and Fs/2.
                CF = obj.CenterFrequency;
                coder.internal.errorIf(CF < 0 || CF > Fs/2, ['dsp:system',...
                    ':NotchPeakFilter:centerFreq']);
                
                % Bandwidth must be between 0 and Fs/2.
                BW = obj.Bandwidth;
                coder.internal.errorIf(BW < 0 || BW >= Fs/2, ['dsp:system',...
                    ':NotchPeakFilter:BW']);

            elseif strcmpi(obj.Specification,'Quality factor and center frequency')
                % Center frequency must be between 0 and Fs/2.
                CF = obj.CenterFrequency;
                coder.internal.errorIf(CF < 0 || CF > Fs/2, ['dsp:system',...
                    ':NotchPeakFilter:centerFreq']);                               
                        
            end
        end

        function processTunedPropertiesImpl(obj)
            inputDataTypeLocal = obj.InputDataType;
            
            if strcmpi(obj.Specification,'Bandwidth and center frequency')
                Fs = cast(obj.SampleRate,inputDataTypeLocal);
                BW = cast(obj.Bandwidth,inputDataTypeLocal);
                CF = cast(obj.CenterFrequency,inputDataTypeLocal);                              
                t  = tan(BW*pi/Fs);
                obj.privBandwidthCoefficient = 2/(1+t)-1;
                obj.privCenterFrequencyCoefficient = -cos(2*CF/Fs*pi);
            elseif strcmpi(obj.Specification,'Quality factor and center frequency')
                Fs = cast(obj.SampleRate,inputDataTypeLocal);
                Q  = cast(obj.QualityFactor,inputDataTypeLocal);
                CF = cast(obj.CenterFrequency,inputDataTypeLocal);
                BW = CF/Q;
                t  = tan(BW*pi/Fs);
                obj.privBandwidthCoefficient = 2/(1+t)-1;
                obj.privCenterFrequencyCoefficient = -cos(2*CF/Fs*pi);
            else
                bwc = cast(obj.BandwidthCoefficient,inputDataTypeLocal);
                cfc = cast(obj.CenterFrequencyCoefficient,inputDataTypeLocal);
                obj.privBandwidthCoefficient       = bwc;
                obj.privCenterFrequencyCoefficient = cfc;
            end
        end
        
        function releaseImpl(obj)
            obj.NumChannels = -1;
        end
        
        function flag = isInactivePropertyImpl(obj, prop)
            flag = false;
            specLocal = obj.Specification;
            switch prop
                case {'BandwidthCoefficient'}
                    if strcmp(specLocal, 'Bandwidth and center frequency') || ...
                        strcmp(specLocal, 'Quality factor and center frequency')
                        flag = true;
                    end
                case {'CenterFrequencyCoefficient'}                    
                    if strcmp(specLocal, 'Bandwidth and center frequency') || ...
                        strcmp(specLocal, 'Quality factor and center frequency')
                        flag = true;
                    end
                case {'Bandwidth'}                    
                    if strcmp(specLocal, 'Coefficients') || ...
                        strcmp(specLocal, 'Quality factor and center frequency')
                        flag = true;
                    end
                case {'CenterFrequency'}
                    if strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'QualityFactor'}
                    if strcmp(specLocal, 'Coefficients') || ...
                        strcmp(specLocal, 'Bandwidth and center frequency')
                        flag = true;
                    end
            end
        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 1; % Because stepImpl has one argument beyond obj
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 2; % Because stepImpl has two outputs
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);

            if isLocked(obj)
                % All the following are set at setup
                s.States = obj.States;
                s.privBandwidthCoefficient = obj.privBandwidthCoefficient;
                s.privCenterFrequencyCoefficient = obj.privCenterFrequencyCoefficient;                
                s.InputDataType = obj.InputDataType;
            end
        end
        
        function s = loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                % All the following were set at setup
                obj.States = s.States;
                obj.privBandwidthCoefficient = s.privBandwidthCoefficient;
                obj.privCenterFrequencyCoefficient = s.privCenterFrequencyCoefficient;                
                obj.InputDataType = s.InputDataType;
            end

            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        
    end
end

