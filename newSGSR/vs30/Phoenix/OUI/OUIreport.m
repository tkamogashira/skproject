function [h, s, ah] = OUIreport(Mess, varargin);
% OUIreport - display message using standard OUI reporter
%   OUIreport(M) displays the message M in the 'stmess' reporter of
%   the current OUI. And makes sure that the OUI is visible.
%   M can be a char matrix or cell string of chars.
%   If no reporter named 'stdmessage' exist, the M is displayed to
%   the command line.
%
%   OUIreport(M, RGB) also sets the color of the message text to
%   a 1x3 MatLab color specification.
%   OUIreport(M, x) is equivalent to OUIreport(M, [x x x]), that is,
%   print in a gray scale. If RGB = [], the current 
%   color of the stdmess reporter is used. If no color spec is given,
%   [0 0 0], i.e black, is used.
%
%   OUIreport(M,'-append') or OUIreport(M, RGB, '-append') appends
%   the text M to any text already displayed by stdout. The default
%   behavior of OUIreport overwrites any existing text.
%
%   Note: use OUIhandle to write to uicontrols other than stdmess.
%
%   See also paramOUI, OUIOhandle, readOUI, OUIerror.


if iscellstr(Mess), Mess = char(Mess); end % char format is compatible with both disp and set(h, 'string', ..)

doAppend = 0; RGB = [0 0 0];
if nargin>1,
   doAppend = isequal('-append', varargin{end});
   if isnumeric(varargin{1}), RGB = varargin{1}; end
end
if numel(RGB)==1, RGB = RGB*[1 1 1]; end % gray value

if doAppend,
   try,
      [dum, previousMess] = OUIhandle('stdmess'); 
      Mess = strvcat(previousMess, Mess);
   end
end

hmess = []; % default: write to screen
try,   
   hmess = OUIhandle('stdmess', Mess);
   figure(get(hmess, 'parent')); % show figure
catch, disp(Mess);
end;

if ~isempty(RGB) & ~isempty(hmess),
   set(hmess, 'foregroundcolor', RGB);
   drawnow;
end












