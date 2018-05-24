function varargout = actualdesign(this,hspecs,varargin)
%ACTUALDESIGN Perform the actual design.

%   Copyright 2011 The MathWorks, Inc.

% Validate specifications
R = validatespecs(hspecs);

this.privNBands = hspecs.NBands;

% Bring specifications to the format needed by multibandFIRGR
% FEdges - cell array of band edges
% AEdges - cell array of amplitude values at band edges
% A - cell array with vectors that contain amplitude values per band
% F - cell array with vectors that contain frequency points per band
% R - vector of ripple values, one per band
[FEdges,AEdges,F,A,NBands] = formatspecs(hspecs);

% Get constraints. Edges are returned as vectors by the getconstraints
% methods.
[constraints,FEdges,AEdges] = getconstraints(this,FEdges,A,AEdges,NBands);

% Parse design options 
[lgrid,phaseStr,minOrderStr,N] = parsedesignopts(this);
Wcell = parseweights(this,hspecs);

% Multi-band
if isempty(phaseStr)
  b = firgr({minOrderStr,N},FEdges,{@multibandFIRGR,AEdges,A,F,Wcell},constraints,R,{lgrid});
else
  b = firgr({minOrderStr,N},FEdges,{@multibandFIRGR,AEdges,A,F,Wcell},constraints,R,phaseStr,{lgrid});
end

varargout = {{b}};

%--------------------------------------------------------------------------
function [DH,DW,WX,FF,FE,devs,constr,erridx,LB,UB,ERRNO] = multibandFIRGR(N,FF,FE,GF,W,~,minPhase,~,AA,A,F,Wcell)
%MYMULTIBANDFCN Magnitude response function called by firgr

% FF - vector of band edges
% AA - vector of amplitude values at band edges
% A - cell array with vectors that contain amplitude values per band
% F - cell array with vectors that contain frequency points per band

if nargin==2,
  % Return symmetry default:
  if strcmp(N,'defaults'),
    DH = 'even';   % can be 'even' or 'odd'
    return
  end
end

nBands = length(W);
constr = zeros(nBands,1);
erridx = ones(nBands,1);
WX = W;
devs = zeros(length(AA)/2,1);

if minPhase
  LB = zeros(length(GF), 1);
else
  LB = [];
end
UB = [];

for m=1:2:length(AA)
  band = (m + 1) / 2;
  
  sel = find( GF>=FF(m) & GF<=FF(m+1) );
  if FF(m+1)~=FF(m)
    DH(sel) = interp1(F{band}, A{band}, GF(sel)); %#ok<*AGROW>
  else   % zero bandwidth band
    DH(sel) = (AA(m)+AA(m+1))/2;
  end
  
  ERRNO(sel) = erridx(band);
  
  % Ripple and weights
  if FF(m+1)~=FF(m)
    myWInterp = interp1(F{band}, Wcell{band},GF(sel));
  else
    myWInterp =  Wcell{band};
  end
  DW(sel) = myWInterp/WX(band);
  devs(band) = WX(band);
  % Change the relative constrained error magnitude into an error weight
  WX(band) = 1.0 / WX(band);
end

if minPhase
  % For minimum phase, the lower bound must be non-negative
  LB(LB < 0.0) = 0.0;
end


% [EOF]