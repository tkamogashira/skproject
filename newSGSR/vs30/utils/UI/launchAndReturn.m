function y = launchAndReturn(MenuName,varargin);
% launchAndReturn - make current gcbf invisible, launch new menu and make old dlg visible
%   the new dlg is launched using the generic syntax "MenuName init ..."
%   It is assumed that this call returns only when the new dlg is closed
figh = gcbf;
if ~isempty(figh),
   set(figh,'visible','off');
end

if MenuName(1)=='\', % no implicit 'init' arg
   MenuName = MenuName(2:end);
else, % prepend 'int' to args
   varargin = {'init' varargin{:}};
end

y = feval(MenuName, varargin{:});

if ~isempty(figh),
   set(figh,'visible','on');
end

