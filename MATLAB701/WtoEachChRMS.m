% WtoEachChRMS
function EachRMS=WtoEachChRMS(W,M)
for n=1:203
    RMSvalue(n)=norm(W(:,n))/sqrt(length(W(:,1)))
end
EachRMS=[M;RMSvalue];
assignin('base','EachRMS',EachRMS);    
stem3(EachRMS(2,:),EachRMS(3,:),EachRMS(4,:))
end