% Dick's PZFC Fit params

%case 515  % order 2, 6 params
   %FeedbackType = 1;  % enable feedback iteration
   %ModelName = 'PZFC';  % pole-zero filter cascade
   ValParam = [ ...
% Final, Nfit = 515, 9-3 parameters, PZFC, cwt 0
     1.72861   0.00000   0.00000 % SumSqrErr=  13622.24
     0.56657  -0.93911   0.89163 % RMSErr   =   3.26610
     0.39469   0.00000   0.00000 % MeanErr  =   0.00000
         Inf   0.00000   0.00000 % RMSCost  =       NaN
     0.00000   0.00000   0.00000
     2.00000   0.00000   0.00000
     1.27393   0.00000   0.00000
    11.46247   5.46894   0.11800
%    -4.15525   1.54874   2.99858 % Kv
     ];
%    CtrlParam = [ ...  % a 6-parameter fit
%      1  0  0  % b1 zero BW relative to ERB
%      1  1  1  % B2
%      1  0  0  % B21
%      0  0  0  % c    one extra zero maybe
%      0  0  0  % n1 unused
%      0  0  0  % n2 order, stages per nominal ERB
%      1  0  0  % frat Fzero:Fpole
%      1  1  1  % P0
%      ];
