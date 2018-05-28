% パラメータ設定
dt = 0.1;
vel = 10.0;

% 問題の読み込み
prob = imread('problem.png');
% 壁領域の設定
wall = 1 - (prob(:,:,1).*prob(:,:,2).*prob(:,:,3) > 0);
% 全体領域の大きさ
[h,w] = size(wall);
[gx,gy] = meshgrid(1:w,1:h);

% 未知数を含むセルを求める
cells = find(wall);
m=numel(cells);
unknowns = zeros(h,w);
unknowns(cells) = [1:m];
L = sparse(m,m);

% ノイマン条件下でラプラシアン行列を生成する
for n=1:m
    for k=[-h 1 h -1]
        nei = unknowns(cells(n)+k);
        if(nei>0)
            L(n,nei) = 1;
            L(n,n) = L(n,n)-1;
        end
    end
end

% 境界条件を埋め込む
fall = unknowns(find(prob(:,:,3)>0));
fall = fall(find(fall));
L(fall,1:m) = zeros(numel(fall),m);
L(fall+(fall-1).*m) = 1;

% 速度場の初期化
u=zeros(h,w);
v=zeros(h,w);

% 以下ループで時間発展させる
for t=1:200
    % 流体流入セルで流速を固定する
    pour = find((prob(:,:,1)>0).*wall);
    falldown = find((prob(:,:,3)>0).*wall);
    u(pour) = vel;
    
    % 発散を計算する
    div = (gradient(u)+gradient(v')').*wall;
    div(pour) = 0;
    div(falldown) = 0;
    div = div(cells);
    
    % 線形方程式を解き，圧力を求める
    p = L \ div;
   
    % グリッドに写像する
    pg = zeros(h,w);
    pg(cells) = p;
    
    % 圧力を壁セルにコピーする
    npg = zeros(h,w);
    npg_sum = zeros(h,w);
    for i=1:4
        dir = [0 1; 0 -1; 1 0; -1 0];
        npg = npg + (1-wall).*(circshift(pg,dir(i,:)));
        npg_sum = npg_sum + (1-wall).*circshift(wall,dir(i,:));
    end
    pg = npg./max(npg_sum,1)+pg;
    
    % 非圧縮場を求める
    u = u - gradient(pg).*wall;
    v = v - gradient(pg')'.*wall;
    
    % 移流
    sx = max(min(gx-dt*u,w),1);
    sy = max(min(gy-dt*v,h),1);
    u = interp2(gx,gy,u,sx,sy);
    v = interp2(gx,gy,v,sx,sy);
    
    % 可視化
    clf;
    axis([1 w+2 1 h]);
    title(sprintf('TimeStep = %d', t));
    hold on;
    axis equal;
	contour(wall);
    quiver(u,v,4);
    hold off;
    drawnow;
end