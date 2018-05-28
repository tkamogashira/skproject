function fixate( CC, fixationStruct )
%FIXATE Summary of this function goes here
%   Detailed explanation goes here

beep on;

%% warn the monkey
CC = flushQueues(CC);
CC = flashLeds(CC, fixationStruct.FlashTime);

% do nothing during onset
pause((fixationStruct.Onset + fixationStruct.FlashTime) / 1000)

timeBegin = clock;
if ischar(fixationStruct.FixLed)
    fixationStruct.FixLed = translateDirection(fixationStruct.FixLed);
end

%% Start fixation
CC = setFixationLed(CC, fixationStruct.FixLed, 'on');
timeNow = clock;
currEyePos = requestCurrWindow(CC);
abortFixation = 0;
rewardPos = 1;

CC = processQueue(CC);
if saccadesHappened(CC)
    currEyePos = CC.saccadeQueue(end).newWindow;
    CC.saccadeQueue = [];
end

while etime(timeNow, timeBegin) < (fixationStruct.GraceTime / 1000) & ~isequal( fixationStruct.FixLed, currEyePos ) %#ok<AND2>
    CC = processQueue(CC);
    pause(0.02)
    if saccadesHappened(CC)
        currEyePos = CC.saccadeQueue(end).newWindow;
        CC.saccadeQueue = [];
    end
    timeNow = clock;
end

if ~isequal( fixationStruct.FixLed, currEyePos )
    abortFixation = 1;
else
    beep
    disp(['Now fixating on Led Nr. ' num2str(fixationStruct.FixLed)]);
end

timeBegin = clock;
timeNow = clock;
while (etime(timeNow, timeBegin) < fixationStruct.FixDur / 1000) & (~abortFixation) %#ok<AND2>
    CC = processQueue(CC);
    pause(0.02)
    for cSaccade = 1:saccadesHappened(CC)
        if ~isequal(fixationStruct.FixLed, CC.saccadeQueue(cSaccade).newWindow)
            abortFixation = 1;
        end
    end
    CC.saccadeQueue = [];
    
    if rewardPos <= length(fixationStruct.RewardTimes)
        if etime(timeNow, timeBegin) > (fixationStruct.RewardTimes(rewardPos)/1000)
            beep;
            disp(['Rewarding the monkey: ' num2str(fixationStruct.RewardAmpl(rewardPos)*200) ' ms']);
            CC = reward(CC, fixationStruct.RewardAmpl(rewardPos));
            rewardPos = rewardPos + 1;
        end
    end
            
    timeNow = clock;
end

beep

if abortFixation,
    warning('Fixation unsuccesful!');
    disp(['Punishing the monkey: ' num2str(fixationStruct.PunishAmpl * 200) ' ms']);
    CC = punish(CC, fixationStruct.PunishAmpl);
    pause(fixationStruct.AbortDelay/1000);
else
    if ~isequal(rewardPos, length(fixationStruct.RewardTimes))
        warning('Fixation succesful, but not all rewards were given. Please review reward times.');
    else
        disp('Fixation succesful!');
    end
end

CC = setFixationLed(CC, fixationStruct.FixLed, 'off');

pause(fixationStruct.OffTime / 1000);