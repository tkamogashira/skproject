function display(Stk)
%DISPLAY    displays stack object
%   DISPLAY(Stk)
%   Input parameter
%   Stk : Stack object to be displayed.
%
%   See also PUSH, POP

VarName = inputname(1);
if isempty(VarName), disp('ans =');
else disp(sprintf('%s =', VarName)); end

if isempty(Stk), fprintf('\tvoid stack object\n');
else
    NItems = Stk.NItems;
    
    if (NItems == 1), fprintf('\tstack object with one item (Maximum: %d).\n\n', Stk.MaxNItems);
    else, fprintf('\tstack object with %d items (Maximum: %d).\n\n', NItems, Stk.MaxNItems); end
    
    for ItemNr = 1:NItems, fprintf('\t%d:\t%s\n', ItemNr, class(Stk.Data{ItemNr})); end    
end