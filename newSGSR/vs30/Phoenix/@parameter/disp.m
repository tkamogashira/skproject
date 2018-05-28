function dp = disp(P, Nindent);
% Parameter/DISP - DISP for Parameter objects
%   DISP(P) displays the parameter object P.
%
%   D = DISP(P) returns the same info as char string.
%
%   DISP(P,N) uses N indent spaces instead of default 5.
%
%   See also DISP and documentation on parameter objects.

if nargin<2 Nindent = 5; end;

if isempty(P),
   d = 'empty parameter object';
elseif numel(P)>1,
   d = '';
   for ii=1:numel(P),
      dii = disp(P(ii),0); % no indent
      num = sprintf('%3d: ', ii);
      d = strvcat(d, [num dii]);
   end
elseif isempty(P.Name),
   d = 'void parameter object';
else, % single elem
   valStr = P.ValueStr;
   % provide brackets if needed
   if isempty(findstr('[', valStr)) & ~isempty(findstr(' ', valStr)),
      valStr = bracket(valStr);
   end
   d = [P.Name ': ' valStr ' ' P.Unit];
end

% provide indent space
d = [repmat(' ', size(d,1), Nindent) d];

if nargout<1, disp(d); % display if no argout is requested
else, dp = d; % return argout; do not display
end;

