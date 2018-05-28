function y= uiinitSU(figh);
% initialize subunit-storage in dialog by gathering relevant figure props

if nargin<1, figh=gcf; end;

uuu{1}.Props = GetMenuProps(figh);
set(figh, 'userdata', uuu);

