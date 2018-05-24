classdef SignalSource < matlab.System & ...
      matlab.system.mixin.FiniteSource
%SignalSource Import variable from MATLAB workspace
%   HSR = dsp.SignalSource returns a MATLAB variable reader System object,
%   HSR, that outputs the variable one sample or frame at a time.
%
%   HSR = dsp.SignalSource('PropertyName', PropertyValue, ...) returns a
%   MATLAB variable reader System object, HSR, with each specified property
%   set to the specified value.
%
%   HSR = dsp.SignalSource(SIGNAL, SAMPLESPERFRAME, 'PropertyName',
%   PropertyValue, ...) returns a MATLAB variable reader System object,
%   HSR, with the Signal property set to SIGNAL, the SamplesPerFrame
%   property set to SAMPLESPERFRAME, and other specified properties set to
%   the specified values.
%
%   Step method syntax:
%
%   Y = step(HSR) outputs one sample or frame of data, Y, from each column
%   of the specified signal.
%
%   SignalSource methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create signal reader object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset to the beginning of the signal
%   isDone   - True if last sample or frame of signal has been output
%
%   SignalSource properties:
%
%   Signal          - Value of, or variable containing the signal
%   SamplesPerFrame - Number of samples per output frame
%   SignalEndAction - Action after final signal values are generated
%
%   % EXAMPLE #1: Create a SignalSource System object to output one
%   % sample at a time.
%       hsr1 = dsp.SignalSource;
%       hsr1.Signal = randn(1024, 1);
%       y1 = zeros(1024,1);
%       idx = 1;
%       while ~isDone(hsr1)
%         y1(idx) = step(hsr1);  
%         idx = idx+1;
%       end
%
%   % EXAMPLE #2: Create a SignalSource System object to output vectors.
%       hsr2 = dsp.SignalSource(randn(1024, 1), 128);
%       y2 = step(hsr2);  % y2 is a 128-by-1 frame of samples
%
%   See also dsp.SignalSink.

%   Copyright 2007-2013 The MathWorks, Inc.


