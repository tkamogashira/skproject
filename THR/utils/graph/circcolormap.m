function qq = circcolormap;
%  circcolormap - circular colormap
%      circcolormap returns a 64x3 matrix representing a circular colormap
%      that makes ends meet. It starts & ends purple.
%
%      See also COLORMAP, GRAY, HOT.

qq = ones(64,1); 
qq(1:22) = (0:21).'/22; 
qq(end:-1:end-21) = (0:21)/22'; 
qq = [circshift(qq,21) qq circshift(qq,-21)];

