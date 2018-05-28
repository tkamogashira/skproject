% E1to10over95ChNumberLCRnewX571
function NumberTvsRev=E1to10over95ChNumberLCRnewX571(M571,M4,N,V)
% M571:FFTby571HzBB; M4:FFTby4HzBB; N:FFTbyNoBB; V:channels202XY 

% In 571HzBB, find channel in which there find 571Hz peak over 95 of M571(verification of peak) 
C571=((M571(78,(1:202))>mean(M571(([72:77 80:85]),(1:202)),1)+std(M571(([72:77 80:85]),(1:202)),0,1)*1.64)...
    |((M571(79,(1:202))>mean(M571(([72:77 80:85]),(1:202)),1)+std(M571(([72:77 80:85]),(1:202)),0,1)*1.64)));
C571rev=((N(78,(1:202))>mean(N(([72:77 80:85]),(1:202)),1)+std(N(([72:77 80:85]),(1:202)),0,1)*1.64)...
    |((N(79,(1:202))>mean(N(([72:77 80:85]),(1:202)),1)+std(N(([72:77 80:85]),(1:202)),0,1)*1.64)));

% In 4HzBB, find channel in which there find no 571Hz peak over 95 of M4(control1) 
C4=((M4(78,(1:202))<mean(M4((72:85),(1:202)),1)+std(M4((72:85),(1:202)),0,1)*1.64)...
    &((M4(79,(1:202))<mean(M4((72:85),(1:202)),1)+std(M4((72:85),(1:202)),0,1)*1.64)));
C4_2=((M571(78,(1:202))>mean(M4((72:85),(1:202)),1)+std(M4((72:85),(1:202)),0,1)*1.64)...
    |((M571(79,(1:202))>mean(M4((72:85),(1:202)),1)+std(M4((72:85),(1:202)),0,1)*1.64)));
C4_2rev=((N(78,(1:202))>mean(M4((72:85),(1:202)),1)+std(M4((72:85),(1:202)),0,1)*1.64)...
    |((N(79,(1:202))>mean(M4((72:85),(1:202)),1)+std(M4((72:85),(1:202)),0,1)*1.64)));

% In NoBB, find channel in which there find no 571Hz peak over 95 of N(control2)
CN=((N(78,(1:202))<mean(N((72:85),(1:202)),1)+std(N((72:85),(1:202)),0,1)*1.64)...
    &((N(79,(1:202))<mean(N((72:85),(1:202)),1)+std(N((72:85),(1:202)),0,1)*1.64)));
CN_2=((M571(78,(1:202))>mean(N((72:85),(1:202)),1)+std(N((72:85),(1:202)),0,1)*1.64)...
    |((M571(79,(1:202))>mean(N((72:85),(1:202)),1)+std(N((72:85),(1:202)),0,1)*1.64)));
CNrev=((M571(78,(1:202))<mean(M571((72:85),(1:202)),1)+std(M571((72:85),(1:202)),0,1)*1.64)...
    &((M571(79,(1:202))<mean(M571((72:85),(1:202)),1)+std(M571((72:85),(1:202)),0,1)*1.64)));
CN_2rev=((N(78,(1:202))>mean(M571((72:85),(1:202)),1)+std(M571((72:85),(1:202)),0,1)*1.64)...
    |((N(79,(1:202))>mean(M571((72:85),(1:202)),1)+std(M571((72:85),(1:202)),0,1)*1.64)));
% find propriate channels
C=C571.*C4.*CN.*C4_2.*CN_2;
Crev=C571rev.*C4.*CNrev.*C4_2rev.*CN_2rev;
SelectChs=V(:,find(C>0));
SelectChs_rev=V(:,find(Crev>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95newC'],[V(:,(1:202));C]);
NumberLCRrev=[nnz(SelectChs_rev(2,:)==1) nnz(SelectChs_rev(2,:)==0) nnz(SelectChs_rev(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new_revC'],[V(:,(1:202));Crev]);
NumberTvsRev=[NumberLCR;NumberLCRrev];
assignin('base',[inputname(1) '_SelectChs95new_NLCRNLCRrev'],NumberTvsRev);
plot(M571((15:137),203)/1000,M571((15:137),find(C>0)),'b',M4((15:137),203)/1000,M4((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
