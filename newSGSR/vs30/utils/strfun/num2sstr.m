function s=num2sstr(x,besmart);
% NUM@SSTR - a version of num2str that attempts to be short
if nargin<2, besmart=0; end;
if length(x)>1,
   if besmart, % look if x is linspace-like vector
      doReturn = 1;
      mas = mean(abs(x(:)));
      if mas>0,
         DX = 1e-4*mas*unique(round(1e4*diff(x)/mas));
      else, DX = unique(diff(x));
      end
      if (length(x)>2) & (length(DX)==1), % i.e., equally spaced
         if DX==1, dstr=':'; else, dstr=[':' num2sstr(DX) ':']; end
         s = [num2sstr(x(1)) dstr  num2sstr(x(end))];
      else, doReturn = 0;
      end
      if doReturn, return; end;
   end
   MMM = max(abs(x(find(~isinf(x))))); x(find(abs(x)<1e-5*MMM))=0; % restrict dynamic range
   s = '';
   for ii=1:length(x),
      s = [s ' ' num2sstr(x(ii))];
      s = trimspace(s);
   end
   return;
end

if abs(x)<100, s = num2str(x,3);
elseif abs(x)<1e5, s = num2str(round(x),5);
else, s = num2str(x,2);
end
% remove unnecesary zeros in exponent
while 1,
   if length(s)<3, break; end; % take care of strange findstr conventions
   ii = findstr(s, 'e+0');
   if isempty(ii), break; end;
   s(ii+2)='';
end
while 1,
   if length(s)<3, break; end; % take care of strange findstr conventions
   ii = findstr(s, 'e-0');
   if isempty(ii), break; end;
   s(ii+2)='';
end
