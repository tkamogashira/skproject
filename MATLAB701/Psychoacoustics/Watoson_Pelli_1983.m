% QUESTのシミュレーション
%
% Watson, A. B. & Pelli, D. G. (1983) "QUEST: A Bayesian adaptive
%     psychometric method". Perception & Psychophysics, 33, 113-120.
% Figure 4 から。
% 
% 事前情報としての閾値の推定値と、実際の閾値の値を入力すると
% 設定された試行数の範囲で、QUESTによる閾値の推定を行う。
%
% ・上記論文では BASIC で書かれていたものを MATLAB のスクリプトに
% 　書き直した。
% ・もとのプログラムでは配列の添え字は 0 から始まっているが、MATLAB
% 　では最小値は 1 なので、そのように改変してある。
% ・「MATLAB的」に書き直す余地が多々あるが、もとのプログラムとの
% 　比較のために、そのままにした。

% このスクリプトは自由に改変して使用して構いません。
% 私はこのスクリプトの使用による、いかなる損害に対しても責任を負いません。
% 
% 原澤賢充
% e-mail: harasawa@be.to
% 2001.02.12

clear;
close all;

SUB=['x=-n;for t=-n:n;if (q(n+t+1) > q(n+x+1)) x=t;end;end;'];


n=20;     %実施可能な測定の範囲
n2=n*2;
S=12;     %事前分布の標準偏差
m=32;     %測定する試行数
d=.01;    %δ：キーの押し間違いなどの失敗要因の生じる確率
g=.5;     %γ：チャンスレベル
b=3.5/20; %β/20：閾値でのpsychometric functionの傾き/20
e=1.5;    %ε：閾値をちょうどいいところで測るための水平ずらし幅

for x=(-n2:n2)  % x は刺激強度 (dB)
   p(n2+x+1)=1-(1-g).*exp(-10.^(b.*(x+e)));
   if (p(n2+x+1) > 1-d)
      p(n2+x+1)=1-d;
   end
   s(1,n2-x+1)=log(1-p(n2+x+1));
   s(2,n2-x+1)=log(p(n2+x+1));
end

for t=(-n:n) % t は想定される閾値の事前推定(t0)に対しての相対的な値
   q0(n+t+1)=-(t./S).^2;
   q(n+t+1)=q0(n+t+1);
end

t0=input(['Prior estimate (+/-' num2str(S) 'dB)? ']);
t1=input(['Actual threshold? ']);
for k=1:m
   eval(SUB);
   r=floor(p(n2+x+t0-t1+1)+rand);  % x はt0に相対的な閾値のベイズ推定
   % 実際の実験ではこの行↑は刺激の呈示と反応の取得に置き換わる
   disp(['Trial ' num2str(k) ' at ' num2str(x+t0) ' dB has response ' num2str(r) ]);
   for t=-n:n
      q(n+t+1)=q(n+t+1)+s(r+1,n2+t-x+1);
   end
   % QUEST関数をグラフに出力
   plot(-n:n,q);hold on;
end
for t=-n:n
   q(n+t+1)=q(n+t+1)-q0(n+t+1);
end
eval(SUB);
disp(['Maximum likelihood estimate is ' num2str(x+t0) ' dB']);

