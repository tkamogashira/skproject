
% 変数の初期化
clear all;

gauss_plot;

% 描画モードの設定
figure(1);
hold on;
axis([0 300 0 15]);

% スパイク発火時刻のデータ（４試行分）
trial1 = [51 55 60 70 78];
trial2 = [51 58 65 75 110 150];
trial3 = [52 57 66 80 100 160 180];
trial4 = [54 62 70 77 105 125 140];

% スパイク発火時刻を全試行でまとめた
all_trial = [trial1 trial2 trial3 trial4];
%sort(all_trial);

% 1試行目でのスパイク発火時刻のラスター表示（黒丸１段目）
y1(1:5) = 14;
plot(trial1, y1, 'ko');

% ２～４試行目でのスパイク発火時刻のラスター表示（黒丸２～４段目）
y2(1:6) = 13;
y3(1:7) = 12;
y4(1:7) = 11;
plot(trial2, y2, 'ko');
plot(trial3, y3, 'ko');
plot(trial4, y4, 'ko');

% 全試行でまとめたスパイク発火時刻のラスター表示（４試行分、赤丸）
yall(1:25) = 9;
plot(all_trial, yall, 'ro');

% スパイク数のカウント
%hist(all_trial);
for i=1:30
    hist_edge(i) = (i-1)*10;
end
hist(all_trial, hist_edge);

% ＰＳＴＨの描画
figure(2);
hold on;
axis([0 300 0 150]);

[n,xout] = hist(all_trial, hist_edge);
stairs(hist_edge, n/4*100, '-r');

hist_bin(1:300) = [1:300];
figure(1);
hist(all_trial, hist_bin);
figure(2);
spk_time = hist(all_trial, hist_bin)*1000/4;
sdf = conv(gauss_function, spk_time);
t(1:400) = [-50:349];
plot(t,sdf);