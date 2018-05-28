function str = UIstr(h);
str = get(h,'string');
if iscell(str); str = str{1}; end;
