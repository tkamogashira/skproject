%DeltaCF vs CD and BestITD
structplot(CFcombiselectWithDFS,'$DeltaCF$','$CD$',...
    CFcombiselectWithDFS,'$DeltaCF$','$BestITD$','markers', {'*','of'},'Colors', {'k','r'});
%DeltaCF vs CP
structplot(CFcombiselectWithDFS,'$DeltaCF$','$CP$','markers', {'o'},'Colors', {'g'})