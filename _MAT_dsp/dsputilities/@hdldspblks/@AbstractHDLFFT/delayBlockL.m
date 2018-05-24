function [x_re_dly1, x_im_dly1, x_re_dly2, x_im_dly2, y_re_dly1, y_im_dly1, din_re_dly1, din_im_dly1, din_re_dly2, din_im_dly2, din_re_dly3, din_im_dly3] = ...
         delayBlockL(x_re, x_im, y_re, y_im, din_re, din_im, din_vld, SIGNED, WORDLENGTH, FRACTIONLENGTH)
%DELAYBLOCKL Summary of this function goes here
%   Detailed explanation goes here

persistent xre_dly1 xim_dly1 xre_dly2 xim_dly2 yre_dly1 yim_dly1 dinim_dly1 dinre_dly1 dinim_dly2 dinre_dly2 dinim_dly3 dinre_dly3

if isempty(xre_dly1) 
    xre_dly1   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    xim_dly1   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    xre_dly2   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    xim_dly2   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    yre_dly1   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    yim_dly1   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinim_dly1 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinre_dly1 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'); 
    dinim_dly2 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinre_dly2 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinim_dly3 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinre_dly3 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

x_re_dly1 = xre_dly1;
x_re_dly2 = xre_dly2;
xre_dly2 = xre_dly1;
xre_dly1 = x_re;

x_im_dly2 = xim_dly2;
x_im_dly1 = xim_dly1;
xim_dly2 = xim_dly1;
xim_dly1 = x_im;

y_re_dly1 = yre_dly1;
yre_dly1 = y_re;
y_im_dly1 = yim_dly1;
yim_dly1 = y_im;

din_im_dly1 = dinim_dly1;
din_im_dly2 = dinim_dly2;
din_im_dly3 = dinim_dly3;
dinim_dly3 = dinim_dly2;
dinim_dly2 = dinim_dly1;
if din_vld
    dinim_dly1 = din_im;
end

din_re_dly1 = dinre_dly1;
din_re_dly2 = dinre_dly2;
din_re_dly3 = dinre_dly3;
dinre_dly3 = dinre_dly2;
dinre_dly2 = dinre_dly1;
if din_vld
   dinre_dly1 = din_re;
end



















