function ii = strfindcell(CA, P);
% strfindcell - find string within char string array
%   I = strfindcell(CA, P) returns the indices I of
%   char array CA for which CA{I} contains pattern P.

ca = char(CA); % string matrix
sz = size(ca); 
ca = ca'; ca = ca(:)'; % big row vector with all words catted
ii = strfind(ca,P); % where the pattern is in the row vector
dum = zeros(size(ca)); % logical matrix mimicking ca vector
dum(ii) = 1; % where the pattern was found in ca vector
dum = reshape(dum, sz(2), sz(1)); % idem ca matrix
ii = find(sum(dum));% ca entries where the pattern was found

