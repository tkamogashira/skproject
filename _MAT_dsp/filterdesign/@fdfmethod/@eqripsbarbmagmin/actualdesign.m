function varargout = actualdesign(this,hspecs,varargin)
%ACTUALDESIGN Perform the actual design.

%   Copyright 2011 The MathWorks, Inc.

% Validate specifications
[F,A,R] = validatespecs(hspecs);

[lgrid,phaseStr, minOrderStr, N] = parsedesignopts(this);

% Weights
myW = this.Weights;
if isempty(myW),
    myW = ones(size(F));
elseif isscalar(myW)
  % Scalar expansion
  myW = myW*ones(size(F));  
elseif length(myW)~=length(F)
    error(message('dsp:fdfmethod:eqripsbarbmagmin:actualdesign:InvalidWeights'));
end

% Single band design
FF = [0 1];

if isempty(phaseStr)
  b = firgr({minOrderStr,N},FF,{@singlebandFIRGR,A,F,myW},R,{lgrid});
else
  b = firgr({minOrderStr,N},FF,{@singlebandFIRGR,A,F,myW},R,phaseStr,{lgrid});
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

if minPhase > 0
  LB = zeros(length(GF), 1);
else
  LB = [];
end
UB = [];

DH = interp1(F(:), A(:), GF);

% Min order devs and weights
myWInterp = interp1(F(:), myW(:),GF);
DW =  myWInterp/W;
devs = W;
WX = 1/W;





