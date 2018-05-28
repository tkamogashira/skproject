% E1to10over95ChNumberLCR666newX
function NumberTvsRev=E1to10over95ChNumberLCR666newX(M4,M6,N,V)
% M4:FFTby4HzBB; M6:FFTby6.66HzBB; N:FFTbyNoBB; V:channels202XY 
% In 666HzBB, find channel in which there find 666Hz peak over 95 of M6(verification of peak) 
C6=((M6(91,(1:202))>mean(M6(([85:90 93:99]),(1:202)),1)+std(M6(([85:90 93:99]),(1:202)),0,1)*1.64)...
    |((M6(92,(1:202))>mean(M6(([85:90 93:99]),(1:202)),1)+std(M6(([85:90 93:99]),(1:202)),0,1)*1.64)));
C6rev=((N(91,(1:202))>mean(N(([85:90 93:99]),(1:202)),1)+std(N(([85:90 93:99]),(1:202)),0,1)*1.64)...
    |((N(92,(1:202))>mean(N(([85:90 93:99]),(1:202)),1)+std(N(([85:90 93:99]),(1:202)),0,1)*1.64)));
% In 666HzBB, find channel in which there find 4Hz peak over 95 of M4(control1) 
C4=((M4(91,(1:202))<mean(M4((85:99),(1:202)),1)+std(M4((85:99),(1:202)),0,1)*1.64)...
    &((M4(92,(1:202))<mean(M4((85:99),(1:202)),1)+std(M4((85:99),(1:202)),0,1)*1.64)));
C4_2=((M6(91,(1:202))>mean(M4((85:99),(1:202)),1)+std(M4((85:99),(1:202)),0,1)*1.64)...
    |((M6(92,(1:202))>mean(M4((85:99),(1:202)),1)+std(M4((85:99),(1:202)),0,1)*1.64)));
C4_2rev=((N(91,(1:202))>mean(M4((85:99),(1:202)),1)+std(M4((85:99),(1:202)),0,1)*1.64)...
    |((N(92,(1:202))>mean(M4((85:99),(1:202)),1)+std(M4((85:99),(1:202)),0,1)*1.64)));
% In 4HzBB, find channel in which there find 4Hz peak over 95 of N(control2)
CN=((N(91,(1:202))<mean(N((85:99),(1:202)),1)+std(N((85:99),(1:202)),0,1)*1.64)...
    &((N(92,(1:202))<mean(N((85:99),(1:202)),1)+std(N((85:99),(1:202)),0,1)*1.64)));
CN_2=((M6(91,(1:202))>mean(N((85:99),(1:202)),1)+std(N((85:99),(1:202)),0,1)*1.64)...
    |((M6(92,(1:202))>mean(N((85:99),(1:202)),1)+std(N((85:99),(1:202)),0,1)*1.64)));
CNrev=((M6(91,(1:202))<mean(M6((85:99),(1:202)),1)+std(M6((85:99),(1:202)),0,1)*1.64)...
    &((M6(92,(1:202))<mean(M6((85:99),(1:202)),1)+std(M6((85:99),(1:202)),0,1)*1.64)));
CN_2rev=((N(91,(1:202))>mean(M6((85:99),(1:202)),1)+std(M6((85:99),(1:202)),0,1)*1.64)...
    |((N(92,(1:202))>mean(M6((85:99),(1:202)),1)+std(M6((85:99),(1:202)),0,1)*1.64)));
% find propriate channels
C=C6.*C4.*CN.*C4_2.*CN_2;
Crev=C6rev.*C4.*CNrev.*C4_2rev.*CN_2rev;
SelectChs=V(:,find(C>0));
SelectChs_rev=V(:,find(Crev>0));
% find number of propriate channels
NumberLCR=[nnz(SelectChs(2,:)==1) nnz(SelectChs(2,:)==0) nnz(SelectChs(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new666C'],[V(:,(1:202));C]);
NumberLCRrev=[nnz(SelectChs_rev(2,:)==1) nnz(SelectChs_rev(2,:)==0) nnz(SelectChs_rev(2,:)==2)];
assignin('base',[inputname(1) '_SelectChs95new666_revC'],[V(:,(1:202));Crev]);
NumberTvsRev=[NumberLCR;NumberLCRrev];
plot(M4((15:137),203)/1000,M4((15:137),find(C>0)),'b',M6((15:137),203)/1000,M6((15:137),find(C>0)),'r',N((15:137),203)/1000,N((15:137),find(C>0)),'k'),grid on
end
