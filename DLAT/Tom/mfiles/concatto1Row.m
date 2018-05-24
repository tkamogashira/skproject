function Dcon = concatto1Row(D,confield1, confield2, confield3, confield4, confield5, confield6, confield7)

% concatto1Row(struct array D)
% Tool to take the rows in struct array D and replace them by 1 row, 
% and put the values that were in the different rows for the fields 
% specified by confield1 and confield2 as vectors in the resulting one-row-structure array. 
%
% TF 01/09/2005


field1vals=structfield(D,confield1);
field2vals=structfield(D,confield2);
%field3vals=structfield(D,confield3);
%field4vals=structfield(D,confield4);
%field5vals=structfield(D,confield5);
%field6vals=structfield(D,confield6);
%field7vals=structfield(D,confield7);

D=setfield(D,{1},confield1,field1vals);
D=setfield(D,{1},confield2,field2vals);
%D=setfield(D,{1},confield3,field3vals);
%D=setfield(D,{1},confield4,field4vals);
%D=setfield(D,{1},confield5,field5vals);
%D=setfield(D,{1},confield6,field6vals);
%D=setfield(D,{1},confield7,field7vals);

Dcon=D(1);