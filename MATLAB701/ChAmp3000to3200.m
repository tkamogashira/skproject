% M to ChAmp3000to5000
function ChMXY=ChAmp3000to5000(M,V,C)
ChPlusData=[M;V];
ChMXY(1,:)=C(1,:);
ChMXY(2,:)=C(2,:);
ChMXY(3,:)=V(1:202);
hold off;
for f=42:69
    for n=1:202
        ChMXY((f-38),n)=ChPlusData(f,n)
    end
end
assignin('base','ChMXY',ChMXY);    
stem3(ChMXY(1,:),ChMXY(2,:),ChMXY(17,:))


