function [wrEnb, wrAddr ] = wrStateMachineG(validIn, ADDRWIDTH, ADDRRANGE)
%wrStateMachineF Summary of this function goes here
%   Detailed explanation goes here

persistent wrState  curWrAddr wrRdy %curWrEnb

%write states
IDLE_STATE        = fi(0,0,2,0);
FIRST_PHASE_STATE = fi(1,0,2,0);
PAUSE_STATE       = fi(2,0,2,0);
SECOND_PHASE_STATE= fi(3,0,2,0);


if isempty(wrState)
    wrState     = IDLE_STATE;
    %curWrEnb    = false;
    wrRdy       = true;
    curWrAddr   = fi(0,0,ADDRWIDTH, 0);
end

wrEnb = and(wrRdy, validIn);
wrAddr = curWrAddr;

switch wrState
    case IDLE_STATE
       wrRdy = true;
        if validIn
            wrState    = FIRST_PHASE_STATE;
            curWrAddr = fi(1,0,ADDRWIDTH, 0);
        else
            wrState     = IDLE_STATE;
            curWrAddr = fi(0,0,ADDRWIDTH, 0);
        end
        
    case FIRST_PHASE_STATE
        if validIn
            if curWrAddr == fi(ADDRRANGE - 1, 0, ADDRWIDTH, 0)
                curWrAddr =  fi(0,0,ADDRWIDTH, 0);
                wrRdy     = ~ wrRdy;
                wrState    = PAUSE_STATE;
            else
                curWrAddr = fi(curWrAddr+1,0,ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                wrRdy = true;
            end
        end
    case PAUSE_STATE
        if validIn
            wrState = SECOND_PHASE_STATE;
            curWrAddr = fi(0,0,ADDRWIDTH, 0);
            if ADDRRANGE == 2
                wrRdy   = false;
            else
                wrRdy   = true;
            end
        end
    case SECOND_PHASE_STATE
        if validIn
            if curWrAddr == fi(ADDRRANGE - 2, 0, ADDRWIDTH, 0)
                curWrAddr =  fi(0,0,ADDRWIDTH, 0);
                wrRdy = true;
                wrState    = FIRST_PHASE_STATE;
            else
                curWrAddr = fi(curWrAddr +1,0,ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                wrRdy     = ~ wrRdy;
                wrState = SECOND_PHASE_STATE;
            end
        end
    otherwise
        wrState     = IDLE_STATE;
        curWrAddr  = fi(0, 0, ADDRWIDTH, 0);
        wrRdy = true;
       
end
