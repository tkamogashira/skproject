function structview(varargin)
%STRUCTVIEW  View the elements of a structure array.
%   STRUCTVIEW(S) displays the elements of an array of structures in
%   a graphical spreadsheet. The fieldnames of the structure-array are
%   displayed in the top header bar of this spreadsheet.
%   By clicking on the header bar the spreadsheet will automatically be
%   sorted in ascending order according to that column. Clicking for the
%   second time on the same item of header bar will sort the spreadsheet
%   in descending order. Columns can be dragged around.
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument.
%
%   See also STRUCTSORT, STRUCTFILTER, STRUCTMERGE, STRUCTFIELD and STRUCTPLOT

%B. Van de Sande 21-02-2005

%Using interface of MATLAB (MWT) instead of Swing interface to get more
%integrated results ...
import javax.swing.* com.mathworks.mwt.* 

%------------------------------default parameters---------------------------
if (nargin >= 1)
    StructName = inputname(1);
else
    StructName = '';
end
DefParam.titletxt       = sprintf('Elements of structure-array %s', StructName);
DefParam.fields         = cell(0);
DefParam.indexrow       = 'on'; %'on' or 'off' ...
DefParam.emptyformat    = '';
DefParam.charstrformat  = '';
DefParam.integerformat  = '%.0f';
DefParam.flpointformat  = '%.3f';
DefParam.unknownformat  = '<invalid>';
DefParam.maxcolwidth    = 10;   %in characters ...

%--------------------------------main program-------------------------------
%Checking input arguments ...
if (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'callback') %Callback function ...
    CallBackFnc;
    return
elseif (nargin == 1) && ischar(varargin{1}) && strcmpi(varargin{1}, 'factory')
    disp('Properties and their factory defaults:')
    disp(DefParam);
    return
elseif (nargin == 0) || ~isstruct(varargin{1})
    error('Wrong input arguments.');
end
S = varargin{1};
Param = checkproplist(DefParam, varargin{2:end});
Param = CheckParam(Param);

%Reorganizing the structure array ...
if isempty(S)
    error('Empty structure-array.');
end
try
    [C, F] = destruct(S);
catch destructErr
	throw(destructErr);
end
NFields = length(Param.fields);
if (NFields > 0)
    if ~all(ismember(Param.fields, F))
        error('One of the requested fieldnames doesn''t exist.');
    end
    for n = 1:NFields
        idx(n) = find(ismember(F, Param.fields{n}));
    end
    F = F(idx);
    C = C(:, idx);
