function [wrEnb_1, wrAddr_1, wrEnb_2, wrAddr_2 ] = wrStateMachineL(validIn, ADDRWIDTH, ADDRRANGE, FFTLENGTH)
%wrStateMachineF Summary of this function goes here
%   Detailed explanation goes here

persistent wrState curWrEnb_1 curWrAddr_1 curWrEnb_2 curWrAddr_2

%write states
WRITE_IDLE_STATE  = fi(0,0,2,0);
WRITE_FIRST_PHASE = fi(1,0,2,0);
WRITE_PAUSE_STATE = fi(2,0,2,0);
WRITE_SECOND_PHASE= fi(3,0,2,0);

WRDELAY = fi(3, 0, ADDRWIDTH, 0);
WRMAXADDR = fi(ADDRRANGE - 4, 0, ADDRWIDTH, 0);


if isempty(wrState)
    wrState     = WRITE_IDLE_STATE;
    curWrEnb_1    = true;
    curWrAddr_1  = fi(1,0,ADDRWIDTH, 0);
    curWrEnb_2    = false;
    curWrAddr_2  = fi(1,0,ADDRWIDTH, 0);
end

wrEnb_1  = curWrEnb_1 && validIn;
wrAddr_1 = curWrAddr_1;
wrEnb_2  = curWrEnb_2 && validIn;
wrAddr_2 = curWrAddr_2;

switch wrState
    case WRITE_IDLE_STATE
       curWrEnb_1 = true;
       curWrEnb_2 = false;
       curWrAddr_1 = fi(0,0,ADDRWIDTH, 0);
       curWrAddr_2 = fi(0,0,ADDRWIDTH, 0);
       if validIn
            wrState     = WRITE_FIRST_PHASE;
            curWrAddr_1 = fi(1,0,ADDRWIDTH, 0);
            curWrEnb_1  = true;
       end
    case WRITE_FIRST_PHASE
        if validIn
            if curWrAddr_1 == fi(ADDRRANGE - 1, 0, ADDRWIDTH, 0)
                curWrAddr_1 =  fi(1,0,ADDRWIDTH, 0);
                curWrEnb_1  = false;
                wrState     = WRITE_PAUSE_STATE;
            else
                curWrAddr_1 = fi(curWrAddr_1+1,0,ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                curWrEnb_1  = true;
            end
        end
    case WRITE_PAUSE_STATE
        if validIn
            if curWrAddr_1 == WRDELAY
                wrState     = WRITE_SECOND_PHASE;
                curWrAddr_1 = fi(0,0,ADDRWIDTH, 0);
                curWrAddr_2 = fi(0,0,ADDRWIDTH, 0);
                curWrEnb_2  = true;
            else
                curWrAddr_1 = fi(curWrAddr_1 + 1,0,ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            end
        end
    case WRITE_SECOND_PHASE
        if validIn
            curWrEnb_2 = true;
            if FFTLENGTH == 16
                if curWrAddr_2 == fi(4, 0, ADDRWIDTH, 0)
                    curWrAddr_2 = fi(0,0, ADDRWIDTH, 0);
                    wrState    = WRITE_FIRST_PHASE;
                    curWrEnb_1 = true;
                    curWrEnb_2 = false;
                else
                    curWrAddr_2 = fi(curWrAddr_2 + 1,0,ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                end
            else
                if curWrAddr_2 == WRMAXADDR
                    curWrAddr_2 = fi(0, 0, ADDRWIDTH, 0);
                    curWrEnb_1  = true;
                    curWrEnb_2  = false;
                    wrState     = WRITE_FIRST_PHASE;
                else
                    curWrAddr_2 = fi(curWrAddr_2 + 1,0,ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
                end
                
            end
        end
    otherwise
        wrState      = WRITE_IDLE_STATE;
        curWrAddr_1  = fi(0, 0, ADDRWIDTH, 0);
        curWrEnb_1   = validIn;
        curWrAddr_2  = fi(0, 0, ADDRWIDTH, 0);
        curWrEnb_2   = false;
        
end
