function Dcon = groupandconcat(D,confield1, confield2)

% groupandconcat(struct array D,confield1, confield2)
% Adjacent rows of struct array D are concatenated as long as the values for the fields
% specified by fields gf1 and gf2 are the same.
% Current settings:
%       gf1 = 'filename'  
%       gf2 = 'fibernr'
% The result is a struct array with one row, and vectors instead of
% numerical values for the 2 fields, confield1 and confield2.
%
% TF 01/09/2005

gf1='filename';
gf2='fibernr';

nd=numel(D);

for i=1:(nd-1)
    for j=i:nd
        %as long as the fields gf1 and gf2 carry the same values, don't break
        try
        if ~(isequal(getfield(D,{j},gf1),getfield(D,{j+1},gf1))&isequal(getfield(D,{j},gf2),getfield(D,{j+1},gf2)))
            break;
        end
        catch %catch error if j+1 is bigger dan D-dimensions
            break;
        end
    end
       
    if j>i %if there are at least two adjacent rows for which gf1 and gf2 have the same value, concatenate those rows and replace
           %them by one row in struct array D
        field1vals=structfield(D(i:j),confield1);
        field2vals=structfield(D(i:j),confield2);
        
        D=setfield(D,{i},confield1,field1vals);
        D=setfield(D,{i},confield2,field2vals);
        
        D=[D(1:i);D((j+1):numel(D))];
        
        nd=numel(D); %this is necessary because the number of elements in struct array D changes as rows are concatenated
    end        
end

Dcon=D;