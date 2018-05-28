% E1to10over95ChNumberLCRnewX8
function NumberTvsRev=E1to10over95ChNumberLCRnewX8(M8,M4,N,V)
% M8:FFTby8HzBB; M4:FFTby4HzBB; N:FFTbyNoBB; V:channels202XY 

% In 8HzBB, find channel in which there find 8Hz peak over 95 of M8(verification of peak) 
C8=((M8(110,(1:202))>mean(M8(([103:109 112:117]),(1:202)),1)+std(M8(([103:109 112:117]),(1:202)),0,1)*1.64)...
    |((M8(111,(1:202))>mean(M8(([103:109 112:117]),(1:202)),1)+std(M8(([103:109 112:117]),(1:202)),0,1)*1.64)));
C8rev=((N(110,(1:202))>mean(N(([103:109 112:117]),(1:202)),1)+std(N(([103:109 112:117]),(1:202)),0,1)*1.64)...
    |((N(111,(1:202))>mean(N(([103:109 112:117]),(1:202)),1)+std(N(([103:109 112:117]),(1:202)),0,1)*1.64)));

% In 4HzBB, find channel in which there find no 8Hz peak over 95 of M4(control1) 
C4=((M4(110,(1:202))<mean(M4((103:117),(1:202)),1)+std(M4((103:117),(1:202)),0,1)*1.64)...
    &((M4(111,(1:202))<mean(M4((103:117),(1:202)),1)+std(M4((103:117),(1:202)),0,1)*1.64)));
C4_2=((M8(110,(1:202))>mean(M4((103:117),(1:202)),1)+std(M4((103:117),(1:202)),0,1)*1.64)...
    |((M8(111,(1:202))>mean(M4((103:117),(1:202)),1)+std(M4((103:117),(1:202)),0,1)*1.64)));
C4_2rev=((N(110,(1:202))>mean(M4((103:117),(1:202)),1)+std(M4((103:117),(1:202)),0,1)*1.64)...
    |((N(111,(1:202))>mean(M4((103:117),(1:202)),1)+std(M4((103:117),(1:202)),0,1)*1.64)));

% In NoBB, find channel in which there find no 8Hz peak over 95 of N(control2)
CN=((N(110,(1:202))<mean(N((103:117),(1:202)),1)+std(N((103:117),(1:202)),0,1)*1.64)...
    &((N(111,(1:202))<mean(N((103:117),(1:202)),1)+std(N((103:117),(1:202)),0,1)*1.64)));
CN_2=((M8(110,(1:202))>mean(N((103:117),(1:202)),1)+std(N((103:117),(1:202)),0,1)*1.64)...
    |((M8(111,(1:202))>mean(N((103:117),(1:202)),1)+std(N((103:117),(1:202)),0,1)*1.64)));
CNrev=((M8(110,(1:202))<mean(M8((103:117),(1:202)),1)+std(M8((103:117),(1:202)),0,1)*1.64)...
    &((M8(111,(1:202))<mean(M8((103:117),(1:202)),1)+std(M8((103:117),(1:202)),0,1)*1.64)));
CN_2rev=((N(110,(1:202))>mean(M8((103:117),(1:202)),1)+std(M8((103:117),(1:202)),0,1)*1.64)...
    |((N(111,(1:202))>mean(M8((103:117),(1:202)),1)+std(M8((103:117),(1:202)),0,1)*1.64)));
% find propriate channels
C=C8.*C4.*CN.*C4_2.*CN_2;
Crev=C8rev.*C4.*CNrev.*C4_2rev.*CN_2rev;
SelectChs=V(:,find(C>0));
SelectChs_rev=V(:,find(Crev>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95newC'],[V(:,(1:202));C]);
NumberLCRrev=[nnz(SelectChs_rev(2,:)==1) nnz(SelectChs_rev(2,:)==0) nnz(SelectChs_rev(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new_revC'],[V(:,(1:202));Crev]);
NumberTvsRev=[NumberLCR;NumberLCRrev];
assignin('base',[inputname(1) '_SelectChs95new_NLCRNLCRrev'],NumberTvsRev);
plot(M8((15:137),203)/1000,M8((15:137),find(C>0)),'b',M4((15:137),203)/1000,M4((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
