function [SU, inUIgroup] = ParseMenu(MenuName,SmallVersions);
% tries to cast a menu in terms of uigroups - temporary util function

if nargin<2, SmallVersions = 0; end;

eval(['open ' MenuName 'Menu.fig;']);
rget; global GG;
UIgroupNames = {...
      'freqsweep',...
      'durations',...
      'DeveloperMenu',...
      'SessionMenu',...
      'levels',...
      'TitledFrame',...
      'presentation',...
      'Modulation',...
      'binbeat',...
      'PRP'};
if SmallVersions,
   UIgroupNames{1} = 'freqsweepSmall';
   UIgroupNames{2} = 'durationsSmall';
end

M = length(UIgroupNames)
% collect tags and try to localize them in existing UIgroups
N = length(GG)-1;
menuTags = cell(1,N);
inUIgroup = cell(1,N);
for ii=1:N,
   menuTags{ii} = get(GG(ii+1),'Tag');
end
GroupAnchors = zeros(1,M);
GroupAnchorNames = cell(1,M);
for iGroup=1:M,
   qq = load([UIgroupNames{iGroup} '.mat']);
   Gtags = qq.tags;
   NGtag = length(Gtags);
   GroupAnchors(iGroup) = qq.anchor;
   GroupAnchorNames{iGroup} = Gtags{qq.anchor};
   for iGtag=1:NGtag,
      gtag = Gtags{iGtag};
      for iMenuTag =1:N,
         if isequal(gtag,menuTags{iMenuTag}),
            inUIgroup{iMenuTag} = [inUIgroup{iMenuTag}, [iGroup; iGtag]];
         end
      end
   end
end   
for iMtag=1:N,
   if isempty(inUIgroup{iMtag}),
      disp([menuTags{iMenuTag} 'not localized']);
   elseif size(inUIgroup{iMtag},2)>1,
      warning([menuTags{iMenuTag} 'detected in multiple groups'])
   end
end
% now find anchors
SUindex = zeros(1,M);
NSU = 0;
for iMtag=1:N,
   if ~isempty(inUIgroup{iMtag}),
      iGroup = inUIgroup{iMtag}(1);
      if ~SUindex(iGroup), % this group is not visited yet
         NSU = NSU + 1;
         SUindex(iGroup) = NSU; % now it is
         iSU = SUindex(iGroup);
         SU{iSU}.filename = [UIgroupNames{iGroup} '.mat'];
         SU{iSU}.tags = [];
         SU{iSU}.anchor = '';
         SU{iSU}.anchorPos = [];
      end
      iSU = SUindex(iGroup);
      ntags = length(SU{iSU}.tags);
      SU{iSU}.tags{ntags+1} = menuTags{iMtag};
      anchorTag = GroupAnchorNames{iGroup};
      if isequal(menuTags{iMtag},anchorTag),
         SU{iSU}.anchor = anchorTag;
         SU{iSU}.anchorPos = get(GG(iMtag+1),'position');
      end
   end
end
% last SU contains is figure properties
SU{NSU+1}.Props = getMenuProps(GG(1));

delete(GG(1));





