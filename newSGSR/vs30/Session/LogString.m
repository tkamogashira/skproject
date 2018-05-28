function str = LogString(Nlast, maxWidth);
if nargin<2,
   maxWidth = inf;
end

global LOG

if isempty(LOG),
   str = '';
   return;
end;

if LOG.Full,
   Nlast = min(Nlast,LOG.N);
   first = LOG.Last+1-Nlast;
   if first<1,
      first = first+LOG.N;
   end
else,
   first = max(LOG.First, LOG.Last+1-Nlast);
end

if LOG.Last>=first,
   str = strvcat(LOG.Contents{first:LOG.Last});
else,
   str = strvcat(LOG.Contents{first:LOG.N},...
      LOG.Contents{1:LOG.Last});
end

width = size(str,2);
if width>maxWidth,
   str = str(:,1:maxWidth);
end

