function varargout = actualdesign(this,hspecs,varargin)
%ACTUALDESIGN Perform the actual design.

%   Copyright 2011 The MathWorks, Inc.

% Validate specifications
[N,F,A,~,nfpts] = validatespecs(hspecs);

% Determine if the filter is real
isreal = true;
if F(1)<0, isreal = false; end

% Weights
W = this.Weights;
if isempty(W),
    W = ones(size(F));
elseif isscalar(W)
  % Scalar expansion
  W = W*ones(size(F));  
elseif length(W)~=nfpts,
    error(message('dsp:fdfmethod:eqripsbarbmag:actualdesign:InvalidWeights'));
end

% Density factor
lgrid = this.Densityfactor;
if lgrid<16,
    error(message('dsp:fdfmethod:eqripsbarbmag:actualdesign:InvalidDensityFactor'));
end

% Min/Max phase 
phaseStr = [];
if this.MinPhase
  phaseStr = 'minphase';
end
if this.MaxPhase
  if ~isempty(phaseStr)
    error(message('dsp:fdfmethod:eqripsbarbmag:actualdesign:InvalidPhaseOpt'));    
  end
  phaseStr = 'maxphase';
end
if ~isempty(phaseStr) && ~isreal
  warning(message('dsp:fdfmethod:eqripsbarbmag:actualdesign:InvalidComplexMinMaxPhase'));
end

if ~isempty(phaseStr) && (rem(N,2)~=0)
 % Increase order by one when order is odd for min/max-phase designs
 N = N+1;
end

% Single band design
if isreal,
    FF = [0 1];
    method = thisrealmethod(this);    
    if A(end)~=0 && rem(N,2)
        b = feval(method,N,FF,{@this.singleband,A,F,W,false},{lgrid},'h');
    else
      if isempty(phaseStr)
        b = feval(method,N,FF,{@this.singleband,A,F,W,false},{lgrid});
      else
        b = feval(method,N,FF,{@singlebandFIRGR,A,F,W},phaseStr,{lgrid});
      end
    end
else
    FF = [-1 1];
    method = thiscomplexmethod(this);
    b = feval(method,N,FF,{@this.singleband,A,F,W,true},{lgrid}); 
end

varargout = {{b}};    
%--------------------------------------------------------------------------
function [DH,DW,WX,FF,FE,devs,constr,erridx,LB,UB,ERRNO] = singlebandFIRGR(N,FF,FE,GF,W,~,minPhase,~,A,F,myW)
%singlebandFIRGR Frequency response function called by FIRGR for single
%band minimum order, min/max-phase designs.

if nargin==3,
  % Return symmetry default:
  if strcmp(N,'defaults'),
    DH='even';
    return
  end
end

constr = 0;
erridx = 1;
ERRNO = erridx*ones(size(GF));
WX = W;
devs = 0;

if minPhase > 0
  LB = zeros(length(GF), 1);
else
  LB = [];
end
UB = [];

DH = interp1(F(:), A(:), GF);
DW = interp1(F(:), myW, GF);




