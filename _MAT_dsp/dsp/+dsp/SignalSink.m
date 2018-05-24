classdef SignalSink < matlab.System
%SignalSink Log simulation data in MATLAB
%   HLOG = dsp.SignalSink returns a signal logger System object, HLOG,
%   that logs 2-D input data in the object. This object accepts any numeric
%   data type.
%
%   HLOG = dsp.SignalSink('PropertyName', PropertyValue, ...) returns a
%   signal logger System object, HLOG, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   step(HLOG, Y) buffers the signal Y. The buffer may be accessed at any
%   time from the Buffer property of HLOG.
%
%   SignalSink methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create signal logger object with same property values
%   isLocked - Locked status (logical)
%   reset    - Clear the logged data
%
%   SignalSink properties:
%
%   FrameBasedProcessing - Process input in frames or as samples
%   BufferLength         - Maximum number of input samples or frames to log
%   Decimation           - Decimation factor
%   FrameHandlingMode    - Dimensionality of output for frame-based inputs
%   Buffer               - Logged data (read only)
%
%   % EXAMPLE: Log input data.
%       hlog = dsp.SignalSink;
%       for i = 1:10
%         y = sin(i);
%         step(hlog, y);
%       end
%       log = hlog.Buffer;  % log = sin([1;2;3;4;5;6;7;8;9;10]);
%
%   See also dsp.SignalSource.

%   Copyright 2009-2013 The MathWorks, Inc.

properties (Nontunable, Logical)
  %FrameBasedProcessing Process input in frames or as samples
  %   Set this property to true to enable <a href="matlab:helpview(fullfile(docroot,'toolbox','dsp','dsp.map'),'ugframebasedprocessing')">frame-based processing</a>. Set this
  %   property to false to enable sample-based processing. This property
  %   affects how BufferLength and Decimation work. The default value of
  %   this property is true.
  FrameBasedProcessing = true;
end
properties (Nontunable)
  %BufferLength Maximum number of input samples or frames to log
  %   Specify maximum number of most recent samples of data to log when
  %   the input is sample based, or the maximum number of most recent
  %   frames of data to log when the input is frame based. To capture all
  %   data, set BufferLength to inf. The default value of this property
  %   is inf.
  BufferLength = inf;
  %Decimation Decimation factor
  %   This property can be set to any positive integer d, and indicates
  %   that the System object writes data at every dth sample. The default
  %   value of this property is 1.
  Decimation = 1;
  %FrameHandlingMode Output dimensionality for frame-based inputs
  %   Set the dimension of the output array for frame-based inputs as one
  %   of [{'2-D array (concatenate)'} | '3-D array (separate)'].
  %   Concatenation occurs along the first dimension for '2-D array
  %   (concatenate)'. This property is only applicable when
  %   FrameBasedProcessing is true.
  FrameHandlingMode = '2-D array (concatenate)';
end
properties(Dependent, Nontunable)
  %Buffer Logged Data (read only)
  Buffer;
end

properties(Constant, Hidden)
  % enum props
  FrameHandlingModeSet = matlab.system.StringSet({ ...
    '2-D array (concatenate)',...
    '3-D array (separate)'
    });
end

properties(Access = private)
  pBuffer;
  pNextIndex;
  pResetOrReleaseCalled;
  pSampleCounter;
  pBufferFilled;
  pDecimInSizeFirstDim;
end

properties(Access = private, Nontunable)
  pConcatenate;
  pLogContinuous;
  pInSizeFirstDim;
  pInDataType;
end

