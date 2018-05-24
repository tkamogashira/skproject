function [dout_re, dout_im] = twoLocationReg(din_re, din_im, wrAddr, wrEnb, rdAddr, DATA_WORDLENGTH, DATA_FRACTIONLENGTH) 

persistent  MEM_re_0 MEM_im_0 MEM_re_1 MEM_im_1 dout_re_reg dout_im_reg

if isempty(MEM_re_0)
    MEM_re_0    = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    MEM_im_0    = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    MEM_re_1    = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    MEM_im_1    = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout_re_reg = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout_im_reg = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

dout_re = dout_re_reg;
dout_im = dout_im_reg;

if rdAddr == fi(1, 0, 1, 0)
    dout_re_reg = MEM_re_1;
    dout_im_reg = MEM_im_1;
else
    dout_re_reg = MEM_re_0;
    dout_im_reg = MEM_im_0;
end

if wrEnb
    if wrAddr == fi(1, 0, 1, 0)
        MEM_re_1 = fi(din_re, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        MEM_im_1 = fi(din_im, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');   
    else
        MEM_re_0 = fi(din_re, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        MEM_im_0 = fi(din_im, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    end
end