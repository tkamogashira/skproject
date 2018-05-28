function stripIDpoints(fh);
% stripIDpoints - removes all IDpoints-related data from the figure
%   stripIDpoints(H) removes the IDpoints-related data from the figure
%   having graphics handle H. Default handle is GCF. This saves disk space
%   when exporting the figure to a .fig file.
%
%   Note: stripIDpoints indiscriminately removes all iocontextmenu objects
%   from the figure. This may have undesired side effects.
%
%   See also: IDpoints, GCF, SAVE.

if nargin < 1,
    fh = gcf;
end;
if isempty(fh) || ~all(istypedhandle(fh, 'figure')),
    error('Argument of stripIDpoints must be nonempty array of figure handles.');
end

h = findobj(fh, 'type', 'uicontextmenu');
delete(h);




