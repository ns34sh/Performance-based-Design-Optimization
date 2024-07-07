function PerfPointConstraint=PerfPointScript

global SapModel dataBaseIndex
%% unlock the model
ret=SapModel.SetModelIsLocked(false);
%% set load case to run
ret=SapModel.Analyze.SetRunCaseFlag(' ',false,true);
% ret=SapModel.Analyze.SetRunCaseFlag('Modal',false);
ret=SapModel.Analyze.SetRunCaseFlag('Push Gravity',true);
ret=SapModel.Analyze.SetRunCaseFlag('Push X',true);
ret=SapModel.Analyze.SetRunCaseFlag('Push Y',true);
%% run advanced solver,0=Standard,1=Advanced
SolverType=2;
Force32BitSolver=false();
SapModel.Analyze.SetSolverOption(SolverType,Force32BitSolver);
%% run model (this will create the analysis model)
SapModel.Analyze.RunAnalysis();
%% Get target displacement from the database file
eval(['conn=database(''PerformancePoint' num2str(dataBaseIndex) ''' ,'''','''');']);
% conn=database('Hinge state' ,'','');
setdbprefs('DataReturnFormat','cellarray');
PPtFound=fetch(conn,'select PPtFound from [Pushover Results - FEMA440 Equivalent Linearization]');
% PONamedSet=fetch(conn,'select PONamedSet from [Pushover Results - FEMA440 Equivalent Linearization]');
OutputCase=fetch(conn,'select OutputCase from [Pushover Results - Force Displacement]');

setdbprefs('DataReturnFormat','numeric');
Displ=fetch(conn,'select Displ from [Pushover Results - Force Displacement]');

PPtDispl=fetch(conn,'select PPtDispl from [Pushover Results - FEMA440 Equivalent Linearization]');
AtoB=fetch(conn,'select AtoB from [Pushover Results - Force Displacement]');
AtoIO=fetch(conn,'select AtoIO from [Pushover Results - Force Displacement]');
BtoIO=AtoIO-AtoB;
IOtoLS=fetch(conn,'select IOtoLS from [Pushover Results - Force Displacement]');
LStoCP=fetch(conn,'select LStoCP from [Pushover Results - Force Displacement]');
BeyondCP=fetch(conn,'select BeyondCP from [Pushover Results - Force Displacement]');

% Displ=Displ*1000;
close(conn);

    NumRecordsForPushX=0;
    NumRecordsForPushY=0;
for i=1:numel(OutputCase)
    if strcmp(OutputCase(i),'Push X')
    NumRecordsForPushX=NumRecordsForPushX+1;
    end
    if strcmp(OutputCase(i),'Push Y')
    NumRecordsForPushY=NumRecordsForPushY+1;
    end
end

PPtIndex=zeros(1,numel(PPtDispl),'double');
for i=1:numel(PPtFound),    
    if strcmp(PPtFound(i),'Yes')||(strcmp(PPtFound(i),'No'))
    PPtIndex(i)=0;
    else
    PPtIndex(i)=1;
    end
end
indexPPtDispl=find(PPtIndex==0);


PPtObtained=zeros(1,numel(indexPPtDispl),'double');
for i=1:numel(indexPPtDispl)
    if strcmp(PPtFound(indexPPtDispl(i)),'Yes')
    PPtObtained(i)=0;
    else
    PPtObtained(i)=1;
    end
end

% NumRecordsXMCEorDBE=NumRecordsForPushX/2;
% NumRecordsYMCEorDBE=NumRecordsForPushY/2;
DisplX=zeros(1,NumRecordsForPushX,'double');
for i=1:NumRecordsForPushX
DisplX(i)=Displ(i);
end
DisplY=zeros(1,NumRecordsForPushY,'double');
for i=(NumRecordsForPushX+1):(NumRecordsForPushY+NumRecordsForPushX)
DisplY(i-NumRecordsForPushX)=Displ(i);
end

if strcmp(PPtFound(indexPPtDispl(1)),'Yes')
PPtDisplXDBE=PPtDispl(indexPPtDispl(1));
else
PPtDisplXDBE=DisplX(NumRecordsForPushX);  
end

if strcmp(PPtFound(indexPPtDispl(2)),'Yes')
PPtDisplXMCE=PPtDispl(indexPPtDispl(2));
else
PPtDisplXMCE=DisplX(NumRecordsForPushX);
end

if strcmp(PPtFound(indexPPtDispl(3)),'Yes')
PPtDisplYDBE=PPtDispl(indexPPtDispl(3));
else
PPtDisplYDBE=DisplY(NumRecordsForPushY);  
end

if strcmp(PPtFound(indexPPtDispl(3)),'Yes')
PPtDisplYMCE=PPtDispl(indexPPtDispl(4));
else
PPtDisplYMCE=DisplY(NumRecordsForPushY);  
end

AtoBX=zeros(1,NumRecordsForPushX,'double');
for i=1:NumRecordsForPushX
AtoBX(i)=AtoB(i);
end
AtoBY=zeros(1,NumRecordsForPushY,'double');
for i=(NumRecordsForPushX+1):(NumRecordsForPushY+NumRecordsForPushX)
AtoBY(i-NumRecordsForPushX)=AtoB(i);
end

BtoIOX=zeros(1,NumRecordsForPushX,'double');
for i=1:NumRecordsForPushX
BtoIOX(i)=BtoIO(i);
end
BtoIOY=zeros(1,NumRecordsForPushY,'double');
for i=(NumRecordsForPushX+1):(NumRecordsForPushY+NumRecordsForPushX)
BtoIOY(i-NumRecordsForPushX)=BtoIO(i);
end

IOtoLSX=zeros(1,NumRecordsForPushX,'double');
for i=1:NumRecordsForPushX
IOtoLSX(i)=IOtoLS(i);
end
IOtoLSY=zeros(1,NumRecordsForPushY,'double');
for i=(NumRecordsForPushX+1):(NumRecordsForPushY+NumRecordsForPushX)
IOtoLSY(i-NumRecordsForPushX)=IOtoLS(i);
end

LStoCPX=zeros(1,NumRecordsForPushX,'double');
for i=1:NumRecordsForPushX
LStoCPX(i)=LStoCP(i);
end
LStoCPY=zeros(1,NumRecordsForPushY,'double');
for i=(NumRecordsForPushX+1):(NumRecordsForPushY+NumRecordsForPushX)
LStoCPY(i-NumRecordsForPushX)=LStoCP(i);
end

BeyondCPX=zeros(1,NumRecordsForPushX,'double');
for i=1:NumRecordsForPushX
BeyondCPX(i)=BeyondCP(i);
end
BeyondCPY=zeros(1,NumRecordsForPushY,'double');
for i=(NumRecordsForPushX+1):(NumRecordsForPushY+NumRecordsForPushX)
BeyondCPY(i-NumRecordsForPushX)=BeyondCP(i);
end

StepNumXDBE=0;
for i=1:numel(DisplX)
if PPtDisplXDBE>DisplX(i)
    StepNumXDBE=StepNumXDBE+1;
end
end

StepNumXMCE=0;
for i=1:numel(DisplX)
if PPtDisplXMCE>DisplX(i)
    StepNumXMCE=StepNumXMCE+1;
end
end

StepNumYDBE=0;
for i=1:numel(DisplY)
if PPtDisplYDBE>DisplY(i)
    StepNumYDBE=StepNumYDBE+1;
end
end

StepNumYMCE=0;
for i=1:numel(DisplY)
if PPtDisplYMCE>DisplY(i)
    StepNumYMCE=StepNumYMCE+1;
end
end

% AtoIOatPPtXDBE=AtoIOX(StepNumXDBE+1);
% AtoIOatPPtXMCE=AtoIOX(StepNumXMCE+1);
% AtoIOatPPtYDBE=AtoIOY(StepNumYDBE+1);
% AtoIOatPPtYMCE=AtoIOY(StepNumYMCE+1);

BtoIOatPPtXDBE=BtoIOX(StepNumXDBE+1);
BtoIOatPPtXMCE=BtoIOX(StepNumXMCE+1);
BtoIOatPPtYDBE=BtoIOY(StepNumYDBE+1);
BtoIOatPPtYMCE=BtoIOY(StepNumYMCE+1);

IOtoLSatPPtXDBE=IOtoLSX(StepNumXDBE+1);
IOtoLSatPPtXMCE=IOtoLSX(StepNumXMCE+1);
IOtoLSatPPtYDBE=IOtoLSY(StepNumYDBE+1);
IOtoLSatPPtYMCE=IOtoLSY(StepNumYMCE+1);

LStoCPatPPtXDBE=LStoCPX(StepNumXDBE+1);
LStoCPatPPtXMCE=LStoCPX(StepNumXMCE+1);
LStoCPatPPtYDBE=LStoCPY(StepNumYDBE+1);
LStoCPatPPtYMCE=LStoCPY(StepNumYMCE+1);

BeyondCPatPPtXDBE=BeyondCPX(StepNumXDBE+1);
BeyondCPatPPtXMCE=BeyondCPX(StepNumXMCE+1);
BeyondCPatPPtYDBE=BeyondCPY(StepNumYDBE+1);
BeyondCPatPPtYMCE=BeyondCPY(StepNumYMCE+1);
%% Desired state of building at MCE and DBE
BuildingStateDBE='Operational';
BuildingStateMCE='Operational';

switch BuildingStateDBE
    case 'Operational'
    PerfPointConstraintDBE=[BtoIOatPPtXDBE+IOtoLSatPPtXDBE+LStoCPatPPtXDBE+BeyondCPatPPtXDBE;BtoIOatPPtYDBE+IOtoLSatPPtYDBE+LStoCPatPPtYDBE+BeyondCPatPPtYDBE];
    
    case 'IO'
    PerfPointConstraintDBE=[IOtoLSatPPtXDBE+LStoCPatPPtXDBE+BeyondCPatPPtXDBE;IOtoLSatPPtYDBE+LStoCPatPPtYDBE+BeyondCPatPPtYDBE];
    case 'LS'
    PerfPointConstraintDBE=[LStoCPatPPtXDBE+BeyondCPatPPtXDBE;LStoCPatPPtYDBE+BeyondCPatPPtYDBE];
    case 'CP'
    PerfPointConstraintDBE=[BeyondCPatPPtXDBE;BeyondCPatPPtYDBE];
end
switch BuildingStateMCE
    case 'Operational'
    PerfPointConstraintMCE=[BtoIOatPPtXMCE+IOtoLSatPPtXMCE+LStoCPatPPtXMCE+BeyondCPatPPtXMCE;BtoIOatPPtYMCE+IOtoLSatPPtYMCE+LStoCPatPPtYMCE+BeyondCPatPPtYMCE];

    case 'IO'
    PerfPointConstraintMCE=[IOtoLSatPPtXMCE+LStoCPatPPtXMCE+BeyondCPatPPtXMCE;IOtoLSatPPtYMCE+LStoCPatPPtYMCE+BeyondCPatPPtYMCE];
    case 'LS'
    PerfPointConstraintMCE=[LStoCPatPPtXMCE+BeyondCPatPPtXMCE;LStoCPatPPtYMCE+BeyondCPatPPtYMCE];
    case 'CP'
    PerfPointConstraintMCE=[BeyondCPatPPtXMCE;BeyondCPatPPtYMCE];
end  
    PerfPointConstraint=[PPtObtained';PerfPointConstraintDBE;PerfPointConstraintMCE];

end