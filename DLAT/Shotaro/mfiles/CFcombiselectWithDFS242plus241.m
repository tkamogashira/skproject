SIZE=size(CFcombiselectWithDFS);
SIZE241=size(CFcombiselectWithDFS241);
for n=1:SIZE241(2)
    CFcombiselectWithDFS(SIZE(2)+n)=CFcombiselectWithDFS241(n);
end;
structsort(CFcombiselectWithDFS,'$CF2$');
assignin('base','CFcombiselectWithDFS242241',CFcombiselectWithDFS);