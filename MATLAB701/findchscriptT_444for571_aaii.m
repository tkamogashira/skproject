%Script for T (1st control is "attend-attend or ignore-ignore")

%Note that "X444no" function is for no peak channel case, but it can be
%used in normal case.
close all;E1to10over95ChNumberLCRnewX444no(Tl240r24444attend_fft,Tl240r248attend_fft,Tl240r240fft,channels202XY)
close all;E1to10over95ChNumberLCRnewX444no(Tl240r24444ignore_fft,Tl240r248ignore_fft,Tl240r240fft,channels202XY)

%Note that 444HzBB is used as 1st control for 5.71HzBB
close all;E1to10over95ChNumberLCRnewX571(Tl240r24571attend_fft,Tl240r24444attend_fft,Tl240r240fft,channels202XY)
close all;E1to10over95ChNumberLCRnewX571(Tl240r24571ignore_fft,Tl240r24444ignore_fft,Tl240r240fft,channels202XY)

close all;E1to10over95ChNumberLCRnewX8(Tl240r248attend_fft,Tl240r24444attend_fft,Tl240r240fft,channels202XY)
close all;E1to10over95ChNumberLCRnewX8(Tl240r248ignore_fft,Tl240r24444ignore_fft,Tl240r240fft,channels202XY)