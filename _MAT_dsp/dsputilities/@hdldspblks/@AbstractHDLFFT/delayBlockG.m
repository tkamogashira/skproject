function [x_re_dly1, x_im_dly1, x_re_dly2, x_im_dly2, din_re_dly1, din_im_dly1, din_re_dly2, din_im_dly2] = delayBlockG(x_re, x_im, din_re, din_im, SIGNED, WORDLENGTH, FRACTIONLENGTH)
%DELAYBLOCKG Summary of this function goes here
%   Detailed explanation goes here

persistent xre_dly1 xim_dly1 xre_dly2 xim_dly2 dinim_dly1 dinre_dly1 dinim_dly2 dinre_dly2

if isempty(xre_dly1) 
    xre_dly1   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    xim_dly1   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    xre_dly2   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    xim_dly2   = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinim_dly1 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinre_dly1 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'); 
    dinim_dly2 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinre_dly2 = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

x_re_dly1 = xre_dly1;
x_im_dly1 = xim_dly1;

x_re_dly2 = xre_dly2;
x_im_dly2 = xim_dly2;

din_im_dly1 = dinim_dly1;
din_re_dly1 = dinre_dly1;

din_im_dly2 = dinim_dly2;
din_re_dly2 = dinre_dly2;

xre_dly2 = xre_dly1;
xre_dly1 = x_re;

xim_dly2 = xim_dly1;
xim_dly1 = x_im;

dinre_dly2 = dinre_dly1;
dinre_dly1 = din_re;

dinim_dly2 = dinim_dly1;
dinim_dly1 = din_im;
