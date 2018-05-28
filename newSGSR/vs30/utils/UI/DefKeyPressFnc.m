function y = DefKeyPressFnc;
% DefKeyPressFnc - default keypressfunction
if isempty(gcbf), return; end;
c = get(gcbf,'CurrentCharacter');
if isempty(c), return; end;
OKh = findobj(gcbf,'tag','OKButton');
Cancelh = findobj(gcbf,'tag','CancelButton');

switch double(c),
case 13, % <CR>
   if ~isempty(OKh),
      if isequal('on', get(OKh,'enable')),
         cb = get(OKh,'callback');
         if isempty(cb), return; end;
         cb = cb(find(cb)~=';');
         feval(cb,'OKButton');
      end
   end
case 27, % <ESC>
   if ~isempty(Cancelh),
      if isequal('on', get(Cancelh,'enable')),
         cb = get(Cancelh,'callback');
         if isempty(cb), return; end;
         cb = cb(find(cb)~=';');
         feval(cb,'CancelButton');
      end
   end
case 23, % <ctrl w>
   close(gcbf);
end

