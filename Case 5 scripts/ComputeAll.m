function [TotalCost,c,ceq] = ComputeAll(x)
%Function to calculate cost and constraints based on linear elastic
%analysis
global SapModel 

%% unlock the model
ret=SapModel.SetModelIsLocked(false);
%% Reset load combinations for wall design

       SFEQ=1.2;
       SapModel.RespCombo.SetCaseList('DCON3',0,'EQ X',SFEQ); 
       SFEQ=-1.2;
       SapModel.RespCombo.SetCaseList('DCON4',0,'EQ X',SFEQ); 
       SFEQ=1.5;
       SapModel.RespCombo.SetCaseList('DCON7',0,'EQ X',SFEQ); 
       SFEQ=-1.5;
       SapModel.RespCombo.SetCaseList('DCON8',0,'EQ X',SFEQ);      
       SFEQ=1.5;
       SapModel.RespCombo.SetCaseList('DCON11',0,'EQ X',SFEQ); 
       SFEQ=-1.5;
       SapModel.RespCombo.SetCaseList('DCON12',0,'EQ X',SFEQ);  
       SFEQ=1.2;
       SapModel.RespCombo.SetCaseList('DCON5',0,'EQ Y',SFEQ); 
       SFEQ=-1.2;
       SapModel.RespCombo.SetCaseList('DCON6',0,'EQ Y',SFEQ); 
       SFEQ=1.5;
       SapModel.RespCombo.SetCaseList('DCON9',0,'EQ Y',SFEQ); 
       SFEQ=-1.5;
       SapModel.RespCombo.SetCaseList('DCON10',0,'EQ Y',SFEQ);      
       SFEQ=1.5;
       SapModel.RespCombo.SetCaseList('DCON13',0,'EQ Y',SFEQ); 
       SFEQ=-1.5;
       SapModel.RespCombo.SetCaseList('DCON14',0,'EQ Y',SFEQ);  

%% Assign sections to all the elements
beamcolsectionassignment1;


%% set load case to run
ret=SapModel.Analyze.SetRunCaseFlag(' ',true,true);
ret=SapModel.Analyze.SetRunCaseFlag('Modal',false);
ret=SapModel.Analyze.SetRunCaseFlag('Push Gravity',false);
ret=SapModel.Analyze.SetRunCaseFlag('Push X',false);
ret=SapModel.Analyze.SetRunCaseFlag('Push Y',false);
%% run advanced solver,0=Standard,1=Advanced
SolverType=1;
Force32BitSolver=false();
SapModel.Analyze.SetSolverOption(SolverType,Force32BitSolver);
%% run model (this will create the analysis model)
SapModel.Analyze.RunAnalysis();
%% Select code for design and start the design
SapModel.DesignConcrete.SetCode('Indian IS 456-2000');
SapModel.SelectObj.Group('Walls',false);
SapModel.DesignConcrete.StartDesign;
%% Find the number of members which have failed the design check
NumberItems=0;n1=0;n2=0;MyName=cellstr(' ');
[ret,NumberItems,NoOfFailedWalls,n2,MyName]=SapModel.DesignConcrete.VerifyPassed(NumberItems,n1,n2,MyName);
ceq=[];


%% Get list of names in the group 'Walls'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Walls',NumberItems,ObjectType,ObjectName);
%% Calculate Cost for all the walls
TotalWlCost=0;
WallConcrete=0;
WallMain=0;
WallSecondary=0;
for i=1:size(ObjectName,1)
Name=ObjectName{i};
[A,B,C,D]=WlCost(Name);
TotalWlCost=TotalWlCost+A;
WallConcrete=WallConcrete+B;
WallMain=WallMain+C;
WallSecondary=WallSecondary+D;
end
WallConcrete
WallMain
WallSecondary
%% Delete wall design results
SapModel.DesignConcrete.DeleteResults;

   %clear all case and combo output selections
      ret = SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput;

   %set case and combo output selections
      ret = SapModel.Results.Setup.SetCaseSelectedForOutput('EQ X');
