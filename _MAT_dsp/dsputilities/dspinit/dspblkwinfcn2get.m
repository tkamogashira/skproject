function [w,xw,yw,wtxt] = dspblkwinfcn2get(wintype,N,winsamp,Rs,beta,nbar,sll,userwinName,OptionalParams,userwinParams)
%DSPBLKWINFCN2GET Get new window for DSP System Toolbox Window function.
%   [W,XW,YW,WTXT] = DSPBLKWINFCN2GET(BLK,N) gets a new window W, and
%   scaled x- and y- values XW, YW for the plot on the face of the
%   block, and a text message WTXT for the face of the block.  BLK is
%   the name of the block that calls this function (from GCBH), and N
%   is the width of the window.  The other window parameters are read
%   from the mask.
%
%   This is a block helper function for the Window Function.

% Copyright 1995-2011 The MathWorks, Inc.

%#function bartlett
%#function blackman
%#function boxcar
%#function chebwin
%#function hamming
%#function hann
%#function hanning
%#function kaiser
%#function taylorwin
%#function triang

  if ~ischar(winsamp)
    if winsamp == 1
      sflag = 'symmetric';
    else
      sflag = 'periodic';
    end
  else
    sflag = lower(winsamp);
  end

  switch wintype,
   case {1, 'Bartlett'}
    s={'bartlett',N};
   case {2, 'Blackman'}
    s={'blackman',N,sflag};
   case {3, 'Boxcar'}
    s={'boxcar',N};
   case {4, 'Chebyshev'}
    s ={'chebwin',N,Rs};
   case {5, 'Hamming'}
    s={'hamming',N,sflag};
   case {6, 'Hann'}
    s={'hann',N,sflag};
   case {7, 'Hanning'}
    s={'hanning',N,sflag};
   case {8, 'Kaiser'}
    s={'kaiser',N,beta};
   case {9, 'Taylor'}
    s={'taylorwin',N,nbar,sll};
   case {10, 'Triang'}
    s={'triang',N};
   case {11, 'User defined'}
    s={userwinName,N};
    if (OptionalParams)
      if ~isempty(userwinParams),
        if ~iscell(userwinParams), userwinParams={userwinParams}; end
        s=[s userwinParams];
      end
    end
  end


  if nargout==1
    % The S-function is requesting a new window.  Do not suppress any
    % warnings or errors.
    w=feval(s{:});
  else
    % For icon only.
    try
      % None of the window fcn arguments should be empty.
      % It's either a user mistake, or the mask variable
      % was undefined.  We wish to suppress all warnings
      % from the window design functions, and to produce
      % a default icon for the block:
      anyEmpty = 0;
      for i=2:length(s),
        if isempty(s{i}),
          anyEmpty=1;
          break;
        end
      end
      if anyEmpty,
        w=zeros(N,1);
      else
        w=feval(s{:});
      end
    catch
      % Any other errors:
      w=zeros(N,1);
    end
    % wtxt, xw, yw are only computed for the icon.
    if strcmp(s{1},'boxcar')
        yw = w .* 0.65;
    else
        % Normalize yw to fit within 0-1, and then squeeze to 0.65:
        yw = w - min(abs(w));
        ywmax = max(abs(yw));
        if ywmax > 0
            yw = yw ./ ywmax;
        end
        yw = yw .* 0.65;
    end
    wtxt=s{1}; xw=((0:N-1)/(N-1))*0.75+0.05;
  end

  return

