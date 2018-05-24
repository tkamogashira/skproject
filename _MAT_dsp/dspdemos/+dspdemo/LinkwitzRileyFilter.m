classdef LinkwitzRileyFilter < matlab.System
%LinkwitzRileyFilter Linkwitz-Riley crossover filter.
    %   H = dspdemo.LinkwitzRileyFilter returns a Linkwitz-Riley crossover
    %   filter which independently filters each channel of the input over
    %   time.
    %
    %   H = dspdemo.LinkwitzRileyFilter('Name', Value, ...) returns a
    %   Linkwitz-Riley crossover filter with each specified property name
    %   set to the specified value. You can specify additional name-value
    %   pair arguments in any order as (Name1,Value1,...,NameN,ValueN).
    %
    %   Step method syntax:
    %
    %   [Ylp,Yhp] = step(H, X) filters the real or complex input signal X
    %   using the specified filter to produce the lowpass branch output,
    %   Ylp, and the highpass branch output, Yhp. The filter processes each
    %   channel of the input signal (each column of X) independently over
    %   time. For an even crossover filter order N, the lowpass and
    %   highpass branches are formed of a cascade of two lowpass and two
    %   highpass Butterworth filters of order N/2, respectively. For odd N,
    %   the lowpass and highpass branches are formed of one lowpass and
    %   highpass Butterworth filter of order N, respectively. When N is
    %   even and N/2 is odd, Ylp - Yhp has an all-pass characteristic. When
    %   N is even and N/2 is even, or when N is odd, Ylp + Yhp has an
    %   all-pass characteristic.
    %
    %   LinkwitzRileyFilter methods:
    %
    %   step       - See above description for use of this method 
    %   release    - Allow property value and input characteristics changes 
    %   clone      - Create LinkwitzRileyFilter object with same property 
    %                values
    %   isLocked   - Locked status (logical) 
    %   reset      - Reset the internal states to initial conditions
    %
    %   LinkwitzRileyFilter properties:
    %
    %   SampleRate                   - Input sample rate
    %   CrossoverFrequency           - Filter crossover frequency
    %   FilterOrder                  - Crossover filter order
    %
    % %Example - Plot the transfer function of an Eighth order
    % %Linkwitz–Riley crossover (LR8)
    % hlr = dspdemo.LinkwitzRileyFilter('FilterOrder',8,...
    %                                   'SampleRate',44.1e3,...
    %                                   'CrossoverFrequency',5000);
    % hsa = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
    %                                     'SpectralAverages',20);
    % frameLength = 1024;
    % hplot = dsp.ArrayPlot(...
    %       'PlotType','Line','YLimits', [-40 1],...
    %            'YLabel','Magnitude (dB)',...
    %            'SampleIncrement',22.05e3/(frameLength/2+1),...
    %            'XLabel','Frequency (Hz)',...
    %            'Title','Order-8 Linkwitz-Riley Crossover Filter',...
    %            'ShowLegend', true);
    % for i=1:50
    %     in = rand(1024,1);
    %     [ylp,yhp] = step(hlr,in);
    %     y = ylp+yhp;
    %     v = step(hsa,[in in in],real([ylp yhp y]));
    %     step(hplot,db(v)); 
    % end

    % Copyright 2013 The MathWorks, Inc.
    
    properties (Nontunable)
        %SampleRate Sample rate of input
        %   Specify the sample rate of the input in Hertz as a finite
        %   numeric scalar. The default is 44100 Hz.
        SampleRate = 44100;
        %CrossoverFrequency Filter crossover frequency
        %   Specify the crossover frequency of the filter in Hertz as a
        %   finite numeric scalar. The crossover frequency cannot exceed
        %   the Nyquist rate. The default is 1 KHz.
        CrossoverFrequency = 1e3;
        %FilterOrder Crossover filter order
        %   Specify the filter order as a positive scalar integer. For an
        %   even crossover filter order N, the lowpass and highpass
        %   branches are formed of a cascade of two lowpass and highpass
        %   Butterworth filters of order N/2, respectively. For odd N, the
        %   lowpass and highpass branches are formed of one lowpass and
        %   highpass Butterworth filter of order N, respectively. The
        %   default is 8.
        FilterOrder = 8;
    end
    
    properties (Access = private)
       % pFrontLPFilter First Butterworth filter in the lowpass branch
       pFrontLPFilter 
       % pFrontHPFilter First Butterworth filter in the highpass branch
       pFrontHPFilter
       % pBackLPFilter Second Butterworth filter in the lowpass branch
       pBackLPFilter
       % pBackHPFilter Second Butterworth filter in the highpass branch
       pBackHPFilter
    end

    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods
        % Constructor
        function obj = LinkwitzRileyFilter(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    %----------------------------------------------------------------------
    % Protected methods
    %----------------------------------------------------------------------
    methods(Access = protected)
        
        function out = getNumOutputsImpl(~)
            % Lowpass and highpass outputs
            out = 2;
        end
        
        function [yLP,yHP] = stepImpl(obj, x)
            if mod(obj.FilterOrder,2) == 0
                yLP0 = step(obj.pFrontLPFilter,x);
                yHP0 = step(obj.pFrontHPFilter,x);
                yLP =  step(obj.pBackLPFilter,yLP0);
                yHP =  step(obj.pBackHPFilter,yHP0);
            else
                yLP = step(obj.pFrontLPFilter,x);
                yHP = step(obj.pFrontHPFilter,x);
            end
        end
        
        function setupImpl(obj, ~)
           % Define the design function as extrinsic
           coder.extrinsic('dspdemo.LinkwitzRileyFilter.designCoefficients');
           % Return the coefficients of the lowpass and higpass Butterwirth
           % filters:
            [bL,aL,bH,aH] = coder.const(@obj.designCoefficients,...
                               obj.FilterOrder,...
                              (2 * obj.CrossoverFrequency/obj.SampleRate));
            % setup the Butterworth filters
            % Even order LR: Cascade of two butter filters
            % Odd order LR:  One butter filter
            obj.pFrontLPFilter  = dsp.IIRFilter('Numerator', bL,...
                                               'Denominator',aL);
            obj.pFrontHPFilter  = dsp.IIRFilter('Numerator', bH,...
                                               'Denominator',aH);
            if mod(obj.FilterOrder,2) == 0
                obj.pBackLPFilter = dsp.IIRFilter('Numerator', bL,...
                                                  'Denominator',aL);
                obj.pBackHPFilter = dsp.IIRFilter('Numerator', bH,...
                                                  'Denominator',aH);
            end
        end
        
        function  resetImpl(obj)
            % Reset the Butterworth filters
            reset(obj.pFrontLPFilter);
            reset(obj.pFrontHPFilter);
            if mod(obj.FilterOrder,2) == 0
                reset(obj.pBackLPFilter);
                reset(obj.pBackHPFilter);
            end
        end
        
        function  releaseImpl(obj)
            % Release the Butterworth filters
            release(obj.pFrontLPFilter);
            release(obj.pFrontHPFilter);
            if mod(obj.FilterOrder,2) == 0
                release(obj.pBackLPFilter);
                release(obj.pBackHPFilter);
            end
        end
        
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                s.pFrontLPFilter = matlab.System.saveObject(obj.pFrontLPFilter);
                s.pFrontHPFilter = matlab.System.saveObject(obj.pFrontHPFilter);
               if mod(obj.FilterOrder,2)==0
                   s.pBackLPFilter = matlab.System.saveObject(obj.pBackLPFilter);
                   s.pBackHPFilter = matlab.System.saveObject(obj.pBackHPFilter);
               end
            end
        end
        
        function loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                obj.pFrontLPFilter = matlab.System.loadObject(s.pFrontLPFilter);
                obj.pFrontHPFilter = matlab.System.loadObject(s.pFrontHPFilter);
               if mod(obj.FilterOrder,2)==0
                   obj.pBackLPFilter = matlab.System.saveObject(s.pBackLPFilter);
                   obj.pBackHPFilter = matlab.System.saveObject(s.pBackHPFilter);
               end
            end
            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
    end
    
    methods (Static, Hidden)
        function [bL,aL,bH,aH] = designCoefficients(order,wc)
            % For even orders N, the crossover is formed of filters of
            % order N/2
            if mod(order,2)==0
               order = order/2; 
            end
            [bL,aL]=butter(order,wc);
            [bH,aH]=butter(order,wc,'high');
        end
        
    end
    
end