Name='WallSupports';
NumberResults=0;
Obj=cellstr(' ');
Elm=cellstr(' ');
LoadCase=cellstr(' ');
StepType=cellstr(' ');
StepNum=zeros(2,1,'double');
StepNum(1)=0;
F1=zeros(2,1,'double');
F1(1)=0;
F2=zeros(2,1,'double');
F2(1)=0;
F3=zeros(2,1,'double');
F3(1)=0;
M1=zeros(2,1,'double');
M1(1)=0;
M2=zeros(2,1,'double');
M2(1)=0;
M3=zeros(2,1,'double');
M3(1)=0;
[ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2]=SapModel.Results.JointReact(Name,2,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2,F3,M1,M2,M3);
SumWallReactX=abs(sum(F1));

%% Get total base shear in X 
NumberResults=0;
LoadCase=cellstr(' ');
StepType=cellstr(' ');
StepNum=zeros(2,1,'double');
StepNum(1)=0;
Fx=zeros(2,1,'double');
Fx(1)=0;
Fy=zeros(2,1,'double');
Fy(1)=0;
Fz=zeros(2,1,'double');
Fz(1)=0;
Mx=zeros(2,1,'double');
Mx(1)=0;
My=zeros(2,1,'double');
My(1)=0;
Mz=zeros(2,1,'double');
Mz(1)=0;
% gx=zeros(2,1,'double');
gx=0;
% gy=zeros(2,1,'double');
gy=0;
% gz=zeros(2,1,'double');
gz=0;
[ret,NumberResults,LoadCase,StepType,StepNum,Fx,Fy,Fz,Mx,My,Mz]=SapModel.Results.BaseReact(NumberResults,LoadCase,StepType,StepNum,Fx,Fy,Fz,Mx,My,Mz,gx,gy,gz);
TotalReactX=abs(Fx);
percentFrameX=(TotalReactX-SumWallReactX)/TotalReactX*100


   %clear all case and combo output selections
      ret = SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput;

   %set case and combo output selections
      ret = SapModel.Results.Setup.SetCaseSelectedForOutput('EQ Y');
Name='WallSupports';
NumberResults=0;
Obj=cellstr(' ');
Elm=cellstr(' ');
LoadCase=cellstr(' ');
StepType=cellstr(' ');
StepNum=zeros(2,1,'double');
StepNum(1)=0;
F1=zeros(2,1,'double');
F1(1)=0;
F2=zeros(2,1,'double');
F2(1)=0;
F3=zeros(2,1,'double');
F3(1)=0;
M1=zeros(2,1,'double');
M1(1)=0;
M2=zeros(2,1,'double');
M2(1)=0;
M3=zeros(2,1,'double');
M3(1)=0;
[ret,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2]=SapModel.Results.JointReact(Name,2,NumberResults,Obj,Elm,LoadCase,StepType,StepNum,F1,F2,F3,M1,M2,M3);
SumWallReactY=abs(sum(F2));


%% Get total base shear in Y 
NumberResults=0;
LoadCase=cellstr(' ');
StepType=cellstr(' ');
StepNum=zeros(2,1,'double');
StepNum(1)=0;
Fx=zeros(2,1,'double');
Fx(1)=0;
Fy=zeros(2,1,'double');
Fy(1)=0;
Fz=zeros(2,1,'double');
Fz(1)=0;
Mx=zeros(2,1,'double');
Mx(1)=0;
My=zeros(2,1,'double');
My(1)=0;
Mz=zeros(2,1,'double');
Mz(1)=0;
% gx=zeros(2,1,'double');
gx=0;
% gy=zeros(2,1,'double');
gy=0;
% gz=zeros(2,1,'double');
gz=0;
[ret,NumberResults,LoadCase,StepType,StepNum,Fx,Fy,Fz,Mx,My,Mz]=SapModel.Results.BaseReact(NumberResults,LoadCase,StepType,StepNum,Fx,Fy,Fz,Mx,My,Mz,gx,gy,gz);
TotalReactY=abs(Fy);
percentFrameY=(TotalReactY-SumWallReactY)/TotalReactY*100
% PerfIncrX=1+(0.5/10)*(x(numel(x)-1)-1);
   if percentFrameX<25
       SFx=25/percentFrameX;
       
       SFEQ=SFx*1.2;
       SapModel.RespCombo.SetCaseList('DCON3',0,'EQ X',SFEQ); 
       SFEQ=SFx*-1.2;
       SapModel.RespCombo.SetCaseList('DCON4',0,'EQ X',SFEQ); 
       SFEQ=SFx*1.5;
       SapModel.RespCombo.SetCaseList('DCON7',0,'EQ X',SFEQ); 
       SFEQ=SFx*-1.5;
       SapModel.RespCombo.SetCaseList('DCON8',0,'EQ X',SFEQ);      
       SFEQ=SFx*1.5;
       SapModel.RespCombo.SetCaseList('DCON11',0,'EQ X',SFEQ); 
       SFEQ=SFx*-1.5;
       SapModel.RespCombo.SetCaseList('DCON12',0,'EQ X',SFEQ);         
       
