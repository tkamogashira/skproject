function CleanUImessStack;
% CleanUImessageStack - removes dead handles from UImessStack
global UImessStack
deadh = find(~ishandle(UImessStack));
UImessStack(deadh) = [];

