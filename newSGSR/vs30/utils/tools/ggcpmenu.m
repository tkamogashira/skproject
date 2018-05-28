function qq = ggcpmenu(n, newTag, newLabel);
% ggcpmenu - copy uimenu 

global GG;

if ~isequal('uimenu', get(GG(n),'Type')),
   error('Not a uimenu object.')
end
qq = get(GG(n));
qq = rmfield(qq,{'BeingDeleted' 'Type' 'Position'});
qq.Tag = [newTag 'MenuItem'];
qq.Label = newLabel;
