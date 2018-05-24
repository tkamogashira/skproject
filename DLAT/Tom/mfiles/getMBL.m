function ou = getMBL(D)

% getMBL(struct array D)
% Reads SPL-values in the field x-val out of struct array D and returns the 
% 'mean binaural level' for each row as a vector

nd=numel(D);
ou=zeros(1,nd);

for i=1:nd
    xval=D(i).xval;
    ou(i)=(xval(1)+xval(numel(xval)))/2;    
end