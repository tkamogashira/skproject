function H = xplot(varargin)
% xplot - add plot to existing plot(s)
%    xplot(..) sets the current figure in "hold on mode", calls
%    plot(..) and restores the original hold mode of the current axes.
%    xplot also brings the current plot to the foreground.
%
%    xplot(..., 'n') is equivalent to plot(...). ['n' for 'new']
%
%    xplot returns the handles returned by plot.
%
%    See also figure, dplot, xdplot.

%figure out whether first input arg is handle to axes
if issingleHandle(varargin{1}) & isequal(get(varargin{1}, 'Type'),'axes'),
    axes(varargin{1}); %goto these axes
    varargin = varargin(2:end); %remove handle from list
end

if (nargin>1) && isequal('n', varargin{end}),
    % by convention xplot(..., 'n') is equivalent to plot(...)
    h = plot(varargin{1:end-1});
else, % add plot
    ih = ishold;
    hold on;
    h = plot(varargin{:});
    if ~ih, hold off; end
end
figure(gcf);

% only return outarg if explicitly requested (suppress unwanted echoing)
if nargout>0,
    H  = h;
end
