%After binbeathsr_lsr1.m run figbinbeathsr_lsr1.m

%Figure 1
figure;
subplot(3,2,1); plot(Rin(1:6,1),Rmon(1:6,1),'b.', Rin(7,1),Rmon(7,1),'ro', Rin(8:38,1),Rmon(8:38,1),'y+', Rin(39:end,1),Rmon(39:end,1),'g^', [0 1], [0 1],'k-');
axis square
axis ([0 1 0 1])
title('Ipsilateral','Fontsize',10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,2); plot(Rin(1:6,2),Rmon(1:6,2),'b.', Rin(7,2),Rmon(7,2),'ro', Rin(8:38,2),Rmon(8:38,2),'y+', Rin(39:end,2),Rmon(39:end,2),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
title('Contralateral','Fontsize', 10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,3); plot(Rin(1:6,1),Rbin(1:6,1),'b.', Rin(7,1),Rbin(7,1),'ro', Rin(8:38,1),Rbin(8:38,1),'y+', Rin(39:end,1),Rbin(39:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,4); plot(Rin(1:6,2),Rbin(1:6,2),'b.', Rin(7,2),Rbin(7,2),'ro', Rin(8:38,2),Rbin(8:38,2),'y+', Rin(39:end,2),Rbin(39:end,2),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBc','Fontsize',8)

subplot(3,2,5); plot(Rmon(1:6,1),Rbin(1:6,1),'b.', Rmon(7,1), Rbin(7,1),'ro', Rmon(8:38,1),Rbin(8:38,1),'y+', Rmon(39:end,1),Rbin(39:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,6); plot(Rmon(1:6,2),Rbin(1:6,2),'b.', Rmon(7,2), Rbin(7,2),'ro', Rmon(8:38,1),Rbin(8:38,1),'y+', Rmon(39:end,1),Rbin(39:end,1),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBc','Fontsize',8)

%Figure 2
figure;
subplot(2,2,1); plot(Rin(1:6,1).*Rin(1:6,2),Rbin(1:6,3),'b.', Rin(7,1).*Rin(7,2),Rbin(7,3),'ro', Rin(8:38,1).*Rin(8:38,2),Rbin(8:38,3),'y+', Rin(39:end,1).*Rin(39:end,2),Rbin(39:end,3),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rin ipsilateral x Rin contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,2); plot(Rmon(1:6,1).*Rmon(1:6,2),Rbin(1:6,3),'b.', Rmon(7,1).*Rmon(7,2), Rbin(7,3),'ro', Rmon(8:38,1).*Rmon(8:38,2),Rbin(8:38,3),'y+', Rmon(39:end,1).*Rmon(39:end,2),Rbin(39:end,3),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rmon ipsilateral x Rmon contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,3); plot(Rbin(1:6,1).*Rbin(1:6,2),Rbin(1:6,3),'b.', Rbin(7,1).*Rbin(7,2),Rbin(7,3),'ro', Rbin(8:38,1).*Rbin(8:38,2),Rbin(8:38,3),'y+', Rbin(39:end,1).*Rbin(39:end,2),Rbin(39:end,3),'g^', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('BBi x BBc','Fontsize',8)
ylabel ('BBb','Fontsize',8)

legend('binaural beatdata HSR','binaural beatdata LSR','timewarped data HSR','timewarped data LSR')