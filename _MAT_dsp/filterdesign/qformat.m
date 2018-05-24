function varargout = qformat(obj,fun,varargin)
%QFORMAT  Access to formats of QFFT objects.
%   QFORMAT(OBJ,FUN) gives access to format properties of QFFT
%   objects.  For example,
%     Hq = qfft;
%     qformat(Hq,'eps') 
%   displays the eps of all the quantizers in QFFT object Hq.
%
%   QFORMAT(OBJ,FUN,FORMATTYPE) gives access to the format specified by
%   FORMATTYPE.  FORMATTYPE is a string: one of 'coefficient',
%   'input', 'output', 'multiplicand', 'product', 'sum'.  For example,
%     Hq = qfft;
%     qformat(Hq,'range','coefficient') 
%   displays the range of the coefficient format.
%
%   QFORMAT(OBJ,FUN,FORMATTYPE1,FORMATTYPE2,...) gives access to the formats
%   associated with the quantizers associated with FORMATTYPE1, ....
%
%   [X1,X2,...] = QFORMAT(...) returns the specified formats instead of
%   displaying.  For example:
%     Hq = qfft;
%     e = qformat(Hq,'eps','coefficient')
% 
%   See also QFFT/EPS, QFFT/RANGE.

%   Thomas A. Bryan, 11 October 1999
%   Copyright 1999-2011 The MathWorks, Inc.

switch class(obj)
  case 'qfft'
    validnames = {'coefficient','input','output', 'multiplicand','product','sum'};
  otherwise
    error(message('dsp:qformat:FixedPtErr'));
end

% Validate the input
for k=1:length(varargin)
  [varargin{k},msgObj] = qpropertymatch(varargin{k},validnames);
  if ~isempty(msgObj),
     error(msgObj);
  end;
end

if nargout==0
  % format(F)
  allformatdisplay(obj,fun,validnames,varargin{:});
else
  % r = eps(F)
  % [r1,r2,...] = eps(obj,'input','output',...)
  if isempty(varargin)
    % r = eps(F)
    % [rcoefficient, rinput, routput, ...] = eps(F)
    formats = {validnames{1:min(nargout,length(validnames))}};
  else
    %[r1,r2,...] = eps(obj,'input','output',...)
    varargout = cell(size(varargin));
    formats = varargin;
  end
  for k=1:min(nargout,length(formats))
    varargout{k} = feval(fun,quantizer(obj,formats{k}));
  end
end
    
function allformatdisplay(obj,fun,validnames,varargin)
if isempty(varargin)
  for k=1:length(validnames)
    formatdisplay(fun,validnames{k},quantizer(obj,validnames{k}));
  end
else
  for k=1:length(varargin)
    formatdisplay(fun,varargin{k},quantizer(obj,varargin{k}));
  end
end

function formatdisplay(fun,name,q)
e = feval(fun,q);
fmt0 = get(0,'format');
switch fmt0
  case 'hex'
    e = num2hex(q,e(:));
  case 'rational'
    if strmatch(mode(q),strvcat('fixed','ufixed'))
      fmtrat = ['%17.0f/2^',num2str(fractionlength(q))];
      e = deblank(num2str(pow2(e(:),fractionlength(q)),fmtrat));
    end
end

if isnumeric(e)
  if length(e)==1
    fprintf('%12s  %17.10g\n',name,e);
  else
    fprintf('%12s  %17.10g  %17.10g\n',name,e(1),e(2));
  end
else
  % String
  if size(e,1)==1
    fprintf('%12s  %17s\n',name,e);
  else
    fprintf('%12s  %17s  %17s\n',name,e(1,:),e(2,:));
  end
end
