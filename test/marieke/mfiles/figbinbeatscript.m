%After binbeatscript.m run figbinbeatscript.m for scatterplots

%Figure 1
figure;
subplot(3,2,1); plot(Rin(:,1),Rmon(:,1), 'b.', [0 1], [0 1],'k-');
axis square
axis ([0 1 0 1])
title('Ipsilateral','Fontsize',10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,2); plot(Rin(:,2),Rmon(:,2),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
title('Contralateral','Fontsize', 10)
xlabel('Rin','Fontsize',8)
ylabel('Rmon','Fontsize',8)

subplot(3,2,3); plot(Rin(:,1),Rbin(:,1),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,4); plot(Rin(:,2),Rbin(:,2),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rin','Fontsize',8)
ylabel('BBc','Fontsize',8)

subplot(3,2,5); plot(Rmon(:,1),Rbin(:,1),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBi','Fontsize',8)

subplot(3,2,6); plot(Rmon(:,2),Rbin(:,2),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel('Rmon','Fontsize',8)
ylabel('BBc','Fontsize',8)

%Figure 2
figure;
subplot(2,2,1); plot(Rin(:,1).*Rin(:,2),Rbin(:,3),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rin ipsilateral x Rin contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,2); plot(Rmon(:,1).*Rmon(:,2),Rbin(:,3),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('Rmon ipsilateral x Rmon contralateral','Fontsize',8)
ylabel ('BBb','Fontsize',8)

subplot(2,2,3); plot(Rbin(:,1).*Rbin(:,2),Rbin(:,3),'b.', [0 1], [0 1], 'k-');
axis square
axis ([0 1 0 1])
xlabel ('BBi x BBc','Fontsize',8)
ylabel ('BBb','Fontsize',8)