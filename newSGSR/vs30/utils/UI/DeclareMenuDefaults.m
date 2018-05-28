function DeclareMenuDefaults(MenuName, varargin)

% stores tag/property values in menustatus.defaults
% syntax:
% DeclareMenuDefaults('tag1:prop1', 'tag2:prop2', ..)
% where tagx is the tag of the object and propx the corresponding
% property to be stored.
% At call time, menu must have been opened and
% its handles stored in global Menu Status variable
% (see openUImenu)

Nprop = nargin-1;

[MSname MenuHandles] = MenuStatusName(MenuName);
figh = MenuHandles.Root;
DEFS = struct('tag','','prop','','value','');
iTag = 1;
for iProp=1:Nprop,
   pstr = varargin{iProp};
   [tag prop] = strtok(pstr,':');
   prop(1) = ''; % remove ':' delimiter
   if isequal(tag(1),'*'), % wildcard
      tagList = getWildCardTags(figh,tag);
      for ii=1:length(tagList),
         iTag = iTag+1;
         DEFS(iTag) = DEFS(1); % get right format
         % add this tag/prop/value triple to defaults
      	DEFS(iTag).tag = tagList{ii};
      	DEFS(iTag).prop = prop;
      end
   else
      iTag = iTag+1;
      DEFS(iTag) = DEFS(1); % get right format
      % add this tag/prop pair to MS.defaults
      DEFS(iTag).tag = tag;
    	DEFS(iTag).prop = prop;
   end
end
% remove dummy first DEFS element
DEFS(1) = [];

% store this DEFS struct in global menu status
eval(['global ' MSname ';']);
eval([MSname '.defaults = DEFS;']);

