x=CFcombiselect(1).CPr;
y=CFcombiselect(1).CD;
z=CFcombiselect(1).BestITD;
for n=2:length(CFcombiselect)
    x=[x CFcombiselect(n).CPr];
    y=[y CFcombiselect(n).CD];
    z=[z CFcombiselect(n).BestITD];
end;
[X,Y]=meshgrid(x,y);
[C,H]=contourf(X,Y,z);
%clabel(C,H)
colormap autumn
colorbar

