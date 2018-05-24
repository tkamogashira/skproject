classdef DynamicRangeExpander < dspdemo.private.DynamicRangeBase & matlab.system.mixin.CustomIcon 
    %DynamicRangeExpander Dynamic range expander
    %   HEXP = dspdemo.DynamicRangeExpander returns a System object,
    %   HEXP, which independently dynamically expands each channel of
    %   the input over time using specified expansion specifications.
    %
    %   H = dsp.DynamicRangeExpander('Name', Value, ...) returns a
    %   dynamic expander System object, H, with each specified property
    %   name set to the specified value. You can specify additional
    %   name-value pair arguments in any order as (Name1,Value1,...,NameN,
    %   ValueN).
    %
    %   Step method syntax:
    %
    %   Y = step(H, X) expands the input signal X to produce the output Y.
    %   The System object expands each channel of the input signal
    %   independently over time.
    %
    %   DynamicRangeExpander methods:
    %
    %   step      - See above description for use of this method
    %   release   - Allow property value and input characteristics changes
    %   clone     - Create Dynamic Range Expander object with
    %               same property values
    %   isLocked  - Locked status (logical)
    %   reset     - Reset the internal states to initial conditions
    %
    %   DynamicRangeCompressor properties:
    %
    %   SampleRate                 - Sample rate of input
    %   ExpansionRatio             - Expansion ratio
    %   Threshold                  - Expansion threshold
    %   KneeWidth                  - Knee width
    %   AttackTime                 - Attack time
    %   ReleaseTime                - Release time
    %   MakeUpGain                 - Make-up gain
    %
    %  % EXAMPLE: Expand a variable-amplitude sine wave input.
    %   Fs = 8000; % Sample rate 
    %   HEXP = dspdemo.DynamicRangeExpander('SampleRate',Fs,...
    %                                       'AttackTime',50e-3,...
    %                                       'ReleaseTime',100e-3,...
    %                                       'KneeWidth',5);
    %   L = Fs/5; % Frame length
    %   hsin = dsp.SineWave('Frequency',50,...
    %                       'SampleRate',Fs,...
    %                       'SamplesPerFrame',L);
    %   count = 4;
    %   gain = [1 0.3 2 .8];
    %   x = zeros(count*L,1);
    %   y = zeros(count*L,1);
    %   % Compress varying-amplitude sine wave
    %   for i=1:count
    %     xin = gain(i) * step(hsin);
    %     y(1+(i-1)*L:i*L) = step(HEXP,xin);
    %     x(1+(i-1)*L:i*L) = xin;
    %   end
    %   hfig = figure;
    %   t = (1/Fs) * (0:4*L-1);
    %   plot(t,x);
    %   hold on; grid on;
    %   plot(t,y,'r')
    %   xlabel('Time (sec)')
    %   ylabel('Amplitude')
    %   title('Dynamic Range Expander applied to sine wave input')
    %   legend('Input','Expanded Output')
    %  
    %   % Plot the static expansion characterstic
    %   hfig2 = figure;
    %   pos = get(hfig,'Position');
    %   set(hfig2,'Position',[pos(1) pos(2)-1.3*pos(4),pos(3),pos(4)])
    %   xdB    = -10:0.01:0;xdB=xdB.';
    %   gaindB = computeGain(HEXP,xdB);
    %   G = computeGain(HEXP,xdB);
    %   plot(xdB,G+xdB)
    %   grid on;
    %   title('Static Expansion Characterstic')
    %   xlabel('Input (dB)')
    %   ylabel('Output (dB)')

    %#codegen
    %#ok<*EMCLS>
    
    % Copyright 2013 The MathWorks, Inc.
   
    properties
        %ExpansionFactor Expansion factor
        %   Specify the expansion factor as a real scalar greater than or
        %   equal to 1. The default is 5.
        ExpansionFactor = 5;

    end

    %--------------------------------------------------------------------------
    % Public methods
    %--------------------------------------------------------------------------
    methods
        % Constructor
        function obj = DynamicRangeExpander(varargin)
            obj@dspdemo.private.DynamicRangeBase(varargin{:})
        end
    end
    
    %--------------------------------------------------------------------------
    % Protected methods
    %--------------------------------------------------------------------------
    methods(Access = public)
        function  G = computeGain(obj,xG)
            
            W = obj.KneeWidth;
            R = obj.ExpansionFactor;
            T = obj.Threshold;
            
            yG = zeros(size(xG),'like',xG);
            ind1 = 2*(xG-T)<=-W;
            yG(ind1) = T + (xG(ind1) - T) * R;
            
            ind2 = 2*(xG-T)>W;
            yG(ind2)  =  xG(ind2);
            
            if (W ~=0)
                ind3 = 2*abs((xG-T))<=W;
                yG(ind3) = xG(ind3) + (1 - R) * (xG(ind3) - T - W/2).^2 ./ (2*W);
            end
            
            G  = yG - xG;
        end
        
    end
    
    methods (Access = protected, Static)
        function group = getPropertyGroupsImpl
            % Modify order of display
            group = matlab.system.display.Section('Title','Parameters');
            group.PropertyList = {'SampleRate','ExpansionFactor','Threshold',...
                'KneeWidth', 'AttackTime',...
                'ReleaseTime', 'MakeUpGain'}; %#ok
        end
    end
    
    methods (Access = protected)
        function icon = getIconImpl(~)
            % MATLAB system block icon
            icon = sprintf('Dynamic Range\nExpander');
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