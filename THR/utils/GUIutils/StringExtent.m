function [E, Ext_Empty, Ext_chars] = StringExtent(Str, Units, FontSize,FontName,FontUnits,FontWeight);
% stringExtent - extent of string in uicontrol
%    stringExtent(Str, Units, FontSize, FontName, FontUnits)
%    returns the extent (DX,DY) in Units of the string when displayed in a
%    uicontrol, using the specified FontSize, FontName, FontUnits.
%    If not specified, the default values for uicontrols are used for these
%    properties.
%
%    stringExtent(Str, S) where S is a struct with fields Units, FontSize,
%    FontName, and FontUnits is the same as 
%    stringExtent(Str, S.Units, S.FontSize, S.FontName, S.FontUnits)
%
%    Note: multiple-line strings must be specified as char matrices or
%    cell strings. Strings containing newline or linefeed characters are 
%    not handled properly!
%
%    See also getGUIdata, rmUserdata, findobj.

DefUnits = get(0,'defaultuicontrolUnits');
DefFontSize = get(0,'defaultuicontrolFontSize');
DefFontName = get(0,'defaultuicontrolFontName');
DefFontUnits = get(0,'defaultuicontrolFontUnits');
DefFontWeight = get(0,'defaultuicontrolFontWeight');
if (nargin==2) && isstruct(Units),
    S = Units; % note that S may contain other, nonrelevant fields beyond font-related ones. ..
    Units = getfieldOrDefault(S,'Units', DefUnits);
    FontSize = getfieldOrDefault(S,'FontSize', DefFontSize);
    FontName = getfieldOrDefault(S,'FontName', DefFontName);
    FontUnits = getfieldOrDefault(S,'FontUnits', DefFontUnits);
    FontWeight = getfieldOrDefault(S,'FontWeight', DefFontWeight);
else, % provide defaults if needed
    if nargin<2,  Units = DefUnits; end
    if nargin<3, FontSize = DefFontSize; end
    if nargin<4, FontName = DefFontName; end
    if nargin<5, FontUnits = DefFontUnits; end
    if nargin<6, FontWeight = DefFontWeight; end
end

FontSpec = collectInstruct(Units, FontSize,FontName,FontUnits,FontWeight);

[Ext_Empty, Ext_chars] = local_all_Extents(FontSpec);

if ischar(Str), % char matrix -> convert to cellstring
    % cellstr trims trailing paces, so convert to cell string by hand
    if isempty(Str), Str = {''};
    else,
        M = Str; Str = {};
        for ii=1:size(M,1),
            Str = [Str M(ii,:)];
        end
    end
end
if ~iscellstr(Str),
    error('Str input must be character string or cell array of strings.')
end
E = [0 0];
for ii=1:length(Str),
    iascii = double(Str{ii})+1; % indices in Ext_chars of the characters in Str{ii}
    DX = sum(Ext_chars(iascii,1)); % width of line: add individual character widths
    DY = max(Ext_chars(iascii,2)); % height of line: largest individual character height
    E(1) = max(E(1),DX); % width of block = width of widest line
    E(2) = E(2) + DY; % height of block summed heights of lines
end
E = E + Ext_Empty; % constant additional extent (not multiplied).

%-------------------------------------
function [Ext_Empty, Ext_chars] = local_all_Extents(FontSpec);
% Return extents of all elementary characters & ''
% This local function delegates the real work to local_Compute_Extents, but
% it keeps a cache & persistent storage for better performance.
persistent Last_FontSpec Last_Ext_Empty Last_Ext_chars
% first look if FontSpec is equal to last-used FontSpec
if isequal(Last_FontSpec, FontSpec),
    Ext_Empty = Last_Ext_Empty;
    Ext_chars = Last_Ext_chars;
    return
end
% next look if it has been evaluated previously
CFN = 'StringExtent';
Q = getcache(CFN, FontSpec);
if ~isempty(Q),
    Ext_Empty = Q.Ext_Empty;
    Ext_chars = Q.Ext_chars;
else, % not used previously - compute it.
    [Ext_Empty, Ext_chars] = local_Compute_Extents(FontSpec);
end
% store - both in persistent & as in cache
Last_FontSpec = FontSpec;
Last_Ext_Empty = Ext_Empty; 
Last_Ext_chars = Ext_chars; 
if isempty(Q),
    putcache(CFN, 100, FontSpec, CollectInStruct(Ext_Empty, Ext_chars));
end

function [Ext_Empty, Ext_chars] = local_Compute_Extents(FontSpec);
% get extents by realizing uicontrols containing single-character strings
%FontSpec
Nchar = 256; % # chars considered
figh=figure('visible', 'off');
h=uicontrol(figh, 'string', '', FontSpec); 
ext = get(h,'extent'); 
Ext_Empty = ext(3:4); 
delete(h);
Ext_chars = zeros(Nchar,2);
for ichar=0:Nchar-1,
    h=uicontrol(figh, 'string', char(ichar), FontSpec);
    ext = get(h,'extent');
    Ext_chars(ichar+1,1:2) = ext(3:4);
    delete(h);
end
delete(figh);
% From the single-char extents, subtract the extent of empty string, as 
% this contribution is not multipled when concatenating single characters
% (either horizontally or vertically).
Ext_chars = Ext_chars - repmat(Ext_Empty,Nchar,1); 


