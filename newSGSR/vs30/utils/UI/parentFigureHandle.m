function ph = parentFigureHandle(h);
% parentFigureHandle - returns handle to (grand-) parent figure of objects
%    parentFigureHandle(h) returns the handle of the figure
%    to which the object with handle h belongs.
%    If h is already a figure handle, h itself is returned.
%    Nan is returned for non-handle input(s) and for handles
%    that do not belong to a figure.
%
%    Note that for menus, the parent figure can be the grandparent,
%    grand-grandparent, etc, of the graphics object.
%
%    Vector-valued inputs are allowed: 
%       parentFigureHandle([h1 h2 ..]) is the same as
%       [ parentFigureHandle(h1) parentFigureHandle(h2) .. ].

Nrec = 20; % max recursion limit (max # generations checked)

ph = nan*zeros(size(h));;

for ii=1:numel(h),
   hi = h(ii); % current child handle
   phi = nan; % provisional parent
   if ~ishandle(hi), continue; end
   for jj=1:Nrec,
      if isequal('figure', get(hi, 'type')), % gotcha
         phi = hi;
      end
      if isequal(0,hi), break; end % arrived at Root -> no figure in ancestors
      hi = get(hi, 'parent');
   end
   ph(ii) = phi;
end







