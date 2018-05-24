function [twdl_re, twdl_im] = twiddleAddr3(realIn_vld, TOTALSTAGES, STAGENUM, TWDL_WORDLENGTH, TWDL_FRACTIONLENGTH)

persistent twiddleAddrReg twdlReReg twdlImReg

TWDL0_RE  = fi(1, 1, TWDL_WORDLENGTH, -TWDL_FRACTIONLENGTH, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Convergent');
TWDL0_IM  = cast(0, 'like', TWDL0_RE);
TWDL45_RE = cast(real(exp(-1i*2*pi/8)), 'like', TWDL0_RE);
TWDL45_IM = cast(imag(exp(-1i*2*pi/8)), 'like', TWDL0_RE);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TWIDDLE ADDR Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(twiddleAddrReg) 
    twiddleAddrReg = fi(0, 0, TOTALSTAGES - 1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
    twdlReReg = cast(0,'like', TWDL0_RE);
    twdlImReg = cast(0,'like', TWDL0_RE);
end

twiddleAddr_bitReverse = repmat(bitsliceget(fi(0, 0, 1, 0), 1, 1),1, TOTALSTAGES - 1);
for index = coder.unroll(1: TOTALSTAGES - 1)
  twiddleAddr_bitReverse(index) = bitsliceget(twiddleAddrReg, index, index); %#ok<EMVDF,AGROW>
end
% incrementing Addr.
if realIn_vld 
    twiddleAddrReg = fi(twiddleAddrReg + 1, 0, TOTALSTAGES -1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end
twdlAddr_raw       = fi(bitconcat(twiddleAddr_bitReverse), 0,  TOTALSTAGES - 1, 0);
if STAGENUM == TOTALSTAGES
    twdlAddrSliced = twdlAddr_raw;
else
    twdlAddrSliced     = fi(bitsliceget(twdlAddr_raw, STAGENUM, 2), 0, STAGENUM -1, 0, 'OverflowAction', 'Wrap', 'RoundingMethod', 'Floor');
end

twdl_re = twdlReReg;
twdl_im = twdlImReg;

if twdlAddrSliced == cast(0, 'like', twdlAddrSliced)
    twdlReReg = TWDL0_RE;
    twdlImReg = TWDL0_IM;
elseif twdlAddrSliced == cast(1, 'like', twdlAddrSliced)
    twdlReReg = TWDL45_RE;
    twdlImReg = TWDL45_IM;
elseif twdlAddrSliced == cast(2, 'like', twdlAddrSliced)
    twdlReReg = TWDL0_IM;
    twdlImReg = - TWDL0_RE;
else
    twdlReReg = -TWDL45_RE;
    twdlImReg = TWDL45_IM;
end
    