function [dout_re, dout_im, dout_vld] = outputMuxL(dvld, realOut_vld, x_out, y_out, u_out, v_out, SIGNED, WORDLENGTH, FRACTIONLENGTH, OVERFLOWACTION, ROUNDINGMETHOD, NORMALIZE)
%outputMuxG Summary of this function goes here
%   Detailed explanation goes here

% x_re or x_im comed from memory.

persistent x_out_dly y_out_dly doutvld doutvld_reg dout_re_reg dout_im_reg 

if isempty(x_out_dly)
    x_out_dly       = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    y_out_dly       = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    dout_re_reg     = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    dout_im_reg     = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    doutvld_reg     = false;
    doutvld         = false;
end

dout_vld = doutvld;
if NORMALIZE == 0
    dout_re = dout_re_reg;
    dout_im = dout_im_reg;
else
    dout_re_cast = fi(dout_re_reg, 1, WORDLENGTH + NORMALIZE, -FRACTIONLENGTH,'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout_im_cast = fi(dout_im_reg, 1, WORDLENGTH + NORMALIZE, -FRACTIONLENGTH,'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout_re_scaled = bitsra(dout_re_cast, NORMALIZE);
    dout_im_scaled = bitsra(dout_im_cast, NORMALIZE);
    dout_re = fi(dout_re_scaled, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    dout_im = fi(dout_im_scaled, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);   
end

if doutvld_reg
    if realOut_vld
        dout_re_reg = fi(y_out_dly, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
        dout_im_reg = fi(v_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    else
        dout_re_reg = fi(x_out_dly, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
        dout_im_reg = fi(u_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    end
end

if dvld
    x_out_dly       = fi(x_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    y_out_dly       = fi(y_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
end

doutvld         = doutvld_reg;
doutvld_reg     = dvld;