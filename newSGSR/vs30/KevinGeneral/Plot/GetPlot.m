function AxHdl = GetPlot(FigHdl, varargin)
%GETPLOT    get axes handle from a figure
%   AxHdl = GETPLOT(FigHdl) gets the handle of the axes object on the figure 
%   specified by its handle FigHdl. If multiple axes objects are present
%   on a figure then a specific axes object can be specified by a scalar or a
%   character string:
%   AxHdl = GETPLOT(FigHdl, LocStr) gets the handle of the axes object on the
%   figure with handle FigHdl and location specified by the character string
%   LocStr. This string can be 'ul'(Upper Left corner), 'll'(Lower Left corner),
%   'ur'(Upper Right corner) and 'lr'(Lower Right corner).
%   AxHdl = GETPLOT(FigHdl, Loc) gets the handle of the axes object on a figure
%   with location specified by a positive integer Loc. The axes objects on a 
%   figure are numbered starting with the object in the upper left corner and
%   counting from left to right and from top to bottom.
%
%   See also PUTPLOT

%B. Van de Sande 13-02-2004
%Compulsively adjusted by Kevin Spiritus 12-04-2007

if (nargin < 1) | ~ishandle(FigHdl) | ~strcmpi(get(FigHdl, 'Type'), 'figure')
    error('First argument should be handle of figure object.');
end

if (nargin == 1)
    Hdls = get(FigHdl, 'Children');
    if (length(Hdls) ~= 1) | ~strcmpi(get(Hdls, 'Type'), 'axes')
        error('Figure contains no or more than one axes object.');
    else
        AxHdl = Hdls; return; 
    end
elseif (nargin == 2),
    if isa(varargin{1}, 'char')
        LocStr = lower(varargin{1});
        if ~any(strcmp(LocStr, {'ul', 'll', 'lr', 'ur'}))
            error('Invalid location string.'); 
        end
        AxHdls = GetAxHdls(FigHdl); 
        NHdls = length(AxHdls); 
        if (NHdls == 0)
            error('No axes objects on figure.'); 
        end
        switch LocStr
        case 'll' %Axes object in lower left corner ...
            [X, Y] = GetLLCorners(AxHdls);
            [dummy, idx] = min(X+Y); 
            AxHdl = AxHdls(idx);
        case 'ur' %Axes object in upper right corner ...
            [X, Y] = GetLLCorners(AxHdls);
            [dummy, idx] = max(X+Y); 
            AxHdl = AxHdls(idx);
        case 'ul' %Axes object in upper left corner ...
            AxHdls = SortAxHdls(AxHdls);
            AxHdl = AxHdls(1);
        case 'lr' %Axes object in lower right corner ...
            AxHdls = SortAxHdls(AxHdls);
            AxHdl = AxHdls(end);
        end
    elseif isa(varargin{1}, 'numeric')
        Loc = varargin{1};
        if (length(Loc) ~= 1) | (Loc <= 0)| (mod(Loc, 1) ~= 0)
            error('Location should be positive integer.'); 
        end
        AxHdls = GetAxHdls(FigHdl);
        NHdls = length(AxHdls);
        if (NHdls == 0)
            error('No axes objects on figure.'); 
        end
        if (Loc > NHdls)
            error('Location doesn''t exist.'); 
        end
        AxHdls = SortAxHdls(AxHdls);
        AxHdl = AxHdls(Loc);
    else
        error('Wrong input arguments.'); 
    end
else
    error('Wrong input arguments.'); 
end

%----------------------------------local functions---------------------------
function Hdls = GetAxHdls(FigHdl)

Hdls = get(FigHdl, 'Children');
idx = find(strcmpi(get(Hdls, 'Type'), 'axes') & ~strncmpi(get(Hdls, 'DeleteFcn'), 'legend', 6));
Hdls = Hdls(idx);
if isempty(Hdls)
    error('Figure contains no axes objects.'); 
end  

%-----------------------------------------------------------------------------
function AxHdls = SortAxHdls(AxHdls)

[X, Y] = GetLLCorners(AxHdls);

[dummy, idx] = sort(X); 
idx = idx(end:-1:1); 
Y = Y(idx); 
AxHdls = AxHdls(idx);

[dummy, idx] = sort(Y); 
idx = idx(end:-1:1); 
AxHdls = AxHdls(idx);

%-----------------------------------------------------------------------------
function [X, Y] = GetLLCorners(AxHdls)

set(AxHdls, 'Units', 'normalized');
Pos = get(AxHdls, 'Position');
if (length(AxHdls) > 1)
    Pos = cat(1, Pos{:}); 
end

X = Pos(:, 1);
Y = Pos(:, 2);
%-----------------------------------------------------------------------------