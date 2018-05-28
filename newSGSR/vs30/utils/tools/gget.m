function ss=gget(n, prop);

global GG;
if ~ishandle(GG(1)), error('gg figure not found'); end;

if nargin<2, prop = ''; end;
if n==0, n=1:length(GG); end;

N = length(n);
if N>1,
   if nargout>0, ss = cell(1,N); end;
   for ii=1:N,
      if nargout<1,
         gget(n(ii),prop);
      else,
         ss{ii} = gget(n(ii),prop);
      end
   end
   return;
end


if isempty(prop),
   rr = get(GG(n));
else
   rr =[];
   try,
      rr = get(GG(n),prop);
   end; % try
end
if nargout<1,
   istag = isequal(lower(prop),'tag');
   if ~isempty(rr) | istag,
      if istag, 
         indexstr = [num2str(n) ': '];
      else,
         TAG = get(GG(n),'tag');
         indexstr = [num2str(n) ' (' TAG ')'  ': '];
      end;
      try,
         disp([indexstr num2str(rr)]);
      catch 
         disp(indexstr);
         disp(rr);
      end;%try/catch
   end;
else
   ss = rr;
end




   