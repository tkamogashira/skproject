function [stageOut, dout1_re, dout1_im, dout2_re, dout2_im, realOut_vld, dout_vld] = Radix2ButterflyF(stageIn, realIn_vld, din1, din2, din3, din_vld, TOTALSTAGES, WORDLENGTH, FRACTIONLENGTH)

persistent twdlAddr dout1_re_reg dout2_re_reg dout1_im_reg dout2_im_reg realOut_vld_reg  din1_pipe1 din2_pipe1 
persistent conj_pipe1 conj_pipe2 realIn_vld_pipe1 dinVld_pipe1 dinvld_pipe2 stageOut_reg

if isempty(twdlAddr)
    twdlAddr         = fi(0, 0, TOTALSTAGES - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout1_re_reg     = fi(0, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout2_re_reg     = fi(0, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout1_im_reg     = fi(0, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout2_im_reg     = fi(0, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    din1_pipe1       = fi(0, 1, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    din2_pipe1       = fi(0, 1, WORDLENGTH, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    realOut_vld_reg  = false;
    dinVld_pipe1     = false;
    dinvld_pipe2     = false;
    conj_pipe1       = fi(0, 0, 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    conj_pipe2       = fi(0, 0, 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    realIn_vld_pipe1 = false;
    stageOut_reg     = fi(0, 0, ceil(log2(TOTALSTAGES)), 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

if stageIn == fi(1, 0, ceil(log2(TOTALSTAGES)), 0)
    conj = fi(0, 0, 1, 0);
else    
    twdlAddr_bitReverse = repmat(bitsliceget(fi(0, 0, 1, 0), 1, 1),1, TOTALSTAGES - 1);
    for index = coder.unroll(1: TOTALSTAGES - 1)
        twdlAddr_bitReverse(index) = bitsliceget(twdlAddr, index, index); %#ok<EMVDF,AGROW>
    end
    
    twdlAddr_bitReverse= bitconcat(twdlAddr_bitReverse);
    conj = bitsliceget(twdlAddr_bitReverse, 2, 2);
    if realIn_vld
        twdlAddr = fi(twdlAddr + 1, 0, TOTALSTAGES - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    end
end

dout1_re    = fi(dout1_re_reg, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
dout2_re    = fi(dout2_re_reg, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
dout1_im    = fi(dout1_im_reg, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
dout2_im    = fi(dout2_im_reg, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
realOut_vld = realOut_vld_reg;
dout_vld    = dinvld_pipe2;

dinvld_pipe2 = dinVld_pipe1;
dinVld_pipe1 = din_vld;


if conj_pipe2 == fi(1, 0, 1, 0) 
    if realIn_vld_pipe1
        dout1_re_reg    = fi(din1_pipe1 + din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        dout2_re_reg    = fi(din1_pipe1 - din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        realOut_vld_reg = true;
    else
        dout1_im_reg    = fi(din1_pipe1 - din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        dout2_im_reg    = fi(din1_pipe1 + din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        realOut_vld_reg = false;
    end
    
else
    if realIn_vld_pipe1
        dout1_re_reg    = fi(din1_pipe1 + din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        dout2_re_reg    = fi(din1_pipe1 - din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        realOut_vld_reg = true;
    else
        dout1_im_reg    = fi(din1_pipe1 + din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        dout2_im_reg    = fi(din1_pipe1 - din2_pipe1, 1, WORDLENGTH + 1, -FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        realOut_vld_reg = false;
    end   
end

realIn_vld_pipe1 = realIn_vld;
din1_pipe1       = din1;
if conj_pipe1 == fi(1, 0, 1, 0) 
    din2_pipe1 = din3;
else
    din2_pipe1 = din2;
end

conj_pipe2  = conj_pipe1;
conj_pipe1  = conj;
stageOut = stageOut_reg;
stageOut_reg = fi(stageIn + 1, 0, ceil(log2(TOTALSTAGES)), 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
