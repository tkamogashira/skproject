ds=dataset('G0886','7-5-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0886','7-6-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close

ds=dataset('G0890','5-10-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','5-11-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','5-12-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','5-13-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','5-14-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','5-15-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','5-16-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close

ds=dataset('G0890','6-5-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','6-9-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','6-10-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','6-11-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close
ds=dataset('G0890','6-12-NRHO');T = EvalSACXACfigure(ds, [+1, -1], 'anwin', [50 1000],'plot','yes');close


s1=subplot(4,4,1);
plot(G0886_7_5sacxacX,G0886_7_5sacxacY(1,:),'Color', [1-0.5 1-0.5 1-0.5],'LineWidth', 2); hold on;
plot(G0886_7_6sacxacX,G0886_7_6sacxacY(1,:),'Color', [1-0.9 1-0.9 1-0.9],'LineWidth', 2); hold off;
%text('Position',[-5 28],'String','G0886 7');
title('G0886 7');

s2=subplot(4,4,2);
plot(G0890_5_10sacxacX,G0890_5_10sacxacY(1,:),'Color', [1-0.7 1-0.7 1-0.7],'LineWidth', 2); hold on;
plot(G0890_5_11sacxacX,G0890_5_11sacxacY(1,:),'Color', [1-0.5 1-0.5 1-0.5],'LineWidth', 2); hold on;
plot(G0890_5_12sacxacX,G0890_5_12sacxacY(1,:),'Color', [1-0.9 1-0.9 1-0.9],'LineWidth', 2); hold on;
plot(G0890_5_13sacxacX,G0890_5_13sacxacY(1,:),'Color', [1-0.4 1-0.4 1-0.4],'LineWidth', 2); hold on;
plot(G0890_5_14sacxacX,G0890_5_14sacxacY(1,:),'Color', [1-0.3 1-0.3 1-0.3],'LineWidth', 2); hold on;
plot(G0890_5_15sacxacX,G0890_5_15sacxacY(1,:),'Color', [1-0.6 1-0.6 1-0.6],'LineWidth', 2); hold on;
plot(G0890_5_16sacxacX,G0890_5_16sacxacY(1,:),'Color', [1-0.8 1-0.8 1-0.8],'LineWidth', 2); hold off;
%text('Position',[-5 28],'String','G0890 5');
title('G0890 5');

s3=subplot(4,4,3);
plot(G0890_6_5sacxacX,G0890_6_5sacxacY(1,:),'Color', [1-0.7 1-0.7 1-0.7],'LineWidth', 2); hold on;
plot(G0890_6_9sacxacX,G0890_6_9sacxacY(1,:),'Color', [1-0.6 1-0.6 1-0.6],'LineWidth', 2); hold on;
plot(G0890_6_10sacxacX,G0890_6_10sacxacY(1,:),'Color', [1-0.5 1-0.5 1-0.5],'LineWidth', 2); hold on;
plot(G0890_6_11sacxacX,G0890_6_11sacxacY(1,:),'Color', [1-0.4 1-0.4 1-0.4],'LineWidth', 2); hold on;
plot(G0890_6_12sacxacX,G0890_6_12sacxacY(1,:),'Color', [1-0.3 1-0.3 1-0.3],'LineWidth', 2); hold off;
%text('Position',[-5 28],'String','G0890 6');
title('G0890 6');





