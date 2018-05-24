classdef SampleRateConverter < matlab.System
    %SampleRateConverter Multistage sample rate converter.
    %   H = dspdemo.SampleRateConverter returns a multistage FIR sample
    %   rate converter which converts the rate of each channel of the input
    %   signal from the input sampling rate to the output sampling rate
    %   specified.
    %
    %   H = dspdemo.SampleRateConverter('Name', Value, ...) returns a
    %   multistage SRC with each specified property name set to the
    %   specified value. You can specify additional name-value pair
    %   arguments in any order as (Name1,Value1,...,NameN,ValueN).
    %
    %   Step method syntax:
    %
    %   Y = step(H, X) designs one or more multirate FIR filters and then
    %   uses the fitlers to convert the rate of each channel (column) of
    %   the real or complex input signal X to the output sampling rate
    %   specified in H.
    %
    %   SampleRateConverter methods:
    %
    %   step               - See above description for use of this method
    %   release            - Allow property value and input characteristics
    %                        changes
    %   clone              - Create SampleRateConverter object with same
    %                        property values
    %   isLocked           - Locked status (logical)
    %   reset              - Reset the internal states to initial
    %                        conditions
    %   getFilters         - Return filters used for rate conversion
    %
    %   SampleRateConverter properties:
    %
    %   Bandwidth               - (Two-sided) bandwidth of interest
    %   SampleRateIn            - Input signal sampling rate
    %   SampleRateOut           - Output signal sampling rate
    %   MinimumAliasAttenuation - Minimum attenuation for aliased
    %                             components (dB)
    %
    %   % EXAMPLE: Convert an audio signal from 44.1 kHz to 96 kHz
    %   SRC = dspdemo.SampleRateConverter('Bandwidth',40e3,...
    %       'SampleRateIn',44.1e3,'SampleRateOut',96e3);
    %   AR = dsp.AudioFileReader('guitar10min.ogg','SamplesPerFrame',14700);
    %   AW = dsp.AudioFileWriter('guitar10min_96kHz.wav','SampleRate',96e3);
    %   
    %   while ~isDone(AR)
    %       x = step(AR);
    %       y = step(SRC,x);
    %       step(AW,y);
    %   end
    %   release(AR); release(AW); release(SRC)
    %
    %   See also dsp.FIRRateConverter, dsp.FIRDecimator, 
    %            dsp.FIRInterpolator.
    
    % Copyright 2013 The MathWorks, Inc.
    % $Date: 2013/11/07 17:20:17 $
    
    %#codegen
    
    properties (Nontunable)
        %Bandwidth bandwidth of interest
        %   Specify the bandwith of interest for the signal after rate 
        %   conversion.
        Bandwidth =  40e3;
        %SampleRateIn sample rate of input signal
        %   Specify the sampling rate of the input signal.
        SampleRateIn = 192e3;
        %SampleRateOut sample rate of output signal
        %   Specify the sampling rate desired for the output signal.
        SampleRateOut = 44.1e3
        %MinimumAliasAttenuation minimum alias attenuation
        %   Specify the minimum amount of attenuation, in dB, for any
        %   signal components that alias back into the bandwidth of
        %   interest.
        MinimumAliasAttenuation = 80;
    end
    
    properties (Nontunable, Access=private)              
        Nstages = 0;
        filt1
        filt2
        filt3
        filt4
        filt5
        filt6
        filt7
        filt8
        filt9
        AreFiltersDesigned = false;
    end
    properties(Constant, Access = private)
        FilterNumber = ['1';'2';'3';'4';'5';'6';'7';'8';'9'];
        MaxFilters = 9;
    end    
        
    methods
        function obj = SampleRateConverter(varargin)
            %Constructor
            
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
        end
        
        function set.SampleRateIn(obj,Fs)
            coder.internal.errorIf(~isnumeric(Fs) || ~isscalar(Fs)...
                || ~isreal(Fs) || Fs <= 0, ['dsp:system',...
                ':NotchPeakFilter:sampleRate']);
            obj.SampleRateIn = Fs;
            needToDesignFilters(obj);
        end
        function set.SampleRateOut(obj,Fs)
            coder.internal.errorIf(~isnumeric(Fs) || ~isscalar(Fs)...
                || ~isreal(Fs) || Fs <= 0, ['dsp:system',...
                ':NotchPeakFilter:sampleRate']);
            obj.SampleRateOut = Fs;
            needToDesignFilters(obj);
        end
        function set.Bandwidth(obj,bw)
            coder.internal.errorIf(~isnumeric(bw) || ~isscalar(bw)...
                || ~isreal(bw) || bw < 0, ['dsp:system',...
                ':NotchPeakFilter:BW']);            
            obj.Bandwidth = bw;
            needToDesignFilters(obj);
        end
        
    end
    
    methods (Access=protected)
        function setupImpl(obj, ~)      
            setfilters(obj);
        end

        function setfilters(obj)
            % Create filter System objects
            
            if obj.AreFiltersDesigned
                % This helps avoid duplicate construction of filters when
                % setup() is called after getFilters().
                % For codegen, this property is always false.
                return
            end
            
            coder.extrinsic('SampleRateConverter.designfilters');
            [s, numStages] = coder.const(@obj.designfilters, ...
                obj.SampleRateIn, obj.SampleRateOut, ...
                obj.Bandwidth, obj.MinimumAliasAttenuation);
            obj.Nstages = numStages;
            for k = coder.unroll(1:obj.MaxFilters, true)
                if k<=obj.Nstages
                    if s.(['rcf',obj.FilterNumber(k)])(1) == 1
                        % Decimator
                        obj.(['filt',obj.FilterNumber(k)]) = dsp.FIRDecimator(...
                            'DecimationFactor',s.(['rcf',obj.FilterNumber(k)])(2),...
                            'Numerator',s.(['coeffs',obj.FilterNumber(k)]));
                    elseif s.(['rcf',obj.FilterNumber(k)])(2) == 1
                        % Interpolator
                        obj.(['filt',obj.FilterNumber(k)]) = dsp.FIRInterpolator(...
                            'InterpolationFactor',s.(['rcf',obj.FilterNumber(k)])(1),...
                            'Numerator',s.(['coeffs',obj.FilterNumber(k)]));
                    else
                        % SRC
                        obj.(['filt',obj.FilterNumber(k)]) = dsp.FIRRateConverter(...
                            'InterpolationFactor',s.(['rcf',obj.FilterNumber(k)])(1),...
                            'DecimationFactor',s.(['rcf',obj.FilterNumber(k)])(2),...
                            'Numerator',s.(['coeffs',obj.FilterNumber(k)]));
                    end
                end
            end
            
            if isempty(coder.target)
                obj.AreFiltersDesigned = true;
            end
        end
        
        function resetImpl(obj)
            % Reset the filters
            
            for k = coder.unroll(1:obj.MaxFilters, true)
                if k<=obj.Nstages           
                    reset(obj.(['filt',obj.FilterNumber(k)]));
                end
            end
        end
        
        function releaseImpl(obj)
            % Release the filters 
            
            for k = coder.unroll(1:obj.MaxFilters, true)
                if k<=obj.Nstages           
                    release(obj.(['filt',obj.FilterNumber(k)]));
                end
            end
        end
        
        function y = stepImpl(obj, u)
            
            y1 = step(obj.filt1,u);
            if obj.Nstages > 1
                y2 = step(obj.filt2,y1);
            else
                y = y1;
                return;
            end
            if obj.Nstages > 2
                y3 = step(obj.filt3,y2);
            else
                y = y2;
                return;
            end
            if obj.Nstages > 3
                y4 = step(obj.filt4,y3);
            else
                y = y3;
                return;
            end
            if obj.Nstages > 4
                y5 = step(obj.filt5,y4);
            else
                y = y4;
            end
            if obj.Nstages > 5
                y6 = step(obj.filt6,y5);
            else
                y = y5;
            end
            if obj.Nstages > 6
                y7 = step(obj.filt7,y6);
            else
                y = y6;
            end
            if obj.Nstages > 7
                y8 = step(obj.filt8,y7);
            else
                y = y7;
            end
            if obj.Nstages > 8
                y = step(obj.filt9,y8);
            end
        end
        
        function validateInputsImpl(obj,u)

             validateattributes(u, {'single', 'double'}, {'2d'},'','')%#ok<EMCA>
            
        end        

        function validatePropertiesImpl(obj)

            Fs = obj.SampleRateOut;

            % Bandwidth must be between 0 and Fs/2.
            BW = obj.Bandwidth;
            coder.internal.errorIf(BW < 0 || BW >= Fs, ['dsp:system',...
                ':NotchPeakFilter:BW']);

        end
        
        function N = getNumInputsImpl(~)
            % Specify number of System inputs
            N = 1; % Because stepImpl has one argument beyond obj
        end
        
        function N = getNumOutputsImpl(~)
            % Specify number of System outputs
            N = 1; % Because stepImpl has two outputs
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);
            
            % Private properties
            s.Apass = obj.Apass;
            s.Astop = obj.MinimumAliasAttenuation;
            s.Nstages = obj.Nstages;
            s.filt1 = obj.filt1;
            s.filt2 = obj.filt2;
            s.filt3 = obj.filt3;
            s.filt4 = obj.filt4;
            s.filt5 = obj.filt5;
            s.filt6 = obj.filt6;
            s.filt7 = obj.filt7;
            s.filt8 = obj.filt8;
            s.filt9 = obj.filt9;
            s.AreFiltersDesigned = obj.AreFiltersDesigned;
        end
        
        function s = loadObjectImpl(obj, s, wasLocked)
            % Private properties
            obj.Apass = s.Apass;
            obj.MinimumAliasAttenuation = s.Astop;
            obj.Nstages = s.Nstages;
            obj.filt1 = s.filt1;
            obj.filt2 = s.filt2;
            obj.filt3 = s.filt3;
            obj.filt4 = s.filt4;
            obj.filt5 = s.filt5;
            obj.filt6 = s.filt6;
            obj.filt7 = s.filt7;
            obj.filt8 = s.filt8;
            obj.filt9 = s.filt9;

            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
            
            obj.AreFiltersDesigned = s.AreFiltersDesigned;
        end
        
        function needToDesignFilters(obj)
            obj.AreFiltersDesigned = false;
        end
        
    end
    
    methods
        function filters = getFilters(obj)
             %S = getFilters(obj) get filters
             %   S = getFilters(obj) returns the multirate filters used to
             %   perform the sampling rate conversion in a structure S.
             %   Each field of the structure holds the filter used at a
             %   given stage. The stages are cascaded together in order to
             %   perform the overall rate conversion.
             %   % Example: Analysis of filters used for sample rate
             %   % conversion between 192 kHz and 44.1 kHz
             %   SRC = dspdemo.SampleRateConverter;
             %   f = getFilters(SRC);
             %   fvtool(f.Stage1,f.Stage2,f.Stage3,...
             %      'Fs',[192e3 96e3 48e3*147],...
             %      'NormalizeMagnitudeto1','on')
            
            if ~obj.AreFiltersDesigned
                setfilters(obj);
                obj.AreFiltersDesigned = true;
            end
            
            for idx = 1:obj.Nstages
                filters.(['Stage', num2str(idx)]) = obj.(['filt', num2str(idx)]);
            end
            
        end
    end
    
    methods (Static, Hidden)
        function [s, Nstages] = designfilters(SampleRateIn, SampleRateOut, ...
                Bandwidth, Astop)
            % Over all parameters
            Fs_in = SampleRateIn;
            Fs_out = SampleRateOut;
            l = lcm(Fs_in,Fs_out);
            L = l/Fs_in; % Overall interpolation
            M = l/Fs_out; % Overall decimation
            FM = sort([cumprod(fliplr(factor(M))) cumprod(factor(M))]);
            FL = sort([cumprod(fliplr(factor(L))) cumprod(factor(L))]);
            BW = Bandwidth;
            TW = min(Fs_in,Fs_out) - BW; % Overall transition width
            
            
            % Decimate first if at all possible; Determine Optimal decimation
            M1max = floor(SampleRateIn/SampleRateOut);
            if M1max > 1
                M1 = FM(find(FM <= M1max,1,'last'));
            else
                M1 = 1;
            end
            TW1 = (SampleRateIn/M1 - Bandwidth);
            
            if M1 > 1
                useMultistageDecim = true;
                % Design multistage decimator
                fmd = fdesign.decimator(M1,'Nyquist',M1,...
                    TW1,Astop,SampleRateIn);
                if M1 == 2
                    hmd = equiripple(fmd);
                else
                    hmd = multistage(fmd,'HalfbandDesignMethod','equiripple');
                end
            else
                useMultistageDecim = false;
            end
            
            if L == 1
                needMoreFilts = false;
            else
                needMoreFilts = true;
            end
            
            
            if needMoreFilts
                if M/M1 > 1
                    useSRC = true;
                    % SRC needed, design it 
                    SampleRateAfterDecim = SampleRateIn/M1;
                    % Design an SRC that doesn't reduce the rate if possible
                    L1 = FL(find(FL > M/M1,1,'first'));
                    if isempty(L1)
                        % If have to reduce the rate, just interpolate by full
                        % factor
                        L1 = L;
                    end
                    fsrc = fdesign.rsrc(L1,M/M1,'Nyquist',max(L1,M/M1),...
                        TW1,Astop,SampleRateAfterDecim*L1);
                    hsrc = kaiserwin(fsrc);
                else
                    useSRC = false;
                    L1 = 1;
                end
                
                if L1 < L
                    SampleRateAfterSRC = SampleRateIn*L1/M;
                    useMultistageInterp = true;
                    % Try multistage interpolation but never interpolate beyond
                    % final sampleRateOut                                            
                    fmi = fdesign.interpolator(L/L1,'Nyquist',L/L1,...
                        TW,Astop,SampleRateAfterSRC*L/L1);
                    if L/L1 == 2
                        hmi = equiripple(fmi);
                    else
                        hmi = multistage(fmi,'HalfbandDesignMethod','equiripple');
                    end
                    
                else
                    useMultistageInterp = false;                  
                end
            end
            
            finalIdx = 0;
            s = struct;
            if useMultistageDecim
                if isa(hmd,'mfilt.firdecim'),
                    % Single-stage decimator
                    finalIdx = finalIdx + 1;
                    s.(['coeffs',num2str(finalIdx)]) = ...
                        hmd.Numerator;
                    s.(['rcf',num2str(finalIdx)]) = ...
                        [1, hmd.DecimationFactor];
                else
                    for k = 1:nstages(hmd)
                        finalIdx = finalIdx + 1;
                        s.(['coeffs',num2str(finalIdx)]) = ...
                            hmd.Stage(k).Numerator;
                        s.(['rcf',num2str(finalIdx)]) = ...
                            [1,hmd.Stage(k).DecimationFactor];
                    end
                end
            end
            
            if needMoreFilts
                if useSRC
                    finalIdx = finalIdx + 1;
                    s.(['coeffs',num2str(finalIdx)]) = ...
                        hsrc.Numerator;
                    s.(['rcf',num2str(finalIdx)]) = ...
                        hsrc.RateChangeFactors;
                end
                
                if useMultistageInterp
                    if isa(hmi,'mfilt.firinterp'),
                        % Single-stage interpolator
                        finalIdx = finalIdx + 1;
                        s.(['coeffs',num2str(finalIdx)]) = ...
                            hmi.Numerator;
                        s.(['rcf',num2str(finalIdx)]) = ...
                            [hmi.InterpolationFactor, 1];
                    else
                        for k = 1:nstages(hmi)
                            finalIdx = finalIdx + 1;
                            s.(['coeffs',num2str(finalIdx)]) = ...
                                hmi.Stage(k).Numerator;
                            s.(['rcf',num2str(finalIdx)]) = ...
                                [hmi.Stage(k).InterpolationFactor, 1];
                        end
                    end
                end
            end
            
            Nstages = finalIdx;
        end
    end
end

