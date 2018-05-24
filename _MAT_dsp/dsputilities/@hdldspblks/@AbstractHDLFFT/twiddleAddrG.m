function [twdl_addr, twdl_re, twdl_im] = twiddleAddrG(realIn_vld, twiddle_re, twiddle_im, TOTALSTAGES, STAGENUM, TWDL_WORDLENGTH, TWDL_FRACTIONLENGTH  )

persistent twiddleAddrReg twdlDataMapReg twdlDataMapReg1 twdlDataMapReg2 useInterData useInterDataReg1 useInterDataReg2
persistent twdl_reI_reg twdl_imI_reg twdl_reI_reg1 twdl_imI_reg1 twdl_reI_reg2 twdl_imI_reg2 twdl_reX_regP twdl_imX_regP twdl_reX_regN twdl_imX_regN twdl_reX_reg twdl_imX_reg 

MAXADDR      = fi(2^(STAGENUM -1), 0, STAGENUM, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
if STAGENUM == 3
   ADDRWIDTH    = 1;
   FIRSTOCTANT  = fi(1, 0, STAGENUM - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
   THIRDOCTANT  = fi(3, 0, STAGENUM - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
else
   ADDRWIDTH    = STAGENUM - 3;
   FIRSTOCTANT  = fi(1*(2^(ADDRWIDTH)),0, STAGENUM - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
   THIRDOCTANT  = fi(3*(2^(ADDRWIDTH)),0, STAGENUM - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'); 
end

NOCHANGE       = fi(0, 0, 3, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
NEGATE         = cast(1, 'like', NOCHANGE);
SWITCHREIM     = cast(2, 'like', NOCHANGE);
SWITCHNEGA     = cast(3, 'like', NOCHANGE);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TWIDDLE ADDR Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(twiddleAddrReg) 
    twiddleAddrReg  = fi(0, 0, TOTALSTAGES - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    twdlDataMapReg   = fi(0, 0, 3, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    twdlDataMapReg1   = fi(0, 0, 3, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    twdlDataMapReg2   = fi(0, 0, 3, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    useInterData     = false;
    useInterDataReg1 = false;
    useInterDataReg2 = false;
    twdl_reI_reg      = cast(0, 'like', twiddle_re);
    twdl_imI_reg      = cast(0, 'like', twiddle_re);
    twdl_reI_reg1     = cast(0, 'like', twiddle_re);
    twdl_imI_reg1     = cast(0, 'like', twiddle_re);
    twdl_reI_reg2     = cast(0, 'like', twiddle_re);
    twdl_imI_reg2     = cast(0, 'like', twiddle_re);
    twdl_reX_regP   = cast(0, 'like', twiddle_re);
    twdl_imX_regP   = cast(0, 'like', twiddle_re);
    twdl_reX_regN   = cast(0, 'like', twiddle_re);
    twdl_imX_regN   = cast(0, 'like', twiddle_re);
    twdl_reX_reg    = cast(0, 'like', twiddle_re);
    twdl_imX_reg    = cast(0, 'like', twiddle_re);
end

twiddleAddr_bitReverse = repmat(bitsliceget(fi(0, 0, 1, 0), 1, 1),1, TOTALSTAGES - 1);
for index = coder.unroll(1: TOTALSTAGES - 1)
  twiddleAddr_bitReverse(index) = bitsliceget(twiddleAddrReg, index, index); %#ok<EMVDF,AGROW>
end
% incrementing Addr.
if realIn_vld 
    twiddleAddrReg = fi(twiddleAddrReg + 1, 0, TOTALSTAGES -1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end
twdlAddr_raw       = fi(bitconcat(twiddleAddr_bitReverse), 0,  TOTALSTAGES - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
if STAGENUM == TOTALSTAGES
    twdlAddrSliced = twdlAddr_raw;
else
    twdlAddrSliced     = fi(bitsliceget(twdlAddr_raw, STAGENUM, 2), 0, STAGENUM -1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ADDRESS MAPPING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addrMSB = fi(bitsliceget(twdlAddrSliced, STAGENUM - 1, STAGENUM - 2), 0, 2, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
switch addrMSB
    case 0
        twdlAddrMap    = fi(twdlAddrSliced, 0, STAGENUM - 2, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    case 1
        if STAGENUM == 3
            twdlAddrMap     = fi(bitsliceget(twdlAddrSliced, 1, 1), 0, STAGENUM -2, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        else
            addr_tmp1       = fi(bitsliceget(twdlAddrSliced, STAGENUM - 1, 1), 0, STAGENUM -1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            addr_tmp2       = fi(FIRSTOCTANT - addr_tmp1, 0, STAGENUM - 3, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
            twdlAddrMap     = fi(addr_tmp2, 0, STAGENUM - 2, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
        end
    case 2
        twdlAddrMap    = fi(bitsliceget(twdlAddrSliced, STAGENUM - 1, 1), 0, STAGENUM - 2, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    otherwise
        twdlAddrMap    = fi(MAXADDR - twdlAddrSliced, 0, STAGENUM - 2,  0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end
twdl_addr      = fi(twdlAddrMap, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Based on TWDLMAPREG, Calculate the right REAL and IMAG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


switch twdlDataMapReg2
    case NOCHANGE
        twdl_reX_reg2 = twdl_reX_regP;
        twdl_imX_reg2 = twdl_imX_regP;
    case SWITCHREIM
        twdl_reX_reg2 = twdl_imX_regN;
        twdl_imX_reg2 = twdl_reX_regN;
    case SWITCHNEGA
        twdl_reX_reg2 = twdl_imX_regP;
        twdl_imX_reg2 = twdl_reX_regN;
    case NEGATE
        twdl_reX_reg2 = twdl_reX_regN;
        twdl_imX_reg2 = twdl_imX_regP;
    otherwise
        twdl_reX_reg2 = twdl_reX_regP;
        twdl_imX_reg2 = twdl_imX_regP;
end

twdlDataMapReg2 = twdlDataMapReg1;
twdlDataMapReg1 = twdlDataMapReg;

switch addrMSB
    case cast(0, 'like', addrMSB)
        twdlDataMapReg  = NOCHANGE;
    case cast(1, 'like', addrMSB)
        twdlDataMapReg  = SWITCHREIM;
    case cast(2, 'like', addrMSB)
        twdlDataMapReg  = SWITCHNEGA;
    otherwise
        twdlDataMapReg  = NEGATE;
end

if useInterDataReg2
    twdl_re = cast(twdl_reI_reg2, 'like', twiddle_re);
    twdl_im = cast(twdl_imI_reg2, 'like', twiddle_re); 
else
    twdl_re = cast(twdl_reX_reg2, 'like', twiddle_re);
    twdl_im = cast(twdl_imX_reg2, 'like', twiddle_re);
end

useInterDataReg2 = useInterDataReg1;
useInterDataReg1 = useInterData;
twdl_reI_reg2 = twdl_reI_reg1;
twdl_reI_reg1 = twdl_reI_reg;
twdl_imI_reg2 = twdl_imI_reg1;
twdl_imI_reg1 = twdl_imI_reg;
switch twdlAddrSliced
    case FIRSTOCTANT
        useInterData = true;
        twdl_reI_reg =  cast(fi(real(exp(-1i*2*pi/8)), 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'RoundingMethod', 'Convergent', 'OverflowAction', 'Wrap'), 'like', twiddle_re);
        twdl_imI_reg =  cast(fi(imag(exp(-1i*2*pi/8)), 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'RoundingMethod', 'Convergent', 'OverflowAction', 'Wrap'), 'like', twiddle_re);
    case THIRDOCTANT
        useInterData = true;
        twdl_reI_reg = cast(fi(real(exp(-1i*6*pi/8)), 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'RoundingMethod', 'Convergent', 'OverflowAction', 'Wrap'), 'like', twiddle_re);
        twdl_imI_reg = cast(fi(imag(exp(-1i*6*pi/8)), 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'RoundingMethod', 'Convergent', 'OverflowAction', 'Wrap'), 'like', twiddle_re);
    otherwise
        useInterData = false;
        twdl_reI_reg =  cast(fi(real(exp(-1i*2*pi/8)), 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'RoundingMethod', 'Convergent', 'OverflowAction', 'Wrap'), 'like', twiddle_re);
        twdl_imI_reg =  cast(fi(imag(exp(-1i*2*pi/8)), 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'RoundingMethod', 'Convergent', 'OverflowAction', 'Wrap'), 'like', twiddle_re);
end


twdl_reX_regP = cast(fi(twdl_reX_reg, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'), 'like', twiddle_re);
twdl_imX_regP = cast(fi(twdl_imX_reg, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'), 'like', twiddle_re);

twdl_reX_regN = cast(fi(-twdl_reX_reg, 1, TWDL_WORDLENGTH + 1, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'), 'like', twiddle_re);
twdl_imX_regN = cast(fi(-twdl_imX_reg, 1, TWDL_WORDLENGTH + 1, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor'), 'like', twiddle_re);

twdl_reX_reg = twiddle_re;
twdl_imX_reg = twiddle_im;

