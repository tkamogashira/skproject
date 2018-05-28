% GroupTn6
function H=GroupTn6(M1,M2,M3,M4,M5,M6)
SortM1=[(sortrows((M1(:,(1:202)))',2))',M1(:,203)];
SortM2=[(sortrows((M2(:,(1:202)))',2))',M2(:,203)];
SortM3=[(sortrows((M3(:,(1:202)))',2))',M3(:,203)];
SortM4=[(sortrows((M4(:,(1:202)))',2))',M4(:,203)];
SortM5=[(sortrows((M5(:,(1:202)))',2))',M5(:,203)];
SortM6=[(sortrows((M6(:,(1:202)))',2))',M6(:,203)];
for f=5:127
    [H(f,1),sig,ci]=ttest([SortM1(f,(1:123)),SortM2(f,(1:123)),SortM3(f,(1:123)),SortM4(f,(1:123)),SortM5(f,(1:123)),SortM6(f,(1:123))],0,0.0001,1);
    [H(f,2),sig,ci]=ttest([SortM1(f,(124:162)),SortM2(f,(124:162)),SortM3(f,(124:162)),SortM4(f,(124:162)),SortM5(f,(124:162)),SortM6(f,(124:162))],0,0.01,1);
    [H(f,3),sig,ci]=ttest([SortM1(f,(163:202)),SortM2(f,(163:202)),SortM3(f,(163:202)),SortM4(f,(163:202)),SortM5(f,(163:202)),SortM6(f,(163:202))],0,0.01,1);
end;
for f=1:4
    H(f,1)=0;
    H(f,2)=1;
    H(f,3)=2;
end;
H(:,4)=M1(:,203);
assignin('base','H',H);    
end



