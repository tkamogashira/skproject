function equalize_tagged_figs(Ax)
% Equalize_tagged_figs - equalize axes limits in figures having FigName
%    Equalize_tagged_figs('X') equalizes the X limits of corresponding axes
%    in figures sharing a name (see FigName). It is assumed that 
%    corresponding figs have the same number of axes.
%
%    Equalize_tagged_figs('Y') and Equalize_tagged_figs('XY') do the same
%    for Y axes and X&Y axes, respectively.
%
%    See also XLIM, YLIM.

EqX = any('X'==Ax);
EqY = any('Y'==Ax);

AllFigh = findobj('type', 'figure');
if isempty(AllFigh), return; end
AllTags = cellify(figname(findobj('type', 'figure')));
noname = cellfun('isempty', AllTags);
AllTags = AllTags(~noname);
UnTags = unique(AllTags);
Ntag = numel(UnTags);

for itag=1:Ntag,
    imatch = strmatch(UnTags{itag}, AllTags, 'exact');
    hfig = AllFigh(imatch);
    Nfig = numel(hfig);
    hax{itag} = [];
    for ifig=1:Nfig,
        ha = findobj(hfig(ifig), 'type', 'axes');
        hax{itag} = [hax{itag}; ha(:).']; % so hax{itag}(ifig,iax) is the referencing
    end
end

for itag=1:Ntag,
    ha = hax{itag};
    for iax=1:size(ha,2),
        LIM = [];
        for ifig = 1:size(ha,1),
            h = ha(ifig, iax);
            LIM = [LIM; [get(h,'xlim') get(h,'ylim')]];
        end
        LIM = [min(LIM(:,1))  max(LIM(:,2))  min(LIM(:,3))  max(LIM(:,4))];
        for ifig = 1:size(ha,1),
            h = ha(ifig, iax);
            set(h, 'xlim', LIM(1:2));
            set(h, 'ylim', LIM(3:4));
        end
    end
end









