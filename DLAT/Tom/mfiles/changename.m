function S = changename(D,oldname,newname);

% changename(struct array D, oldname, newname)
% Changes the name of the field oldname in struct array D in newname. This doesn't work
% for branched fieldnames.
%
% TF 07/09/2005
echo on;

nd=numel(D);


D=setfield(D,{1},newname,NaN);



 for i=1:nd
      D=setfield(D,{i},newname,getfield(D,{i},oldname));
 end

    

echo off;

S=rmfield(D,oldname);