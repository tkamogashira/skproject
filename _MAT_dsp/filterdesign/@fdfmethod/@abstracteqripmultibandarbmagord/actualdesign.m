function varargout = actualdesign(this,hspecs,varargin)
%ACTUALDESIGN Perform the actual design.

%   Copyright 2011 The MathWorks, Inc.

[~,F,E,A,~,Fs,normFreqFlag] = validatespecs(hspecs);

% Cache design parameters so that we can use them in the info method.
this.privNBands = hspecs.NBands;
this.privActualNormalizedFreq = normFreqFlag;
this.privFs = Fs;

% Determine if the filter is real
isreal = true;
if F(1)<0, isreal = false; end

% Parse design options
[lgrid,phaseStr,N,W,Wcell,constraints] = parsedesignopts(this,hspecs,Fs,isreal);

if isreal
  method = thisrealmethod(this);
  if isequal(method,@firpm)
    if A(end)~=0 && rem(N,2),
      b = firpm(N,E,{@this.multiband,A,F,W,false},{lgrid},'h');
    else
      b = firpm(N,E,{@this.multiband,A,F,W,false},{lgrid});
    end
  else
    % Bring specifications to the format needed by multibandFIRGR
    % FEdges - cell array of band edges
    % AEdges - cell array of amplitude values at band edges
    % A - cell array with vectors that contain amplitude values per band
    % F - cell array with vectors that contain frequency points per band
    [FEdges,AEdges,F,A,NBands] = formatspecs(hspecs);
    
    % Get band edge properties and constraints. Edges are returned as
    % vectors by the getconstraints methods.
    [bandEdgeProps,constraints,FEdges,AEdges,A,F,WBands,myW] = getconstraints(this,FEdges,AEdges,A,F,Wcell,constraints,NBands,Fs);
       
    % Suppress firgr warning thrown when passing a constraints cell array
    ignoreID = 'dsp:firgr:DeprecatedFeature';
    w = warning('off', ignoreID);    
    if A{end}(end)~=0 && rem(N,2),
      b = feval(method,N,FEdges,{@this.multibandFIRGR,AEdges,A,F,myW},bandEdgeProps,WBands,constraints,{lgrid},'h');
    else
      if isempty(phaseStr)
        b = feval(method,N,FEdges,{@this.multibandFIRGR,AEdges,A,F,myW},bandEdgeProps,WBands,constraints,{lgrid});
      else
        b = feval(method,N,FEdges,{@this.multibandFIRGR,AEdges,A,F,myW},bandEdgeProps,WBands,constraints,phaseStr,{lgrid});
      end
    end
    warning(w);
  end
else % complex design
  thiscomplexmethod(this);
  b = cfirpm(N,E,{@this.multiband,A,F,W,true},{lgrid});
end

varargout = {{b}};

% [EOF]

