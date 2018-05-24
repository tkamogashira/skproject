function enrichedBlockRecord = autofixexp_autoScale(...
                                  blockRecord, ...
                                  topSubSystemToScale, RangeFactor)

% Copyright 2005-2006 The MathWorks, Inc.

enrichedBlockRecord = blockRecord;

unknownParam = 0;

% get Parameter names from Signal names
switch enrichedBlockRecord.SignalName
   % try the 'standard' attribute types first
   case 'Accumulator'
    modeStr = 'accumMode';
    wlStr   = 'accumWordLength';
    flStr   = 'accumFracLength';
   case 'Product output'
    modeStr = 'prodOutputMode';
    wlStr   = 'prodOutputWordLength';
    flStr   = 'prodOutputFracLength';
   case 'State'
    modeStr = 'memoryMode';
    wlStr   = 'memoryWordLength';
    flStr   = 'memoryFracLength';
   case 'Output'
    modeStr = 'outputMode';
    wlStr   = 'outputWordLength';
    flStr   = 'outputFracLength';

   otherwise
    % Handling special case blocks
    % Those blocks which do not use standard names for fixed-point parameters
    % will have to provide in their DDG class a method called
    % getParamsFromSignalName which will return a structure with the members
    % modeStr, wlStr, flStr, skipThisSignal and unknownParam
    % See for example DDG of LMS block.
    try
      blockDialogObj = enrichedBlockRecord.blockDialogObj;

      if (ismethod(blockDialogObj, 'getParamsFromSignalName'))
        paramNames = blockDialogObj.getParamsFromSignalName(...
                                          enrichedBlockRecord.SignalName);
        if paramNames.skipThisSignal
            return;
        end
        modeStr = paramNames.modeStr;
        
        wlStr   = paramNames.wlStr;
        flStr   = paramNames.flStr;
        unknownParam = paramNames.unknownParam;
      else
        unknownParam = 1;
      end
    catch
      unknownParam = 1;
      blockDialogObj = [];
    end
    delete(blockDialogObj);
end

if unknownParam
    enrichedBlockRecord = handleUnknownParameter(enrichedBlockRecord);
    return;
end

enrichedBlockRecord = appendToRecordFinalScalingName(enrichedBlockRecord,flStr);

minValue = autofixexp('getFieldOrDefault',enrichedBlockRecord,'MinValue', Inf);
maxValue = autofixexp('getFieldOrDefault',enrichedBlockRecord,'MaxValue',-Inf);

enrichedBlockRecord = appendToRecordDoScaleStatusLocal(minValue,...
                                                  maxValue,...
                                                  enrichedBlockRecord,...
                                                  modeStr,...
                                                  wlStr,...
                                                  topSubSystemToScale);

enrichedBlockRecord = getCurOutDataType(wlStr,enrichedBlockRecord);

enrichedBlockRecord = autofixexp('MinMax2ProposedFrac',...
                                 minValue,...
                                 maxValue,...
                                 RangeFactor,...
                                 enrichedBlockRecord);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function curFixPtTempOut = getCurOutDataType(wlStr,curFixPtTemp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

curOutDataType = [];

if curFixPtTemp.doScaling

    curFixPtTemp.WordLengthSpecified = curFixPtTemp.Parameters.(wlStr).paramValue;
    
    % xxx - TBD - support unsigned!
    curFixPtTemp.SignedSpecified = logical(1);
    
    curOutDataType = fixdt(curFixPtTemp.SignedSpecified,...
                           curFixPtTemp.WordLengthSpecified);
end
   
curFixPtTemp.NumericTypeSpecified = curOutDataType;

curFixPtTempOut = curFixPtTemp;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function enrichedBlockRecord = handleUnknownParameter(blockRecord)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    enrichedBlockRecord = blockRecord;

    if ~isfield(enrichedBlockRecord,'scalingComments')
        
        enrichedBlockRecord.scalingComments = {};
    end
    
    enrichedBlockRecord.scalingComments{end+1} = sprintf('Block parameter can''t be autoscaled.');
    %                                                           %%%%%%%%%

    enrichedBlockRecord.scalingComments{end+1} = sprintf('Autoscaling of block''s "%s" parameter is not supported.', enrichedBlockRecord.SignalName);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function enrichedBlockRecord = appendToRecordFinalScalingName(blockRecord,FinalScalingName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    followToOrigin_YES = 1;

    enrichedBlockRecord = autofixexp('getBlockParameterInfo',...
                                     blockRecord, ...
                                     FinalScalingName, ...
                                     followToOrigin_YES, ...
                                     'FinalScaling');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Inherited = isDataTypeInherited(curFixPtTemp,modeStr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Inherited = ~any(strcmp(...
  {...
      'Binary point scaling',...
      'Slope and bias scaling',...
      'User-defined'...
  }, ...
  autofixexp('getParamOrDefault',curFixPtTemp,modeStr,'')));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hasDataTypeField = isDataTypeFieldPresent(curFixPtTemp,wlStr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    hasDataTypeField = isfield(curFixPtTemp,'Parameters') && ...
        ( ...
            ( ...
                isfield(curFixPtTemp.Parameters,wlStr) && ...
                isfield(curFixPtTemp.Parameters.(wlStr),'paramValue') ...
                ) ...
            );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function curFixPtTempOut = appendToRecordDoScaleStatusLocal(minValue,maxValue,curFixPtTemp,modeStr,wlStr,topSubSystemToScale)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
rec.Inherited = isDataTypeInherited(curFixPtTemp,modeStr);
  
rec.hasDataTypeField =   isDataTypeFieldPresent(curFixPtTemp,wlStr);

curFixPtTempOut = autofixexp('appendToRecordDoScaleStatus',...
                             minValue,...
                             maxValue,...
                             curFixPtTemp,...
                             topSubSystemToScale,...
                             rec);
