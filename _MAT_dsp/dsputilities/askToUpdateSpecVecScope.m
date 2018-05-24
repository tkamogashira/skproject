function replace = askToUpdateSpecVecScope(block, h)
%Function to prompt for update of Spectrum and Vector Scope block to be used with SLUPDATE.
% This function provides customized prompt for these two blocks.

%   Copyright 2008 The MathWorks, Inc.

%Function askToUpdateSpecVecScope(block, h): prompts user about replacing Spectrum or Vector
%   Scope block. If the user should not be prompted it immediately returns true so that 
%   callers of this function do not need to worry about the state of the prompt flag.
%   If the user selects to not replace, displays a skipping message.

% This function is based on askToReplace() method of ModelUpdater class. It has been customized
% for Spectrum and Vector Scope blocks.

if getPrompt(h)

    name = cleanBlockName(h, block);

    updatePrompt = DAStudio.message('SignalBlockset:utility:slupdatePrompt', name, name);
    replaceReply = input(updatePrompt, 's');

    if isempty(replaceReply),
        replace = true;
    else
        switch replaceReply(1)
            case 'y'
                replace = true;
            case 'n'
                replace = false;
                fprintf('Skipping: %s\n', name);
            case 'a'
                replace = true;
                setPrompt(h, false);

            otherwise
                warning(message('dsp:slupdate:slupdateInvalidPromptResponse', replaceReply));
                replace = false;
                fprintf('Skipping: %s\n', name);
        end
    end
else
    replace = true;
end

end

%[EOF] askToUpdateSpecVecScope.m
