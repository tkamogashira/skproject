% E1to10over95ChNumberLCRr2
function NumberLCR=E1to10over95ChNumberLCRr2(M4,M6,N,V)
% M4:FFTby4HzBB; M6:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
% In 4HzBB, find channel in which there find 4Hz peak over 95 
C4=(((M4(55,(1:202))>mean(M4(([49:53 58:63]),(1:202)),1)+std(M4(([49:53 58:63]),(1:202)),0,1)*1.64)...
    &(M4(54,(1:202))<mean(M4(([49:53 58:63]),(1:202)),1)+std(M4(([49:53 58:63]),(1:202)),0,1)*1.64)...
    &(M4(57,(1:202))<mean(M4(([49:53 58:63]),(1:202)),1)+std(M4(([49:53 58:63]),(1:202)),0,1)*1.64))...
    |((M4(56,(1:202))>mean(M4(([49:53 58:63]),(1:202)),1)+std(M4(([49:53 58:63]),(1:202)),0,1)*1.64))...
    &(M4(54,(1:202))<mean(M4(([49:53 58:63]),(1:202)),1)+std(M4(([49:53 58:63]),(1:202)),0,1)*1.64)...
    &(M4(57,(1:202))<mean(M4(([49:53 58:63]),(1:202)),1)+std(M4(([49:53 58:63]),(1:202)),0,1)*1.64));
% In 666HzBB, find channel in which there find no 4Hz peak over 95
C6=((M6(55,(1:202))<mean(M6(([49:53 58:63]),(1:202)),1)+std(M6(([49:53 58:63]),(1:202)),0,1)*1.64)...
    &(M6(56,(1:202))<mean(M6(([49:53 58:63]),(1:202)),1)+std(M6(([49:53 58:63]),(1:202)),0,1)*1.64));
% In NoBB, find channel in which there find no 4Hz peak over 95
CN=((N(55,(1:202))<mean(N(([49:53 58:63]),(1:202)),1)+std(N(([49:53 58:63]),(1:202)),0,1)*1.64)...
    &(N(56,(1:202))<mean(N(([49:53 58:63]),(1:202)),1)+std(N(([49:53 58:63]),(1:202)),0,1)*1.64));
% find propriate channels
C=(C4.*C6).*CN;
SelectChs=V(:,find(C>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95r2'],SelectChs);
assignin('base',[inputname(1) '_NumberLCR95r2'],NumberLCR);
plot(M4((15:137),203)/1000,M4((15:137),find(C>0)),'b',M6((15:137),203)/1000,M6((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
