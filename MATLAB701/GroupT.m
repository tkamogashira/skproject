% GroupT
function H=GroupT(M)
SortM=[(sortrows((M(:,(1:202)))',2))',M(:,203)];
for f=5:127
    [H(f,1),sig,ci]=ttest(SortM(f,(1:123)),0,0.01,1);
    [H(f,2),sig,ci]=ttest(SortM(f,(124:162)),0,0.01,1);
    [H(f,3),sig,ci]=ttest(SortM(f,(163:202)),0,0.01,1);
end;
for f=1:4
    H(f,1)=0;
    H(f,2)=1;
    H(f,3)=2;
end;
H(:,4)=M(:,203);
assignin('base','SortM',SortM);
assignin('base','H',H);    
end



