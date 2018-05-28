function structview(S, TitleTxt)
%STRUCTVIEW  View the elements of a structure array
%   STRUCTVIEW(S) displays the elements of an array of structures
%
%   See also CV2STR

%B. Van de Sande 01-08-2003

MAXCHAR = 10;
MAXPREC = 5;

%Interface gebruikt die meegeleverd werd met MATLAB (MWT) in plaats van de Swing interface, om mooiere 
%integratie te krijgen ...
import javax.swing.* com.mathworks.mwt.* 

%Parameters nagaan ...
if (nargin == 1) & ischar(S) & strcmp(S, 'CALLBACK'), callbackfunc; return; end %CALLBACK ...

switch nargin
case 1, TitleTxt = ['Elements of structure-array ' inputname(1)];
case 2, 
otherwise, error('Wrong number of input arguments.'); end

if ~isstruct(S) | ~ischar(TitleTxt) | ndims(TitleTxt) ~= 2 | ~any(size(TitleTxt) == 1), error('Wrong input arguments.'); end

%De structarray omvormen naar een cellarray ...
[C, F] = destruct(S);
[NRow, NCol] = size(C);

%Mogelijks hybride cellarray omzetten naar cellarray of strings. Dit enkel om de visualisatie per kolom
%beter te regelen, immers JTable object van Swing package kan per kolom verschillend type aan. TRAAG
D = C; idx = find(cellfun('isclass', D, 'double'));
%D(idx) = cleanstr(cellstr(num2str(cat(1, D{idx}), MAXPREC)));
D(idx) = cleanstr(cellstr( eval(sprintf([ '{' repmat('mat2str(D{%d}) ', 1, length(idx)) '}'], idx) )));
%Kolom-  en tabelbreedte nagaan ...
ColumnNChar = max(cellfun('length', [F; D]));
ColumnNChar(find(ColumnNChar > MAXCHAR)) = MAXCHAR;
ColumnWidth = ColumnNChar * 8;
TableWidth = sum(ColumnWidth);

%De gegevens weergeven ...
Fobj = MWFrame(TitleTxt);
ScrSz = Fobj.getToolkit.getScreenSize;

Tobj = javaObject('javax.swing.JTable', D, F);

Hobj = Tobj.getTableHeader;
set(Hobj, 'ReorderingAllowed', 'off');
set(Hobj, 'MouseClickedCallBack', 'structview(''CALLBACK'');');
Tobj.setTableHeader(Hobj);

CMobj = Tobj.getColumnModel;
for n = 1:NCol, Cobj = CMobj.getColumn(n-1); Cobj.setPreferredWidth(ColumnWidth(n)); end

Tobj.setCellEditor([]);
Tobj.setSelectionMode(0);
Tobj.setShowHorizontalLines(0);
Tobj.setAutoResizeMode(0);

Sobj = javaObject('javax.swing.JScrollPane', Tobj);
Sobj.setVisible(1);

Fobj.add(Sobj);
Fobj.addWindowListener(window.MWWindowActivater(Fobj));
Fobj.setSize(min([ScrSz.width-100, TableWidth]), min([ScrSz.height-100, (NRow+1)*20]));
Fobj.setVisible(1);

%Alle gegevens die nodig zijn voor callback meegeven aan userdata property van TableHeader object ...
UD.HdrCaption   = F;
UD.HdrSortOrder = repmat(0, 1, NCol); %0 is niet gesorteerd, 1 is opstijgend en 2 afdalend gesorteerd ...
UD.HdrObj       = Hobj;
UD.TblData      = C;
UD.TblDataDisp  = D;
UD.TblSize      = [NRow, NCol];
UD.TblObj       = Tobj;

set(Hobj, 'UserData', UD);
%-----------------------------------------callback functie-------------------------------------------------
function callbackfunc

MD = get(gcbo, 'MouseClickedCallBackData');
UD = get(gcbo, 'UserData');

[NRow, NCol] = deal(UD.TblSize(1), UD.TblSize(2));

%Nagaan welke kolom aangeklikt werd ...
ColNr = UD.HdrObj.columnAtPoint(java.awt.Point(MD.point(1), MD.point(2))) + 1;
PrevColNr = find(UD.HdrSortOrder > 0);

%De gegevens sorteren volgens deze kolom ...
switch UD.HdrSortOrder(ColNr),
case {0, 2}, SortOrder = 1;
case 1, SortOrder = 2; end

if isa(UD.TblData{1, ColNr}, 'double'), [dummy, idx] = sort(cat(1, UD.TblData{:, ColNr}));
else, [dummy, idx] = sort(UD.TblData(:, ColNr)); end;
if SortOrder == 2, idx = idx(end:-1:1); end

if ~isempty(PrevColNr), UD.HdrSortOrder([PrevColNr ColNr]) = [0 SortOrder];
else, UD.HdrSortOrder(ColNr) = SortOrder; end
UD.TblData     = UD.TblData(idx, :);
UD.TblDataDisp = UD.TblDataDisp(idx, :);

%Aanpassen van de header ...
if ~isempty(PrevColNr),
    Caption = char(UD.HdrCaption(PrevColNr)); Caption(end-2:end) = [];
    UD.HdrCaption(PrevColNr) = java.lang.String(Caption);
end

Caption = UD.HdrCaption{ColNr};
switch SortOrder,
case 1, Caption = [Caption '(v)'];
case 2, Caption = [Caption '(^)']; end
UD.HdrCaption{ColNr} = Caption;

%Header en tabelgegevens weergeven ... 
%Via MATLAB traag ... omwille van het feit dat elk element van de tabel apart moet gewijzigd worden, waardoor
%for-loops moeten gebruikt worden in MATLAB ...
if ~exist('JTableExt', 'class'), 
    CMobj = UD.TblObj.getColumnModel;
    if ~isempty(PrevColNr), Cobj = CMobj.getColumn(PrevColNr-1); Cobj.setHeaderValue(UD.HdrCaption{PrevColNr}); end
    Cobj = CMobj.getColumn(ColNr-1); Cobj.setHeaderValue(UD.HdrCaption{ColNr});
    
    for r = 1:NRow, for c = 1:NCol,
            UD.TblObj.setValueAt(UD.TblDataDisp{r, c}, r-1, c-1);
    end; end;
else, %Daarom via JTableExt class, die static method updateTable heeft, de for-loops via de JAVA interpreter doen ...
    JTableExt.updateTable(UD.TblObj, UD.TblDataDisp, UD.HdrCaption);
end

%gewijzigde UserData terug meegeven aan object ...
set(gcbo, 'UserData', UD);