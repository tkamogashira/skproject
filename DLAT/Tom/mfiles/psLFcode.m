% psLFcode
% This popscript generates the code for pslatgen for low frequency-fibers,
% i.e. paragraphs like the following:
%
%%Fiber 5
%List = GenWFList(struct([]), 'M0542', [74;75;76;77;78;79;80], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
%T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes'); % reference = ds 74                       
%D = [D; ExtractPSentry(T, XFieldName, YFieldName)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 


%if NRHO +1-1, make difcor code

%if not, make nodifcor code