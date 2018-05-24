function placefig(figh, Tag, Tag2, flag);
% placefig - store/retrieve the position of a figure to previous value
%    placefig(figh, Tag, Tag2) retrieves the previous position of a figure
%    with the same tag(s) and sets the closerequest function of figh to
%    {@(Src,Ev)placefig(figh, Tag,Tag2, 'save')}. Matching of Tag is enough to
%    yield a match, but matching of both Tag and Tag2 has priority.
%
%    placefig(figh, Tag,Tag2,'save'), which is the closereq function of a figure
%    subjected to the above call, saves its current position using tags
%    Tag and Tag2, and then deletes the figure.
%
%    See also GUIclose.

if nargin<3, Tag2='' ; end
if nargin<4, flag='retrieve' ; end

switch flag,
    case 'retrieve',
        % try to find match of both Tag & Tag2
        Pos = getcache([mfilename '2'], {Tag Tag2});
        if isempty(Pos), % Tag only?
            Pos = getcache([mfilename '1'], {Tag});
        end
        % use any non-empty Pos to restore figh position
        if ~isempty(Pos), 
            if isequal('on', get(figh,'resize')),
                setposinunits(figh,'normalized', Pos);
            else, % no resize, just offset
                curpos = getposinunits(figh,'normalized');
                setposinunits(figh, 'normalized', [Pos(1:2) curpos(3:4)]);
            end
        end
        % set closereq fcn
        setGUIdata(figh,'FigurePositionTags', CollectInStruct(Tag, Tag2));
        if isGUI(figh), % prepare for closing the figure using GUIclose, leaving room for any closereqfcn
            setGUIdata(figh, 'SavePosAndDelete', {@placefig figh nan nan 'save'});
        end
        set(figh,'closereq',{@placefig nan 'save'});
    case 'save',
        Pos = getposinunits(figh,'normalized');
        TT = getGUIdata(figh,'FigurePositionTags');
        putcache([mfilename '1'], 1500, {TT.Tag}, Pos);
        putcache([mfilename '2'], 1500, {TT.Tag, TT.Tag2}, Pos);
        delete(figh);
end







