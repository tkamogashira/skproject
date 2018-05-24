classdef MultibandCrossoverFilter < matlab.System & matlab.system.mixin.CustomIcon 
%MultibandCrossoverFilter Multiband crossover filter.
    %   H = dspdemo.MultibandCrossoverFilter returns a multiband crossover
    %   filter which independently filters each channel of the input over
    %   time.
    %
    %   H = dspdemo.MultibandCrossoverFilter('Name', Value, ...) returns a
    %   MultibandCrossoverFilter crossover filter with each specified
    %   property name set to the specified value. You can specify
    %   additional name-value pair arguments in any order as
    %   (Name1,Value1,...,NameN,ValueN).
    %
    %   Step method syntax:
    %
    %   [yband1,yband2,..ybandN] = step(H, X) filters the real or complex
    %   input signal X using the specified filter to produce the band
    %   outputs yband1,yband2,..ybandN, where N is the specified number of
    %   bands. The filter processes each channel of the input signal (each
    %   column of X) independently over time.
    %
    %   MultibandCrossoverFilter methods:
    %
    %   step       - See above description for use of this method 
    %   release    - Allow property value and input characteristics changes 
    %   clone      - Create MultibandCrossoverFilter object with same 
    %                property values
    %   isLocked   - Locked status (logical) 
    %   reset      - Reset the internal states to initial conditions
    %
    %   MultibandCrossoverFilter properties:
    %
    %   SampleRate                   - Input sample rate
    %   CrossoverFilterOrder         - Crossover filter order
    %   CrossoverFrequencies         - Filter crossover frequencies
    %
    % % Example- Filter input through 4-band crossover filter. Notice the
    % % allpass response of the sum of the four bands 
    % htfe = dsp.TransferFunctionEstimator('FrequencyRange','onesided',...
    %                                      'SpectralAverages',20);
    % L = 2^14; 
    % SampleRate = 44100; 
    % hCrossOver = dspdemo.MultibandCrossoverFilter('NumBands',4,...
    %                             'CrossoverFrequencies',[2e3 5e3 10e3],... 
    %                             'SampleRate',SampleRate);
    % hplot = dsp.ArrayPlot('PlotType','Line',...
    %         'XOffset',0,... 
    %         'YLimits',[-120 5],...
    %         'SampleIncrement', .5 * hCrossOver.SampleRate/(L/2 + 1),...
    %         'YLabel','Frequency Response(dB)',... 
    %         'XLabel','Frequency (Hz)',... 
    %         'Title','4-Band Crossover Filter',...
    %         'ShowLegend',true);
    % hsin = dsp.SineWave('Frequency', 800 ,...
    %                     'SampleRate',22050,...
    %                     'SamplesPerFrame',L);
    % for i=1:10
    %    in = randn(L,1) + step(hsin); 
    %    [yLP,yBP,yBP2,yHP] = step(hCrossOver,in); 
    %    z = step(htfe,[in,in,in,in,in],...
    %        [yLP,yBP,yBP2,yHP,yLP+yHP+yBP+yBP2]);
    %    step(hplot,20*log10(abs(z)))
    % end

    % Copyright 2013 The MathWorks, Inc.
    
    %#codegen
    %#ok<*EMCLS>
    
    properties (Nontunable)
        %SampleRate Sample rate of input
        %   Specify the sample rate of the input in Hertz as a finite
        %   numeric scalar. The default is 44100 Hz.
        SampleRate = 44100;
        %CrossoverFilterOrder Crossover filter order
        %   Specify the order of the Linkwitz-Riley filters forming the
        %   multiband crossover filter as a positive scalar integer. The
        %   default is 8.
        CrossoverFilterOrder = 8;
        % NumBands Number of bands
        %   Specify the number of bands as a positive scalar integer. The 
        %   default is 2.  
        NumBands = 2;
        %CrossoverFrequencies Filter crossover frequencies
        %   Specify the crossover frequencies of the filter in Hertz as a
        %   vector of length NumBands-1. The frequencies must be less than
        %   the Nyquist rate. the default is 5 KHz. 
        CrossoverFrequencies = 5000;
    end

    properties (Access = private)
        % Handles to filters comprising the multiband crossover filter pLR#
        % are the Linkwitz-Riley (LR) filters. The number of required LR
        % filters is equal to NumBands - 1. pAP# are allpass filters used
        % to make the sure the sum of all the bands is all-pass.
        pLR1;
        pLR2;
        pLR3;
        pLR4;
        pAP1;
        pAP2;
        pAP3;
        pAP4;
    end

    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods
        % Constructor
        function obj = MultibandCrossoverFilter(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    %----------------------------------------------------------------------
    % Protected methods
    %----------------------------------------------------------------------
    methods(Access = protected)
        
        function out = getNumOutputsImpl(obj)
            % One output per band
            out = obj.NumBands;
        end
        
        function varargout = stepImpl(obj, x)
            switch obj.NumBands
                case {2}
                    % 2 bands is equivalent to a Linkwitz-Riley filter. No
                    % allpass filters are reuqired to force the output to
                    % be allpass.
                    %                     
                    %           ---- LP1
                    %          |          
                    %       x -
                    %          |                
                    %           ---- HP1
                    %        
                    [ylow,yhigh]= step(obj.pLR1,x);
                    varargout{1} = ylow;
                    varargout{2} = yhigh;
                    
                case {3}   
                    % y1  = LP1.LP2.x
                    % y2  = LP1.HP2.x
                    % y3  = HP1.AP1.x
                    % AP1 = LP2 + HP2
                    % y1 + y2 + y3 = (LP1+HP1).(LP2+HP2).x (allpass)
                    %
                    %                     | LP2
                    %           ----LP1----
                    %          |          | HP2
                    %       x -
                    %          |                
                    %           ----HP1---- AP1
                    %                           
                    [outL,outH] = step(obj.pLR1,x);
                    [y1,y2] = step(obj.pLR2,outL);
                    [y3L,y3H] = step(obj.pAP1,outH);
                    y3 = y3L + y3H;
                    varargout{1} = y1;
                    varargout{2} = y2;
                    varargout{3} = y3;
                    
                case {4} 
                    % y1  = LP1.LP2.AP2.x
                    % y2  = LP1.HP2.AP2.x
                    % y3  = HP1.LP3.AP1.x
                    % y4  = HP1.HP3.AP1.x
                    % AP1 = LP2 + HP2
                    % AP2 = LP3 + HP3
                    % y1 + y2 + y3 + y4 = (LP1+HP1).(LP2+HP2).(LP3+HP3).x
                    %   
                    %                            | LP2
                    %           ----LP1----AP2----
                    %          |                 | HP2
                    %       x -
                    %          |                 | LP3
                    %           ----HP1----AP1----
                    %                            | HP3

                    [outL,outH] = step(obj.pLR1,x);
                    
                    [outLL,outLH] = step(obj.pAP2,outL);
                    outL = outLL + outLH;
                    [y1,y2] = step(obj.pLR2,outL);
                    
                    [outHL,outHH] = step(obj.pAP1,outH);
                    outH = outHL + outHH;
                    [y3,y4] = step(obj.pLR3,outH);
                    
                    varargout{1} = y1;
                    varargout{2} = y2;
                    varargout{3} = y3;
                    varargout{4} = y4;
         
                case {5}  
                    % y1 = LP1.LP2.LP3.AP4.x
                    % y2 = LP1.LP2.HP3.AP4.x
                    % y3 = LP1.HP2.AP5.AP3.x
                    % y4 = HP1.LP4.AP1.AP2.x
                    % y5 = HP1.HP4.AP1.AP2.x
                    % AP4 = LP4 + HP4
                    % AP3 = LP3 + HP3
                    % AP1 = LP2 + HP2
                    % AP2 = LP3 + HP3
                    %
                    %                                    | LP3
                    %                            | LP2 ---
                    %                            |       | HP3
                    %           ----LP1----AP4----
                    %          |                 | HP2 --- AP3
                    %       x -
                    %          |                         | LP4
                    %           ----HP1----AP2---AP1------
                    %                                    | HP4

                    [outL,outH] = step(obj.pLR1,x);
                    
                    [out3a,outb] = step(obj.pAP4,outL);
                    out3 = out3a + outb;
                    
                    [out_low2,out_high2] =  step(obj.pLR2,out3);
                    
                    [y1,y2] = step(obj.pLR3,out_low2);
                     
                    [y3a,y3b] = step(obj.pAP3,out_high2);
                    y3 = y3a + y3b;
                    
                    [out8a,out8b] = step(obj.pAP2,outH);
                    out8 = out8a + out8b;
                    [out9a,out9b] = step(obj.pAP1,out8);
                    out9 = out9a + out9b;
                    
                    [y4,y5] = step(obj.pLR4,out9);
                    
                    varargout{1} = y1;
                    varargout{2} = y2;
                    varargout{3} = y3;
                    varargout{4} = y4;
                    varargout{5} = y5;
   
                otherwise
            end
        end
        
        function setupImpl(obj, ~)
            switch obj.NumBands
                case {2}
                    setup2Bands(obj);
                case {3}
                    setup3Bands(obj);
                case {4}
                    setup4Bands(obj);
                case {5}
                    setup5Bands(obj);
                otherwise
            end
        end
        
        function setup2Bands(obj)
            % 2 bands is equivalent to a Linkwitz-Riley filter. No
            % allpass filters are reuqired to force the output to
            % be allpass.
            %
            %           ---- LP1
            %          |
            %       x -
            %          |
            %           ---- HP1
            %
            obj.pLR1 = dspdemo.LinkwitzRileyFilter(...
                         'FilterOrder',obj.CrossoverFilterOrder,...
                         'SampleRate',obj.SampleRate,...
                         'CrossoverFrequency',obj.CrossoverFrequencies(1));
        end
        
        function setup3Bands(obj)
            % y1  = LP1.LP2.x
            % y2  = LP1.HP2.x
            % y3  = HP1.AP1.x
            % AP1 = LP2 + HP2
            % y1 + y2 + y3 = (LP1+HP1).(LP2+HP2).x (allpass)
            %
            %                     | LP2
            %           ----LP1----
            %          |          | HP2
            %       x -
            %          |
            %           ----HP1---- AP1
            %
            obj.pLR1 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(2));
            obj.pLR2 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
            obj.pAP1 =  dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
        end

        function setup4Bands(obj)
            % y1  = LP1.LP2.AP2.x
            % y2  = LP1.HP2.AP2.x
            % y3  = HP1.LP3.AP1.x
            % y4  = HP1.HP3.AP1.x
            % AP1 = LP2 + HP2
            % AP2 = LP3 + HP3
            % y1 + y2 + y3 + y4 = (LP1+HP1).(LP2+HP2).(LP3+HP3).x
            %
            %                            | LP2
            %           ----LP1----AP2----
            %          |                 | HP2
            %       x -
            %          |                 | LP3
            %           ----HP1----AP1----
            %                            | HP3
            
            obj.pLR1 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(2));
            
            obj.pLR2 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
            obj.pAP1 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
            
            obj.pLR3 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(3));
            obj.pAP2 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(3));
        end
        
        function setup5Bands(obj)
            % y1 = LP1.LP2.LP3.AP4.x
            % y2 = LP1.LP2.HP3.AP4.x
            % y3 = LP1.HP2.AP4.AP3.x
            % y4 = HP1.LP4.AP1.AP2.x
            % y5 = HP1.HP4.AP1.AP2.x
            % AP4 = LP4 + HP4
            % AP3 = LP3 + HP3
            % AP1 = LP2 + HP2
            % AP2 = LP3 + HP3
            %
            %                                    | LP3
            %                            | LP2 ---
            %                            |       | HP3
            %           ----LP1----AP4----
            %          |                 | HP2 --- AP3
            %       x -
            %          |                         | LP4
            %           ----HP1----AP2---AP1------
            %                                    | HP4
            
            obj.pLR1 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(3));
            obj.pLR2 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(2));
            obj.pAP1 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(2));
            
            obj.pLR3 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
            obj.pAP2 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
            obj.pAP3 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(1));
            
            obj.pLR4 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(4));
            obj.pAP4 = dspdemo.LinkwitzRileyFilter(...
                'FilterOrder',obj.CrossoverFilterOrder,...
                'SampleRate',obj.SampleRate,...
                'CrossoverFrequency',obj.CrossoverFrequencies(4));
            
        end
        
         function icon = getIconImpl(~)
            % MATLAB system block icon
            icon = sprintf('Multiband Crossover\nFilter');
        end
        
        function flag = isInputSizeLockedImpl(~,varargin)
            flag = true;
        end
        
        function  resetImpl(obj)
            switch obj.NumBands
                case {2}
                    reset2Bands(obj);
                case {3}
                    reset3Bands(obj);
                case {4}
                    reset4Bands(obj);
                case {5}
                    reset5Bands(obj);
                otherwise
            end
        end
        
        function reset2Bands(obj)
            reset(obj.pLR1);
        end
        
        function reset3Bands(obj)
            reset(obj.pLR1);
            reset(obj.pLR2);
            reset(obj.pAP1);
        end
        
        function reset4Bands(obj)
            reset(obj.pLR1);
            reset(obj.pLR2);
            reset(obj.pLR3);
            reset(obj.pAP1);
            reset(obj.pAP2);
        end
        
        function reset5Bands(obj)
            reset(obj.pLR1);
            reset(obj.pLR2);
            reset(obj.pLR3);
            reset(obj.pLR4);
            reset(obj.pAP1);
            reset(obj.pAP2);
            reset(obj.pAP3);
            reset(obj.pAP4);
        end

        function  releaseImpl(obj)
            switch obj.NumBands
                case {2}
                    release2Bands(obj);
                case {3}
                    release3Bands(obj);
                case {4}
                    release4Bands(obj);
                case {5}
                    release5Bands(obj);
                otherwise
            end
        end
        
        function release2Bands(obj)
            release(obj.pLR1);
        end
        
        function release3Bands(obj)
            release(obj.pLR1);
            release(obj.pLR2);
            release(obj.pAP1);
        end
        
        function release4Bands(obj)
            release(obj.pLR1);
            release(obj.pLR2);
            release(obj.pLR3);
            release(obj.pAP1);
            release(obj.pAP2);
        end
        
        function release5Bands(obj)
            release(obj.pLR1);
            release(obj.pLR2);
            release(obj.pLR3);
            release(obj.pLR4);
            release(obj.pAP1);
            release(obj.pAP2);
            release(obj.pAP3);
            release(obj.pAP4);
        end
        
                
        function s = saveObjectImpl(obj)
            % Default implementaion saves all public properties
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                switch obj.NumBands
                    case {2}
                        s.pLR1 = matlab.System.saveObject(obj.pLR1);
                        
                    case {3}
                        s.pLR1 = matlab.System.saveObject(obj.pLR1);
                        s.pLR2 = matlab.System.saveObject(obj.pLR2);
                        s.pAP1 = matlab.System.saveObject(obj.pAP1);
                    case {4}
                        s.pLR1 = matlab.System.saveObject(obj.pLR1);
                        s.pLR2 = matlab.System.saveObject(obj.pLR2);
                        s.pLR3 = matlab.System.saveObject(obj.pLR3);
                        s.pAP1 = matlab.System.saveObject(obj.pAP1);
                        s.pAP2 = matlab.System.saveObject(obj.pAP2);
                    case {5}
                        s.pLR1 = matlab.System.saveObject(obj.pLR1);
                        s.pLR1 = matlab.System.saveObject(obj.pLR1);
                        s.pLR3 = matlab.System.saveObject(obj.pLR3);
                        s.pLR4 = matlab.System.saveObject(obj.pLR4);
                        s.pAP1 = matlab.System.saveObject(obj.pAP1);
                        s.pAP2 = matlab.System.saveObject(obj.pAP2);
                        s.pAP3 = matlab.System.saveObject(obj.pAP3);
                        s.pAP4 = matlab.System.saveObject(obj.pAP4);
                end
            end
            s.pBackLPFilter = matlab.System.saveObject(obj.pBackLPFilter);
        end

        function loadObjectImpl(obj, s, wasLocked)
            % Re-load state if saved version was locked
            if wasLocked
                switch obj.NumBands
                    case {2}
                        obj.pLR1 = matlab.System.loadObject(s.pLR1);
                        
                    case {3}
                        obj.pLR1 = matlab.System.loadObject(s.pLR1);
                        obj.pLR2 = matlab.System.loadObject(s.pLR2);
                        obj.pAP1 = matlab.System.loadObject(s.pAP1);
                    case {4}
                        obj.pLR1 = matlab.System.loadObject(s.pLR1);
                        obj.pLR2 = matlab.System.loadObject(s.pLR2);
                        obj.pLR3 = matlab.System.loadObject(s.pLR3);
                        obj.pAP1 = matlab.System.loadObject(s.pAP1);
                        obj.pAP2 = matlab.System.loadObject(s.pAP2);
                    case {5}
                        obj.pLR1 = matlab.System.loadObject(s.pLR1);
                        obj.pLR1 = matlab.System.loadObject(s.pLR1);
                        obj.pLR3 = matlab.System.loadObject(s.pLR3);
                        obj.pLR4 = matlab.System.loadObject(s.pLR4);
                        obj.pAP1 = matlab.System.loadObject(s.pAP1);
                        obj.pAP2 = matlab.System.loadObject(s.pAP2);
                        obj.pAP3 = matlab.System.loadObject(s.pAP3);
                        obj.pAP4 = matlab.System.loadObject(s.pAP4);
                end
            end
            % Call base class method
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
    end
    
    %----------------------------------------------------------------------
methods(Static, Access=protected)
  function header = getHeaderImpl
    % MATLAB System block header
    header = matlab.system.display.Header(...
         'dspdemo.MultibandCrossoverFilter', ...
         'ShowSourceLink', true,...
         'Title','Multiband Crossover Filter');
  end
end 
end