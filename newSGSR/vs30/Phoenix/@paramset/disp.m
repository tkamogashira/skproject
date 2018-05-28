function dp = disp(S, Nindent);
% paramset/DISP - DISP for paramset objects
%   DISP(S) displays the paramset object S.
%
%   D = DISP(S) returns the same info as char string.
%
%   DISP(S,N) uses N indent spaces instead of default 5.
%
%   See also DISP and documentation on paramset objects.

if nargin<2 Nindent = 5; end;

if isempty(S),
   d = 'empty paramset object';
elseif numel(S)>1,
   d = num2sstr(size(S));
   d = strsubst(d, ' ', 'x');
   d = [d ' paramset object' ];
elseif isvoid(S),
   d = 'void paramset object';
else, % single elem
   d = [S.Type ' paramset named ' S.Name ' vs ' num2str(S.Version) '   (' S.Description ')' ];
   if ~isempty(S.Stimparam), % compile comma separated list of par names
      d = strvcat(d, disp(S.Stimparam,3));
   else,
      d = strvcat(d, 'No parameters defined.');
   end
end

% provide indent space
d = [repmat(' ', size(d,1), Nindent) d];

if nargout<1, disp(d); % display if no argout is requested
else, dp = d; % return argout; do not display
end;


