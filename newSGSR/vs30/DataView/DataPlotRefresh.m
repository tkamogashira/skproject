function DataPlotRefresh(figh);
% DataPlotRefresh - undress dataplot figure to newborn state

% legal children were registered when born (see openDialog)

legalch = getUIprop(figh, 'Iam.EveryHandleAndAll');
%get(legalch, 'tag')

% all children, visible or not
shh = get(0,'showhiddenhandles');
set(0,'showhiddenhandles', 'on');
allch = get(figh, 'children');
nonlegals = setdiff(allch,legalch);
%get(nonlegals, 'tag')
delete(nonlegals);
set(0,'showhiddenhandles', shh);

% update UIprops
setUIprop(figh,'Iam.EveryHandleAndAll', allObjectsInFigure(figh));
setUIprop(figh,'Iam.handles' , CollectMenuHandles('', figh));


