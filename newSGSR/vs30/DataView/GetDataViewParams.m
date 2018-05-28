function [params, storedparams, trail] = GetDataViewParams(callerfnc, ds, iSub, varargin);
% GetDataViewParams - collect non-default params from cache and from function arguments

% get factory defaults from caller function like ucrate, etc.
eval(['params = ' callerfnc ' (''factory'');' ]);
DefFieldnames = fieldnames(params); % need field names to make sure that no new names are added below

storedparams = UCdefaults(callerfnc);

params = CombineStruct(params, storedparams);

% parse trailing parameter specification, if any
if isempty(varargin), trail = [];
elseif isstruct(varargin{1}), % trailing params neatly packed in struct
   trail = varargin{1}; 
elseif isequal('default', varargin{1}), % undo cache stuff; get back to default params
   params = defparams;
   trail = [];
else, % prop/val pairs (empty values prevent simple struct(varargin{:})); gotta use for loop instead
   trail = [];
   Nvara = length(varargin);
   for ipair = 1:fix(Nvara/2),
      prop = varargin{2*ipair-1};
      val = varargin{2*ipair};
      if isempty(prop), break; end;
      eval(['trail.' prop '= val;']);
   end
end;
params = CombineStruct(params, trail);
if isfield(params, 'defaultvalues'), params = rmfield(params, 'defaultvalues'); end % temp hack 
% check if new names have been added that were not present in default set
newNames = setdiff(fieldnames(params) , DefFieldnames);
if ~isempty(newNames),
   nn = char(newNames); NN = size(nn,1); bl = blanks(NN)'; nn = [nn bl]';
   error(['Unknown parameters named: ' nn(:).' '.']);
end

if ~isempty(iSub), params.iSub = iSub; end;
