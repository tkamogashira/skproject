function dp = disp(Q, Nindent);
% Query/DISP - DISP for Query objects
%   DISP(Q) displays the query object Q.
%
%   D = DISP(Q) returns the same info as char string.
%
%   DISP(P,N) uses N indent spaces instead of default 5.
%
%   See also DISP and documentation on query objects.

if nargin<2 Nindent = 5; end;

if isempty(Q),
   d = 'empty query object';
elseif numel(Q)>1,
   d = '';
   for ii=1:numel(Q),
      dii = disp(Q(ii),0); % no indent
      num = sprintf('%3d: ', ii);
      d = strvcat(d, [num dii]);
   end
elseif isvoid(Q),
   d = 'void query object';
else, % single elem
   d = [sprintf('%6s', Q.Style) ' for ' Q.Param.Name ];
   if ~isempty(Q.Prompt),
      d = [d, ' [prompt=''' Q.Prompt ''']'];
   end
end

% provide indent space
d = [repmat(' ', size(d,1), Nindent) d];

if nargout<1, disp(d); % display if no argout is requested
else, dp = d; % return argout; do not display
end;

