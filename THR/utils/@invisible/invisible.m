function I = invisible
% invisible - construct invisible object.
%    invisible returns an object that is not displayed.
I = class(struct([]), mfilename);
