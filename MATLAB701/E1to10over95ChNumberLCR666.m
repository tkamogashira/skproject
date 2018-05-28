% E1to10over95ChNumberLCR666
function NumberLCR=E1to10over95ChNumberLCR666(M6,M4,N,V)
% M6:FFTby6.66HzBB; M4:FFTby4HzBB; N:FFTbyNoBB; V:channels202XY 
% In 666HzBB, find channel in which there find 666Hz peak over 95 
C6=((M6(91,(1:202))>mean(M6((86:98),(1:202)),1)+std(M6((86:98),(1:202)),0,1)*1.64)|(M6(92,(1:202))>mean(M6((86:98),(1:202)),1)+std(M6((86:98),(1:202)),0,1)*1.64));
% In 4HzBB, find channel in which there find no 666Hz peak over 95
C4=((M4(91,(1:202))<mean(M4((86:98),(1:202)),1)+std(M4((86:98),(1:202)),0,1)*1.64)&(M4(92,(1:202))<mean(M4((86:98),(1:202)),1)+std(M4((86:98),(1:202)),0,1)*1.64));
% In NoBB, find channel in which there find no 666Hz peak over 95
CN=((N(91,(1:202))<mean(N((86:98),(1:202)),1)+std(N((86:98),(1:202)),0,1)*1.64)&(N(92,(1:202))<mean(N((86:98),(1:202)),1)+std(N((86:98),(1:202)),0,1)*1.64));
% find propriate channels
C=(C6.*C4).*CN;
SelectChs=V(:,find(C>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95_666'],SelectChs);
assignin('base',[inputname(1) '_NumberLCR95_666'],NumberLCR);
plot(M6((15:137),203)/1000,M6((15:137),find(C>0)),'b',M4((15:137),203)/1000,M4((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
