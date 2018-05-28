function AddToDefFileList(newFN);
% adds filename to default menu of stimmenu
% get all filenames
[FN, Index, h, isvis] = FileNameFromDefMenuItem;
NN = 9;
pos = 0;
if nargin>0, % is it new?
   newFN = trimspace(newFN);
   NN = length(h);
   for ii=1:NN,
      fn = lower(trimspace(FN(ii,:)));
      if isequal(fn,lower(newFN)),
         pos = ii;
         break;
      end
   end
else, pos = 1;
end

if pos==0, % New
   FN = strvcat(newFN, FN(1:NN-1,:));
elseif pos>1, % move it up
   FN = strvcat(newFN, FN(1:pos-1,:), FN(pos+1:NN,:));
end

menupos = 0;
for ii=1:NN,
   fn = trimspace(FN(ii,:));
   fn(end);
   if ~isequal('?', fn(end)), 
      menupos = menupos+1;
      set(h(menupos), 'label', ['&' num2str(menupos), ' ' fn]);
      set(h(menupos),'visible', 'on');
   end
end
for ii=menupos+1:NN,
   set(h(ii),'visible', 'off');
end



