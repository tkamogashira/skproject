function IDpoints(h,GenID, pointID, ID2string, varargin);
% IDpoints - attach identifiers to datapoints in plot
%   IDpoints(H, CommonID, pointID, ID2string) attaches unique identifiers 
%   to the datapoints in line object with handle H. CommonID is an identifier 
%   common to all data  points of H. pointID is an array whose elements
%   correspond to the individual points of the line object. ID2string is a
%   function handle which returns a char string that describes the 
%   datapoint. Its input arguments are CommonID and pointID(k). The string 
%   returned by ID2string is used in GrabPoints as the top label of the 
%   context menu associated with the k-th datapoint.
%
%   IDpoints(H, {ID1 ID2 ..}, pointID, ID2string) results in ID2string to be
%   called with multiple arguments: ID2string(ID1, ID2, .., pointID(k)) when
%   the k-th data point is clicked.
%
%   IDpoints(H, CommonID, pointID, ID2string, Label1, Fcn1, Label2, Fcn2, ...)
%   results in additional menu items to be created in the context menu.
%   Their labels are Label1, Label2, etc.  Fcn1, etc, are function handles
%   When a menu item is selected, the corresponding function is called with 
%   input arguments (CommonID, pointID(k)). If CommonID is a cell array 
%   {ID1 ID2..}, the function is called with input arguments
%   (ID1,ID2, ..., pointID(k)).
%
%   EXAMPLE
%     h=plot(rand(1, 5),'*'); 
%     IDpoints(h,'point # ',{'one' 'two' 'three' 'four' 'five'}, @(x,y)[char(x)  char(y)], 'disp ID', @(x,y)disp([x y])); 
%
%   See also GrabPoints, DataPointMenu.

% this function consist mostly of arg checking:
if ~isSingleHandle(h) || ~isequal('line', get(h,'type')),
    error('Input arg H must be single handle to a LINE object.');
end

if ~iscell(GenID), GenID = {GenID}; end % enforce 2nd syntax (see help text)

Npoints = numel(get(h,'Xdata')); % # plotted points
if ~isequal(Npoints, numel(pointID)),
    error('Number of individual identifiers (elements of pointID) must match # plotted data points in line object.');
end

if ~isfhandle(ID2string),
    error('IDstring input arg must be function handle.');
end

Tmess = 'Trailing arguments to IDpoints must be label/function_handle pairs.';
M2 = numel(varargin);
if ~isequal(0,rem(M2,2)),
    error(Tmess);
end
Ncallback = round(M2/2); MenuItem = struct([]);
for ifcn=1:Ncallback,
    Label = varargin{2*ifcn-1};
    Callback = varargin{2*ifcn};
    if ~ischar(Label) || ~isfhandle(Callback),
        error(Tmess);
    end
    if ifcn==1, clear('MenuItem'); end % stupid matlab conventions on struct assigments
    MenuItem(ifcn) = collectInStruct(Label, Callback);
end
% args checked. Just store the values. They will only be used when a
% datapoint is right-clicked. This is handled by DataPointMenu.

MenuInfo = collectInStruct(h,GenID, pointID, ID2string, Ncallback, MenuItem);

private_StorePointIDs(MenuInfo);

%create or update the context menu of the axes and its lines
grabPoints(parentAxesh(h));



