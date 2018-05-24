function [mulRes1, mulRes2] = complexMultiply(din1, din2, twiddle_re, twiddle_im, DATA_WORDLENGTH, DATA_FRACTIONLENGTH, TWDL_WORDLENGTH, TWDL_FRACTIONLENGTH)


%%%%% Implementation for 2 registers BEFORE multiply %%%%%%%%%%%%%%%%%%%%%%
% persistent din1_pipe1 din1_pipe2 din2_pipe1 din2_pipe2 mult1_pipe1 mult2_pipe1
% persistent twiddle_re_pipe1 twiddle_re_pipe2 twiddle_im_pipe1 twiddle_im_pipe2 
% 
% if isempty(din1_pipe1) 
%     din1_pipe1       = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     din1_pipe2       = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     din2_pipe1       = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     din2_pipe2       = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     twiddle_re_pipe1 = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     twiddle_re_pipe2 = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     twiddle_im_pipe1 = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     twiddle_im_pipe2 = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     mult1_pipe1      = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
%     mult2_pipe1      = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
% end
% mulRes1 = mult1_pipe1;
% mulRes2 = mult2_pipe1;
% 
% mult1_pipe1 = din1_pipe2 * twiddle_re_pipe2;
% mult2_pipe1 = din2_pipe2 * twiddle_im_pipe2;
% 
% twiddle_re_pipe2 = twiddle_re_pipe1;
% twiddle_im_pipe2 = twiddle_im_pipe1;
% twiddle_re_pipe1 = twiddle_re;
% twiddle_im_pipe1 = twiddle_im;
% din1_pipe2 = din1_pipe1;
% din2_pipe2 = din2_pipe1;
% din1_pipe1 = din1;
% din2_pipe1 = din2;


%%%%% Implementation for 2 registers AFTER multiply %%%%%%%%%%%%%%%%%%%%%%
persistent din1_pipe1 din2_pipe1 mult1_pipe1 mult2_pipe1 mult1_pipe2 mult2_pipe2 
persistent twiddle_re_pipe1  twiddle_im_pipe1
if isempty(din1_pipe1) 
    din1_pipe1       = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH);
    din2_pipe1       = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH);
    twiddle_re_pipe1 = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH);
    twiddle_im_pipe1 = fi(0, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH);
    mult1_pipe1      = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH));
    mult2_pipe1      = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH));
    mult1_pipe2      = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH));
    mult2_pipe2      = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH));
end
mulRes1 = mult1_pipe2;
mulRes2 = mult2_pipe2;
mult1_pipe2 = mult1_pipe1;
mult2_pipe2 = mult2_pipe1;
mult1_pipe1 = din1_pipe1 * twiddle_re_pipe1;
mult2_pipe1 = din2_pipe1 * twiddle_im_pipe1;
twiddle_re_pipe1 = twiddle_re;
twiddle_im_pipe1 = twiddle_im;
din1_pipe1 = din1;
din2_pipe1 = din2;
