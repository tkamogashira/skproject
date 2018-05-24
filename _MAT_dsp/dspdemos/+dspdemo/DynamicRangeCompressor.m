classdef DynamicRangeCompressor < dspdemo.private.DynamicRangeBase & matlab.system.mixin.CustomIcon 
    %DynamicRangeCompressor Dynamic range compressor
    %   HCOMP = dspdemo.DynamicRangeCompressor returns a System object,
    %   HCOMP, which independently dynamically compresses each channel of
    %   the input over time using specified compression specifications.
    %
    %   H = dspdemo.DynamicRangeCompressor('Name', Value, ...) returns a
    %   dynamic compressor System object, H, with each specified property
    %   name set to the specified value. You can specify additional
    %   name-value pair arguments in any order as (Name1,Value1,...,NameN,
    %   ValueN).
    %
    %   Step method syntax:
    %
    %   Y = step(H, X) compresses the input signal X to produce the output
    %   Y. The System object compresses each channel of the input signal
    %   independently over time.
    %
    %   DynamicRangeCompressor methods:
    %
    %   step      - See above description for use of this method
    %   release   - Allow property value and input characteristics changes
    %   clone     - Create Dynamic Range Compressor object with same 
    %               property values
    %   isLocked  - Locked status (logical)
    %   reset     - Reset the internal states to initial conditions
    %
    %   DynamicRangeCompressor properties:
    %
    %   SampleRate                 - Sample rate of input
    %   CompressionRatio           - Compression ratio
    %   Threshold                  - Compression threshold
    %   KneeWidth                  - Knee width
    %   AttackTime                 - Attack time
    %   ReleaseTime                - Release time
    %   MakeUpGain                 - Make-up gain
    %
    %   % EXAMPLE: Compress a variable-amplitude sine wave input.
    % Fs = 8000; % Sample rate 
    % hcomp = dspdemo.DynamicRangeCompressor('SampleRate',Fs,...
    %                                        'AttackTime',50e-3,...
    %                                        'ReleaseTime',100e-3,...
    %                                        'KneeWidth',5);
    % L = Fs/5; % Frame length
    % hsin = dsp.SineWave('Frequency',50,...
    %                     'SampleRate',Fs,...
    %                     'SamplesPerFrame',L);
    % count = 4;
    % gain = [1 0.3 2 .8];
    % x = zeros(count*L,1);
    % y = zeros(count*L,1);
    % % Compress varying-amplitude sine wave
    % for i=1:count
    %   xin = gain(i) * step(hsin);
    %   y(1+(i-1)*L:i*L) = step(hcomp,xin);
    %   x(1+(i-1)*L:i*L) = xin;
    % end
    % hfig = figure;
    % t = (1/Fs) * (0:4*L-1);
    % plot(t,x);
    % hold on; grid on;
    % plot(t,y,'r')
    % xlabel('Time (sec)')
    % ylabel('Amplitude')
    % title('Compressed Sine Wave Example')
    % legend('Input','Compressed Output')
    %
    % % Plot the static compression characterstic
    % hfig2 = figure;
    % pos = get(hfig,'Position');
    % set(hfig2,'Position',[pos(1) pos(2)-1.3*pos(4),pos(3),pos(4)])
    % xdB    = -10:0.01:0;xdB=xdB.';
    % gaindB = computeGain(hcomp,xdB);
    % G = computeGain(hcomp,xdB);
    % plot(xdB,G+xdB)
    % grid on;
    % title('Static Compression Characterstic')
    % xlabel('Input (dB)')
    % ylabel('Output (dB)')
    
    %#codegen
    %#ok<*EMCLS>
    
    properties
        %CompressionRatio Compression ratio
        %   Specify the compression ratio as a real scalar greater than or
        %   equal to 1. For input value X (in dB) greater than the
        %   threshold T, the output (in dB) is defined as Y = T + (X-T)/R,
        %   where R is the compression ratio. For example, for a threshold
        %   of -3 dB and a compression ratio of 5, an input of 0 dB is
        %   compressed to -2.4 dB. The default is 5.
        CompressionRatio = 5;
    end
    
    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods
        % Constructor
        function obj = DynamicRangeCompressor(varargin)
            obj@dspdemo.private.DynamicRangeBase(varargin{:})
        end
    end
    
    methods (Access = public)
        
        function  G = computeGain(obj,xG)
            
            W = obj.KneeWidth;
            R = obj.CompressionRatio;
            T = obj.Threshold;
            
            yG = zeros(size(xG),'like',xG);
            ind1 = 2*(xG-T)<=-W;
            yG(ind1) = xG(ind1);
            
            ind2 = 2*(xG-T)>W;
            yG(ind2)  =  T + (xG(ind2) - T)/R;
            
            if (W ~=0)
                ind3 = 2*abs((xG-T))<=W;
                yG(ind3) = xG(ind3) + (1/R - 1) * (xG(ind3) - T + W/2).^2 ./ (2*W);
            end
            
            G  = yG - xG;
        end
        
    end
    
    methods (Access = protected, Static)
        function group = getPropertyGroupsImpl
            % Modify order of display
            group = matlab.system.display.Section('Title','Parameters');
            group.PropertyList = {'SampleRate','CompressionRatio','Threshold',...
                'KneeWidth', 'AttackTime',...
                'ReleaseTime', 'MakeUpGain'}; %#ok
        end
        function header = getHeaderImpl
            % MATLAB System block header
            header = matlab.system.display.Header('dspdemo.DynamicRangeCompressor', ...
                'ShowSourceLink', true, 'Title', 'Dynamic Range Compressor');
        end
    end
    
    methods (Access = protected)
        function icon = getIconImpl(~)
            % MATLAB system block icon
            icon = sprintf('Dynamic Range\nCompressor');
        end
        
        %------------------------------------------------------------------
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@dspdemo.private.DynamicRangeBase (obj);
        end
        %------------------------------------------------------------------
        function loadObjectImpl(obj, s, wasLocked)
            loadObjectImpl@dspdemo.private.DynamicRangeBase (obj,s,wasLocked);
        end
        
    end
    
end