methods
  % CONSTRUCTOR
  function obj = SignalSink(varargin)
    setProperties(obj, nargin, varargin{:});
    obj.pResetOrReleaseCalled = true;
    obj.pBufferFilled = false;
    obj.pNextIndex = 1;
  end

  % PROPERTY VALIDATION
  function set.BufferLength(obj,val)
      coder.internal.assert(isnumeric(val) && val > 0 &&  val == round(val), ...
          'dsp:system:SignalSink:invalidNumDataPoints');    
    obj.BufferLength = val;
  end

  function set.Decimation(obj,val)
    validateattributes(val, ...
      {'numeric'}, {'integer', '>', 0}, '', 'Decimation'); 
    obj.Decimation = val;
  end

  % BUFFER ACCESS
  function buf = get.Buffer(obj)
    if obj.pResetOrReleaseCalled
      buf = cast([], class(obj.pBuffer));
    elseif isinf(obj.BufferLength) || ~obj.pBufferFilled
      if obj.pConcatenate
        buf = dsp.SignalSink.Cat3rdDim(obj.pBuffer);
      else
        buf = obj.pBuffer;
      end
    else
      % pBuffer has filled at least once and we are reusing it
      buf = obj.pBuffer(:,:,obj.pNextIndex:obj.BufferLength);
      buf(:,:,(obj.BufferLength-obj.pNextIndex)+ 2:obj.BufferLength) = ...
        obj.pBuffer(:,:,1:obj.pNextIndex-1);
      if obj.pConcatenate
        buf = dsp.SignalSink.Cat3rdDim(buf);
      end
    end
  end

  function set.Buffer(obj,val)                         %#ok<INUSD,MANU>
    coder.internal.assert(false, 'dsp:system:SignalSink:BufferReadOnly');
  end
end

methods(Access = protected)
  % System object API, PROTECTED
  function stepImpl(obj,in)
    % Need to set this to false for the case when step is called after
    % reset.
    obj.pResetOrReleaseCalled = false;
    % If decimated output
    if obj.Decimation ~= 1
      if obj.pLogContinuous
        % Extract the decimated input along the first
        % dimension
        in = in( rem(obj.pSampleCounter:...
          obj.pSampleCounter+obj.pInSizeFirstDim-1,...
          obj.Decimation) == 1, :);
        obj.pSampleCounter = ...
          obj.pSampleCounter + obj.pInSizeFirstDim;
        obj.pDecimInSizeFirstDim = size(in,1);
      else
        obj.pSampleCounter = obj.pSampleCounter + 1;
        if rem(obj.pSampleCounter-2, obj.Decimation) ~= 0
          return;
        end
      end
    end

    if isinf(obj.BufferLength) % If infinite number of data points
      if obj.pNextIndex == 1  % First time or after reset
        obj.pBuffer = in;   % initialize the buffer
        if obj.pLogContinuous
          obj.pNextIndex = ...
            obj.pNextIndex + obj.pDecimInSizeFirstDim;
        else
          obj.pNextIndex = obj.pNextIndex + 1;
        end
      else
        if obj.pLogContinuous
          obj.pBuffer(obj.pNextIndex:...
            obj.pNextIndex+obj.pDecimInSizeFirstDim-1, :) = in;
          obj.pNextIndex = ...
            obj.pNextIndex + obj.pDecimInSizeFirstDim;
        else
          obj.pBuffer(:,:,obj.pNextIndex) = in;
          obj.pNextIndex = obj.pNextIndex + 1;
        end
      end
    elseif obj.pNextIndex > obj.BufferLength % Reached end of input
      obj.pBuffer(:,:,1) = in;
      obj.pBufferFilled = true;
      obj.pNextIndex = 2;
    else                                    % Not reached end of input
      if obj.pLogContinuous
        obj.pBuffer(obj.pNextIndex:...
          obj.pNextIndex+obj.pDecimInSizeFirstDim-1, :) = in;
        obj.pNextIndex = ...
          obj.pNextIndex + obj.pDecimInSizeFirstDim;
      else
        obj.pBuffer(:,:,obj.pNextIndex) = in;
        obj.pNextIndex = obj.pNextIndex + 1;
      end
    end
  end

  function setupImpl(obj,in)
    coder.internal.errorIf(~isdeployed && ...
        ~license('checkout','signal_blocks'), ...
        'dspshared:system:sigLicenseFailed');
            
    dt = class(in);

    obj.pConcatenate = ...
      obj.FrameBasedProcessing && ...
      strcmp(obj.FrameHandlingMode, '2-D array (concatenate)');
    obj.pInDataType = dt;
    sz1 = size(in);
    obj.pInSizeFirstDim = sz1(1);
    obj.pDecimInSizeFirstDim = sz1(1);

    obj.pLogContinuous = obj.Decimation > 1 && ...
      obj.pInSizeFirstDim ~= 1 && ...
      obj.pConcatenate;

    % set up the buffer
    if ~isinf(obj.BufferLength)
      sz1(3) = obj.BufferLength;
    end
    if isa(in, 'embedded.fi')
      % We need to use numerictype while constructing the
      % fi object because using the signedness, word and
      % fraction lengths will not work for non-fixed point
      % datatype modes
      obj.pBuffer = fi(zeros(sz1), numerictype(in));
    else
      % we want:
      %    this.pBuffer = <class>(zeros(sz));
      obj.pBuffer = cast(zeros(sz1), obj.pInDataType);
    end

    obj.pResetOrReleaseCalled = false;
    obj.pNextIndex = 1;
    obj.pBufferFilled = false;
    obj.pSampleCounter = 1;
  end

  function resetImpl(obj)
        
    if (obj.pNextIndex > 1)
      % only clear if we've logged something
      obj.pResetOrReleaseCalled = true;
      obj.pNextIndex = 1;
      obj.pBufferFilled = false;
      obj.pSampleCounter = 1;

      % reset the buffer for finite buffer-length.
      if ~isinf(obj.BufferLength)
        obj.pBuffer(:) = 0;
      end
    end
  end

  function releaseImpl(obj)
    if (obj.pNextIndex > 1)
      % only clear if we've logged something
      obj.pResetOrReleaseCalled = true;
      obj.pNextIndex = 1;
      obj.pBufferFilled = false;
    end
  end

  function num = getNumOutputsImpl(obj) %#ok<MANU>
    num = 0; %sink System object
  end

  function flag = isInputSizeLockedImpl(~,~)
    flag = true;
  end

  function flag = isInputComplexityLockedImpl(~,~)
    flag = true;
  end
    
  function flag = isInactivePropertyImpl(obj, prop)
    flag = false; 
    if  strcmp(prop, 'FrameHandlingMode') && ~obj.FrameBasedProcessing
      flag = true; 
    end
  end
  
  
