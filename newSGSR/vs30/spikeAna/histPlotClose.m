function y = histPlotClose;

HPh = findobj('tag','HistPlotMenu');
if ishandle(HPh),
   SaveMenuDefaults('HistPlot');
   delete(HPh);
end