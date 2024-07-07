function [BeamCost,ConcreteCost,MainSteelCost,SecondarySteelCost] = BmCost(Name)
% Script to calculate cost of individual beam
% Name=ObjectName{i};
global SapModel
PropName='';
SAuto='';
% eval(['[ret,PropListBm' num2str(i) ',SAuto]=SapModel.FrameObj.GetSection(char(Name),PropName,SAuto);']);
[ret,PropBm,SAuto]=SapModel.FrameObj.GetSection(char(Name),PropName,SAuto);
%     if size(PropListBm,2)==7
%     BeamPropNo(1)=ColGradeProp(7);
%     BeamPropNo=str2double(ColGradeNo);
%     else
%     BeamPropNo(1)=ColGradeProp(7);
%     BeamPropNo(2)=ColGradeProp(8);
%     BeamPropNo=str2double(ColGradeNo);
%     end
FileName='';GradeBm='';Depth=0;Width=0;Color=int32(0);Notes='';GUID='';
[ret,FileName,GradeBm,Depth,Width]=SapModel.PropFrame.GetRectangle(PropBm,FileName,GradeBm,Depth,Width,Color,Notes,GUID);
% Depth=eval(['B' num2str(BeamPropNo) '.Depth']);
% Width=eval(['B' num2str(BeamPropNo) '.Width']);
GradeLong='';GradeConf='';CoverTop=0;CoverBot=0;TopLeft=0;TopRight=0;BotLeft=0;BotRight=0;
[ret,GradeLong,GradeConf]=SapModel.PropFrame.GetRebarBeam(PropBm,GradeLong,GradeConf,CoverTop,CoverBot,TopLeft,TopRight,BotLeft,BotRight);

NumberItems=0;
FrameName = cellstr(' ');
Location=zeros(2,1,'double');
Location(1)=0.0;
TopCombo=cellstr(' ');
TopArea=zeros(2,1,'double');
TopArea(1)=0.0;
BotCombo=cellstr(' ');
BotArea=zeros(2,1,'double');
BotArea(1)=0.0;
VmajorCombo=cellstr(' ');
VmajorArea=zeros(2,1,'double');
VmajorArea(1)=0.0;
TLCombo=cellstr(' ');
TLArea=zeros(2,1,'double');
TLArea(1)=0.0;
TTCombo=cellstr(' ');
TTArea=zeros(2,1,'double');
TTArea(1)=0.0;
ErrorSummary=cellstr(' ');
WarningSummary=cellstr(' ');
[ret,NumberItems,FrameName,Location,TopCombo,TopArea,BotCombo,BotArea,VmajorCombo,VmajorArea,TLCombo,TLArea,TTCombo,TTArea,ErrorSummary,WarningSummary]=...
SapModel.DesignConcrete.GetSummaryResultsBeam(Name,NumberItems,FrameName,Location,TopCombo,TopArea,BotCombo,BotArea,VmajorCombo,VmajorArea,TLCombo,TLArea,TTCombo,TTArea,ErrorSummary,WarningSummary,0);
SegmentLength=zeros(1,NumberItems-1);
AvgTopArea=zeros(1,NumberItems-1);
AvgBotArea=zeros(1,NumberItems-1);
AvgVmajorArea=zeros(1,NumberItems-1);
AvgTLArea=zeros(1,NumberItems-1);
AvgTTArea=zeros(1,NumberItems-1);
for i=1:(NumberItems-1)
    SegmentLength(i)=Location(i+1)-Location(i);
    AvgTopArea(i)=(TopArea(i+1)+TopArea(i))/2;
    AvgBotArea(i)=(BotArea(i+1)+BotArea(i))/2;
    AvgVmajorArea(i)=(VmajorArea(i+1)+VmajorArea(i))/2;
    AvgTLArea(i)=(TLArea(i+1)+TLArea(i))/2;
    AvgTTArea(i)=(TTArea(i+1)+TTArea(i))/2;
end
TopAreaTotal=sum(SegmentLength.*AvgTopArea);
BotAreaTotal=sum(SegmentLength.*AvgBotArea);
TLAreaTotal=sum(SegmentLength.*AvgTLArea);
VmajorAreaTotal=sum(SegmentLength.*AvgVmajorArea)*Depth;
TTAreaTotal=sum(SegmentLength.*AvgTTArea)*Depth;

MainSteelBm=TopAreaTotal+BotAreaTotal+TLAreaTotal;
SecondarySteelBm=VmajorAreaTotal+TTAreaTotal;

TotalLength=sum(SegmentLength);
VolumeBm=TotalLength*Depth*Width;
switch GradeBm
    case 'M25'
        ConcUnitCost=7943;
    case 'M30'
        ConcUnitCost=8071;
    case 'M35'
        ConcUnitCost=8199;
    case 'M40'
        ConcUnitCost=8327;
end
%% Calculate member height above ground level
HeightBm=MemHeight(Name);
ConcUnitCostIncr=(HeightBm-4000-6000)/3000*202;
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
SteelUnitCostIncr=(HeightBm-4000-6000)/3000*.445;
if SteelUnitCostIncr>0
MainSteelUnitCost=MainSteelUnitCost+SteelUnitCostIncr;
SecondarySteelUnitCost=SecondarySteelUnitCost+SteelUnitCostIncr;
end
MainSteelCost=MainSteelBm*MainSteelUnitCost*7850/10^9;
SecondarySteelCost=SecondarySteelBm*SecondarySteelUnitCost*7850/10^9;
ConcreteCost=VolumeBm*ConcUnitCost/10^9;

BeamCost=MainSteelCost+SecondarySteelCost+ConcreteCost;
end
% for j=1:3
% BeamTop(k,j)=TopArea(j);
% BeamBot(k,j)=BotArea(j);
% BeamShearMajor(k,j)=VmajorArea(j);
% TorsionLong(k,j)=TLArea(j);
% TorsionShear(k,j)=TTArea(j);
% end
% k=k+1;
% end
% k=1;
% 
% end

