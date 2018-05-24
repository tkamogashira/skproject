function H = plotcontour(CC, ah, varargin)
% plotcontour - plot CONTOUR output and plot it as lines
%
%   h = plotcontour(CC) takes the output from the functions contour.m,
%   contourf.m, or contourc.m and plots these lines in the current axes with
%   the default Matlab plotting color. The returned variable h is a column
%   array of handles to the plotted lines. This is different from the 
%   graphs produces by CONTOUR, etc, because these functions use patches.
%
%   h = plotcontour(CC, ah) does the plotting in the axes specified by the
%   handle ah.
%
%   h = plotcontour(CC, ah, ..) allows specification of plotstyle
%   settings. These are directly passed to PLOT and must be valid inputs 
%   for that function.
%
%   See also CONTOUR, CONTOURF, CONTOURC, PLOT, contour2struct.


if nargin < 3, varargin = {''}; end
if nargin < 2, ah = gca; end
h = [];

axes(ah); %go to approp. axes
HoldSetting = get(gca,'NextPlot'); %remember 'NextPlot' settings
hold on; %go to hold on

%loop of contour chunks
S = contour2struct(CC);
for ii=1:numel(S),
    h(ii) = plot(S(ii).X, S(ii).Y, varargin{:});
end
% ii = 1;
% while ~isempty(CC),
%     [X, Y, CC] = local_section(CC);
%     h(ii) = plot(X, Y, varargin{:});
%     ii = ii+1;
% end
%reset 'NextPlot' settings to what it was
set(gca,'NextPlot',HoldSetting);
h = h(:);
if nargout>0, H=h; end % only return handles when requested

%---- LOCAL ---
function [X, Y, CC] = local_section(CC)
%get next (section of) contour. Then remove the plotted section
%from CC and return.

chunk = (1:CC(2,:))+1;
X = CC(1,chunk);
Y = CC(2,chunk);
CC(:,[1 chunk]) = [];