end % methods, protected API

methods(Access=protected)
    
    function s = saveObjectImpl(obj)
        % Save the public properties
        s = saveObjectImpl@matlab.System(obj);
        % Save the private properties if object is locked
        s.isLocked = obj.isLocked;
        if obj.isLocked
            s.pBuffer               = obj.pBuffer;
            s.pNextIndex            = obj.pNextIndex;
            s.pResetOrReleaseCalled = obj.pResetOrReleaseCalled;
            s.pSampleCounter        = obj.pSampleCounter;
            s.pBufferFilled         = obj.pBufferFilled;
            s.pDecimInSizeFirstDim  = obj.pDecimInSizeFirstDim;
            s.pConcatenate          = obj.pConcatenate;
            s.pLogContinuous        = obj.pLogContinuous;
            s.pInSizeFirstDim       = obj.pInSizeFirstDim;
            s.pInDataType           = obj.pInDataType;
        end
    end
    
    function loadObjectImpl(obj, s, wasLocked)
        fn = fieldnames(s);
        % Buffer is read-only
        fn = setdiff(fn,{'isLocked','Buffer'});
        for ii=1:numel(fn)
            obj.(fn{ii}) = s.(fn{ii}); 
        end
    end
end

methods(Hidden)
  function props = getCloneProperties(obj) 
    props = setdiff(properties(obj), {'Buffer'}); 
  end
end

methods(Hidden,Static)
  function result = Cat3rdDim(y)
    %Cat3rdDim Vertically concatenate along third dimension.
    %   X = Cat3rdDim(THIS, Y) converts M-by-N-by-P array Y to
    %   (M*P)-by-N array X. The rows of each M-by-N array are stacked
    %   on top of each other to create the resultant array.
    %
    %   Examples
    %      y = randn(4,4,5);           % y is 4-by-4-by-5
    %      x = Cat3rdDim(y); % x is 20-by-4

    ysize = size(y);
    if length(ysize) ~= 3
      result = y;
      return;
    end
    size3rddim = ysize(3);
    if ysize(1) ~= 1
      result = [];
      for i=1:size3rddim
        result = vertcat(result, y(:,:,i)); %#ok<AGROW>
      end
    else
      result = reshape(y, ysize(2), ysize(1) * ysize(3)).';
    end
  end
end
end
