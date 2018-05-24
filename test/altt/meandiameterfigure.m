%contra


%contrafigure
subplot(1,2,1)
plot(contra89021_22_meandiameter(1,:),contra89021_22_meandiameter(2,:),'g');hold on;
plot(contra87039_10_meandiameter(1,:),contra87039_10_meandiameter(2,:),'g');hold on;
plot(contra87102_7_meandiameter(1,:),contra87102_7_meandiameter(2,:),'g');hold on;
plot(contra89007_39_meandiameter(1,:),contra89007_39_meandiameter(2,:),'g');hold on;
plot(contra87039_9_meandiameter(1,:),contra87039_9_meandiameter(2,:),'g');hold on;
plot(contra89141_27_meandiameter(1,:),contra89141_27_meandiameter(2,:),'g');hold on;
plot(contra88107_15_meandiameter(1,:),contra88107_15_meandiameter(2,:),'g');hold on;
plot(contra87091_27_meandiameter(1,:),contra87091_27_meandiameter(2,:),'g');hold on;
plot(contra89151_16_meandiameter(1,:),contra89151_16_meandiameter(2,:),'g');hold on;
xlabel('Axonal length from ML (\mum)');ylabel('Mean diameter of segment (\mum)');title('Contra'); 

hold off;


%ipsi
subplot(1,2,2)


plot(ipsi89021_22_meandiameter(1,:),ipsi89021_22_meandiameter(2,:),'g');hold on;
plot(ipsi89007_39_meandiameter(1,:),ipsi89007_39_meandiameter(2,:),'g');hold on;
plot(ipsi89007_43_meandiameter(1,:),ipsi89007_43_meandiameter(2,:),'g');hold on;
plot(ipsi90043_15_meandiameter(1,:),ipsi90043_15_meandiameter(2,:),'g');hold on;
plot(ipsi87056_24_meandiameter(1,:),ipsi87056_24_meandiameter(2,:),'g');hold on;
plot(ipsi88311_20_meandiameter(1,:),ipsi88311_20_meandiameter(2,:),'g');hold on;
plot(ipsi88011_3_meandiameter(1,:),ipsi88011_3_meandiameter(2,:),'g');hold on;
xlabel('Axonal length from FB (\mum)');ylabel('Mean diameter of segment (\mum)');title('Ipsi'); 

hold off;






























