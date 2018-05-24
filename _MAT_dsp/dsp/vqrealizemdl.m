function vqrealizemdl(UD)
%REALIZEMDL Vector Quantizer realization (Simulink diagram).
% creates model with either VQ Enc or VQ Dec block
%  Specification:
%  CASE-1: Current model: name:NEWBLOCK, overwrite = 0/1;
%  If gcs=library model or '' , it generates a new model 
%       'Untitled' with  a block named NEWBLOCK
%  else %% gcs= a valid model (say 'My_model')
%     if My_model.mdl DOES'NT have a block named NEWBLOCK
%           in My_model.mdl it adds a block named NEWBLOCK
%     else % My_model.mdl has a block named NEWBLOCK
%           if (overwrite=0)
%                in My_model.mdl it adds a block named NEWBLOCK1
%                and, Gives a message to the user.(we are too good)
%           else % (overwrite=1)
%                if NEWBLOCK is a VQ CODEC block, 
%                      work on it to set_param
%                else %NEWBLOCK is NOT a VQ ENC/DEC block
%                     in My_model.mdl it adds a VQ CODEC block named NEWBLOCK1
%                     and, Gives a message to the user.(we are too good)
%                end
%           end
%     end
%  end
%  CASE-2: New model: name:NEWBLOCK
%     it generates a model with name Untitled. If Untitled.mdl is an open model
%     (not necessarily the GCS), then get model name =Untitled1.mdl
%     Add a block NEWBLOCK to that model and work on it.
%  end of specification

%    Copyright 1998-2011 The MathWorks, Inc.

% Check if product is installed
if (nargin ~=1)
    error(message('dsp:vqrealizemdl:invalidFcnInput'));
end    
if ~(exist('dsp') == 7),
    set(UD.hTextStatus,'ForeGroundColor','Red');  set(UD.hTextStatus,'String','Generate Model: Could not find DSP System Toolbox.');
    return
end

set(UD.hTextStatus,'ForeGroundColor','Black');  set(UD.hTextStatus,'String', 'Ready');

% Create model
specname = UD.blockName; 
[new_UD, OtherTypeBlock] = vqcreatemodel(UD);

if ~strcmpi(specname,new_UD.blockName),
    if (OtherTypeBlock)
      msgNotVQBlock = strcat(['Generate Model: The target block is not a Vector Quantizer block. Data have been exported to the block ', new_UD.blockName, '.']);
      set(UD.hTextStatus,'ForeGroundColor','Red');  set(UD.hTextStatus,'String',msgNotVQBlock);
    else
      msgNameChange = ['Generate Model: The generated block has been renamed'];%  to ', new_UD.blockName, '.']);  
      set(UD.hTextStatus,'ForeGroundColor','Red');  set(UD.hTextStatus,'String',msgNameChange);
    end
end

% Refresh connections
sys = new_UD.system;
oldpos = get_param(sys, 'Position');
set_param(sys, 'Position', oldpos + [0 -5 0 -5]);
set_param(sys, 'Position', oldpos);

sizeCB= size(UD.finalCodebook);
tempCB = reshape(UD.finalCodebook,1,sizeCB(1)*sizeCB(2));
set_param(sys,'codebook',['reshape(', '[', num2str(tempCB), ']',',',num2str(sizeCB(1)),',',num2str(sizeCB(2)),')' ]);
if (length(get_param(sys,'codebook')) > (2^15-1))
    uiwait(warndlg('Codebook is too big to write in the block''s edit book. Please export the codebook to workspace using Ctrl+E.', 'Overwrite Warning','modal'));
end    

%set_param(sys,'codebook',strcat('[',num2str(UD.finalCodebook),']'));
if (UD.whichBlock==1)%encoder
	if (UD.TieBreakingRule== 1)
       set_param(sys,'tieBreakRule','Choose the lower index');
	else
       set_param(sys,'tieBreakRule','Choose the higher index'); 
    end 
    if (UD.NeedWeightForCurrentFig)
       if isvector(UD.weightForCurrentFig)
           tmpWeight = reshape(UD.weightForCurrentFig,1,length(UD.weightForCurrentFig));
           set_param(sys,'weights',['[', num2str(tmpWeight), ']']);
           if (length(get_param(sys,'weights')) > (2^15-1))
                 uiwait(warndlg('Weighting factor is too big to write in the block''s edit book.', 'Overwrite Warning','modal'));
           end
       else
           tmpWeight = UD.weightForCurrentFig(:,1); % get only the first column
           %set_param(sys,'weights','Weights in matrix form not allowed');
           set_param(sys,'weights',['[', num2str(tmpWeight'), ']']);
           uiwait(warndlg('In VQ Design Tool, you specified a matrix for the Weighting factor parameter. Since the Vector Quantizer Encoder block only supports vectors for its Weighting factor parameter, VQ Design Tool set this parameter to the first column of the original Weighting factor matrix.', 'Overwrite Warning','modal'));
           if (length(get_param(sys,'weights')) > (2^15-1))
                 uiwait(warndlg('Weighting factor is too big to write in the block''s edit book.', 'Overwrite Warning','modal'));
           end
       end
       set_param(sys,'distMeasure','Weighted squared error');
	else
       set_param(sys,'distMeasure','Squared error'); 
	end 
end
% Open system
slindex = findstr(sys,'/');
open_system(sys(1:slindex(end)-1));

% [EOF]
