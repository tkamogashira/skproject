function [dout_re, dout_im, dout_vld] = evenOddSplit(dataIn, validIn, SIGNED, WORDLENGTH, FRACTIONLENGTH)
%evenOddSplit Summary of this function goes here
%   Detailed explanation goes here

 dout_vld = validIn;
 dout_re  = dataIn;
 dout_im  = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH);
 
%%% the follwoing part is for more optimization when the input is real
%%% only(Not supported in 2014A).
% persistent State doutVld doutRe doutIm doutReDly doutVldDly
% 
% EVEN_STATE = fi(0,0,1,0);
% ODD_STATE  = fi(1,0,1,0);
% 
% if isempty(State)
%     State      = EVEN_STATE;
%     doutRe     = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH);
%     doutIm     = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH);
%     doutReDly  = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH);
%     doutVldDly = false;
%     doutVld    = false;
% end
% 
% dout_vld = doutVldDly;
% doutVldDly = doutVld;
% dout_re  = doutReDly;
% dout_im  = doutIm;
% 
% doutReDly = doutRe;
% 
% switch State
%     case EVEN_STATE
%         doutRe   = dataIn;
%         if validIn
%             State   = ODD_STATE; 
%             doutVld   = false;
%         end
%         
%     case ODD_STATE
%         doutIm   = dataIn;
%         if validIn
%             State  = EVEN_STATE;
%             doutVld   = true;
%         end
%     otherwise
%         State      = EVEN_STATE;
%         doutRe  = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH);
%         doutIm  = fi(0, SIGNED, WORDLENGTH, -FRACTIONLENGTH);
% end

