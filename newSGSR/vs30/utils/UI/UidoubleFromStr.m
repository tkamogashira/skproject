function y = UIdoubleFromStr(h,maxlen, interpretExpr);
% UIdoubleFromStr - reads REAL number(s) from string
if nargin<3, interpretExpr = 0; end;
if ischar(h), h = UIhandle([h 'Edit']); end;
if nargin<2, maxlen=inf; end;
str = getstring(h);
if iscell(str); str = str{1}; end;
str = trimspace(str);
if interpretExpr,
   try,
      eval(['y = ' str ';'])
      if ~isnumeric(y), error('catchme'); end;
      mess = '';
   catch, interpretExpr = 0;
   end % try/catch
end
if ~interpretExpr,
   str = decodekstr(str); % allow "3k4" for 3200, etc
   setstring(h,str);
   [y cnt mess] = sscanf(str ,'%f');
end
y = y(:).'; % read as row vector
if ~isempty(mess), y = NaN; end;
if isempty(y) | ~isreal(y), 
   y = NaN;
   setstring(h,'??');
end;
if length(y)>maxlen, y = inf; end;

if any(isnan(y)) | any(isinf(y)) | ~any(isreal(y)), 
   set(h, 'ForegroundColor',[1 0 0]);
else,
   set(h, 'ForegroundColor',[0 0 0]);
end;
