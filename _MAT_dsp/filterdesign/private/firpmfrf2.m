function [DH,DW,WX,F,FE,devs,constr,erridx,LB,UB,ERRNO] = ...
		firpmfrf2(N, F, FE, GF, W, WP, minPh, minOrd, A, diff_flag)
%FIRPMFRF2 Frequency Response Function for Advanced FIRPM.
%   FIRGR(N,F,A, ...) or FIRPM(2N,F,{@firpmfrf2,...}, ...) designs
%   a linear-phase FIR filter using FIRPM.
%
%   The symmetry option SYM defaults to 'even' if unspecified in the
%   call to FIRGR.
%
%   See also FIRGR.

%   Author(s): D. Shpak
%   Copyright 1999-2012 The MathWorks, Inc.

%  [DH,DW,WX,F,FE,devs,constr,erridx,LB,UB,ERRNO]=
%		FIRPMFRF2(N,F,FE,GF,W,WP,minPh,minOrd,A,diff_flag)
%      N: filter order (length minus one)
%      F: vector of band edges
%     FE: edge properties computed earlier by firpmedge.m
%     GF: vector of interpolated grid frequencies
%      W: vector of weights, one per band
%		WP: weight properties.  A character string for each band
%  minPh: set to 1 for minimum-phase designs.  Else 0.
% minOrd: for minimum-order designs, W is no longer weights.
%         W is instead the maximum allowed error magnitude.
%      A: vector of amplitudes of desired frequency response at band edges F
% diff_flag: ==1 for differentiator (1/f) weights, ==[] otherwise
%
%     DH: vector of desired filter response (mag & phase)
%     DW: vector of weights (positive)
%     WX: the error weights for each band
%     FE: edge properties computed earlier by firpmedge.m
%   devs: constrained deviations for each band
% constr: indicates if each band is constrained
% erridx: index of approximation error for each band.
%     LB: constrained lower bound at each grid point.
%     UB: constrained upper bound at each grid point.
%  ERRNO: index of approximation error for each grid point.
%
% NOTE: DH(GF) and DW(GF) are specified as functions of frequency

% Support query by FIRPM for the default symmetry option:
if nargin==2,
  % Return symmetry default:
  if strcmp(N,'defaults'),
    DH = 'even';   % can be 'even' or 'odd'
    return
  end
end

if nargin < 10
    diff_flag = 0;
end

[WX,constr,erridx] = parse_firgrweights(W, WP);
devs = zeros(length(A)/2,1);

if (any(constr > 0))
	% Constrained magnitudes.  Initially set up huge 
	% constraints that won't come into effect
	Amax = max(abs(A));
	UB = 1.0e4 * Amax * ones(length(GF), 1);
	% For minimum-phase filters, we need a lower bound of zero
	if minPh
		LB = zeros(length(GF), 1);
	else
		LB = -UB;
	end
else
	if minPh
		LB = zeros(length(GF), 1);
	else
		LB = [];
	end
	UB = [];
end


% Prevent discontinuities in desired function
for k=2:2:length(F)-2
    if (F(k) == F(k+1) & A(k) ~= A(k+1))
       error(message('dsp:firpmfrf2:InvalidRange'));      
    end
end
if length(F) ~= length(A)
    error(message('dsp:firpmfrf2:InvalidDimensions'));
end
for m=1:2:length(A)
	band = (m + 1) / 2;
	% Handle an unconstrained left band edge
	if (FE(m) == 1)
		sel = find (GF > F(m-1) & GF < F(m));
		DH(sel) = A(m);
      ERRNO(sel) = erridx(band);
		if constr(band) > 0
			UB(sel) = A(m) + constr(band);
			LB(sel) = A(m) - constr(band);
			devs(band) = constr(band);
			DW(sel) = WX(band);
      else
         if minOrd
            DW(sel) = 1.0 / WX(band);
         	devs(band) = WX(band);
         else
            DW(sel) = WX(band);
         end
      end
   end
	% Handle an unconstrained right band edge
	if (FE(m+1) == 1)
		sel = find (GF > F(m+1) & GF < F(m+2));
		DH(sel) = A(m+1);
		ERRNO(sel) = erridx(band);
		if constr(band) > 0
			UB(sel) = A(m+1) + constr(band);
			LB(sel) = A(m+1) - constr(band);
			devs(band) = constr(band);
			DW(sel) = WX(band);
		else
         if minOrd
            DW(sel) = 1.0 / WX(band);
         	devs(band) = WX(band);
         else
            DW(sel) = WX(band);
         end
		end
    end
    sel = find( GF>=F(m) & GF<=F(m+1) );
    % desired magnitude is line connecting A(m) to A(m+1)
    if F(m+1)~=F(m)   % 
        slope=(A(m+1)-A(m))/(F(m+1)-F(m));
        DH(sel) = polyval([slope A(m)-slope*F(m)],GF(sel));
    else   % zero bandwidth band 
        DH(sel) = (A(m)+A(m+1))/2;  
    end
	ERRNO(sel) = erridx(band);
	if constr(band) > 0
		UB(sel) = DH(sel) + constr(band);
		LB(sel) = DH(sel) - constr(band);
		devs(band) = constr(band);
		DW(sel) = WX(band) ./ (1 +(diff_flag & A(m+1) >= .0001)*(GF(sel)/2 - 1));
   else
      if minOrd
         DW(sel) = 1.0/WX(band) ./ (1 +(diff_flag & A(m+1) >= .0001)*(GF(sel)/2 - 1));
         devs(band) = WX(band);
      else
         DW(sel) = WX(band) ./ (1 +(diff_flag & A(m+1) >= .0001)*(GF(sel)/2 - 1));
      end
   end
	if minOrd
		% Change the relative constrained error magnitude into an error weight
		WX(band) = 1.0 / WX(band);
	end
end
if minPh
	% For minimum phase, the lower bound must be non-negative
	k = find(LB < 0.0);
	LB(k) = 0.0;
end
if diff_flag & minOrd
    % Need to scale the weights to compensate for the
    % error weighting of differentiators in minorder designs
    k = find(DH >= 0.0001);
    scale = max(GF(k))*pi;
    WX = WX * scale;
    DW = DW / scale;
end

