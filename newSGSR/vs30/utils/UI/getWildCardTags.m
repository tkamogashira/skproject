function tagList = getWildCardTags(figh, postFix);
% returns cell array having tags ending with string postFix

postFix = lower(postFix); 
% remove wildcard character
if postFix(1)=='*', postFix = postFix(2:end); end;
N = length(postFix);

% get handles of its children
oh = findobj(figh);
ii = 0;
for hh=oh',
   TAG = get(hh, 'tag');
   tag = lower(TAG);
   if isequal(findstr(tag,postFix)+N-1, length(tag)),
      ii = ii+1;
      tagList{ii} = TAG;
   end
end
