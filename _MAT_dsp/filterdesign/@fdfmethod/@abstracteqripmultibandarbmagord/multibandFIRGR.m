function [DH,DW,WX,FF,FE,devs,constr,erridx,LB,UB,ERRNO] = multibandFIRGR(~,N,FF,FE,GF,W,WP,minPhase,~,AA,A,F,myW)
%multibandFIRGR Magnitude response function called by firgr
%
%   FF - vector of band edges
%   AA - vector of amplitude values at band edges
%   A - cell array with vectors that contain amplitude values per band
%   F - cell array with vectors that contain frequency points per band
%   myW - cell array with vectors that contain weights per band

%   Copyright 2011 The MathWorks, Inc.

if nargin==3,
  % Return symmetry default:
  if strcmp(N,'defaults'),
    DH = 'even';   % can be 'even' or 'odd'
    return
  end
end

[WX,constr,erridx] = parse_firgrweights(W, WP);
devs = zeros(length(AA)/2,1);

if (any(constr > 0))
  % Constrained magnitudes.  Initially set up huge
  % constraints that won't come into effect
  Amax = max(abs(cell2mat(A)));
  UB = 1.0e4 * Amax * ones(length(GF), 1);
  % For minimum-phase filters, we need a lower bound of zero
  if minPhase
    LB = zeros(length(GF), 1);
  else
    LB = -UB;
  end
else
  if minPhase
    LB = zeros(length(GF), 1);
  else
    LB = [];
  end
  UB = [];
end

for m=1:2:length(AA)
  band = (m + 1) / 2;
  % Handle an unconstrained left band edge
  if (FE(m) == 1)
    sel = find (GF > FF(m-1) & GF < FF(m));
    DH(sel) = AA(m); %#ok<*AGROW>
    DW(sel) = WX(band);
    ERRNO(sel) = erridx(band);
    if constr(band) > 0
      UB(sel) = AA(m) + constr(band);
      LB(sel) = AA(m) - constr(band);
    end
  end
  % Handle an unconstrained right band edge
  if (FE(m+1) == 1)
    sel = find (GF > FF(m+1) & GF < FF(m+2));
    DH(sel) = AA(m+1);
    DW(sel) = WX(band);
    ERRNO(sel) = erridx(band);
    if constr(band) > 0
      UB(sel) = AA(m+1) + constr(band);
      LB(sel) = AA(m+1) - constr(band);
    end
  end
  
  % Constrained bands
  sel = find( GF>=FF(m) & GF<=FF(m+1) );
  if FF(m+1)~=FF(m)
    DH(sel) = interp1(F{band}, A{band}, GF(sel));
  else   % zero bandwidth band
    DH(sel) = (AA(m)+AA(m+1))/2;
  end
  
  ERRNO(sel) = erridx(band);
  
  if constr(band) > 0
    UB(sel) = DH(sel) + constr(band);
    LB(sel) = DH(sel) - constr(band);
    devs(band) = constr(band);
    DW(sel) = WX(band);
  else
    if length(F{band}) < 2
      % Single point band
      DW(sel) = myW{band};
    else
      DW(sel) = interp1(F{band}, myW{band}, GF(sel));
    end
  end
end

if minPhase
  % For minimum phase, the lower bound must be non-negative
  LB(LB < 0.0) = 0.0;
end

%---------------------------------------------------------------------------
function [Wnew,constr,erridx] = parse_firgrweights(W, WP)
%PARSE_FIRGRWEIGHTS

% Defaults are: unconstrained, single approximation error, linear phase
nbands = length(W);
constr = zeros(nbands,1);
erridx = ones(nbands,1);
Wnew = W;

if isempty(WP)
  return;
end

if nbands ~= length(WP)
  error(message('dsp:fdfmethod:abstracteqripmultibandarbmagord:parse_firgrweights:InvalidDim'));
end

for i = 1:nbands
  prop = lower(WP{i});
  stop = length(prop);
  j=1;
  while j <= stop
    switch prop(j)
      case 'w'
        % Weight is already correct
      case 'c'
        constr(i) = W(i);
        % Default error un-weighting to force values toward the constraints
        Wnew(i) = 0.05;
    end
    j = j + 1;
  end
end