% %        NumberItems=0;CType=zeros(2,1,'double');CType(1)=0;CName=cellstr(' ');SF=zeros(2,1,'double');SF(1)=0;
% %        eval(['[ret,NumberItems,CType,CName,SF]=SapModel.RespCombo.GetCaseList(''DCON' num2str(i) '''' ',NumberItems,CType,CName,SF)']) 
% %        SFEQ=SFx*SF(NumberItems,1);

%        SFEQ=SFx*1.2*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON3',0,'EQ X',SFEQ); 
%        SFEQ=SFx*-1.2*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON4',0,'EQ X',SFEQ); 
%        SFEQ=SFx*1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON7',0,'EQ X',SFEQ); 
%        SFEQ=SFx*-1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON8',0,'EQ X',SFEQ);      
%        SFEQ=SFx*1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON11',0,'EQ X',SFEQ); 
%        SFEQ=SFx*-1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON12',0,'EQ X',SFEQ);        
%    else
%        SFEQ=1.2*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON3',0,'EQ X',SFEQ); 
%        SFEQ=-1.2*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON4',0,'EQ X',SFEQ); 
%        SFEQ=1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON7',0,'EQ X',SFEQ); 
%        SFEQ=-1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON8',0,'EQ X',SFEQ);      
%        SFEQ=1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON11',0,'EQ X',SFEQ); 
%        SFEQ=-1.5*PerfIncrX;
%        SapModel.RespCombo.SetCaseList('DCON12',0,'EQ X',SFEQ);  
   end
%    PerfIncrY=1+(0.5/10)*(x(numel(x))-1);

   if percentFrameY<25
       SFy=25/percentFrameY;
%        for i=3:14
%        eval(['SapModel.RespCombo.SetCaseList(''DCON' num2str(i) '''' ',0,''EQ Y'',SFy);']) 
%        end

       SFEQ=SFy*1.2;
       SapModel.RespCombo.SetCaseList('DCON5',0,'EQ Y',SFEQ); 
       SFEQ=SFy*-1.2;
       SapModel.RespCombo.SetCaseList('DCON6',0,'EQ Y',SFEQ); 
       SFEQ=SFy*1.5;
       SapModel.RespCombo.SetCaseList('DCON9',0,'EQ Y',SFEQ); 
       SFEQ=SFy*-1.5;
       SapModel.RespCombo.SetCaseList('DCON10',0,'EQ Y',SFEQ);      
       SFEQ=SFy*1.5;
       SapModel.RespCombo.SetCaseList('DCON13',0,'EQ Y',SFEQ); 
       SFEQ=SFy*-1.5;
       SapModel.RespCombo.SetCaseList('DCON14',0,'EQ Y',SFEQ); 

%        SFEQ=SFy*1.2*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON5',0,'EQ Y',SFEQ); 
%        SFEQ=SFy*-1.2*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON6',0,'EQ Y',SFEQ); 
%        SFEQ=SFy*1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON9',0,'EQ Y',SFEQ); 
%        SFEQ=SFy*-1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON10',0,'EQ Y',SFEQ);      
%        SFEQ=SFy*1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON13',0,'EQ Y',SFEQ); 
%        SFEQ=SFy*-1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON14',0,'EQ Y',SFEQ);  
%    else
%        SFEQ=1.2*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON5',0,'EQ Y',SFEQ); 
%        SFEQ=-1.2*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON6',0,'EQ Y',SFEQ); 
%        SFEQ=1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON9',0,'EQ Y',SFEQ); 
%        SFEQ=-1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON10',0,'EQ Y',SFEQ);      
%        SFEQ=1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON13',0,'EQ Y',SFEQ); 
%        SFEQ=-1.5*PerfIncrY;
%        SapModel.RespCombo.SetCaseList('DCON14',0,'EQ Y',SFEQ); 
   end

SapModel.SelectObj.Group('Columns',false);
SapModel.SelectObj.Group('Beams',false);
% SapModel.SelectObj.Group('OtherColumns',false);
SapModel.DesignConcrete.StartDesign;

%% Find the number of members which have failed the design check
NumberItems=0;n1=0;n2=0;MyName=cellstr(' ');
[ret,NumberItems,NoOfFailedFrame,n2,MyName]=SapModel.DesignConcrete.VerifyPassed(NumberItems,n1,n2,MyName);

NoOfFailed=NoOfFailedWalls+NoOfFailedFrame;

SapModel.SelectObj.Group('OtherColumns',false);
SapModel.DesignConcrete.StartDesign;

%% Get list of names in the group 'Beams'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Beams',NumberItems,ObjectType,ObjectName);
%% Calculate Cost for all the beams
TotalBmCost=0;
BeamConcrete=0;
BeamSteelMain=0;
BeamSteelSecondary=0;
for i=1:size(ObjectName,1)
Name=ObjectName{i};
[A,B,C,D]=BmCost(Name);
TotalBmCost=TotalBmCost+A;
BeamConcrete=BeamConcrete+B;
BeamSteelMain=BeamSteelMain+C;
BeamSteelSecondary=BeamSteelSecondary+D;
end
BeamConcrete,
BeamSteelMain,
BeamSteelSecondary,
TotalBmCost,
%% Get list of names in the group 'Columns'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Columns',NumberItems,ObjectType,ObjectName);
%% Calculate Cost for all the columns
TotalColCost=0;
ColConcrete=0;
ColSteelMain=0;
ColSteelSecondary=0;
for i=1:size(ObjectName,1)
Name=ObjectName{i};
[A,B,C,D]=ColCost(Name);
TotalColCost=TotalColCost+A;
ColConcrete=ColConcrete+B;
ColSteelMain=ColSteelMain+C;
ColSteelSecondary=ColSteelSecondary+D;
end
ColConcrete
ColSteelMain
ColSteelSecondary
% %% Get list of names in the group 'OtherColumns'
% NumberItems=0;
% ObjectType=zeros(2,1,'int32');
% ObjectType(1)=0;
% ObjectName=cellstr(' ');
% [ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('OtherColumns',NumberItems,ObjectType,ObjectName);
% %% Calculate Cost for all the columns
% TotalColCostOthers=0;
% ColConcreteOthers=0;
% ColSteelMainOthers=0;
% ColSteelSecondaryOthers=0;
% for i=1:size(ObjectName,1)
% Name=ObjectName{i};
% % TotalColCostOthers=TotalColCostOthers+ColCost(Name);
% [A,B,C,D]=ColCost(Name);
% TotalColCostOthers=TotalColCostOthers+A;
% ColConcreteOthers=ColConcreteOthers+B;
% ColSteelMainOthers=ColSteelMainOthers+C;
% ColSteelSecondaryOthers=ColSteelSecondaryOthers+D;
% end
% ColConcreteOthers
% ColSteelMainOthers
% ColSteelSecondaryOthers

% TotalBmCost, TotalColCost,TotalWlCost
TotalCost=TotalBmCost+TotalColCost+TotalWlCost;

%% Get story drifts for EQX and EQY

%% Get list of names in the group 'ColumnLineDrift'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberOfStories,ObjectType,ObjectName]=SapModel.Group.GetAssignments('ColumnLineDrift',NumberItems,ObjectType,ObjectName);
   %clear all case and combo output selections
      ret = SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput;

   %set case and combo output selections
      ret = SapModel.Results.Setup.SetCaseSelectedForOutput('EQ X');
      DriftX=zeros(1,NumberOfStories,'double');
      ConstDriftX=zeros(NumberOfStories,1,'double');
for i=1:NumberOfStories
Name=['DriftX-' num2str(i)];
NumberResults=0;
GD=cellstr(' ');
LoadCase=cellstr(' ');
StepType=cellstr(' ');
StepNum=zeros(2,1,'double');
StepNum(1)=0;
DType=cellstr(' ');
Value=zeros(2,1,'double');
Value(1)=0;
[ret,NumberResults,GD,LoadCase,StepType,StepNum,DType,Value]=SapModel.Results.GeneralizedDispl(Name,NumberResults,GD,LoadCase,StepType,StepNum,DType,Value);
DriftX(i)=abs(Value(1));
ConstDriftX(i,1)=DriftX(i)-.004;
end
   %clear all case and combo output selections
      ret = SapModel.Results.Setup.DeselectAllCasesAndCombosForOutput;
   %set case and combo output selections
      ret = SapModel.Results.Setup.SetCaseSelectedForOutput('EQ Y');
      DriftY=zeros(1,NumberOfStories,'double');
      ConstDriftY=zeros(NumberOfStories,1,'double');
for i=1:NumberOfStories
Name=['DriftY-' num2str(i)];
NumberResults=0;
GD=cellstr(' ');
LoadCase=cellstr(' ');
StepType=cellstr(' ');
StepNum=zeros(2,1,'double');
StepNum(1)=0;
DType=cellstr(' ');
Value=zeros(2,1,'double');
Value(1)=0;
[ret,NumberResults,GD,LoadCase,StepType,StepNum,DType,Value]=SapModel.Results.GeneralizedDispl(Name,NumberResults,GD,LoadCase,StepType,StepNum,DType,Value);
DriftY(i)=abs(Value(1));
ConstDriftY(i,1)=DriftY(i)-.004;
end

c=[NoOfFailed;ConstDriftX;ConstDriftY];

DriftX',DriftY'


%% Constraint for column-beam capacity ratios

%% Get list of names in the group 'Columns'
% NumberItems=0;
% ObjectType=zeros(2,1,'int32');
% ObjectType(1)=0;
% ObjectName=cellstr(' ');
% [ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Columns',NumberItems,ObjectType,ObjectName);
% %% Calculate Cost for all the columns
% % TotalColCost=0;
% CBRatio=zeros(size(ObjectName,1),1,'double');
% for i=1:size(ObjectName,1)
% Name=ObjectName{i};
% NumberItems=0;
% FrameName=cellstr(' ');
% LCJSRatioMajor=cellstr(' ');
% JSRatioMajor=zeros(2,1,'double');
% JSRatioMajor(1)=0.0;
% LCJSRatioMinor=cellstr(' ');
% JSRatioMinor=zeros(2,1,'double');
% JSRatioMinor(1)=0.0;
% LCBCCRatioMajor=cellstr(' ');
% BCCRatioMajor=zeros(2,1,'double');
% BCCRatioMajor(1)=0.0;
% LCBCCRatioMinor=cellstr(' ');
% BCCRatioMinor=zeros(2,1,'double');
% BCCRatioMinor(1)=0.0;
% ErrorSummary=cellstr(' ');
% WarningSummary=cellstr(' ');
% [ret,NumberItems,FrameName,LCJSRatioMajor,JSRatioMajor,LCJSRatioMinor,JSRatioMinor,LCBCCRatioMajor,BCCRatioMajor,...
% LCBCCRatioMinor,BCCRatioMinor,ErrorSummary,WarningSummary]=SapModel.DesignConcrete.GetSummaryResultsJoint...
% (Name,NumberItems,FrameName,LCJSRatioMajor,JSRatioMajor,LCJSRatioMinor,JSRatioMinor,LCBCCRatioMajor,BCCRatioMajor,...
% LCBCCRatioMinor,BCCRatioMinor,ErrorSummary,WarningSummary);
% 
% % CBRatioMajor(k,1)=BCCRatioMajor(1)
% % CBRatioMinor(k,1)=BCCRatioMinor(1)
% 
% CBRatio(i,1)=min(BCCRatioMajor(1),BCCRatioMinor(1));
% 
% end
% CBRatioConst=-CBRatio+1.4;
% c=[NoOfFailed;ConstDriftX;ConstDriftY;CBRatioConst];

% end

