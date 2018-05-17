%
%     Demonstrations for introducting auditory filters 
%     Irino, T. 
%     Created:   9 Mar 2010
%     Modified:  9 Mar 2010
%     Modified: 20 Mar 2010
%     Modified: 31 Mar 2010
%     Modified:  7 Apr 2010
%     Modified: 11 Apr 2010 (Unicode for MATLAB 2010a)
%     Modified: 11 Jun 2010 (Figure number、strDemo)
%     Modified: 27 Jul 2010 (SwSound, DemoAF_PrintFig)
%     Modified:  3 Sep 2010 (SwEnglish, Note)
%     Modified: 10 Sep 2010 (sound(PlaySnd(:),fs))
%
%     Note: 
%     このデモは、以下の文献用に書かれたものです。
%     入野,"はじめての聴覚フィルタ",日本音響学会誌, 66巻10号, pp.506-512, 2010.
%     デモの詳細は、本文を参照ください。
%　　　* MATLAB_R2010a用です。
%     * Octaveだとsound関数やplot関係の関数の変更が必要だと思われます。
%      デモ4の中の、fminsearch()も変更が必要らしいです。最小２乗法で解いてください。
%
%%
clear

DirWork = '~/tmp/'; % working directory: you may change this.
                    % 作業用のdirectoryです。
                    % Unixの形式で書いています。
                    % Windowsの場合は適宜変更ください。
                    % DirWork = "c:\tmp\" 
                    % でしょうか？
%DirWork = [pwd '/']; % このようにすれば、おそらく問題なく動くようになりますが、
                    % 図やデータがそのまま現時点のdirectoryに残ります。
                    %
                    %
if exist(DirWork) == 0
  disp('You need to specify the working directory.');
  disp('Example commands in matlab:  >> cd ~; mkdir tmp; ');
  error(['Please look into this file : ' mfilename '.m']);
  % もしerrorがここで出るようでしたら、作業用のdirectoryを設定してください。
  % たとえばUnixの場合、cd ~; mkdir tmp; とすれば、動くようになります。
end;
NameRsltNN = [DirWork 'DemoAF_RsltNN.mat']; 

SwEnglish = 0;  % Japanese    日本語 (default)
%SwEnglish = 1; % English     英語

%SwSound = 0;   % No sound playback for　lecture demonstration　教室デモ用
SwSound = 1;  % playback sound (default)

if SwEnglish == 0,
  strDemo0 = 'デモ:';
  strDemo(1) = {'  1) 聴覚フィルタの基礎'};
  strDemo(2) = {'  2) 臨界帯域幅'};
  strDemo(3) = {'  3) ノッチ雑音マスキング法'};
  strDemo(4) = {'  4) 聴覚フィルタ形状推定'};
  strDemoQ = 'デモ番号の選択 >>';

else    
  strDemo0 ='Demo:';
  strDemo(1) = {'  1) Auditory filter basics'};
  strDemo(2) = {'  2) Critical band'};
  strDemo(3) = {'  3) Notched noise masking'};
  strDemo(4) = {'  4) Estimation of filter shape'};
  strDemoQ ='Select demo number >> ';
end;

disp(strDemo0);
for nd =1:4,
    disp(char(strDemo(nd)));
end;
SwDemo = input(strDemoQ);
if length(SwDemo) == 0, SwDemo = 1; end;
 
disp(' ');
disp(['===  ' strDemo0  char(strDemo(SwDemo)) '  ===']);

%%
switch SwDemo
  case 1,
    close all
    DemoAF_Basics
 
  case 2,
    DemoAF_CriticalBand
   % Responses for ASJ review Fig.4 : 12 8 8 8 9 10 

  case 3,
    DemoAF_NotchedNoise
    % Responses for ASJ review Fig. 6 : 13 5 6 8 10 11 12 
    %%% save the result for filer-shape estimation in case 4
    str = ['save ' NameRsltNN ' ProbeLevel ParamNN ' ];
    eval(str);
 
 case 4,
    %%% load the result of exp. notched noise in case 3
    str = ['load ' NameRsltNN ];
    eval(str);
    DemoAF_ShapeEstimation
           
end;

disp(' ');

