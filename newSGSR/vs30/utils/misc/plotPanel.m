function Y = plotPanel(keyword,X);
% plotPanel - global definition of plot panels (axes handles)
%   plotPanel('define', [h1 h2 ... hN]) defines h1 .. hN to be
%        the current sub-plot handles.
%
%   H = plotPanel('draw', P) creates a collection of axes in the
%       current figure and gives them position P(1,1:4), P(2,1:4) ..
%       This collection is then defined to be the current set.
%       The handles of the axes are retruned in vector H.
%
%   plotPanel('default', [M N]) creates default set of MxN subplot 
%        panels
%
%   plotPanel('clear') clears any existing info on plot panels
%
%   plotPanel('current', [k l ..]) makes handles with indices [k l ..]
%   the current subset of handles.
%
%   plotPanel(I) selects panel I from the current subset and 
%   makes it the current axes. If no current set is defined, the 
%   whole set of handles is used.
%
%   YN = plotPanel('exist') returns 1 if panels have been defined
%   and if their axes still exist.

persistent PanelHandles CurrentHandleSet

if isnumeric(keyword), % syntax: plotPanel(I)
   I = keyword;
   if isempty(PanelHandles), error('No plot panels defined.'); end
   if ~ismember(I,1:length(PanelHandles)), 
      error('Invalid plotpanel index.'); end
   if ~isempty(CurrentHandleSet), I = CurrentHandleSet(I); end
   axes(PanelHandles(I));
elseif isequal('define', keyword), % plotPanel('define', [h1 h2 ... hN])
   plotPanel('clear'); % clear any previous values
   PanelHandles = X;
elseif isequal('draw', keyword), % plotPanel('draw', P)
   plotPanel('clear'); % clear any previous values
   for ip = 1:size(X,1),
      PanelHandles(ip) = axes('position', X(ip,:));
   end
   Y = PanelHandles;
elseif isequal('default', keyword), % plotPanel('default', [M N]) 
   plotPanel('clear'); % clear any previous values
   for ip = 1:prod(X),
      PanelHandles(ip) = subplot(X(1), X(2), ip);
   end
elseif isequal('clear', keyword), % plotPanel('clear')
   PanelHandles = []; CurrentHandleSet = [];
elseif isequal('current', keyword), % plotPanel('current', [k l ..])
   CurrentHandleSet = X;
elseif isequal('exist', keyword), % plotPanel('exist')
   Y = 0; % pessimistic default
   if isempty(PanelHandles), return; end % special case, needed because ishandle([]) returns []
   Y = all(ishandle(PanelHandles));
end



