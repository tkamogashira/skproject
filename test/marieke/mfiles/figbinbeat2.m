%After binbeat2script.m run figbinbeat2.m

%Defining vector strengths
RinI = mean(Rin(:,[1,2]),2);
RinC = mean(Rin(:,[3,4]),2);
RmonI = mean(Rmon(:,[1,2]),2);
RmonC = mean(Rmon(:,[3,4]),2);

%Figure1
figure;
subplot(3,2,1); plot(RinI(1:6,1),RmonI(1:6,1),'b.', RinI(7,1),RmonI(7,1),'ro', RinI(8:23,1),RmonI(8:23,1),'y+', RinI(24:end,1),RmonI(24:end,1),'g^', [0 1], [0 1],'k-');
axis square
axis ([0 1 0 1])
title('Ipsilateral','Fontsize',10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,2); plot(RinC(1:6,1),RmonC(1:6,1),'b.', RinC(7,1),RmonC(7,1),'ro', RinC(8:23,1),RmonC(8:23,1),'y+', RinC(24:end,1),RmonC(24:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
title('Contralateral','Fontsize', 10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,3); plot(RinI(1:6,1),Rbin(1:6,1),'b.', RinI(7,1),Rbin(7,1),'ro', RinI(8:23,1),Rbin(8:23,1),'y+', RinI(24:end,1),Rbin(24:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,4); plot(RinC(1:6,1),Rbin(1:6,2),'b.', RinC(7,1),Rbin(7,2),'ro', RinC(8:23,1),Rbin(8:23,2),'y+', RinC(24:end,1),Rbin(24:end,2),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBc','Fontsize',8)

subplot(3,2,5); plot(RmonI(1:6,1),Rbin(1:6,1),'b.', RmonI(7,1), Rbin(7,1),'ro', RmonI(8:23,1),Rbin(8:23,1),'y+', RmonI(24:end,1),Rbin(24:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,6); plot(RmonC(1:6,1),Rbin(1:6,2),'b.', RmonC(7,1), Rbin(7,2),'ro', RmonC(8:23,1),Rbin(8:23,1),'y+', RmonC(24:end,1),Rbin(24:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBc','Fontsize',8)

%Figure 2
figure;
subplot(2,2,1); plot(RinI(1:6,1).*RinC(1:6,1),Rbin(1:6,3),'b.', RinI(7,1).*RinC(7,1),Rbin(7,3),'ro', RinI(8:23,1).*RinC(8:23,1),Rbin(8:23,3),'y+', RinI(24:end,1).*RinC(24:end,1),Rbin(24:end,3),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rin ipsilateral x Rin contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,2); plot(RmonI(1:6,1).*RmonC(1:6,1),Rbin(1:6,3),'b.', RmonI(7,1).*RmonC(7,1), Rbin(7,3),'ro', RmonI(8:23,1).*RmonC(8:23,1),Rbin(8:23,3),'y+', RmonI(24:end,1).*RmonC(24:end,1),Rbin(24:end,3),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rmon ipsilateral x Rmon contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,3); plot(Rbin(1:6,1).*Rbin(1:6,2),Rbin(1:6,3),'b.', Rbin(7,1).*Rbin(7,2),Rbin(7,3),'ro', Rbin(8:23,1).*Rbin(8:23,2),Rbin(8:23,3),'y+', Rbin(24:end,1).*Rbin(24:end,2),Rbin(24:end,3),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('BBi x BBc','Fontsize',8)
ylabel ('BBb','Fontsize',8)

legend('binaural beatdata HSR','binaural beatdata LSR','timewarped data HSR','timewarped data LSR')