%#codegen
%#ok<*EMCLS>
%#ok<*EMCA>

  properties (Nontunable)
    %Signal Value of, or variable containing the signal
    %   Specify the name of the MATLAB workspace variable from which to
    %   import the signal, or a valid MATLAB expression specifying the
    %   signal. The default value of this property is (1:10)'.
    Signal = (1:10)';
    %SamplesPerFrame Number of samples per output frame
    %   Specify the number of samples to buffer into each output frame.
    %   This property must be 1 when you specify a 3-D array in the Signal
    %   property. The default value of this property is 1.
    SamplesPerFrame = 1;
    %SignalEndAction Action after final signal values are generated
    %   Specify the output after all of the specified signal samples have
    %   been generated as one of [{'Set to zero'} | 'Hold final value' |
    %   'Cyclic repetition'].
    SignalEndAction = 'Set to zero';
  end

  properties(Constant, Hidden)
    % enum props
    SignalEndActionSet = matlab.system.StringSet({ ...
        'Set to zero',...
        'Hold final value',...
        'Cyclic repetition'...
        });
  end

  properties(DiscreteState)
    pPointer;
    pDoneStatus;
  end

  properties(Access = private, Nontunable)
    pSignalSize;
    pSignalNDims;
    pCyclicRepetition;
    pHoldFinalValue;
    pSignalClass;
    pOutputBuffer;
    pstartindx;
    pendindx;
    puseidx;
  end

  methods
    function obj = SignalSource(varargin)
      coder.allowpcode('plain');
      setProperties(obj, nargin, varargin{:}, 'Signal', 'SamplesPerFrame');
    end

    % PROPERTY VALIDATION
    function set.Signal(obj,val)
      validateattributes( val, {'numeric' , 'embedded.fi' , 'logical'}, {}, '', 'Signal');
      coder.internal.assert(ndims(val) <= 3, ...
          'dsp:system:SignalSource:invalidSignal');      
      obj.Signal = val;
    end

    function set.SamplesPerFrame(obj,val)
      validateattributes( val, ...
        { 'numeric' }, { 'positive', 'integer', 'scalar' }, ...
        '', 'SamplesPerFrame'); %#ok<EMCA>
      obj.SamplesPerFrame = val;
    end

    function set.SignalEndAction(obj,val)
      obj.SignalEndAction = val;
    end
  end

  methods(Access = protected)
    % API
    function out = stepImpl(obj,varargin)
      % reset the pDoneStatus if cycling
      if obj.pDoneStatus && obj.pCyclicRepetition
        obj.pDoneStatus = false;
      end

      tsz = obj.pSignalSize;
      if length(tsz) == 2
        sz = [tsz 1];
      else
        sz = tsz;
      end
      sndims = obj.pSignalNDims;
      Pointer = obj.pPointer;
      startidx = Pointer;
      endidx = Pointer+obj.SamplesPerFrame-1;

      if sndims == 2
        if startidx <= sz(1) && endidx <= sz(1)  % not reached the end
          out = obj.Signal(startidx+(0:obj.SamplesPerFrame-1), :);
          Pointer = Pointer + obj.SamplesPerFrame;
          if Pointer > sz(1) && ~obj.pDoneStatus
            obj.pDoneStatus = true;
          end
        elseif startidx <= sz(1)
          % remaining signal size < output frame size
          out = obj.pOutputBuffer;
          
          if obj.puseidx % use pre-computed indices
              sidx = obj.pstartindx;
              eidx = obj.pendindx;
          else
              sidx = startidx;
              eidx = endidx;
          end
          
          out(1:end-(eidx-sz(1)), :) = ...
              obj.Signal(sidx:end, :);
          obj.pPointer = Pointer + sz(1) - startidx + 1;
          out(end-(eidx-sz(1))+1:end, :) = ...
              getFinalValues( ...
              obj, (obj.SamplesPerFrame-(sz(1)-sidx)-1), sz(2));

          Pointer = Pointer + obj.SamplesPerFrame;
          if ~obj.pDoneStatus
            obj.pDoneStatus = true;
          end
        else
          out = getFinalValues(obj, obj.SamplesPerFrame, sz(2));
          if obj.pCyclicRepetition
            % increment only for cyclic repetition to avoid
            % eventual overflow for other cases
            Pointer = Pointer + obj.SamplesPerFrame;
          end
          if ~obj.pDoneStatus
            obj.pDoneStatus = true;
          end
        end
      else % 3-D
        if Pointer <= sz(3)
          out = obj.Signal(:, :, Pointer);
        else
          out = getFinalValues(obj, sz(1), sz(2));
        end
        Pointer = Pointer + 1;
        if Pointer > sz(3) && ~obj.pDoneStatus
          obj.pDoneStatus = true;
        end
      end

      if ~isreal(obj.Signal) && isreal(out)
          % If signal is complex and out is real, make out also complex.
          out = complex(out);
      end

      if obj.pCyclicRepetition
        if sndims == 3
          len = sz(3);
        else
          len = sz(1);
        end
        Pointer = rem(Pointer, len);
        if Pointer == 0
          Pointer = len;
        end
      end
      obj.pPointer = Pointer;
    end

    function validatePropertiesImpl(obj)
      if strcmp(obj.SignalEndAction, 'Cyclic repetition')
        sz = size(obj.Signal);
        % Issue warning 'The input length is not an integer multiple of the
        % frame size.' if needed
        if length(sz) == 3
          len = sz(3);
        else
          len = sz(1);
        end
        if rem(len, obj.SamplesPerFrame)
          coder.internal.warning('dsp:system:SignalSource:nonMultipleInputLen');
        end
      end
      
      coder.internal.errorIf(ndims(obj.Signal) == 3 && ...
        obj.SamplesPerFrame > 1, ...
        'dsp:system:SignalSource:invalidSamplesPerFrame');
    end
      
    function setupImpl(obj,varargin)
      coder.extrinsic('builtin');
      
      deployedFlag = 0;
      noCoderFlag    = isempty(coder.target);
      
      if noCoderFlag
        deployedFlag = isdeployed();
      end
      
      if ~deployedFlag
          if noCoderFlag
              licenseFlag = builtin('license','checkout','signal_blocks');
          else
              licenseFlag = coder.license('checkout','signal_blocks');
          end
           coder.internal.errorIf(~licenseFlag, ...
          'dspshared:system:sigLicenseFailed');
      end
      
      obj.pCyclicRepetition = ...
        strcmp(obj.SignalEndAction, 'Cyclic repetition');
      obj.pHoldFinalValue = ...
        strcmp(obj.SignalEndAction, 'Hold final value');
      obj.pPointer = 1;
      obj.pDoneStatus = false;

      obj.pSignalClass = class(obj.Signal);
      obj.pSignalSize  = size(obj.Signal);
      obj.pSignalNDims = ndims(obj.Signal);
      
      if isa(obj.Signal,'embedded.fi')
        obj.pOutputBuffer = ...
          fi(zeros(obj.SamplesPerFrame, obj.pSignalSize(2)), ...
          numerictype(obj.Signal));
      else
        obj.pOutputBuffer = cast(...
          zeros(obj.SamplesPerFrame, obj.pSignalSize(2)), ...
          obj.pSignalClass);
      end
      
      % indices can be pre-computed for all cases except Cyclic repetition
      % when SamplesPerFrame and signal length do not divide
      if ~strcmp(obj.SignalEndAction, 'Cyclic repetition')
          obj.puseidx = true;
      elseif (rem(obj.SamplesPerFrame,obj.pSignalSize(1))==0) || ...
             (rem(obj.pSignalSize(1),obj.SamplesPerFrame)==0)
          obj.puseidx = true;
      else
          obj.puseidx = false;
      end
      
      if obj.puseidx % pre-compute indices
          if (obj.SamplesPerFrame > obj.pSignalSize(1))
              obj.pstartindx = 1;
          else
              obj.pstartindx = obj.SamplesPerFrame * ...
                  floor(obj.pSignalSize(1)/obj.SamplesPerFrame) + 1;
          end
          obj.pendindx = obj.pstartindx + obj.SamplesPerFrame -1;
      end
      
    end

    function resetImpl(obj)
      obj.pPointer = 1;
      obj.pDoneStatus = false;
    end

    function status = isDoneImpl(obj)
    %isDone True if last sample or frame of signal has been output
    %   isDone(OBJ) returns true if the SignalSource object, OBJ, has
    %   output the last sample or frame of the signal. If the
    %   SignalEndAction property is set to 'Cyclic repetition', this method
    %   returns true every time the last signal sample or frame is output,
    %   and false otherwise. If the SignalEndAction property is set to 'Set
    %   to zero' or 'Hold final value', this method always returns true
    %   once the object has output the last signal sample or frame. 
      if ~isLocked(obj)
        setup(obj);
        status = false;
      else
        status = obj.pDoneStatus;
      end
    end
 
    function ds = getDiscreteStateImpl(obj)
        ds.pPointer = obj.pPointer;
        ds.pDoneStatus = obj.pDoneStatus;
    end

    function setDiscreteStateImpl(obj, ds)
        obj.pPointer = ds.pPointer;
        obj.pDoneStatus = ds.pDoneStatus;
    end
   
    function flag = isOutputComplexityLockedImpl(~,~)
        flag = true;
    end
    
    function num = getNumInputsImpl(~)
        num = 0;
    end
    
    function s = saveObjectImpl(obj)
        % Save the public properties
        s = saveObjectImpl@matlab.System(obj);
        % Save the private properties if object is locked
        if obj.isLocked
            s.pSignalSize       = obj.pSignalSize;
            s.pSignalNDims      = obj.pSignalNDims;
            s.pCyclicRepetition = obj.pCyclicRepetition;
            s.pHoldFinalValue   = obj.pHoldFinalValue;
            s.pSignalClass      = obj.pSignalClass;
            s.pOutputBuffer     = obj.pOutputBuffer;
            s.pstartindx        = obj.pstartindx;
            s.pendindx          = obj.pendindx;
            s.puseidx           = obj.puseidx;
        end
    end
    
    function loadObjectImpl(obj, s, ~)
        fn = fieldnames(s);
        for ii=1:numel(fn)
            obj.(fn{ii}) = s.(fn{ii}); %#ok
        end
    end
    
  end % methods, protected API

  methods(Access = private)
    function out = getFinalValues(obj, rows, cols)

      if obj.pCyclicRepetition
        sz = obj.pSignalSize;
        if length(sz) == 3   % for 3-D we have to start from beginning
          out = obj.Signal(:,:,1);
        else % 2-D
          rep = floor(rows / sz(1));
          rest = rem(rows, sz(1));
            if rep > 0
              out = [repmat(obj.Signal, rep, 1); obj.Signal(1:rest, :)];
            else
              out = obj.Signal(1:rest, :);
            end
        end

      elseif obj.pHoldFinalValue
        if cols == 1
          out = repmat(obj.Signal(end), rows, 1);
        else
          if obj.pSignalNDims == 3
            out = obj.Signal(:, :, end);
          else
            out = repmat(obj.Signal(end, :), rows, 1);
          end
        end

      else %if strcmp(this.SignalEndAction, 'Set to zero')
        if isa(obj.Signal, 'embedded.fi')
          outTemp = fi(zeros(rows, cols), ...
            get(obj.Signal,'numerictype'), get(obj.Signal,'fimath'));
        else
          outTemp = zeros(rows,cols,obj.pSignalClass);
        end
        % if signal is complex, return complex zeros as per spec
        % lock-down
        if isreal(obj.Signal)
          out = outTemp;
        else
          out = complex(outTemp, outTemp);
        end
      end
    end
  end
end
