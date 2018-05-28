function OK = checkNaNandInf(pp);

OK = 0;

ERR = '';
if isstruct(pp),
   fns = fieldnames(pp);
   for ifld = 1:length(fns),
      fn = fns{ifld};
      Val = getfield(pp, fn);
      if any(isnan(Val)), ERR = 'NAN'; break;
      elseif any(isinf(Val)), ERR = 'INF'; break;
      end
   end
else, %if isstruct
   if any(isnan(pp)), ERR = 'NAN';
   elseif any(isinf(pp)), ERR = 'INF';
   end
end   

if isequal(ERR,'NAN'),
   UIerror(strvcat('non-numerical or complex', 'values of numerical parameters'));
elseif isequal(ERR,'INF'),
   UIerror('too many numbers specified');
else
   OK = 1;
end
