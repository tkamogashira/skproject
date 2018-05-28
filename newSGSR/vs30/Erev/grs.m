function grs(mtdelay, cdelay);
% GRS - grape settings 
%  GRS(mtdelay, cdelay)

if length(mtdelay)==1, 
   mtdelay = [1 mtdelay];
end;
if ~any(isnan(mtdelay)),
   grape('mtdelay', mtdelay);
end
if nargin>1, 
   grape('cdelay', cdelay); 
   apple('cdelay', cdelay);
end;

% grape;










