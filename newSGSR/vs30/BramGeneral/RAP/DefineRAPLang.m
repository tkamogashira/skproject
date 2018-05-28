function ArgOut = DefineRAPLang
%DefineRAPLang  returns RAP metalanguage definition
%   ML = DEFINERAPLANG returns the metalanguage definition of 
%   RAP as a metalng object.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 02-08-2005
%K. Spiritus 22-03-2006

persistent ML;
if isempty(ML)
    ML = generateMetaLang;
end

ArgOut = ML;

%----------------------------------local functions------------------------------------------
function ML = generateMetaLang

%Disk interface ...
FullMFileName = which(mfilename);
[Path, MFileName, MFileExt] = fileparts(FullMFileName);
FullMATFileName = fullfile(Path, [MFileName '.lng']);

%Attention! isRAPPureXXX and isRAPXXX are different, in the sense that isRAPPureXXX only allows pure 
%tokens of the specified kind, while isRAPXXX also allows memory variables ...
if ~exist(FullMATFileName, 'file') || (getFileDate(FullMFileName) > getFileDate(FullMATFileName))
    ML =  metalng | ...                                                                          %... the empty language ...
          metalng('l', 'help') | ...                                                             %HELP
         (metalng('l', 'more') & (metalng('l', 'on') | metalng('l', 'off'))) | ...               %MORE ON/OFF
         (metalng('l', 'df') & ~metalng('f', 'isRAPChar')) | ...                                 %DF <char> 
         (metalng('l','mash') & metalng('f','isRAPInt')) | ...                                   %MASH <int>
         metalng('l', 'ud') | ...                                                                %UD
         (metalng('l', 'id') & ~metalng('f', 'isRAPChar') & ~metalng('f', 'isRAPErr')) | ...     %ID <char> [<err>]
         (metalng('l', 'ds') & ~metalng('f', 'isRAPInt')) | ...                                  %DS <int>
         (metalng('l', 'nx') & metalng('l', 'ds') & ~metalng('f', 'isRAPErr')) | ...             %NX DS [<err>]
         (metalng('l', 'pv') & metalng('l', 'ds') & ~metalng('f', 'isRAPErr')) | ...             %PV DS [<err>]
          metalng('l', 'swp') | ...                                                              %SWP
         (metalng('l', 'sync') & ~(metalng('l', 'auto') | metalng('l', 'man'))) | ...            %SYNC [AUTO/MAN]    
         (metalng('l', 'aw') & ~(metalng('l', 'def') | ...                                       %AW <float> <float> [<float> <float> ...]
         (metalng('f', 'isRAPFloat') & metalng('f', 'isRAPFloat')).')) | ...                     %AW DEF
         (metalng('l', 'rw') & ~(metalng('l', 'def') | ...                                       %RW <float> <float> [<float> <float> ...]
         (metalng('f', 'isRAPFloat') & metalng('f', 'isRAPFloat')).')) | ...                     %RW DEF
         (metalng('l', 'sub') & ~metalng('f', 'isRAPFloat')) | ...                               %SUB <float>
         (metalng('l', 'tr') & ~(metalng('l', 'def') | ...                                       %TR <int> <int> [<int> <int> ...]
         (metalng('f', 'isRAPInt') & metalng('f', 'isRAPInt')).')) | ...                         %TR DEF
         (metalng('l', 'min') & metalng('l', 'is') & ~metalng('f', 'isRAPFloat')) | ...          %MIN IS <float>
         (metalng('l', 'cr') & ~(metalng('f', 'isRAPFloat') | metalng('l', 'def'))) | ...        %CR [#/DEF]
         (metalng('l', 'boot') & ~(metalng('f', 'isRAPInt') | metalng('l', 'def'))) | ...        %BOOT [#/DEF]
         (metalng('l', 'xn') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...        %XN <float> or XN DEF
         (metalng('l', 'xm') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...        %XM <float> or XM DEF
         (metalng('l', 'yn') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...        %YN <float> or YN DEF
         (metalng('l', 'ym') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...        %YM <float> or YM DEF
         (metalng('l', 'tinc') & (metalng('l', 'x') | metalng('l', 'y')) & ...                   %TINC X/Y <float> or TINC X/Y DEF
         ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...                             
         (metalng('l', 'auto') & (metalng('l', 'xx') | metalng('l', 'yx') | ...                  %AUTO XX/YX/AX
          metalng('l', 'ax'))) | ...
         (metalng('l', 'log') & (metalng('l', 'xx') | metalng('l', 'yx'))) | ...                 %LOG XX/YX
         (metalng('l', 'lin') & (metalng('l', 'xx') | metalng('l', 'yx'))) | ...                 %LIN XX/YX
         (metalng('l', 'flip') & metalng('l', 'xx')) | ...                                       %FLIP XX
         (metalng('l', 'nb') & ~(metalng('l', 'def') | metalng('f', 'isRAPInt'))) | ...          %NB <int> or NB DEF
         (metalng('l', 'bw') & ~metalng('f', 'isRAPFloat')) | ...                                %BW <float>
         (metalng('l', 'mlcor') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...     %MLCOR <float> or MLCOR DEF
         (metalng('l', 'bwcor') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...     %BWCOR <float> or BWCOR DEF
         (metalng('l', 'comdel') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...    %COMDEL <float> or COMDEL DEF
         (metalng('l', 'ry') & ~(metalng('l', 'def') | metalng('f', 'isRAPFloat'))) | ...        %RY <float> or RY DEF
         (metalng('l', 'phconv') & ~(metalng('l', 'lag') | metalng('l', 'lead') | ...            %PHCONV LEAD/LAG/DEF
          metalng('l', 'def'))) | ... 
         (metalng('l', 'cyclint') & ~(metalng('l', 'yes') | metalng('l', 'no') | ...             %CYCLINT YES/NO/DEF
          metalng('l', 'def'))) | ...
         (metalng('l', 'sm') & (metalng('l', 'env') | metalng('l', 'hi') | ...                   %SM ENV/PKL/LIN/HI <float>/DEF
          metalng('l', 'lin') | metalng('l', 'pkl')) & ~(metalng('l', 'def') | ...
          metalng('f', 'isRAPFloat'))) | ... 
         (metalng('l', 'per') & metalng('l', 'pkl') & ~(metalng('l', 'def') | ...                %PER PKL #/DEF
          metalng('f', 'isRAPFloat'))) | ...
         (metalng('l', 'up') & ~(metalng('l', 'yes') | metalng('l', 'no') | ...                  %UP YES/NO/DEF
          metalng('l', 'def'))) | ... 
         (metalng('l', 'pp') & ~(metalng('l', 'def') | (metalng('f', 'isRAPInt') & ...           %PP <int> or PP DEF
          ~metalng('f', 'isRAPInt'))| ((metalng('l', 'x') | metalng('l', 'y')) & ...             %PP X/Y <int> or PP X/Y <int>
          (metalng('l', 'def') | metalng('f', 'isRAPInt'))))) | ...                              %PP <int> <int>
         (metalng('l', 'rr') & ~(metalng('l', 'def') | ...                                       %RR DEF
         (metalng('l', 'seq') & ~(metalng('l', 'def') | ...                                      %RR X/Y <float> [<float>] [<float>]
         (metalng('f', 'isRAPInt') & ~metalng('f', 'isRAPInt') & ...                             %RR SEQ DEF
         ~metalng('f', 'isRAPInt')))) | ((metalng('l', 'x') | metalng('l', 'y')) ...             %RR SEQ <int> [<int>] [<int>]
         & ~metalng('f', 'isRAPFloat') & ~metalng('f', 'isRAPFloat') & ...
         ~metalng('f', 'isRAPFloat')))) | ...    
         (metalng('l', 'hi') & ~((metalng('l', 'bf') & ~(metalng('f', 'isRAPExpr') | ...         %HI BF <expr>/DEF
          metalng('l', 'def'))) | (metalng('l', 'bfi') & metalng('f', 'isRAPFloat') & ...        %HI BFI <float> <float>
          metalng('f', 'isRAPFloat')) | metalng('l', 'out') | metalng('l', 'full') | ...         %HI OUT/FULL 
         (metalng('l', 'yv') & ~(metalng('l', 'rate') |  metalng('l', 'count') | ...             %HI YV RATE/COUNT/NORM
          metalng('l', 'norm'))) | (metalng('l', 'bfv') & ...                                    %HI BFV <float> [<float> ...]           
          metalng('f', 'isRAPPureFloat').') | metalng('l', 'un') | ...
          metalng('l', 'li') | metalng('l', 'hi') | ...                                          %HI LI/HI
          (metalng('l', 'sh') & ...                                                              %HI SH <char>/DEF
          ~(metalng('l', 'def') | metalng('f', 'isRAPChar'))) )) | ...                           %HI UN
         (metalng('l', 'set') & ~(metalng('l', 'def') | ...                                      %SET DEF
         (metalng('l', 'yloc') & ~(metalng('l', 'right') | metalng('l', 'left') | ...            %SET YLOC RIGHT/LEFT/DEF
          metalng('l', 'def'))) | ((metalng('l', 'ti') | metalng('l', 'xlbl') | ...              %SET TI/XLBL/YLBL <char>/<float> [<char>/<float> ...]
          metalng('l', 'ylbl')) & (metalng('f', 'isRAPChar') | ...                               %SET TI/XLBL/YLBL DEF (Attention! 'DEF' is also a character string)
          metalng('f', 'isRAPPureFloat'))') | (metalng('l', 'txt') & ...                         %SET TXT SSQ/CLC/CLC2/EXT ON/OFF/UL/UR/LL/LR
          ~((metalng('l', 'ssq') | metalng('l', 'clc') | metalng('l', 'clc2') | ...              %SET RGL WIN <float> <float>
          metalng('l', 'ext')) & (metalng('l', 'on') | metalng('l', 'off') | ...                 %SET RGL WIN DEF
          metalng('l', 'ul') | metalng('l', 'll') | metalng('l', 'lr') | ...                     %SET RGL MINSPK <int>/DEF
          metalng('l', 'ur')))) | (metalng('l', 'rgl') & ~((metalng('l', 'minspk') & ...         %SET PKL SRW <float> <float>
          (metalng('f', 'isRAPInt') | metalng('l', 'def'))) | (metalng('l', 'win') & ...         %SET PKL SRW DEF
          ((metalng('f', 'isRAPFloat') & metalng('f', 'isRAPFloat')) | ...                       %SET PKL PKW <float> <float>
          metalng('l', 'def'))))) | (metalng('l', 'pkl') & ~((metalng('l', 'srw') | ...          %SET PKL PKW DEF
          metalng('l', 'pkw')) & ((metalng('f', 'isRAPFloat') & ...                              %SET TH Q #
          metalng('f', 'isRAPFloat')) | metalng('l', 'def')))) | (metalng('l', 'th') & ...       %SET TH Q DEF
          metalng('l', 'q') & ~(metalng('f', 'isRAPFloat') | metalng('l', 'def'))) | ...         %SET SYNC THR #
          (metalng('l', 'sync') & metalng('l', 'thr') & ~(metalng('f', 'isRAPFloat') | ...       %SET SYNC THR DEF
          metalng('l', 'def'))) | (metalng('l', 'sp') & metalng('l', 'err') & ...                %SET SP ERR ON/OFF/DEF
          ~(metalng('l', 'on') | metalng('l', 'off') | metalng('l', 'def')))  )) | ...
         (metalng('l', 'lw') & ~((metalng('l', 'ax') | metalng('l', 'th') | ...                  %LW AX/TH/SP/RAS/SC/VS/SCP/AW/ERR/ALL <float>
          metalng('l', 'sp') | metalng('l', 'ras') | metalng('l', 'sc') | ...                    %LW AX/TH/SP/RAS/SC/VS/SCP/AW/ERR/ALL DEF
          metalng('l', 'vs') | metalng('l', 'aw') | metalng('l', 'scp') | metalng('l', 'err') |...
          metalng('l', 'all')) & (metalng('l', 'def') | metalng('f', 'isRAPFloat')))) | ...
         (metalng('l', 'style') & metalng('l', 'li') & ~((metalng('l', 'th') | ...               %STYLE LI TH/SP/SC/VS/SCP/AW/ERR/ALL <char>
          metalng('l', 'sp') | metalng('l', 'sc') | metalng('l', 'vs') | ...                     %STYLE LI TH/SP/SC/VS/SCP/AW/ERR/ALL DEF
          metalng('l', 'aw') | metalng('l', 'scp') | metalng('l', 'err') | ...
          metalng('l', 'all')) & (metalng('f', 'isRAPChar') | metalng('l', 'def')))) | ...   
         (metalng('l', 'sym') & metalng('l', 'dot') & ~((metalng('l', 'th') | ...                %SYM DOT TH/SP/SC/VS/SCP/ALL <char>
          metalng('l', 'sp') | metalng('l', 'sc') | metalng('l', 'scp') | ...                    %SYM DOT TH/SP/SC/VS/SCP/ALL DEF
          metalng('l', 'vs') | metalng('l', 'all')) & (metalng('f', 'isRAPChar') | ...
          metalng('l', 'def')))) | ...   
         (metalng('l', 'font') & ~((metalng('l', 'hdr') | metalng('l', 'ti') | ...               %FONT HDR/TI/LBL/XLBL/YLBL/TIC/TXT/ALL <char>     
          metalng('l', 'lbl') | metalng('l', 'xlbl') | metalng('l', 'ylbl') | ...                %FONT HDR/TI/LBL/XLBL/YLBL/TIC/TXT/ALL DEF  
          metalng('l', 'tic') | metalng('l', 'txt') | metalng('l', 'all')) & ...
         (metalng('l', 'def') | metalng('f', 'isRAPChar')))) | ...
         (metalng('l', 'sz') & ~((metalng('l', 'hdr') | metalng('l', 'ti') | ...                 %SZ HDR/TI/LBL/XLBL/YLBL/TIC/TXT/ALL <float>     
          metalng('l', 'lbl') | metalng('l', 'xlbl') | metalng('l', 'ylbl') | ...                %SZ HDR/TI/LBL/XLBL/YLBL/TIC/TXT/ALL DEF  
          metalng('l', 'tic') | metalng('l', 'txt') | metalng('l', 'all')) & ...
         (metalng('l', 'def') | metalng('f', 'isRAPFloat')))) | ...
         (metalng('l', 'col') & ~((metalng('l', 'hdr') | metalng('l', 'xx') | ...                %COL HDR/XX/YX/AX/XLBL/YLBL/TI/TXT/TH/SP/HI/SC/VS/SCP/AW/ERR/ALL <char>
          metalng('l', 'yx') | metalng('l', 'ax') | metalng('l', 'xlbl') | ...                   %COL HDR/XX/YX/AX/XLBL/YLBL/TI/TXT/TH/SP/HI/SC/VS/SCP/AW/ERR/ALL DEF
          metalng('l', 'ylbl') | metalng('l', 'ti') | metalng('l', 'txt') | ...
          metalng('l', 'sp') | metalng('l', 'th') | metalng('l', 'hi') | ...
          metalng('l', 'sc') | metalng('l', 'vs') | metalng('l', 'scp') | ...
          metalng('l', 'aw') | metalng('l', 'err') | metalng('l', 'all')) & ...
          (metalng('l', 'def') | metalng('f', 'isRAPChar')))) | ...
         (metalng('l', 'sou') & (metalng('l', 'nx') | metalng('l', 'def') | ...                  %SOU <int> <int>
         (metalng('f', 'isRAPInt') & metalng('f', 'isRAPInt')) | (metalng('l', 'new') & ...      %SOU NX/DEF
          metalng('l', 'fig')))) | ...                                                           %SOU NEW FIG
         (metalng('l', 'clo') & ~(metalng('l', 'cur') | metalng('l', 'all'))) | ...              %CLO [ALL/CUR]
         (metalng('l', 'pr') & ~(metalng('l', 'cur') | metalng('l', 'all'))) | ...               %PR [ALL/CUR]         
         (metalng('l', 'ou') & ((metalng('l', 'di') & ~((metalng('f', 'isRAPChar') | ...         %OU RAS/PST/PS/ISI/CH/LAT/SYNC/SY/PHASE/PH/TH
          metalng('f', 'isRAPInt')) & metalng('f', 'isRAPSubstVar')')) | ...                     %OU DI [<int>/<char> [<substvar> ...]]
         ((metalng('l', 'id') |  metalng('l', 'ds')) & ~(metalng('f', 'isRAPChar') | ...         %OU ID [<int>/<char>]
          metalng('f', 'isRAPInt'))) | metalng('l', 'pst') | metalng('l', 'ps') | ...            %OU DS [<int>/<char>]
          metalng('l', 'isi') | metalng('l', 'ch') | metalng('l', 'ras') | ...                   
          (metalng('l', 'sp') & ~(metalng('l', 'count') | metalng('l', 'rate')) ...              %OU SP [COUNT/RATE] [HOLD]
          & ~metalng('l','hold')) | ...                                                          %OU SAC [COUNT/RATE/NORM]
          metalng('l', 'comb') | ...                                                             %OU COMB
          metalng('l', 'lat')  | ((metalng('l', 'sac') | metalng('l', 'xc') | ...                %OU XC [COUNT/RATE/NORM]
          metalng('l', 'dif')) & ~(metalng('l', 'count') | metalng('l', 'rate') | ...            %OU DIF [COUNT/RATE/NORM]
          metalng('l', 'norm'))) | ...
          ((metalng('l', 'sync') | metalng('l', 'sy')) & ~metalng('l', 'hold')) | ...            %OU RGL [CV/MEAN]
          ((metalng('l', 'phase')  | metalng('l', 'ph')) & ~metalng('l', 'hold')) | ...
          metalng('l', 'th') | ...                                                               %OU SCP <expr> <expr>
          (metalng('l', 'rgl') & ~(metalng('l', 'cv') | metalng('l', 'mean'))) | ...             %OU TRD [COUNT/RATE]
          (metalng('l', 'scp') & metalng('f', 'isRAPExpr') & metalng('f', 'isRAPExpr')) | ...    %OU CHD
          (metalng('l', 'trd') & ~(metalng('l', 'count') | metalng('l', 'rate'))) | ...          %OU PKL
          metalng('l', 'chd') |  metalng('l', 'pkl') | ...                                       
        (metalng('l', 'cr') & ~(metalng('l', 'norm') | metalng('l', 'count')))  | ...            %OU CR [NORM|COUNT]
        (metalng('l', 'sr') & ~(metalng('l', 'count') | metalng('l', 'rate')))  | ...            %OU SR [COUNT|RATE]
        (metalng('l', 'ry'))  | ...                                                              %OU RY
          metalng('l', 'pol') )) | ...                                                           %OU POL
         (metalng('l', 'nl') & (metalng('l', 'pst') | metalng('l', 'ps') | ...                   %NL RAS/PST/PS/ISI/CH/LAT/SYNC/SY/PHASE/PH/TH
          metalng('l', 'isi') | metalng('l', 'ch') | metalng('l', 'ras') | ...                   %NL SP [COUNT/RATE]
          (metalng('l', 'sp') & ~(metalng('l', 'count') | metalng('l', 'rate'))) | ...           %NL SAC [COUNT/RATE/NORM]
          metalng('l', 'lat')  | ((metalng('l', 'sac') | metalng('l', 'xc') | ...                %NL XC [COUNT/RATE/NORM]
          metalng('l', 'dif')) & ~(metalng('l', 'count') | metalng('l', 'rate') | ...            %NL DIF [COUNT/RATE/NORM]
          metalng('l', 'norm'))) | metalng('l', 'sync') | metalng('l', 'sy') | ...               %NL RGL [CV/MEAN]
          metalng('l', 'phase') | metalng('l', 'ph') | metalng('l', 'th') | ...                  %NL SCP <expr> <expr>
          (metalng('l', 'rgl') & ~(metalng('l', 'cv') | metalng('l', 'mean'))) | ...             %NL TRD [COUNT/RATE]
          (metalng('l', 'scp') & metalng('f', 'isRAPExpr') & metalng('f', 'isRAPExpr')) | ...    %NL PKL
          (metalng('l', 'trd') & ~(metalng('l', 'count') | metalng('l', 'rate'))) | ...
          metalng('l', 'pkl'))) | ...
         (metalng('l', 'pl') & ( metalng('l', 'pst') | ...                                       %PL RAS/PST/ISI/CH/LAT/SYNC/PHASE/TH
          metalng('l', 'isi') | metalng('l', 'ch') | metalng('l', 'ras') | ...                   %PL SP [COUNT/RATE]
          (metalng('l', 'sp') & ~(metalng('l', 'count') | metalng('l', 'rate'))) | ...           %PL SAC [COUNT/RATE/NORM]
          metalng('l', 'lat')  | ((metalng('l', 'sac') | metalng('l', 'xc')) & ...               %PL XC [COUNT/RATE/NORM]
          ~(metalng('l', 'count') | metalng('l', 'rate') | metalng('l', 'norm'))) | ...
          metalng('l', 'sync') | metalng('l', 'phase')  | ...
          metalng('l', 'th'))) | ...
         (metalng('l', 'gv') & ~((metalng('f', 'isRAPVMemVar') & ~metalng('f', 'isRAPExpr') & ...%GV <var> <expr> [<err>]
          ~metalng('f', 'isRAPErr')) | (metalng('f', 'isRAPCMemVar') & ...                       %GV <var> [<err>]
          ~metalng('f', 'isRAPChar') & ~metalng('f', 'isRAPErr')))) | ...
         (metalng('l', 'di') & ~(metalng('f', 'isRAPMemVar') & ~metalng('f', 'isRAPErr'))) | ... %DI <var> [<err>]
         (metalng('f', 'isRAPVMemVar') & (((metalng('l', '+') | metalng('l', '-') | ...          %<vvar> [=] <expr>
          metalng('l', '*') | metalng('l', '/') | metalng('l', 'gcf')) & ...                     %<vvar> +/-/*/'/'/gcf <vvar>
          metalng('f', 'isRAPVMemVar')) | (~metalng('l', '=') & ...
          metalng('f', 'isRAPExpr')))) | ...
         (metalng('f', 'isRAPCMemVar') & ((~metalng('l', '=') & metalng('f', 'isRAPChar')) | ... %<cvar> [=] <char>
         (metalng('l', '+') & metalng('f', 'isRAPCMemVar')))) | ...                              %<cvar> + <cvar>
         (metalng('l', 'exp') & metalng('f', 'isRAPMemVar') & metalng('f', 'isRAPChar').') | ... %EXP <var> <char> [<char> ...]
         (metalng('l', 'es') & metalng('f', 'isRAPChar') & (metalng('f', 'isRAPMemVar') | ...    %ES <char> <var> [<var> ...]
          metalng('f', 'isRAPSubstVar')).') | ...       
         (metalng('l', 'em') & metalng('f', 'isRAPChar')) | ...                                  %EM <char>
         (metalng('l', 'ed') & metalng('f', 'isRAPChar')) | ...                                  %ED <char>
         (metalng('l', 'go') & (metalng('f', 'isRAPPureInt') | metalng('f', 'isRAPChar'))) | ... %GO <int> or <char>
          metalng('l', 'pause') | ...                                                            %PAUSE
         (metalng('l', 'echo') & (metalng('f', 'isRAPChar') | ...                                %ECHO ON/OFF 
          metalng('f', 'isRAPPureFloat')).')| ...                                                %ECHO <char>/<float> [<char>/<float> ...]
          metalng('l', 'return') | ...                                                           %RETURN
          metalng('l', 'quit') | ...                                                             %QUIT
          metalng('l', 'ex') | metalng('l', 'exit') | ...                                        %EX(IT)
          metalng('l', 'end');                                                                   %END
    
    %This implementation of the metalanguage object doesn't support recursion. The only drawback  
    %for the RAP language definition is with the command IF. In this definition an IF-command
    %cannot invoke another IF-command and so on ...
    ML = ML | (metalng('l', 'if') & ((metalng('f', 'isRAPVMemVar') & (metalng('l', 'eq') | ...   %IF <vvar> EQ/NE/GT/LT/LE/GE <expr> <command> ...
         metalng('l', 'ne')| metalng('l', 'gt')| metalng('l', 'lt') | ...                        %IF <cvar> EQ/NE <char> <command> ...
         metalng('l', 'le') | metalng('l', 'ge')) & metalng('f', 'isRAPExpr')) | ...
         (metalng('f', 'isRAPCMemVar') & (metalng('l', 'eq') | ...    
         metalng('l', 'ne')) & metalng('f', 'isRAPChar'))) & ML);
     
    %Every RAP statement can be preceded by a label-identifier. Because the empty language is also
    % a valid RAP statement, a RAP statement can also be a label definition ...
    ML = ~metalng('f', 'isRAPLbl') & ML;
    
    ML = squeeze(ML);
    save(FullMATFileName, 'ML', '-mat');
else
    load(FullMATFileName, 'ML', '-mat');
end