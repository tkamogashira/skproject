function plotScale(WFP, params)
% DRAWUNITBOX

%% Get size of current axis
xRng = xlim;
xSize = abs(diff(xRng)); 

%% Calculate coordinates of unitbox
[yMin, yMax] = getYRange(WFP, params, params.logY);
xPos = xRng(1) + 0.05*xSize;
yPos = WFP.ZData{params.scaleRow};
height = yMax;

%% Then plot
line([xPos, xPos, xPos], [yPos, yPos + height/2, yPos + height], 'color', 'k', 'marker', '+', 'linewidth', 1.5);
line([xPos-0.01*xSize, xPos+0.01*xSize], [yPos, yPos], 'color', 'k', 'linewidth', 1.5);

% %Plot legend ...
text(xPos+0.01*xSize, yPos, '0.00', 'fontsize', 10, 'FontWeight', 'demi');
text(xPos+0.01*xSize, yPos + height/2, num2str((height/2)/params.scale, '%0.2f'), 'fontsize', 10, 'FontWeight', 'demi');
text(xPos+0.01*xSize, yPos + height, num2str(height/params.scale, '%0.2f'), 'fontsize', 10, 'FontWeight', 'demi');