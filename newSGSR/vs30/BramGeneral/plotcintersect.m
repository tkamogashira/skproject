function Hdl = plotcintersect(Xp, Yp, MinY)
%PLOTCINTERSECT plots intersection points on current axes object

%B. Van de Sande 26-05-2004

Ln1 = line([Xp(1), Xp(2)], [Yp(1), Yp(2)], 'Color', [0 0 0], 'LineStyle', ':', 'tag', 'cintersecthorline');
Ln2 = line([Xp(1), Xp(1)], [MinY, Yp(1)], 'Color', [0 0 0], 'LineStyle', ':', 'tag', 'cintersectverline1');
Ln3 = line([Xp(2), Xp(2)], [MinY, Yp(2)], 'Color', [0 0 0], 'LineStyle', ':', 'tag', 'cintersectverline2');

Hdl = [Ln1; Ln2; Ln3];
