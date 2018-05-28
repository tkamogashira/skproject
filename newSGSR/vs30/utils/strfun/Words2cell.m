function [c, Nw] = w2c(str,D);
% Words2cell - distribute white-space separated words of char string to cell array
%   Words2cell(s) deals words separated by white space
%   Words2cell(s,d) deals words separated by characters in d
%   Note: multiple adjacent delimiters count as one
% 
%   See also ISSPACE, STRTOK


% find positions of delimiters
if nargin<2,
   isep = find(isspace(str));
else, 
   isep = strfind(str,D);
end

isep = [0 isep length(str)+1]; % virtual separators enclosing the string
multsep = [diff(isep)==1];  % repeated delimeter is single delimeter by convention
isepend = isep(find(~multsep));
isepstart = isep(find([0 ~multsep]));
iwordstart = 1+isepend;
iwordend = isepstart-1;
Nw = length(iwordstart);
c = cell(1,Nw);
for ii=1:Nw,
   c{ii} = str(iwordstart(ii):iwordend(ii));
end