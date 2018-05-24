function N = figname(fh, Nam);
% figname - get or set figure name
%   figname(fh, 'Foo') sets the name of the figure with handle fh to Foo.
%   
%   figname(fh) returns the name of the figure with handle fh.
%   If fh is an array, a cell array is returned.
%
%   figname uses getGUIdata and setGuidata.
%   
%   See also getGUIdata, setGUIdata.


if nargin<2 % get,
    if numel(fh)==1,
        N = getGUIdata(fh, 'FigureName', '');
    else,
        for ii=1:numel(fh),
            N{ii} = getGUIdata(fh(ii), 'FigureName', '');
        end
    end
else, % set
    setGUIdata(fh, 'FigureName', Nam);
end