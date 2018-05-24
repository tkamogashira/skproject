classdef ParametricEQFilter < matlab.System
    %ParametricEQFilter Second-order parametric equalizer filter.
    %   H = dsp.ParametricEQFilter returns a second-order parametric
    %   equalizer filter which independently filters each channel of the
    %   input over time using a specified center frequency, bandwidth, and
    %   peak (dip) gain. The center frequency and bandwidth are specified
    %   in Hz and are tunable. The peak gain (dip) is specified in dB and
    %   is also tunable. The bandwidth is measured at the arithmetic mean
    %   between the peak gain in absolute power units and one.
    %
    %   H = dsp.ParametricEQFilter('Name', Value, ...) returns a
    %   parametric EQ filter with each specified property name set to the
    %   specified value. You can specify additional name-value pair
    %   arguments in any order as (Name1,Value1,...,NameN,ValueN).
    %
    %   H = dsp.ParametricEQFilter('Specification', 'Quality factor and
    %   center frequency') specifies the quality factor (Q factor) of the
    %   filter instead of the bandwidth. The Q factor is defined as the
    %   center frequency/bandwidth. A higher Q factor corresponds to a
    %   narrower peak/dip. The Q factor should be a scalar value greater
    %   than 0. The Q factor is tunable.
    %
    %   H = dsp.ParametricEQFilter('Specification', 'Coefficients')
    %   allows specifying the gain values for the bandwidth and center
    %   frequency directly rather than specifying the design parameter in
    %   Hz. This removes the trigonometry calculations involved when the
    %   properties are tuned. The CenterFrequencyCoefficient should be a
    %   scalar between -1 and 1, with -1 corresponding to 0 Hz and 1
    %   corresponding to the Nyquist frequency. The BandwidthCoefficient
    %   should be a scalar betwen -1 and 1, with -1 corresponding to the
    %   largest bandwidth and 1 corresponding to the smallest bandwidth. In
    %   this mode, the peak gain is specified in linear units rather than
    %   dB.
    %
    %   Step method syntax:
    %
    %   Y = step(H, X) filters the real or complex input signal X using the
    %   specified filter to produce the equalized filter output Y. The
    %   filter processes each channel of the input signal (each column of
    %   X) independently over time.
    %
    %   ParametricEQFilter methods:
    %
    %   step               - See above description for use of this method
    %   release            - Allow property value and input characteristics
    %                        changes
    %   clone              - Create ParametricEQFilter object with same
    %                        property values
    %   isLocked           - Locked status (logical)
    %   reset              - Reset the internal states to initial
    %                        conditions
    %   getBandwidth       - Convert quality factor or bandwidth
    %                        coefficient to bandwidth in Hertz
    %   getOctaveBandwidth - Bandwidth measured in number of octaves
    %   getCenterFrequency - Convert center freq. coefficient to Hertz
    %   getQualityFactor   - Convert bandwidth to quality factor
    %   getPeakGain        - Convert peak gain/dip from dB to absolute
    %                        units
    %   getPeakGaindB      - Convert peak gain/dip from absolute units to
    %                        dB
    %   tf                 - Transfer function of parametric EQ filter
    %
    %   ParametricEQFilter properties:
    %
    %   Specification              - Design parameters or Coefficients
    %   Bandwidth                  - filter bandwidth
    %   CenterFrequency            - Center frequency of the filter
    %   QualityFactor              - Quality (Q) factor
    %   SampleRate                 - Sample rate of input in Hz
    %   BandwidthCoefficient       - Bandwidth gain (0 to 1)
    %   CenterFrequencyCoefficient - Center frequency gain (-1 to 1)
    %   PeakGaindB                 - Peak (or dip) gain in dB
    %   PeakGain                   - Peak (or dip) gain in linear units
    %
    %   % EXAMPLE: Parametric EQ filter with center frequency of 5000,
    %   % bandwidth of 500, and peak gain of 6 dB
    %   h = dsp.ParametricEQFilter('CenterFrequency',5000,...
    %       'Bandwidth',500);
    %   htf = dsp.TransferFunctionEstimator(...
    %       'FrequencyRange','onesided','SpectralAverages',50);
    %   hplot = dsp.ArrayPlot('PlotType','Line','YLimits',[-15 15],...
    %       'SampleIncrement',44100/1024);
    %   tic,
    %   while toc < 20 % Run for 20 seconds
    %       x = randn(1024,1);
    %       y = step(h,x);
    %       H = step(htf,x,y);
    %       magdB = 20*log10(abs(H));
    %       step(hplot,magdB);
    %       if toc > 10 % After 10 seconds
    %           % Tune center frequency to 10000
    %           h.CenterFrequency = 10000;
    %           % Tune bandwidth to 2000;
    %           h.Bandwidth = 2000;
    %           % Tune peak to -10 dB
    %           h.PeakGaindB = -10;
    %       end
    %   end
    %   release(h); release(htf); release(hplot)
    %
    %   See also dsp.BiquadFilter, dsp.NotchPeakFilter.
    
    % Copyright 2013 The MathWorks, Inc.
    % $Date: 2013/11/07 17:19:11 $
    
    %#codegen
    
    properties (Nontunable,Dependent)
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
    
    properties (Dependent)
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
        %CenterFrequency Notch/Peak center frequency
        %   Specify the filter's center frequency (for both the notch and
        %   the peak) as a finite positive numeric scalar in Hertz. The
        %   default is 11025 Hz. This property is tunable.
        CenterFrequency = 11025;
        %QualityFactor Quality factor for notch/peak filter
        %   Specify the quality factor (Q factor) for both the notch and
        %   peak filter. The Q factor is defined as the center frequency
        %   divided by the bandwitdh. The default value is 5. This
        %   property is tunable.
        QualityFactor = 5;
    end

    properties
        %PeakGain Peak (or dip) gain in linear units
        %   Specify the peak or dip of the filter in linear units. Values
        %   greater than one correspond to a boost while values less than
        %   one correspond to a dip or cut. The default is 2 (6.0206 dB).
        %   This property is tunable.
        PeakGain = 2;
        %PeakGain Peak (or dip) gain in dB
        %   Specify the peak or dip of the filter in decibels. Values
        %   greater than zero correspond to a boost while values less than
        %   zero correspond to a dip or cut. The default is 6.02036dB. This
        %   property is tunable.
        PeakGaindB = 6.0206;
    end
    
    properties (Access=private)
        ReferenceGain       =  1;
        ReferenceGaindB     =  0;
        NotchPeakFilterObj  
        privReferenceGain
        privPeakGain
        NumChannels = 1
    end
    
    properties (Access=protected, Nontunable)
        %InputDataType Data type of the inputs
        %   This is a private property that stores the data type of the
        %   inputs and it is used to set the data type of all the
        %   DiscreteState properties and the outputs.
        InputDataType;
    end
    
    properties(Constant, Hidden)
        SpecificationSet = matlab.system.StringSet( { ...
            'Coefficients', ...
            'Bandwidth and center frequency',...
            'Quality factor and center frequency'} );
    end
    
    methods
        function obj = ParametricEQFilter(varargin)

            obj.NotchPeakFilterObj = dsp.NotchPeakFilter;
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:}); 
            obj.NumChannels = -1;
        end

        function set.Specification(obj,s)            
            obj.NotchPeakFilterObj.Specification = s;
        end
        function s = get.Specification(obj)
            s = obj.NotchPeakFilterObj.Specification;
        end
        function set.SampleRate(obj,Fs)            
            obj.NotchPeakFilterObj.SampleRate = Fs;
        end
        function Fs = get.SampleRate(obj)
            Fs = obj.NotchPeakFilterObj.SampleRate;
        end
        function set.Bandwidth(obj,bw)
            obj.NotchPeakFilterObj.Bandwidth = bw;
        end

        function bw = get.Bandwidth(obj)
            bw = obj.NotchPeakFilterObj.Bandwidth;
        end
        function set.CenterFrequency(obj,cf)
            obj.NotchPeakFilterObj.CenterFrequency = cf;
        end
        function cf = get.CenterFrequency(obj)
            cf = obj.NotchPeakFilterObj.CenterFrequency ;
        end
        function set.QualityFactor(obj,Q)
            obj.NotchPeakFilterObj.QualityFactor = Q;
        end
        function Q = get.QualityFactor(obj)
            Q = obj.NotchPeakFilterObj.QualityFactor;
        end
        function set.BandwidthCoefficient(obj,bwc)
            obj.NotchPeakFilterObj.BandwidthCoefficient = bwc;
        end
        function bwc = get.BandwidthCoefficient(obj)
            bwc = obj.NotchPeakFilterObj.BandwidthCoefficient;
        end
        function set.CenterFrequencyCoefficient(obj,cfc)
            obj.NotchPeakFilterObj.CenterFrequencyCoefficient = cfc;
        end
        function cfc = get.CenterFrequencyCoefficient(obj)
            cfc = obj.NotchPeakFilterObj.CenterFrequencyCoefficient;
        end
        function set.PeakGain(obj,G)
            coder.internal.errorIf(~isnumeric(G) || ~isscalar(G) ||...
                ~isreal(G) || G < 0, ['dsp:system',...
                ':ParametricEQFilter:peakGain']);
            obj.PeakGain = G;
        end
        function set.PeakGaindB(obj,G)
            coder.internal.errorIf(~isnumeric(G) || ~isscalar(G) || ...
                ~isreal(G), ['dsp:system',...
                ':ParametricEQFilter:peakGaindB']);
            obj.PeakGaindB = G;
        end
        function bw = getBandwidth(obj)
            %BW = getBandwidth(obj) get filter bandwidth
            %   BW = getBandwidth(obj) returns the bandwidth for the
            %   parametric EQ filter. The bandwidth is measured halfway
            %   between 1 and the peak gain/cut of the filter measured in
            %   absolute power units (magnitude squared of the filter). If
            %   the Specification is set to 'Quality factor and center
            %   frequency', the bandwidth is determined from the quality
            %   factor value. If the Specification property is set to
            %   'Coefficients', the bandwidth is determined from the
            %   BandwidthCoefficient value and the sample rate.
            bw = getBandwidth(obj.NotchPeakFilterObj);
        end
        
        function N = getOctaveBandwidth(obj)
            %N = getOctaveBandwidth(obj) bandwidth in number of octaves
            %   N = getOctaveBandwidth(obj) returns the bandwidth of the
            %   parametric EQ filter measured in number of octaves rather
            %   than Hz.
            N = getOctaveBandwidth(obj.NotchPeakFilterObj);
        end
        
        function Q = getQualityFactor(obj)
            %Q = getQualityFactor(obj) get quality (Q) factor
            %   Q = getQualityFactor(obj) returns the quality factor (Q
            %   factor) for the parametric EQ filter. The Q factor is
            %   defined as the center frequency divided by the bandwitdh.
            Q = getQualityFactor(obj.NotchPeakFilterObj);
        end
        
        function cf = getCenterFrequency(obj)
            %CF = getCenterFrequency(obj) get center frequency
            %   CF = getCenterFrequency(obj) returns the center frequency
            %   for the parametric EQ filter. If the Specification property
            %   is set to 'Coefficients', the center frequency is
            %   determined from the CenterFrequencyCoefficient value and
            %   the sample rate.
            cf = getCenterFrequency(obj.NotchPeakFilterObj);
        end
        
        function G = getPeakGain(obj)
            %G = getPeakGain(obj) get peak gain
            %   G = getPeakGain(obj) returns the peak gain/cut for the
            %   parametric EQ filter in absolute units.
            if strcmpi(obj.Specification,'Coefficients')
                G = obj.PeakGain;
            else
                GdB = getPeakGaindB(obj);
                G = 10^(GdB/20);
            end
        end
        
        function GdB = getPeakGaindB(obj)
            %GdB = getPeakGaindB(obj) get peak gain in dB
            %   G = getPeakGaindB(obj) returns the peak gain/cut for the
            %   parametric EQ filter in decibels.
            if strcmpi(obj.Specification,'Coefficients')
                G = obj.PeakGain;
                GdB = 20*log10(G);
            else
                GdB = obj.PeakGaindB;                
            end
        end
        function [b,a] = tf(obj)
            %[B,A] = tf(obj) Transfer function
            %   [B,A] = TF(obj) returns the vector of numerator
            %   coefficients B and the vector of denominator coefficients A
            %   for the equivalent transfer function corresponding to the
            %   parametric EQ filter.
            Fs = obj.SampleRate;
            bw = getBandwidth(obj);       dw = 2*pi*bw/Fs;
            f0 = getCenterFrequency(obj); w0 = 2*pi*f0/Fs;
            s  = tan(dw/2); sp1 = 1+s;
            G  = getPeakGain(obj); 
            a  = [1, -2*cos(w0)/sp1, (1-s)/sp1];
            b  = [(1+G*s)/sp1, -2*cos(w0)/sp1, (1-G*s)/sp1];
        end
        
    end
    
    methods (Access=protected)
        function setupImpl(obj, u)
            obj.InputDataType = class(u);
               
            processTunedPropertiesImpl(obj);

            Nchan = size(u,2);
            obj.NumChannels = Nchan;
        end
        
        function resetImpl(obj)
            % Specify initial values for DiscreteState properties
            reset(obj.NotchPeakFilterObj);
        end
        
        function y = stepImpl(obj, u)
            [y_notch,y_peak] = step(obj.NotchPeakFilterObj, u);
            
            % Final Output
            y = obj.privReferenceGain*y_notch + obj.privPeakGain*y_peak;
        end
                
        function processTunedPropertiesImpl(obj)
            inputDataTypeLocal = obj.InputDataType;
            
            if strcmpi(obj.Specification,'Bandwidth and center frequency')
                
                G0dB = cast(obj.ReferenceGaindB,inputDataTypeLocal);
                obj.privReferenceGain = 10^(G0dB/20);
                GdB  = cast(obj.PeakGaindB,inputDataTypeLocal);
                obj.privPeakGain = 10^(GdB/20);
            elseif strcmpi(obj.Specification,'Quality factor and center frequency')
                
                G0dB = cast(obj.ReferenceGaindB,inputDataTypeLocal);
                obj.privReferenceGain = 10^(G0dB/20);
                GdB  = cast(obj.PeakGaindB,inputDataTypeLocal);
                obj.privPeakGain = 10^(GdB/20);
            else
                
                obj.privReferenceGain = ...
                    cast(obj.ReferenceGain,inputDataTypeLocal);
                obj.privPeakGain = ...
                    cast(obj.PeakGain,inputDataTypeLocal);
            end
            
            
        end
        
        function releaseImpl(obj)
            release(obj.NotchPeakFilterObj);           
            obj.NumChannels = -1;        
        end
        
        function validateInputsImpl(obj,u)
            
            validateattributes(u, {'single', 'double'}, {'2d'},'','')%#ok<EMCA>
            if obj.NumChannels ~= -1
                coder.internal.errorIf(size(u,2) ~= obj.NumChannels, ['dsp:system',...
                    ':Shared:numChannels']);
            end
            
        end
        
        function flag = isInactivePropertyImpl(obj, prop)
            flag = false;
            specLocal = obj.Specification;
            switch prop
                case {'BandwidthCoefficient'}
                    if ~strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'CenterFrequencyCoefficient'}
                    if ~strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'ReferenceGain'}
                    if ~strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'PeakGain'}
                    if ~strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'Bandwidth'}
                    if ~strcmp(specLocal, 'Bandwidth and center frequency')
                        flag = true;
                    end
                case {'QualityFactor'}
                    if ~strcmp(specLocal, 'Quality factor and center frequency')
                        flag = true;
                    end
                case {'CenterFrequency'}
                    if strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'ReferenceGaindB'}
                    if strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end
                case {'PeakGaindB'}
                    if strcmp(specLocal, 'Coefficients')
                        flag = true;
                    end         
            end
        end
        
        function N = getNumInputsImpl(obj)
            % Specify number of System inputs
            N = 1; % Because stepImpl has one argument beyond obj
        end
        
        function N = getNumOutputsImpl(obj)
            % Specify number of System outputs
            N = 1; % Because stepImpl has one output
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);
            s.NotchPeakFilterObj = matlab.System.saveObject(obj.NotchPeakFilterObj);
            if isLocked(obj)
                % All the following are set at setup  
                
                
                s.privReferenceGain = obj.privReferenceGain;
                s.privPeakGain = obj.privPeakGain;               
                s.InputDataType = obj.InputDataType;
            end
        end
        
        function s = loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                % All the following were set at setup
                
                obj.privReferenceGain = s.privReferenceGain;
                obj.privPeakGain = s.privPeakGain;                               
                obj.InputDataType = s.InputDataType;
            end
            obj.NotchPeakFilterObj = matlab.System.loadObject(s.NotchPeakFilterObj);
            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
    end
    
    methods(Static, Access=protected)
        function group = getPropertyGroupsImpl
            %Get default parameters group for this System object
            
            propertyList = {'Specification','SampleRate','Bandwidth',...
                'CenterFrequency','BandwidthCoefficient','PeakGaindB',...
                'CenterFrequencyCoefficient','QualityFactor',...
                'PeakGain'};%#ok<EMCA>
            group = matlab.system.display.Section('Title', 'Parameters', ...
                'PropertyList', propertyList,...
                'DependOnPrivatePropertyList',propertyList);
        end
    end
end

