function DeleteAllFigures

% deletes all MatLab figures regardless of their visibility
set(0,'ShowHiddenHandles','on')
delete(get(0,'Children'))
