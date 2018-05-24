function ftransfargchk(var,varname,varargin)
%FTRANSFARGCHK Input argument check.
%   FTRANSFARGCHK(VAR,VARNAME,ATTRIBUTE1,ATTRIBUTE2,...) error out if
%   variable VAR does not match attributes in strings ATTRIBUTE1, ....  The
%   name for the variable used in the error message is contained in string
%   VARNAME.  If VARNAME is empty, then the name of the
%   variable VAR is used.

%   Copyright 1999-2011 The MathWorks, Inc.

% --------------------------------------------------------------------

if isempty(varname)
  varname = inputname(var);
end
errmsg = '';
for k=1:length(varargin)

   switch(varargin{k})

      case 'overlap'
         [wt,idx] = sort(var(2,:));
         wo       =      var(1,idx);
         Flag     = 1;
         for kk=1:2:length(wt)-1,
            if wo(kk) > wo(kk+1),
               Flag = 0;
               break;
            end;
         end;
         if ~Flag,
            error(message('dsp:ftransfargchk:FilterErr1', varname));
         end;

      case 'real'
         if ~isreal(var),
            error(message('dsp:ftransfargchk:FilterErr2', varname));
         end

      case 'positive'
         if var < 0,
            error(message('dsp:ftransfargchk:FilterErr3', varname));
         end

      case 'negative'
         if var > 0,
            error(message('dsp:ftransfargchk:FilterErr4', varname));
         end

      case 'int'
         if mod(var,1) > eps,
            error(message('dsp:ftransfargchk:FilterErr5', varname));
         end

      case 'scalar'
         if ~isscalar(var),
            error(message('dsp:ftransfargchk:FilterErr6', varname));
         end

      case 'string'
         if ~ischar(var),
            error(message('dsp:ftransfargchk:FilterErr7', varname));
         end

      case 'pass/stop'
         if ~strcmpi(var,'pass') && ~strcmpi(var,'stop'),
            error(message('dsp:ftransfargchk:FilterErr8', varname));
         end

      case 'vector'
         if ~isvector(var),
            error(message('dsp:ftransfargchk:FilterErr9', varname));
         end

      case 'vector2'
         if ~isvector(var) || length(var)~=2,
            error(message('dsp:ftransfargchk:FilterErr10', varname));
         end

      case 'numeric'
         if ~isnumeric(var),
            error(message('dsp:ftransfargchk:FilterErr11', varname));
         end

      case 'normalized'
         if (min(var(:)) <= 0)  || (max(var(:)) >= 1),
            error(message('dsp:ftransfargchk:FilterErr12', varname));
         end

      case 'normalized + edge'
         if (min(var(:)) < 0)  || (max(var(:)) > 1),
            error(message('dsp:ftransfargchk:FilterErr13', varname));
         end

      case 'full normalized'
         if (min(var(:)) <= -1) || (max(var(:)) >= 1),
            error(message('dsp:ftransfargchk:FilterErr14', varname));
         end

      case 'full normalized + edge'
         if (min(var(:)) < -1) || (max(var(:)) > 1),
            error(message('dsp:ftransfargchk:FilterErr15', varname));
         end

      case 'even'
         if mod(length(var),2) > eps,
            error(message('dsp:ftransfargchk:FilterErr16', varname));
         end

      case 'odd'
         if mod(length(var),2) - 1 > eps,
            error(message('dsp:ftransfargchk:FilterErr17', varname));
         end

      otherwise
         error(message('dsp:ftransfargchk:FilterErr'));
   end;

   if ~isempty(errmsg), break, end;

end;


% --------------------------------------------------------------------

function t = isvector(v)
%ISVECTOR  True for a vector.
%   ISVECTOR(V) returns 1 if V is a vector and 0 otherwise.

t = (ndims(v) == 2) & (min(size(v)) <= 1);

% --------------------------------------------------------------------

function t = isscalar(v)
%ISSCALAR  True for a scalar or empty.
%   ISSCALAR(V) returns 1 if V is a scalar and 0 otherwise.

t = (ndims(v) == 2) & (max(size(v)) <= 1);
