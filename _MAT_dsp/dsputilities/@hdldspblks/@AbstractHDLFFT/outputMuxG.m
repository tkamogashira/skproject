function [dout_re, dout_im, dout_vld] = outputMuxG(dvld, realOut_vld, x_out, y_out, u_out, v_out, SIGNED, WORDLENGTH, FRACTIONLENGTH, OVERFLOWACTION, ROUNDINGMETHOD)
%outputMuxG Summary of this function goes here
%   Detailed explanation goes here

% x_re or x_im comes from memory.

persistent x_out_dly y_out_dly doutvld realOut_vld_dly

if isempty(x_out_dly)
    x_out_dly       = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    y_out_dly       = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    doutvld         = false;
    realOut_vld_dly = false;
end

dout_vld = doutvld;
if dvld
    if realOut_vld_dly
        dout_re = fi(x_out_dly, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
        dout_im = fi(u_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    else
        dout_re = fi(y_out_dly, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
        dout_im = fi(v_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
    end
else
  dout_re = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
  dout_im = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
end
    
x_out_dly       = fi(x_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
y_out_dly       = fi(y_out, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', OVERFLOWACTION, 'RoundingMethod', ROUNDINGMETHOD);
doutvld         = dvld;
realOut_vld_dly = realOut_vld;