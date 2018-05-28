function gd = oUIdata(newgd, varargin);
% OUIdata - get or set data of OUI
%   OUIdata returns the OUI info of current OUI in a struct.
%
%   OUIdata(GI) sets the OUI info to GI. GI must be struct.
%
%   OUIdata('set', field, value, ...) sets the fields of the
%   existing OUI info.
%
%   OUIdata('get', 'foo') returnsfield 'foo' of the OUI info.
%
%   See also paramOUI.

% get handle of OUI and of its hidden uicontrol to store OUI info
figh = paramOUI;
if isempty(figh),
   error('No active OUI found.');
end
udh = findobj(figh, 'tag', 'OUIinfo');
if isempty(udh), % make one
   if nargin<1,
      error('No OUI data stored in figure.');
   end
   udh = uicontrol('visible', 'off', 'enable', 'off', 'tag', 'OUIinfo', 'userdata', newgd);
end

if nargin==1, % replace OUI data
   if ~isstruct(newgd), 
      error('OUI data must be struct.')
   end
elseif (nargin>1) & (isequal('get',newgd)), % get field of OUI data
   gd = get(udh, 'userdata');
   gd = getfield(gd, varargin{1});
   return;
elseif (nargin>1) & (isequal('set',newgd)), % change fields of OUI data
   ud = get(udh, 'userdata');
   newfields = struct(varargin{:});
   if isfield(newfields, 'handles'),
      error('OUIdata field named ''handles'' may not be changed.');
   end
   newgd = combineStruct(ud, newfields);
end

if nargin>1, set(udh, 'userdata', newgd); end

gd = get(udh, 'userdata');



