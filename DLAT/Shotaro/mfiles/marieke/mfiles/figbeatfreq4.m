%Figure 1
figure;
subplot(3,2,1); plot(Rin(1:15,1),Rmon(1:15,1),'b.', Rin(16:end,1),Rmon(16:end,1),'ro', [0 1], [0 1],'k-');
axis square
axis ([0 1 0 1])
title('Ipsilateral','Fontsize',10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,2); plot(Rin(1:15,2),Rmon(1:15,2),'b.', Rin(16:end,2),Rmon(16:end,2),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
title('Contralateral','Fontsize', 10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,3); plot(Rin(1:15,1),Rbin(1:15,1),'b.', Rin(16:end,1),Rbin(16:end,1),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,4); plot(Rin(1:15,2),Rbin(1:15,2),'b.', Rin(16:end,2),Rbin(16:end,2),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBc','Fontsize',8)

subplot(3,2,5); plot(Rmon(1:15,1),Rbin(1:15,1),'b.', Rmon(16:end,1),Rbin(16:end,1),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,6); plot(Rmon(1:15,2),Rbin(1:15,2),'b.', Rmon(16:end,2),Rbin(16:end,2),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBc','Fontsize',8)

%Figure 2
figure;
subplot(2,2,1); plot(Rin(1:15,1).*Rin(1:15,2),Rbin(1:15,3),'b.', Rin(16:end,1).*Rin(16:end,2),Rbin(16:end,3),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rin ipsilateral x Rin contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,2); plot(Rmon(1:15,1).*Rmon(1:15,2),Rbin(1:15,3),'b.', Rmon(16:end,1).*Rmon(16:end,2),Rbin(16:end,3),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rmon ipsilateral x Rmon contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,3); plot(Rbin(1:15,1).*Rbin(1:15,2),Rbin(1:15,3),'b.', Rbin(16:end,1).*Rbin(16:end,2),Rbin(16:end,3),'ro', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rbin ipsilateral x Rbin contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

legend ('HSR','LSR')