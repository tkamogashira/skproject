function ggren(n,newName);

if length(n)>1,
   for ii=n(:).', ggren(ii,newName); end;
   return;
end

global GG;

TAG = get(GG(n),'Tag');
postfixes = {'Unit', 'Edit','Prompt','FrameTitle','Frame','Menu','MenuItem'};
newTag = '';
for ii = 1:length(postfixes),
   if StrEndsWith(TAG, postfixes{ii}),
      newTag = [newName postfixes{ii}];
      break;
   end
end
if isempty(newTag),
   disp(['non-standard tag ''' TAG '''']);
else
   ggtag(n,newTag);
end
   

