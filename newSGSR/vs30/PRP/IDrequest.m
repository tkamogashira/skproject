function [id, idOld] = IDrequest(requestType, MN);
% IDrequest - request for ID of currently recorded sequence
global SESSION StimMenuStatus IDrequestMenuStatus
persistent curID

if nargin<2, 
   global StimMenuStatus
   try, MN = StimMenuStatus.MenuName; catch, MN = 'test'; end % for debugging purposes
end

if ~isempty(gcbo) & (nargin==0),
   % IDrequest is called as a callback of ...
   % ... a ui control of the IDrequest window
   requestType = get(gco, 'tag');
end

if isequal(requestType,'debug'),
   keyboard;
   return;
end

id = '';

if isPDP11compatible(MN),
   iseq = SESSION.SGSRSeqIndex;
   idOld = ['Seq ' num2str(SESSION.iSeq) ' (' MN ')'];
else,
   iseq = SESSION.SGSRSeqIndex;
   idOld = ['SGSR-Seq ' num2str(iseq) ' (' MN ')'];
end

if ~SESSION.requestID, 
   id = idOld;
   return;
end;

switch requestType
case 'current',
   if isempty(curID), id = '??'; 
   else, id = curID;
   end
case 'new',
   % a new ID is needed; prompt for one
   hh = openuimenu('IDrequest','','modal');
   % fill the edits/buttons with current values
   setstring(hh.StimEdit, MN);
   setstring(hh.PostfixEdit, '');
   setstring(hh.CellValEdit, num2str(SESSION.iCell));
   setstring(hh.IseqValEdit, num2str(SESSION.iseqPerCell+1));
   setstring(hh.PenDepthEdit, SESSION.PenDepth);
   setstring(hh.ElectrodeNumberEdit, SESSION.ElectrodeNumber);
   setstring(hh.NotifyComputerEdit,SESSION.NotifiedComputer);
   setstring(hh.NotifyPortEdit,num2str(SESSION.NotifyPort));
   if SESSION.KeepPen,
      set(hh.KeepPenButton, 'userdata', 1);  % 1 = YES
      menubuttonmatch(hh.KeepPenButton); % synchronize
   else,% disable PEN-related edits
      set(hh.KeepPenButton, 'userdata', 2);  % 2 = NO
      menubuttonmatch(hh.KeepPenButton); % synchronize
      setstring(hh.PenDepthEdit, '----');
      setstring(hh.ElectrodeNumberEdit, '----');
      set([hh.PenDepthEdit hh.ElectrodeNumberEdit],'enable', 'off');
   end
   % wait for the IDrequest window to be deleted
   IDrequestMenuStatus.ID = '';
   repaintWait(hh.Root);
   id = IDrequestMenuStatus.ID;
   if ~isempty(id), curID = id; end; % store if not empty (=cancelled)
case {'OKButton', 'PostfixEdit', 'CancelButton'}, % real or emulated callback from IDrequest window
   local_OKorCancel(requestType);
case {'KeyHit'};
   the_key = get(gcf,'currentcharacter');
   qq = double(the_key); if isempty(qq), return; end; % tab etc
   switch qq
   case 13, % <return>
      requestType = 'OKButton';
   case 27, % <cancel>
      requestType = 'CancelButton';
   case 110, % "n"
      UIcounter('CellUpButton'); % increase the cell counter
      requestType = 'OKButton';
   otherwise, % not a meaningful key 
      return;
   end
   local_OKorCancel(requestType);
      
end % switch/case


%---------------------------
function local_OKorCancel(TAG);
global SESSION IDrequestMenuStatus
if isequal(TAG,'CancelButton'), 
   delete(gcbf);
   return; 
end;
hh = IDrequestMenuStatus.handles;
iCell = UIdoubleFromStr(hh.CellValEdit);
Iseq = UIdoubleFromStr(hh.IseqValEdit);
NotiComp = trimspace(getstring(hh.NotifyComputerEdit));
NotiPort = UIdoubleFromStr(hh.NotifyPortEdit,1);
MN = getstring(hh.StimEdit);
PF = getstring(hh.PostfixEdit);
if ~CheckNaNandInf([iCell Iseq NotiPort]), return; end;
[dum, KeepPen] = UIintFromToggle(hh.KeepPenButton);
KeepPen = isequal('YES', KeepPen); % Y/N -> 1/0
if KeepPen,
   set([hh.PenDepthEdit hh.ElectrodeNumberEdit],'enable', 'on');
   PenDepth = UIdoubleFromStr(hh.PenDepthEdit);
   ElectrodeNumber = UIdoubleFromStr(hh.ElectrodeNumberEdit);
   if ~CheckNaNandInf([PenDepth, ElectrodeNumber]), return; end;
else, % fake values
   [PenDepth, ElectrodeNumber] = deal(nan,1);
end

figure(hh.Root); drawnow;% make sure focus stays on dialog
if iCell<SESSION.iCell,
   UIwarn('Cell # smaller than last one', hh.CellValEdit);
elseif iCell==SESSION.iCell,
   if Iseq<SESSION.iseqPerCell,
      UIerror('Seq # smaller than last one', hh.IseqValEdit);
      return;
   end
elseif iCell>SESSION.iCell,
   PenStr = ['el(' num2str(ElectrodeNumber) '):' num2str(PenDepth) ' um'];
   addTolog(['------cell ' num2str(iCell) ' -----' datestr(now) '-----' PenStr '---']);
end
% create ID string, but do not return it yet
PF = trimspace(PF);
if ~isempty(PF), PF = ['-' PF]; end; % prepend dash only if a postfix is there
ID_2Breturned = [num2str(iCell) '-' num2str(Iseq) '-' MN PF];

% Notify computer if requested
errormess = localNotify(NotiComp,NotiPort, ID_2Breturned);
if ~isempty(errormess), 
   UIerror(errormess, hh.NotifyComputerEdit); 
   return; 
end

% Green light. Update global SESSION, return the IDstring and close the dialog.
% update SESSION info
SESSION.iCell = iCell;
SESSION.iseqPerCell = Iseq;
SESSION.KeepPen = KeepPen;
SESSION.ElectrodeNumber = ElectrodeNumber;
SESSION.PenDepth = PenDepth;
SESSION.NotifiedComputer = NotiComp;
SESSION.NotifyPort = NotiPort;
IDrequestMenuStatus.ID = ID_2Breturned;
delete(gcbf);


function errormess = localNotify(Compuname, Port, Note);
errormess = '';
if isempty(Compuname), return; end
TimeOut = 5; % sec timeout
try,
   % Compuname, Port, Note
   MsgID = SendMessage (Compuname, Port, Note);
   Tstart = clock;
   MessReceived = 0;
   while etime(clock,Tstart)<TimeOut,
      MessReceived = ~MessagePending(MsgID);
      if MessReceived, break; end
   end
   if ~MessReceived, errormess = ['Timeout reached without conformation from ' Compuname '.']; end
catch
   errormess = stripError(lasterr);
end



