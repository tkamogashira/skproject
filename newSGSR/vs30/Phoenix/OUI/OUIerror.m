function RV = OUIerror(Mess, handles);
% OUIerror - display error message using standard OUI reporter
%   OUIerror(M) displays the message M in the 'stmess' reporter of
%   the current OUI and makes sure that the OUI is visible.
%   M can be a char matrix or cell string of chars.
%   If no reporter named 'stdmess' exist, M is displayed to
%   the command line. A header '---ERROR---' is added to the
%   message, and the text is displayed in dark red.
%   If M is empty, no action whatsoever is taken.
%
%   OUIerror returns 0 if M is empty, 1 otherwise. This allows
%   for usage like: 
%       if OUIerror(mess), return, end;
%   Here the action depends on the emptiness of mess.
%
%   OUIreport(M, h) also sets the value of the forgroundcolor property 
%   of handle(s) h to bright red. The handles h may alternatively be
%   specified as a char string, in which case OUIhandle is used to
%   find the corresponding graphics handles.
%
%   See also paramOUI, readOUI, OUIreport.


RV = ~isempty(Mess); % see help text
if ~RV, return; end;

DarkRed = [0.75 0 0.1];
BrightRed = [1 0 0];
if nargin<2, handles = []; end

if iscellstr(Mess), Mess = char(Mess); end % char format is compatible with both disp and set(h, 'string', ..)
Mess = strvcat('---ERROR---', Mess);
OUIreport(Mess, DarkRed);
if ~isempty(handles) & ~isempty(OUIhandle),  % 2nd condition: OUI must exist
   if ischar(handles), handles = cellstr(handles); end
   if iscellstr(handles),
      [dum, str] = OUIhandle(handles, nan, 'foregroundcolor', BrightRed);
   else, % handles themselves
      set(handles, 'foregroundcolor', BrightRed);
   end
end

