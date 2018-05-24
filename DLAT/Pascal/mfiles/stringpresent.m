function present = stringpresent (s,t)

% stringpresent(string s, char array t)
% Checks if string s is equal to a row in t.
% A vector is returned, with size equal to rows in t, an element is 1
% if s is equal to the corresponding row in t, and 0 otherwise.

sizet = size(t);
nrt = sizet(1);

present = zeros(nrt,1);

for i=1:nrt
       if strcmp(t(i,:),s)
            present(i)=1;   
       end
end