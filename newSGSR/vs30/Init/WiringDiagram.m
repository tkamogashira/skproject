function y=WiringDiagram;

figure(1); clf; axes; 
set(gca,'XlimMode', 'manual');
set(gca,'YlimMode', 'manual');

ROOT = defBox([], [0 1 0 1]);
PD1 = defBox(ROOT, [0.05 0.35 0.6 0.9], 2, 'PD1', [0.2 0.9], 10);
  DAC0 = defBox(PD1, [0.55 0.95 0.8 1], 1, 'DAC0', [0.5 0.5], 8);

drawBox(PD1);
drawBox(DAC0);



%------------------------------------------------------
function bb=defBox(root, edges, LW, LAB, LABpos, FS);
if ~isempty(root), % rescale relative to mother box
   edges = relativeEdges(root, edges); 
end;
bb.xmin = edges(1);
bb.xmax = edges(2);
bb.ymin = edges(3);
bb.ymax = edges(4);
if nargin <3, return; end;
bb.LW = LW; 
bb.LAB = LAB; bb.LABpos = LABpos; bb.FS = FS;

function re = relativeEdges(rt, e);
if length(e)==4,
   re(1) = rt.xmin + e(1)*(rt.xmax-rt.xmin);
   re(2) = rt.xmin + e(2)*(rt.xmax-rt.xmin);
   re(3) = rt.ymin + e(3)*(rt.ymax-rt.ymin);
   re(4) = rt.ymin + e(4)*(rt.ymax-rt.ymin);
else,
   re(1) = rt.xmin + e(1)*(rt.xmax-rt.xmin);
   re(2) = rt.ymin + e(2)*(rt.ymax-rt.ymin);
end



function drawBox(R);
line([R.xmin R.xmax], [R.ymin R.ymin], 'linewidth', R.LW);
line([R.xmax R.xmax], [R.ymin R.ymax], 'linewidth', R.LW);
line([R.xmax R.xmin], [R.ymax R.ymax], 'linewidth', R.LW);
line([R.xmin R.xmin], [R.ymax R.ymin], 'linewidth', R.LW);
LP = relativeEdges(R, R.LABpos)
text(LP(1),LP(2),R.LAB, 'horizontalalign', 'center', 'fontsize', R.FS);


