function [b] = dspblkvfdly2(varargin)
% DSPBLKVFDLY Mask dynamic dialog function for variable fractional delay block

% Copyright 1995-2011 The MathWorks, Inc.

isSysobj = false;
if nargin==0
  action = 'dynamic';   % mask callback
elseif (nargin==1)
    action = 'setup';
else
  action = 'design';    % Design the filter
  isSysobj = dspIsSystemObject(varargin{1});
end

if ~isSysobj %isblock
dspSetFrameUpgradeParameter(gcbh, 'InputProcessing', 'Inherited (this choice will be removed - see release notes)');

oldMode = get_param(gcbh, 'mode');
if (~strcmp(oldMode, 'OBSOLETE'))
    % This block lives in an old model (<9a release) that is being opened for the
    % first time in 9a or later release
    if (strcmp(oldMode,'Linear interpolation'))
        set_param(gcbh, 'modeActive', 'Linear');
    elseif (strcmp(oldMode,'FIR interpolation'))
        set_param(gcbh, 'modeActive', 'FIR');
        set_param(gcbh, 'fallbackFIR', 'Switch to linear interpolation if kernel cannot be centered');
    else
      error(message('dsp:dspblkvfdly2:unhandledCase1'));        
    end
    set_param(gcbh, 'noDFT', 'off');
    set_param(gcbh, 'mode', 'OBSOLETE');
end
end

switch action
            
case 'design'
   % Design filter using matlab intfilt
   mode = varargin{2};
   if mode==3,
      % Farrow filtering
    L = double(varargin{3});
    
    % Lagrange Designs for FD Farrow from
    % http://www.acoustics.hut.fi/~vpv/publications/vesan_vaitos/ch3_pt2_lagrange.pdf
    N = L - 1;
    U = fliplr(vander(0:(L-1)));
    Q = inv(U);
    % Modified Farrow - D' = D+1
    if N>1
        T = eye(L);
        for i=1:L,
            for j=i:L,
                T(i,j) = nchoosek(j-1,i-1)*(floor(N/2))^(j-i);
                [lastmsg, lastid] = lastwarn;
                if strcmpi(lastid,'MATLAB:nchoosek:LargeCoefficient'),
                    warning('off','MATLAB:nchoosek:LargeCoefficient')
                end
            end
        end
        Q = T*Q;
    end

    % Forcing zeros and ones for those ought to be zeros and ones to eliminate
    % the roundoff error.
    [N1, D1] = rat(Q);
    Q(N1 == 0) = 0;
    Q(N1 == D1) = 1;

    b = fliplr(Q.');

   elseif  mode==2,
      % FIR interpolation
      R = double(varargin{3});
      L = double(varargin{4});
      alpha = double(varargin{5});
      if isoktocheckparam(R)
          if (~isreal(R)) || (numel(R) ~= 1) || (R<2) || (R>65535) || (floor(R)~=R) || (~isnumeric(R)),
              error(message('dsp:dspblkvfdly2:paramRealScalarError1'));
          end
      end
      
      if isoktocheckparam(L)
          if (~isreal(L)) || (numel(L) ~= 1) || (L<=0) || (L>65535) || (floor(L)~=L) || (~isnumeric(L)),
              error(message('dsp:dspblkvfdly2:paramRealScalarError2'));
          end
      end
      
      if isoktocheckparam(alpha)
          if (~isreal(alpha)) || (numel(alpha) ~= 1) || isnan(alpha) || (alpha > 1) || (alpha < 0)
              error(message('dsp:dspblkvfdly2:paramRealScalarError3'));
          end
      end
      
      b = [];
      if ~isempty(R) && ~isempty(L) && ~isempty(alpha)
         b=intfilt(R,L,alpha);
         blen=length(b); bcols = ceil(blen/2/L);
         b = [zeros(bcols*2*L-blen,1);b(:)];
         b = flipud(reshape(b,bcols,2*L)');
      end
   else
       % Linear interpolation
      b = [];
   end

otherwise
   error(message('dsp:dspblkvfdly2:unhandledCase2'));
end
% end of dspblkvfdly2.m
