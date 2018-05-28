function uirm(figh);

% removes subunit
if nargin<1, figh=gcf; end;

% get subunits
SU = uigetSU(figh);
% display them
N = length(SU);
for ii=1:N,
   if isfield(SU{ii},'filename'),
      disp([num2str(ii) ': ' SU{ii}.filename]);
   end
end
% ask user which one to remove
ToRemove = input('index of SubUnit to remove: ');
% check if index is valid
if ~isfield(SU{ToRemove},'filename'),
   error('invalid index');
end
% first remove all controls in the subunit
RSU = SU{ToRemove};
Ntag = length(RSU.tags);
for ii=1:Ntag,
   rh = findobj(figh, 'tag', RSU.tags{ii});
   if ishandle(rh), 
      delete(rh); 
   else,
      warning(['cannot remove uicontrol ' RSU.tags{ii} ' - not found ']);
   end
end   
% now cut out the subunit from the list
Survive = 1:N;
Survive(ToRemove) = [];
newindex = 0;
for ii=Survive,
   newindex = newindex + 1;
   newSU{newindex} = SU{ii};
end
rget;
% store newSU in figure
uisetSU(newSU, figh);
