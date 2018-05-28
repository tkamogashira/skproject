%Script for A2 (1st control is "attend-ignore and ignore-ignore")

%Note that "X444no" function is for no peak channel case, but it can be
%used in normal case.
close all;E1to10over95ChNumberLCRnewX444no(A2l240r24444attend_fft,A2l240r248ignore_fft,Al240r240fft,channels202XY)
close all;E1to10over95ChNumberLCRnewX444no(A2l240r24444ignore_fft,A2l240r248ignore_fft,Al240r240fft,channels202XY)

%Note that 8HzBB is used as 1st control for 5.71HzBB
close all;E1to10over95ChNumberLCRnewX571(A2l240r24571attend_fft,A2l240r248ignore_fft,Al240r240fft,channels202XY)
close all;E1to10over95ChNumberLCRnewX571(A2l240r24571ignore_fft,A2l240r248ignore_fft,Al240r240fft,channels202XY)

close all;E1to10over95ChNumberLCRnewX8(A2l240r248attend_fft,A2l240r24444ignore_fft,Al240r240fft,channels202XY)
close all;E1to10over95ChNumberLCRnewX8(A2l240r248ignore_fft,A2l240r24444ignore_fft,Al240r240fft,channels202XY)