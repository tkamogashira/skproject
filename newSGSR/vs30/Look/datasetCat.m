function cc = datasetCat(dim, varargin);
% DataSetCat - CAT for dataset objects. Not a method.

if nargin==1,
   hc=[]; 
   return;
end;

% check stimtypes while ignoring empty entries
ST = '';
qq = {};
for ii=1:length(varargin),
   if ~isempty(varargin{ii}),
      st = varargin{ii}(1).StimType;
      if isempty(ST), ST=st; end;
      qq = {qq{:} varargin{ii}};
   end
   if ~isempty(ST),
      if ~isequal(ST,st),
         error('Cannot concatenate dataset having different stimtypes.');
      end
   end
end

cc = builtin('cat', dim, qq{:});