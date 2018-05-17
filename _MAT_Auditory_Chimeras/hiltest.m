figure;
subplot(2,1,1)

env=abs(zfilt1cell_1{1,:});
plot(env(24000:26000));

subplot(2,1,2)
fine=cos(angle(zfilt1cell_1{1,:}));
plot(fine(24000:26000));