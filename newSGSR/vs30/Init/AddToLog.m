function y=AddToLog(str, varargin);

global LOG
persistent logHandle

if isequal(str,'setLogHandle'),
   logHandle = varargin{1};
   localUpdateLogText(logHandle);
   return;
elseif isequal(str,'updateLogText'),
   localUpdateLogText(logHandle);
   return;
elseif isequal(str,'getLogWidth'),
   y = 1000;
   if ishandle(logHandle),
      y = get(logHandle, 'userdata');
      y = y.width;
   else, y = 1000;
   end
   return;
end
if isempty(logHandle), % set to impossible handle value
   logHandle = -1;
end

if isempty(LOG),
   Initlog;
end;

next = LOG.Last + 1;
if next>LOG.N,
   next = 1;
   LOG.Full = 1;
end
LOG.Contents{next} = str;
LOG.Last = next;
if LOG.Full,
   LOG.First = next + 1;
end

% add to log file if any
LFN = dataFile('log');
if ~isempty(LFN),
   AddLineToFile(str, LFN);
   % add extra lines
   for ii=1:length(varargin),
      AddLineToFile(['  ' varargin{ii}], LFN);
   end
end

localUpdateLogText(logHandle);

%-------------------------------
function localUpdateLogText(logHandle);
if ishandle(logHandle),
   try
      FormatInfo = get(logHandle, 'userdata');
      setstring(logHandle, logstring(FormatInfo.Nlines, FormatInfo.width));
   catch
      warning(lasterr);
   end
   drawnow;
end