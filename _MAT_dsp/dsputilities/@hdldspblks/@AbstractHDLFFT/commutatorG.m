function [x_u_in, y_v_in, v_y_in, extended_dvld] = commutatorG(realIn_vld, useDlyData,...
                                                 din_re, din_im, din_re_dly1, din_im_dly1, din_re_dly2, din_im_dly2, ...
                                                 x_re, x_re_dly1, x_im_dly1, x_re_dly2, x_im_dly2, ADDRRANGE,SIGNED, WORDLENGTH,FRACTIONLENGTH)
%COMMUTATORG Summary of this function goes here
%   Detailed explanation goes here

% x_re or x_im comes from memory.

%%% Extend realIn_vld to cover imaginary phase.
persistent realIn_vld_dly

if isempty(realIn_vld_dly)
    realIn_vld_dly = false;
end
extended_dvld = realIn_vld || realIn_vld_dly;
realIn_vld_dly = realIn_vld;


%%% Commutator.
if realIn_vld
    x_u_in = fi(x_re, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
else
    x_u_in = fi(x_im_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end;
if ADDRRANGE == 2
    if useDlyData
        if realIn_vld
            y_v_in = fi(din_re_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(din_im_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        else
            y_v_in = fi(din_im_dly2, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(din_re_dly2, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        end
    else
        if realIn_vld
            y_v_in = fi(din_re, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(din_im, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        else
            y_v_in = fi(din_im_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(din_re_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        end;
    end;
else
    if useDlyData
        if realIn_vld
            y_v_in = fi(x_re_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(x_im_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        else
            y_v_in = fi(x_im_dly2, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(x_re_dly2, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        end;
    else
        if realIn_vld
            y_v_in = fi(din_re, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(din_im, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        else
            y_v_in = fi(din_im_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            v_y_in = fi(din_re_dly1, SIGNED, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        end;
    end;
end;