end    
if strcmpi(Param.indexrow, 'on')
    NRow = size(C, 1);
    F = [{'RowIdx'}, F];
    C = [num2cell(1:NRow)', C];
end

[NRow, NCol] = size(C);

%Formating elements of table and converting all elements to character strings ...
D = cell2cellstr(C, 'coloriented', 'yes', 'emptyformat', Param.emptyformat, ...
   'charstrformat', Param.charstrformat, 'integerformat', Param.integerformat, ...
   'flpointformat', Param.flpointformat, 'unknownformat', Param.unknownformat);

%Determining width of columns ...
ColumnNChar = max(cellfun('length', [F; D]));
ColumnNChar(ColumnNChar > Param.maxcolwidth) = Param.maxcolwidth;
ColumnWidth = ColumnNChar * 8;
TableWidth  = sum(ColumnWidth);

%Display of data ...
Fobj = MWFrame(Param.titletxt);
ScrSz = Fobj.getToolkit.getScreenSize;

Tobj = javaObject('javax.swing.JTable', D, F);

Hobj = Tobj.getTableHeader;
set(Hobj, 'ReorderingAllowed', 'on');
set(Hobj, 'MouseClickedCallBack', 'structview(''callback'');');
Tobj.setTableHeader(Hobj);

CMobj = Tobj.getColumnModel;
for n = 1:NCol
    Cobj = CMobj.getColumn(n-1);
    Cobj.setPreferredWidth(ColumnWidth(n));
end

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

%Assembling userdata ...
UD.HdrCaption   = F;
UD.HdrSortOrder = repmat(0, 1, NCol); %0 is not sorted, 1 or 2 is sorted in ascending or descending order ...
UD.HdrObj       = Hobj;
UD.TblData      = C;
UD.TblDataDisp  = D;
UD.TblSize      = [NRow, NCol];
UD.TblObj       = Tobj;
UD.InCallBack   = false;
set(Hobj, 'UserData', UD);

%---------------------------local functions------------------------
function Param = CheckParam(Param)

if ~ischar(Param.titletxt) || ndims(Param.titletxt) ~= 2 || ...
        (~isempty(Param.titletxt) && ~any(size(Param.titletxt) == 1))
    error('Invalid value for property titletxt.'); 
end
Param.titletxt = Param.titletxt(:)'; %Always rowvector ...

if ~iscellstr(Param.fields) && ~ischar(Param.fields)
    error('Invalid value for property fields.'); 
end
Param.fields = cellstr(Param.fields); 

if ~any(strcmpi(Param.indexrow, {'on', 'off'}))
    error('Property indexrow must be ''on'' or ''off''.'); 
end
if ~isnumeric(Param.maxcolwidth) || (length(Param.maxcolwidth) ~= 1) || ...
        (Param.maxcolwidth <= 0) || (mod(Param.maxcolwidth, 1) ~= 0)
    error('Invalid value for property maxcolwidth.'); 
end

%-------------------------callback function------------------------
function CallBackFnc

UD = get(gcbo, 'UserData');
if UD.InCallBack
    return; %Gate watch ...
else
    UD.InCallBack = true; 
    set(gcbo, 'UserData', UD); 
    UD.InCallBack = false;
end    
MD = get(gcbo, 'MouseClickedCallBackData');
[NRow, NCol] = deal(UD.TblSize(1), UD.TblSize(2));

%Check of columns were not dragged around by the user ...
Captions = GetCurrentHdrCaptions(UD.TblObj);
for n = 1:NCol
    ReOrderIdx(n) = find(ismember(UD.HdrCaption, Captions(n)));
end
UD.HdrCaption   = UD.HdrCaption(ReOrderIdx);
UD.HdrSortOrder = UD.HdrSortOrder(ReOrderIdx);
UD.TblData      = UD.TblData(:, ReOrderIdx);
UD.TblDataDisp  = UD.TblDataDisp(:, ReOrderIdx);

%Find out which column was clicked by the user ...
ColNr = UD.HdrObj.columnAtPoint(java.awt.Point(MD.point(1), MD.point(2))) + 1;
PrevColNr = find(UD.HdrSortOrder > 0);

%Sorting data ...
switch UD.HdrSortOrder(ColNr)
    case {0, 2}
        SortOrder = 1;
    case 1
        SortOrder = 2;
end

if isa(UD.TblData{1, ColNr}, 'double')
    [dummy, idx] = sort(cat(1, UD.TblData{:, ColNr}));
elseif isa(UD.TblData{1, ColNr}, 'char')
    [dummy, idx] = sort(UD.TblData(:, ColNr)); 
else
    warning('Cannot sort according to requested column.');
    idx = 1:NRow;
end
if SortOrder == 2
    idx = idx(end:-1:1);
end

if ~isempty(PrevColNr)
    UD.HdrSortOrder([PrevColNr ColNr]) = [0 SortOrder];
else
    UD.HdrSortOrder(ColNr) = SortOrder;
end
UD.TblData     = UD.TblData(idx, :);
UD.TblDataDisp = UD.TblDataDisp(idx, :);

%Adjusting header ...
if ~isempty(PrevColNr),
    Caption = char(UD.HdrCaption(PrevColNr)); Caption(end-2:end) = [];
    UD.HdrCaption(PrevColNr) = java.lang.String(Caption);
end

Caption = UD.HdrCaption{ColNr};
switch SortOrder
    case 1
        Caption = [Caption '(v)'];
    case 2
        Caption = [Caption '(^)'];
end
UD.HdrCaption{ColNr} = Caption;

%Refresh table and header ...
if ~exist('JTableExt', 'class') %Slow when using the MATLAB interpreter ...
    CMobj = UD.TblObj.getColumnModel;
    if ~isempty(PrevColNr)
        CMobj.getColumn(PrevColNr-1).setHeaderValue(UD.HdrCaption{PrevColNr});
    end
    CMobj.getColumn(ColNr-1).setHeaderValue(UD.HdrCaption{ColNr});
    
    for r = 1:NRow
        for c = 1:NCol,
            UD.TblObj.setValueAt(UD.TblDataDisp{r, c}, r-1, c-1);
        end
    end
else
    JTableExt.updateTable(UD.TblObj, UD.TblDataDisp, UD.HdrCaption);
end

%Actualize UserData ...
set(gcbo, 'UserData', UD);

%------------------------------------------------------------------
function Captions = GetCurrentHdrCaptions(TblObj)

CMObj = TblObj.getColumnModel;
NCol = CMObj.getColumnCount;
for n = 0:(NCol-1)
    Captions{n+1} = CMObj.getColumn(n).getHeaderValue;
end

%------------------------------------------------------------------