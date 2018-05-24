function [rdAddr_1, rdAddr_2, dataVld, rdEnb_1, rdEnb_2, twdlRdEnb, useDlyData_1, useDlyData_2, useMemData] = rdStateMachineL(validIn, wrAddr, ADDRWIDTH, ADDRRANGE)
%rdStateMachineF Summary of this function goes here
%   Detailed explanation goes here

persistent rdState curRdAddr_1 curRdAddr_2 curDataVld curRdEnb_1 curRdEnb_2 curUseDlyData_1 curUseDlyData_2 curUseMemData
%read states
READ_IDLE_STATE   = fi(0,0,3,0);
READ_FIRST_PHASE  = fi(1,0,3,0);
READ_SECOND_PHASE = fi(2,0,3,0);
READ_THIRD_PHASE  = fi(3,0,3,0);
READ_FORTH_PHASE  = fi(4,0,3,0);

RDMAXADDR = fi(ADDRRANGE - 4, 0, ADDRWIDTH, 0);

if isempty(rdState)
    rdState         = READ_IDLE_STATE;
    curRdAddr_1     = fi(0, 0, ADDRWIDTH, 0);
    curRdAddr_2     = fi(2^ADDRWIDTH - 1, 0, ADDRWIDTH, 0);
    curDataVld      = false;
    curRdEnb_1      = false;
    curUseDlyData_1 = false;
    curRdEnb_2      = false;
    curUseDlyData_2 = false;
    curUseMemData   = false;

end

rdAddr_1     = curRdAddr_1;
rdAddr_2     = curRdAddr_2;
dataVld      = curDataVld ;
rdEnb_1      = curRdEnb_1;
rdEnb_2      = curRdEnb_2;
%twdlRdEnb    = curRdEnb_1 || curRdEnb_2;
useDlyData_1 = curUseDlyData_1;
useDlyData_2 = curUseDlyData_2;
useMemData   = curUseMemData;

switch rdState
    case READ_IDLE_STATE
        curUseDlyData_1 = false;
        curUseDlyData_2 = false;
        %curUseMemData   = false;
        curRdAddr_2     = fi(2^ADDRWIDTH - 1, 0, ADDRWIDTH, 0);
        dataRdEnb_2      = false;
        if validIn && wrAddr == fi(ADDRRANGE - 2, 0,  ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
            curRdAddr_1 = fi(0, 0, ADDRWIDTH, 0);
            dataRdEnb_1 = true;
            curDataVld = false;
        elseif validIn && wrAddr == fi(ADDRRANGE - 1, 0,  ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
            rdState       = READ_FIRST_PHASE;
            curDataVld    = curRdEnb_1;
            dataRdEnb_1    = false;
            curRdAddr_1   = fi(curRdAddr_1 + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            curUseMemData = false;
        else
            curRdAddr_1     = fi(0, 0, ADDRWIDTH, 0);
            dataRdEnb_1      = false;
            curDataVld      = false;
        end      
    case READ_FIRST_PHASE
        curDataVld = curRdEnb_1;
        dataRdEnb_2 = curRdEnb_2;
        if curRdEnb_1
            rdState         = READ_SECOND_PHASE;
            curRdAddr_1     = fi(curRdAddr_1 + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            curUseDlyData_1 = true;
            dataRdEnb_1      = false;
        else
            dataRdEnb_1      = true;
        end     
    case READ_SECOND_PHASE
        curDataVld = curRdEnb_1;
        dataRdEnb_2 = curRdEnb_2;
        if curRdEnb_1
            rdState = READ_THIRD_PHASE;
            dataRdEnb_1 = false;
            curUseDlyData_1 = false;
            curUseDlyData_2 = true; 
        else
            dataRdEnb_1 = true;
        end
    case READ_THIRD_PHASE
        curDataVld = ~ curDataVld;
        if curRdAddr_1 == fi(ADDRRANGE - 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
            curRdAddr_1   = fi(0, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            rdState       = READ_IDLE_STATE;
            curUseMemData = false;
            dataRdEnb_1    = false;
            dataRdEnb_2    = false;
        else
            curRdAddr_1 = fi(curRdAddr_1 + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            if curRdAddr_2 == fi(RDMAXADDR, 0, ADDRWIDTH, 0);
                curRdAddr_2 = fi(2^ADDRWIDTH - 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            else
                curRdAddr_2 = fi(curRdAddr_2 + 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap');
            end
            rdState         = READ_FORTH_PHASE;
            dataRdEnb_1      = true;
            dataRdEnb_2      = true;
        end 
    case READ_FORTH_PHASE
        curDataVld = ~ curDataVld;
        dataRdEnb_1      = false;
        dataRdEnb_2      = false;
        if ADDRRANGE == 4
            rdState         = READ_IDLE_STATE;
            curUseMemData   = true;
            curUseDlyData_2 = false;
        else
            if curRdAddr_1 == fi(ADDRRANGE - 1, 0, ADDRWIDTH, 0, 'OverflowAction', 'Wrap')
                rdState       = READ_IDLE_STATE;
            else
                rdState = READ_THIRD_PHASE;
                curUseMemData   = true;
                curUseDlyData_2 = false;
            end
        end
        
    otherwise
        curRdAddr_1     = fi(0, 0, ADDRWIDTH, 0);
        curRdAddr_2     = fi(2^ADDRWIDTH - 1, 0, ADDRWIDTH, 0);
        dataRdEnb_1      = false;
        dataRdEnb_2      = false;
        curDataVld      = false;
        curUseDlyData_1 = false;
        curUseDlyData_2 = false;
end
%twdlRdEnb  = bitor(dataRdEnb_1, dataRdEnb_2);
twdlRdEnb  = dataRdEnb_1;
curRdEnb_1 = dataRdEnb_1;
curRdEnb_2 = dataRdEnb_2;


