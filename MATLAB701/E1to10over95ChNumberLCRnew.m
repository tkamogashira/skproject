% E1to10over95ChNumberLCRnew
function NumberTvsRev=E1to10over95ChNumberLCRnew(M4,M6,N,V)
% M4:FFTby4HzBB; M6:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
% In 4HzBB, find channel in which there find 4Hz peak over 95 of M4(verification of peak) 
C4=((M4(55,(1:202))>mean(M4(([49:54 57:63]),(1:202)),1)+std(M4(([49:54 57:63]),(1:202)),0,1)*1.64)...
    |((M4(56,(1:202))>mean(M4(([49:54 57:63]),(1:202)),1)+std(M4(([49:54 57:63]),(1:202)),0,1)*1.64)));
C4rev=((N(55,(1:202))>mean(N(([49:54 57:63]),(1:202)),1)+std(N(([49:54 57:63]),(1:202)),0,1)*1.64)...
    |((N(56,(1:202))>mean(N(([49:54 57:63]),(1:202)),1)+std(N(([49:54 57:63]),(1:202)),0,1)*1.64)));
% In 4HzBB, find channel in which there find 4Hz peak over 95 of M6(control1) 
C6=((M6(55,(1:202))<mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*1.64)...
    &((M6(56,(1:202))<mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*1.64)));
C6_2=((M4(55,(1:202))>mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*1.64)...
    |((M4(56,(1:202))>mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*1.64)));
C6_2rev=((N(55,(1:202))>mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*1.64)...
    |((N(56,(1:202))>mean(M6((49:63),(1:202)),1)+std(M6((49:63),(1:202)),0,1)*1.64)));
% In 4HzBB, find channel in which there find 4Hz peak over 95 of N(control2)
CN=((N(55,(1:202))<mean(N((49:63),(1:202)),1)+std(N((49:63),(1:202)),0,1)*1.64)...
    &((N(56,(1:202))<mean(N((49:63),(1:202)),1)+std(N((49:63),(1:202)),0,1)*1.64)));
CN_2=((M4(55,(1:202))>mean(N((49:63),(1:202)),1)+std(N((49:63),(1:202)),0,1)*1.64)...
    |((M4(56,(1:202))>mean(N((49:63),(1:202)),1)+std(N((49:63),(1:202)),0,1)*1.64)));
CNrev=((M4(55,(1:202))<mean(M4((49:63),(1:202)),1)+std(M4((49:63),(1:202)),0,1)*1.64)...
    &((M4(56,(1:202))<mean(M4((49:63),(1:202)),1)+std(M4((49:63),(1:202)),0,1)*1.64)));
CN_2rev=((N(55,(1:202))>mean(M4((49:63),(1:202)),1)+std(M4((49:63),(1:202)),0,1)*1.64)...
    |((N(56,(1:202))>mean(M4((49:63),(1:202)),1)+std(M4((49:63),(1:202)),0,1)*1.64)));
% find propriate channels
C=C4.*C6.*CN.*C6_2.*CN_2;
Crev=C4rev.*C6.*CNrev.*C6_2rev.*CN_2rev;
SelectChs=V(:,find(C>0));
SelectChs_rev=V(:,find(Crev>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new'],SelectChs);
assignin('base',[inputname(1) '_NumberLCR95new'],NumberLCR);
NumberLCRrev=[nnz(SelectChs_rev(2,:)==1) nnz(SelectChs_rev(2,:)==0) nnz(SelectChs_rev(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new_rev'],SelectChs_rev);
assignin('base',[inputname(1) '_NumberLCR95new_rev'],NumberLCRrev);
NumberTvsRev=[NumberLCR;NumberLCRrev];
plot(M4((15:137),203)/1000,M4((15:137),find(C>0)),'b',M6((15:137),203)/1000,M6((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
