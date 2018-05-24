SIZE=size(CFcombiselectWithDFS_NearCF2);

for m=1:SIZE(2)
    plot(CFcombiselectWithDFS_NearCF2(m).bumpfreq,CFcombiselectWithDFS_NearCF2(m).bumpdif,'bo','MarkerSize',4);hold on;grid on
end;


