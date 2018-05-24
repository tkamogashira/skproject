function [rdAddr, realDataVld, dataRdEnb, twdlRdEnb, useDlyData] = rdStateMachineG(validIn, wrAddr, ADDRWIDTH, ADDRRANGE)
%rdStateMachineF Summary of this function goes here
%   Detailed explanation goes here

persistent rdState twdlRdState curRdAddr curRealDataVld curRdEnb curUseDlyData twdlRdEnbReg
%read states
IDLE_STATE        = fi(0,0,3,0);
PAUSE_STATE       = fi(1,0,3,0);
FIRST_PHASE_STATE = fi(2,0,3,0);
WAIT_STATE        = fi(3,0,3,0);
SECOND_PHASE_STATE= fi(4,0,3,0);

TWDL_IDLE    = fi(0, 0, 2, 0);
TWDL_READ    = fi(1, 0, 2, 0);
TWDL_WAIT    = fi(2, 0, 2, 0);

if isempty(rdState)
    rdState         = IDLE_STATE;
    twdlRdState     = TWDL_IDLE;
    curRdAddr       = fi(0, 0, ADDRWIDTH, 0);
    curRealDataVld  = false;
    curRdEnb        = false;
    curUseDlyData   = false;
    twdlRdEnbReg    = false;
end

rdAddr       = curRdAddr;
realDataVld  = curRealDataVld;
dataRdEnb    = curRdEnb;
useDlyData   = curUseDlyData;

switch rdState
    case IDLE_STATE
        if ADDRRANGE == 2
            curRdAddr     = fi(0, 0, ADDRWIDTH, 0);
            curUseDlyData = true;
            if validIn
                rdState        = FIRST_PHASE_STATE;
                curRealDataVld = curRdEnb; 
                rdEnb          = true;   
            else
                rdState         = IDLE_STATE;
                rdEnb           = false; 
                curRealDataVld  = false;
            end
        else
            curRdAddr      = fi(0, 0, ADDRWIDTH, 0);
            rdEnb          = false;
            curRealDataVld = false;
            curUseDlyData  = true;
            if validIn && wrAddr == fi(ADDRRANGE - 3, 0,  ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
                rdState       = PAUSE_STATE;
            end
        end
        
    case PAUSE_STATE
        rdEnb =  curRdEnb;
        if ADDRRANGE == 2
            if validIn
                rdState         = FIRST_PHASE_STATE;
                curRealDataVld  = curRdEnb; 
                rdEnb           = true;   
            end
        else
            if validIn
                curRdAddr       = fi(0, 0, ADDRWIDTH, 0);
                rdState         = FIRST_PHASE_STATE;
                curRealDataVld  = false;
                rdEnb           = true;
            end
        end
    case FIRST_PHASE_STATE
        if ADDRRANGE == 2
            rdState           = PAUSE_STATE;
            curUseDlyData     = ~ curUseDlyData;
            curRealDataVld    = curRdEnb;
            rdEnb             = false;
            if curRdAddr == fi(0, 0, ADDRWIDTH, 0)
                curRdAddr = fi(1, 0, ADDRWIDTH, 0);
            else
                curRdAddr = fi(0, 0, ADDRWIDTH, 0);
            end
        else
            rdEnb      = curRdEnb;
            if validIn
                curUseDlyData    = false;
                curRealDataVld   = curRdEnb; 
                if curRdAddr == fi(ADDRRANGE - 2, 0,  ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
                    curRdAddr  = fi(0, 0, ADDRWIDTH, 0);
                    rdState    = WAIT_STATE;
                else
                    curRdAddr = fi(curRdAddr + 1, 0,  ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                    rdEnb      = ~ curRdEnb;
                end
            end
        end
    case WAIT_STATE   
        curRealDataVld  = false;
        rdEnb           = curRdEnb;
        if curRdAddr == fi(1, 0, ADDRWIDTH, 0)
            rdState        = SECOND_PHASE_STATE;
            curRdAddr       = fi(curRdAddr + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            curRealDataVld = true;
            curUseDlyData  = true;
        else
            curRdAddr       = fi(curRdAddr + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
        end
    case SECOND_PHASE_STATE 
        rdEnb           = curRdEnb;
        if validIn
            curRealDataVld    = ~ curRealDataVld;
            if curRdAddr == fi(ADDRRANGE - 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
                curRdAddr = fi(0, 0, ADDRWIDTH, 0);
                rdState   = PAUSE_STATE;
                rdEnb     = false;
            else
                curRdAddr  = fi(curRdAddr + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                rdEnb      = true;
            end
        end
    otherwise
        rdState         = IDLE_STATE;
        curRdAddr       = fi(0, 0, ADDRWIDTH, 0);
        rdEnb           = false;
        curRealDataVld  = false;
        curUseDlyData   = true;
end
curRdEnb  = rdEnb;
switch twdlRdState
    case TWDL_IDLE
        if ADDRRANGE == 2
            if validIn
               twdlRdEnbS = true;
               twdlRdState = TWDL_READ;
            else
               twdlRdEnbS = false;
               twdlRdState = TWDL_IDLE; 
            end
        else
            if validIn && wrAddr == fi(ADDRRANGE - 3, 0,  ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
                twdlRdEnbS = true;
                twdlRdState = TWDL_READ;
            else
                twdlRdEnbS = false;
                twdlRdState = TWDL_IDLE;
            end
        end
    case TWDL_READ
        twdlRdEnbS   = false;
        twdlRdState = TWDL_WAIT;
    case TWDL_WAIT
        if validIn
            twdlRdEnbS = true;
            twdlRdState = TWDL_READ;
        else
            twdlRdEnbS = false;
            twdlRdState = TWDL_WAIT;
        end
    otherwise
        twdlRdEnbS   = false;
        twdlRdState = TWDL_IDLE;
end

if ADDRRANGE == 2
    twdlRdEnb = twdlRdEnbS;
else
    twdlRdEnb = twdlRdEnbReg;
end

twdlRdEnbReg = twdlRdEnbS;

