function [stageOut, dout1_re, dout1_im, dout2_re, dout2_im, realOut_vld, dout_vld] = Radix2ButterflyG(stageIn, realIn_vld, din1, multRes1, multRes2, din_vld,...
                                                                                                      TOTALSTAGES, DATA_WORDLENGTH, DATA_FRACTIONLENGTH, TWDL_WORDLENGTH , TWDL_FRACTIONLENGTH, OVERFLOWACTION, ROUNDINGMETHOD) 
persistent  stageOut_reg din1_pipe1 din1_pipe2 din1_pipe3 din1_pipe4 dinVld_pipe1  dinVld_pipe2 dinVld_pipe3 dinVld_pipe4 dinVld_pipe5 
persistent  dout1_re_reg dout1_im_reg dout2_re_reg dout2_im_reg cmplxRes realInVld_pipe1 realInVld_pipe2 realInVld_pipe3 realInVld_pipe4 realInVld_pipe5


if isempty(din1_pipe1)
    din1_pipe1     = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    din1_pipe2     = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    din1_pipe3     = fi(0, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    din1_pipe4     = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 1, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    cmplxRes       = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 1, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dinVld_pipe1   = false;
    dinVld_pipe2   = false;
    dinVld_pipe3   = false;
    dinVld_pipe4   = false;
    dinVld_pipe5   = false;
    realInVld_pipe1= false;
    realInVld_pipe2= false;
    realInVld_pipe3= false;
    realInVld_pipe4= false;
    realInVld_pipe5= false;
    stageOut_reg   = fi(0, 0, ceil(log2(TOTALSTAGES)), 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout1_re_reg   = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout1_im_reg   = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout2_re_reg   = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout2_im_reg   = fi(0, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

stageOut = stageOut_reg;
stageOut_reg = fi(stageIn + 1, 0, ceil(log2(TOTALSTAGES)), 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');

dout1_re    = fi(dout1_re_reg, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
dout1_im    = fi(dout1_im_reg, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
dout2_re    = fi(dout2_re_reg, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
dout2_im    = fi(dout2_im_reg, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
realOut_vld = realInVld_pipe5;
dout_vld    = dinVld_pipe5;

if realInVld_pipe4
    dout1_re_reg = fi(din1_pipe4 + cmplxRes, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout2_re_reg = fi(din1_pipe4 - cmplxRes, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
else
    dout1_im_reg = fi(din1_pipe4 + cmplxRes, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    dout2_im_reg = fi(din1_pipe4 - cmplxRes, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 2, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

din1_pipe4 = fi(din1_pipe3, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 1, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH) , 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
din1_pipe3 = din1_pipe2;
din1_pipe2 = din1_pipe1;
din1_pipe1 = fi(din1, 1, DATA_WORDLENGTH, -DATA_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');

dinVld_pipe5 = dinVld_pipe4;
dinVld_pipe4 = dinVld_pipe3;
dinVld_pipe3 = dinVld_pipe2;
dinVld_pipe2 = dinVld_pipe1;
dinVld_pipe1 = din_vld;

if realInVld_pipe3
       cmplxRes = fi(multRes1 - multRes2, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 1, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
else
       cmplxRes = fi(multRes1 + multRes2, 1, DATA_WORDLENGTH + TWDL_WORDLENGTH + 1, -(DATA_FRACTIONLENGTH + TWDL_FRACTIONLENGTH), 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

realInVld_pipe5 = realInVld_pipe4;
realInVld_pipe4 = realInVld_pipe3;
realInVld_pipe3 = realInVld_pipe2;
realInVld_pipe2 = realInVld_pipe1;
realInVld_pipe1 = realIn_vld;
