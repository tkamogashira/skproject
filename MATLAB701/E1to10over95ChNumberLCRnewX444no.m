% E1to10over95ChNumberLCRnewX444 when we found no channels
function NumberTvsRev=E1to10over95ChNumberLCRnewX444no(M444,M4,N,V)
% M444:FFTby444HzBB; M4:FFTby4HzBB; N:FFTbyNoBB; V:channels202XY 

% In 444HzBB, find channel in which there find 444Hz peak over 95 of M444(verification of peak) 
C444=((M444(61,(1:202))>mean(M444(([55:60 63:68]),(1:202)),1)+std(M444(([55:60 63:68]),(1:202)),0,1)*1.64)...
    |((M444(62,(1:202))>mean(M444(([55:60 63:68]),(1:202)),1)+std(M444(([55:60 63:68]),(1:202)),0,1)*1.64)));
C444rev=((N(61,(1:202))>mean(N(([55:60 63:68]),(1:202)),1)+std(N(([55:60 63:68]),(1:202)),0,1)*1.64)...
    |((N(62,(1:202))>mean(N(([55:60 63:68]),(1:202)),1)+std(N(([55:60 63:68]),(1:202)),0,1)*1.64)));

% In 4HzBB, find channel in which there find no 444Hz peak over 95 of M4(control1) 
C4=((M4(61,(1:202))<mean(M4((55:68),(1:202)),1)+std(M4((55:68),(1:202)),0,1)*1.64)...
    &((M4(62,(1:202))<mean(M4((55:68),(1:202)),1)+std(M4((55:68),(1:202)),0,1)*1.64)));
C4_2=((M444(61,(1:202))>mean(M4((55:68),(1:202)),1)+std(M4((55:68),(1:202)),0,1)*1.64)...
    |((M444(62,(1:202))>mean(M4((55:68),(1:202)),1)+std(M4((55:68),(1:202)),0,1)*1.64)));
C4_2rev=((N(61,(1:202))>mean(M4((55:68),(1:202)),1)+std(M4((55:68),(1:202)),0,1)*1.64)...
    |((N(62,(1:202))>mean(M4((55:68),(1:202)),1)+std(M4((55:68),(1:202)),0,1)*1.64)));

% In NoBB, find channel in which there find 8Hz peak over 95 of N(control2)
CN=((N(61,(1:202))<mean(N((55:68),(1:202)),1)+std(N((55:68),(1:202)),0,1)*1.64)...
    &((N(62,(1:202))<mean(N((55:68),(1:202)),1)+std(N((55:68),(1:202)),0,1)*1.64)));
CN_2=((M444(61,(1:202))>mean(N((55:68),(1:202)),1)+std(N((55:68),(1:202)),0,1)*1.64)...
    |((M444(62,(1:202))>mean(N((55:68),(1:202)),1)+std(N((55:68),(1:202)),0,1)*1.64)));
CNrev=((M444(61,(1:202))<mean(M444((55:68),(1:202)),1)+std(M444((55:68),(1:202)),0,1)*1.64)...
    &((M444(62,(1:202))<mean(M444((55:68),(1:202)),1)+std(M444((55:68),(1:202)),0,1)*1.64)));
CN_2rev=((N(61,(1:202))>mean(M444((55:68),(1:202)),1)+std(M444((55:68),(1:202)),0,1)*1.64)...
    |((N(62,(1:202))>mean(M444((55:68),(1:202)),1)+std(M444((55:68),(1:202)),0,1)*1.64)));
% find propriate channels
C=C444.*C4.*CN.*C4_2.*CN_2;
Crev=C444rev.*C4.*CNrev.*C4_2rev.*CN_2rev;
SelectChs=V(:,find(C>0));
SelectChs_rev=V(:,find(Crev>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95newC'],[V(:,(1:202));C]);
NumberLCRrev=[nnz(SelectChs_rev(2,:)==1) nnz(SelectChs_rev(2,:)==0) nnz(SelectChs_rev(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new_revC'],[V(:,(1:202));Crev]);
NumberTvsRev=[NumberLCR;NumberLCRrev];
assignin('base',[inputname(1) '_SelectChs95new_NLCRNLCRrev'],NumberTvsRev);
%plot(M444((15:137),203)/1000,M444((15:137),find(C>0)),'b',M4((15:137),203)/1000,M4((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
