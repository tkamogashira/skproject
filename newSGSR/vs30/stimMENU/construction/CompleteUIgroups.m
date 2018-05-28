function [Tags, AllGroups] = CompleteUIgroups;
% provides tag list to uigroups in mat files - temporary util function

% collect all uigroup files in cell array
global VERSIONDIR ANCHORS
UIgroupDir = [VERSIONDIR '\stimmenu\construction'];
qq= what(UIgroupDir);
fList = qq.mat;
N = length(fList);

% visit all files and collect tags
Tags = cell(1,N);
AllGroups = cell(1,N);
for ii=1:N,
   % disp(['-----' fList{ii} '-----']);
   qq = load(fList{ii});
   M = length(qq.uigroup);
   Tags{ii} = cell(1,M);
   if ~iscell(qq.uigroup), qq.uigroup = {qq.uigroup}; end;
   for jj=1:M,
      if isfield(qq.uigroup{jj},'Tag'),
         Tags{ii}{jj} = qq.uigroup{jj}.Tag;
         % disp([num2str(jj) ': ' Tags{ii}{jj}]);
      end
   end % for jj
   % iAnch(ii) = input('anchor index: ');
   filename = fList{ii};
   tags = Tags{ii};
   uigroup = qq.uigroup;
   anchor = ANCHORS(ii);
   save([UIgroupDir '\' filename],'tags','uigroup','anchor');
   AllGroups{ii} = struct(...
      'filename', fList{ii}, ...
      'tags', [], ...
      'uigroup', [], ...
      'anchor', ANCHORS(ii));
   AllGroups{ii}.Tags = Tags{ii};
   AllGroups{ii}.uigroup = qq.uigroup;
end % for ii

