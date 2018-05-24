function [x_u_in, y_v_in, v_y_in, twdl_re_dly, twdl_im_dly, extended_dvld, realInVld_dly] = ...
    commutatorL(realIn_vld, useMemData, useDlyData_1, useDlyData_2, din_re, din_im, din_re_dly1, din_im_dly1, din_re_dly2, din_im_dly2, din_re_dly3, din_im_dly3,...
                x_re, x_im_dly1, y_re, y_im, y_re_dly1, y_im_dly1, twiddle_re, twiddle_im, TWDL_WORDLENGTH, TWDL_FRACTIONLENGTH, DATA_WORDLENGTH, DATA_FRACTIONLENGTH)
%COMMUTATORG Summary of this function goes here
%   Detailed explanation goes here

% x_re or x_im comes from memory.

%%% Extend realIn_vld to cover imaginary phase.
persistent realIn_vld_dly1 realIn_vld_dly2 yv_in vy_in twdlRe_dly twdlIm_dly x_re_dly1 x_im_dly2

if isempty(realIn_vld_dly1)
    realIn_vld_dly1= false;
    realIn_vld_dly2= false;
    twdlRe_dly     = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    twdlIm_dly     = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'); 
    yv_in          = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    vy_in          = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    x_re_dly1      = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    x_im_dly2      = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');

end
extended_dvld = realIn_vld_dly2 || realIn_vld_dly1;
realInVld_dly = realIn_vld_dly1;
twdl_re_dly = twdlRe_dly;
twdl_im_dly = twdlIm_dly;

%%% Commutator.
% if realIn_vld
%     x_u_in = x_re;
% else
%     x_u_in = x_im_dly1;
% end;

if realIn_vld_dly1
   x_u_in = x_re_dly1;
else
   x_u_in = x_im_dly2;
end;

y_v_in = yv_in;
v_y_in = vy_in;

if useMemData
   if realIn_vld
        yv_in = y_re;
        vy_in = y_im;
    else
        yv_in = y_im_dly1;
        vy_in = y_re_dly1;
    end; 
elseif useDlyData_1
    if realIn_vld
        yv_in = din_re_dly1;
        vy_in = din_im_dly1;
    else
        yv_in = din_im_dly2;
        vy_in = din_re_dly2;
    end;
elseif useDlyData_2
    if realIn_vld
        yv_in = din_re_dly2;
        vy_in = din_im_dly2;
    else
        yv_in = din_im_dly3;
        vy_in = din_re_dly3;
    end;
else
    if realIn_vld
        yv_in = din_re;
        vy_in = din_im;
    else
        yv_in = din_im_dly1;
        vy_in = din_re_dly1;
    end;
end;
twdlRe_dly = twiddle_re;
twdlIm_dly = twiddle_im;
realIn_vld_dly2 = realIn_vld_dly1;
realIn_vld_dly1 = realIn_vld;
x_re_dly1     = x_re;
x_im_dly2     = x_im_dly1;

