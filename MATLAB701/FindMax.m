% FindMax
function MaxCh=FindMax(M,N)
[EachMaxVal,EachMaxLatIndex]=max(M(:,(1:204)));
[MaxChVal,MaxChLatIndex]=max(EachMaxVal);
MaxCh=[MaxChLatIndex N(1,MaxChLatIndex) M(EachMaxLatIndex(1,MaxChLatIndex),205) MaxChVal];
assignin('base','MaxCh',MaxCh);
plot(M(:,205),M(:,MaxChLatIndex)),grid on
end
