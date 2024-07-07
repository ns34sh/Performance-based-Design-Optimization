function [ColumnCost,ConcreteCost,MainSteelCost,SecondarySteelCost] = ColCost(Name)
% Script to calculate cost of individual column
% Name=ObjectName{i};
global SapModel
PropName='';
SAuto='';
% eval(['[ret,PropListBm' num2str(i) ',SAuto]=SapModel.FrameObj.GetSection(char(Name),PropName,SAuto);']);
[ret,PropCol,SAuto]=SapModel.FrameObj.GetSection(char(Name),PropName,SAuto);
%     if size(PropListBm,2)==7
%     BeamPropNo(1)=ColGradeProp(7);
%     BeamPropNo=str2double(ColGradeNo);
%     else
%     BeamPropNo(1)=ColGradeProp(7);
%     BeamPropNo(2)=ColGradeProp(8);
%     BeamPropNo=str2double(ColGradeNo);
%     end
FileName='';GradeCol='';Depth=0;Width=0;Color=int32(0);Notes='';GUID='';
[ret,FileName,GradeCol,Depth,Width]=SapModel.PropFrame.GetRectangle(PropCol,FileName,GradeCol,Depth,Width,Color,Notes,GUID);
% Depth=eval(['B' num2str(BeamPropNo) '.Depth']);
% Width=eval(['B' num2str(BeamPropNo) '.Width']);
GradeLong='';GradeConf='';Pattern=int32(0);ConfineType=int32(0);Cover=0;NumberCBars=int32(0);NumberR3Bars=int32(0);NumberR2Bars=int32(0);
RebarSize='';TieSize='';TieSpacing=0;Num2DTieBars=int32(0);Num3DTieBars=int32(0);
[ret,GradeLong,GradeConf]=SapModel.PropFrame.GetRebarColumn(PropCol,GradeLong,GradeConf,Pattern,ConfineType,Cover,NumberCBars,NumberR3Bars,NumberR2Bars,RebarSize,TieSize,TieSpacing,Num2DTieBars,Num3DTieBars,true);



%% Get design results for columns



NumberItems = 0;
FrameName = cellstr(' ');
MyOption = zeros(2,1,'int32');
MyOption(1)=2;
Location=zeros(2,1,'double');
Location(1)=0.0;
PMMCombo=cellstr(' ');
PMMArea=zeros(2,1,'double');
PMMArea(1)=0.0;
PMMRatio=zeros(2,1,'double');
PMMRatio(1)=0.0;
VmajorCombo=cellstr(' ');
AVmajor=zeros(2,1,'double');
AVmajor(1)=0.0;
VminorCombo=cellstr(' ');
AVminor=zeros(2,1,'double');
AVminor(1)=0.0;
ErrorSummary=cellstr(' ');
WarningSummary=cellstr(' ');
[ret,NumberItems,FrameName,MyOption,Location,PMMCombo,PMMArea,PMMRatio,VmajorCombo,AVmajor,VminorCombo,AVminor,ErrorSummary,WarningSummary]=...
SapModel.DesignConcrete.GetSummaryResultsColumn(Name,NumberItems,FrameName,MyOption,Location,PMMCombo,PMMArea,PMMRatio,VmajorCombo,AVmajor,VminorCombo,AVminor,ErrorSummary,WarningSummary,0);

SegmentLength=zeros(1,NumberItems-1);
AvgPMMArea=zeros(1,NumberItems-1);
AvgAVmajor=zeros(1,NumberItems-1);
AvgAVminor=zeros(1,NumberItems-1);

for i=1:(NumberItems-1)
    SegmentLength(i)=Location(i+1)-Location(i);
    AvgPMMArea(i)=(PMMArea(i+1)+PMMArea(i))/2;
    AvgAVmajor(i)=(AVmajor(i+1)+AVmajor(i))/2;
    AvgAVminor(i)=(AVminor(i+1)+AVminor(i))/2;
  
end
PMMAreaTotal=sum(SegmentLength.*AvgPMMArea);

AVmajorTotal=sum(SegmentLength.*AvgAVmajor)*Depth;
AVminorTotal=sum(SegmentLength.*AvgAVminor)*Width;

MainSteelCol=PMMAreaTotal;
SecondarySteelCol=AVmajorTotal+AVminorTotal;

TotalLength=sum(SegmentLength);
VolumeCol=TotalLength*Depth*Width;
switch GradeCol
    case 'M25'
        ConcUnitCost=8842;
    case 'M30'
        ConcUnitCost=8953;
    case 'M35'
        ConcUnitCost=9064;
    case 'M40'
        ConcUnitCost=9175;
end
HeightCol=MemHeight(Name);
ConcUnitCostIncr=(HeightCol-4000-6000)/3000*202;
if ConcUnitCostIncr>0
ConcUnitCost=ConcUnitCost+ConcUnitCostIncr;
end
switch GradeLong
    case 'HYSD415'
        MainSteelUnitCost=40;
    case 'HYSD500'
        MainSteelUnitCost=43;
end

switch GradeConf
    case 'HYSD415'
        SecondarySteelUnitCost=40;
    case 'HYSD500'
        SecondarySteelUnitCost=43;
end
SteelUnitCostIncr=(HeightCol-4000-6000)/3000*.445;
if SteelUnitCostIncr>0
MainSteelUnitCost=MainSteelUnitCost+SteelUnitCostIncr;
SecondarySteelUnitCost=SecondarySteelUnitCost+SteelUnitCostIncr;
end
MainSteelCost=MainSteelCol*MainSteelUnitCost*7850/10^9;
SecondarySteelCost=SecondarySteelCol*SecondarySteelUnitCost*7850/10^9;
ConcreteCost=VolumeCol*ConcUnitCost/10^9;

ColumnCost=MainSteelCost+SecondarySteelCost+ConcreteCost;
% 





