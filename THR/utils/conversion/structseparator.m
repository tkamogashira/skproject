function sep = structseparator(isep);
% structseparator - helper function for structPart, etc
%
%   See also struct/union, CombineStruct.

if isep<=26,
    offset = double('a')-1;
elseif isep<=52,
    offset = double('A')-1;
    isep = isep-26;
else,
    error('isep>52');
end
sep = [char(isep+offset) '_______________'];

        
        
        
        
        
        
        