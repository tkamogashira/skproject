function handles = uipaste(toScratch,fn,noUserdata,figh);

if nargin<1, toScratch=0; end;
if nargin<2, fn = '*'; end;
if nargin<3, noUserdata = 0; end;
global VERSIONDIR UIGROUP GG

if exist([fn '.mat']),
   FN = which([fn '.mat']);
else,
   [fn fp] = uigetfile([VERSIONDIR '\StimMenu\construction\*.mat'],...
      'Select UIgroup');
   if isequal(fn,0), return; end;
   FN = [fp fn];
end

qq = load(FN); % creates struct qq with fileds named 'uigroup', 'tags' & 'anchor'

if toScratch, 
   open empty.fig;
   figh = gcf;
   delete(get(figh,'children'))
else 
   if nargin<4, figh = GG(1); end;
end
ggpaste(qq.uigroup, figh);
if nargout>0, % collect handles of newly inserted controls
   handles = [];
   for ii=1:length(qq.uigroup),
      handles(ii) = findobj(figh,'tag',qq.uigroup{ii}.Tag);
   end
end


% now look if menu has sessionmenu userdata with subunits listing
% if so, insert the new group
if noUserdata, return; end;
SU = uigetSU(figh);
if ~isempty(SU),
   [PP NN EE] = fileparts(FN);
   newSU{1}.filename = [NN EE];
   % collect non-empty tags
   ntag = 0; 
   for ii=1:length(qq.tags),
      if ~isempty(qq.tags{ii}),
         ntag = ntag+1;
         newSU{1}.tags{ntag} = qq.tags{ii};
      end
   end
   NNN = qq.anchor;
   anchorName = qq.tags{min(NNN,length(qq.tags))};
   newSU{1}.anchor = anchorName;
   ah = findobj(figh,'tag', anchorName)
   newSU{1}.anchorPos = get(ah,'position');
   for ii=1:length(SU),
      newSU{ii+1} = SU{ii};
   end
   UIsetSU(newSU, figh);
end

