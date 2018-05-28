% E1to10over2SDChNumberLCR
function NumberLCR=E1to10over2SDChNumber(M4,M6,N,V)
% M4:FFTby4HzBB; M6:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
% In 4HzBB, find channel in which there find 4Hz peak over 2SD 
C4=((M4(55,(1:202))>mean(M4((49:63),(1:202)),1)+std(M4((49:63),(1:202)),0,1)*2)|(M4(56,(1:202))>mean(M4((49:63),(1:202)),1)+std(M4((49:63),(1:202)),0,1)*2));
% In 666HzBB, find channel in which there find no 4Hz peak over 2SD
C6=((M6(55,(1:202))<mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*2)&(M6(56,(1:202))<mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*2));
% In NoBB, find channel in which there find no 4Hz peak over 2SD
CN=((N(55,(1:202))<mean(N((49:63),(1:202)),1)+std(N((49:63),(1:202)),0,1)*2)&(N(56,(1:202))<mean(N((49:63),(1:202)),1)+std(N((49:63),(1:202)),0,1)*2));
% find propriate channels
C=(C4.*C6).*CN;
SelectChs=V(:,find(C>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs2SD'],SelectChs);
assignin('base',[inputname(1) '_NumberLCR2SD'],NumberLCR);
plot(M4((15:137),203)/1000,M4((15:137),find(C>0)),'b',M6((15:137),203)/1000,M6((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
