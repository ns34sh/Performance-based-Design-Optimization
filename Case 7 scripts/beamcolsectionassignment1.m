for i=1:11
%     if ~exist(['C' num2str(i)],'var');
    eval(['global' ' C' num2str(i)]);
%     end
end
for i=1:8
%     if ~exist(['B' num2str(i)],'var');
    eval(['global' ' B' num2str(i)]);
%     end
end
for i=1:24
%     if ~exist(['W' num2str(i)],'var');
    eval(['global' ' W' num2str(i)]);
%     end
end
%% Get list of names in the group 'Columns'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Columns',NumberItems,ObjectType,ObjectName);
%% Create a list of section property for all columns to be optimized
for i=1:NumberItems
PropName='';
SAuto='';
eval(['[ret,PropListCol' num2str(i) ',SAuto]=SapModel.FrameObj.GetSection(char(ObjectName(i)),PropName,SAuto);']);
end
%% Create an array of property list from individual property variables
PropListCol=cellstr(' ');
for i=1:NumberItems
    PropListCol(i)=cellstr(eval(['PropListCol' num2str(i)]));
end
%% Count number of section properties(i.e. the number of column variables to be used in optimization)
noOfColProp=size(unique(PropListCol),2);


%% Get list of names in the group 'Beams'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Beams',NumberItems,ObjectType,ObjectName);
%% Create a list of section property for all beams to be optimized
for i=1:NumberItems
PropName='';
SAuto='';
eval(['[ret,PropListBm' num2str(i) ',SAuto]=SapModel.FrameObj.GetSection(char(ObjectName(i)),PropName,SAuto);']);
end
%% Create an array of property list from individual property variables
PropListBm=cellstr(' ');
for i=1:NumberItems
    PropListBm(i)=cellstr(eval(['PropListBm' num2str(i)]));
end
%% Count number of section properties(i.e. the number of beam variables to be used in optimization)
noOfBeamProp=size(unique(PropListBm),2);


%% Get list of names in the group 'Walls'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('Walls',NumberItems,ObjectType,ObjectName);
%% Create a list of section property for all walls to be optimized
for i=1:NumberItems
PropName='';
SAuto='';
eval(['[ret,PropListWl' num2str(i) ',SAuto]=SapModel.FrameObj.GetSection(char(ObjectName(i)),PropName,SAuto);']);
end
%% Create an array of property list from individual property variables
PropListWl=cellstr(' ');
for i=1:NumberItems
    PropListWl(i)=cellstr(eval(['PropListWl' num2str(i)]));
end
%% Count number of section properties(i.e. the number of wall variables to be used in optimization)
noOfWlProp=size(unique(PropListWl),2);

% %% Get list of names in the group 'BE'
% NumberItems=0;
% ObjectType=zeros(2,1,'int32');
% ObjectType(1)=0;
% ObjectName=cellstr(' ');
% [ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('BE',NumberItems,ObjectType,ObjectName);
% %% Create a list of section property for all boundary elements to be optimized
% for i=1:NumberItems
% PropName='';
% SAuto='';
% eval(['[ret,PropListBE' num2str(i) ',SAuto]=SapModel.FrameObj.GetSection(char(ObjectName(i)),PropName,SAuto);']);
% end
% %% Create an array of property list from individual property variables
% PropListBE=cellstr(' ');
% for i=1:NumberItems
%     PropListBE(i)=cellstr(eval(['PropListBE' num2str(i)]));
% end
% %% Count number of section properties(i.e. the number of boundary element variables to be used in optimization
% noOfBEProp=size(unique(PropListBE),2);


%% Get list of names in the group 'ColGradeChange'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('ColGradeChange',NumberItems,ObjectType,ObjectName);
% ColGradeNo=str2num(ObjectName{1});
PropName='';
SAuto='';
clear ColGradeProp
eval(['[ret,ColGradeProp,SAuto]=SapModel.FrameObj.GetSection(char(ObjectName),PropName,SAuto);']);
clear ColGradeNo
    if size(ColGradeProp,2)==8
    ColGradeNo(1)=ColGradeProp(8);
    ColGradeNo=str2double(ColGradeNo);
    else
    ColGradeNo(1)=ColGradeProp(8);
    ColGradeNo(2)=ColGradeProp(9);
    ColGradeNo=str2double(ColGradeNo);
    end
    
%% Get list of names in the group 'NoOfColLines'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('NoOfColLines',NumberItems,ObjectType,ObjectName);
NoOfColLines=NumberItems;

NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('NoOfColLines2',NumberItems,ObjectType,ObjectName);
NoOfColLines2=NumberItems;

%% assign sections to columns
for i=1:noOfColProp
% Grade=eval(['C' num2str(x(i)) '.Grade']);
if i<=ColGradeNo
Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+1)-1))];
else
% Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+1)-1)-5*(x(noOfColProp+noOfBeamProp+noOfWlProp+2)-1))];
% if strcmp(Grade,'M20')
%     Grade='M25';
% end
Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+2)-1))];
end
if i<=NoOfColLines
    Depth=eval(['C' num2str(x(i)) '.Depth']);
    Width=eval(['C' num2str(x(i)) '.Width']);
    numR3bars=int32(eval(['C' num2str(x(i)) '.no3dir']));
    numR2bars=int32(eval(['C' num2str(x(i)) '.no2dir']));
    num2dtie=int32(eval(['C' num2str(x(i)) '.no2tie']));
    num3dtie=int32(eval(['C' num2str(x(i)) '.no3tie']));
elseif (NoOfColLines<i)&&(i<=2*NoOfColLines)
    [Bdec,Ddec,noR3dec,noR2dec,no2ddec,no3ddec]=coldec(x(i));
    Depth=eval(['C' num2str(x(i-NoOfColLines)) '.Depth'])-Ddec;
    Width=eval(['C' num2str(x(i-NoOfColLines)) '.Width'])-Bdec;
    if Depth<300
        Depth=300;
    end
    if Width<300
        Width=300;
    end
    numR3bars=int32(eval(['C' num2str(x(i-NoOfColLines)) '.no3dir'])-noR3dec);
    numR2bars=int32(eval(['C' num2str(x(i-NoOfColLines)) '.no2dir'])-noR2dec);
    num2dtie=int32(eval(['C' num2str(x(i-NoOfColLines)) '.no2tie'])-no2ddec);
    num3dtie=int32(eval(['C' num2str(x(i-NoOfColLines)) '.no3tie'])-no3ddec);    
else
    PropColumn=['ConcCol' num2str(i-NoOfColLines2)];
    FileName='';GradeCol='';Depth=0;Width=0;Color=int32(0);Notes='';GUID='';
    [ret,FileName,GradeCol,Depth,Width]=SapModel.PropFrame.GetRectangle(PropColumn,FileName,GradeCol,Depth,Width,Color,Notes,GUID);
    [Bdec,Ddec,noR3dec,noR2dec,no2ddec,no3ddec]=coldec(x(i));
    Depth=Depth-Ddec;
    Width=Width-Bdec;
    if Depth<300
        Depth=300;
    end
    if Width<300;
        Width=300;
    end
    GradeLong='';GradeConf='';Pattern=int32(0);ConfineType=int32(0);Cover=0;NumberCBars=int32(0);NumberR3Bars=int32(0);NumberR2Bars=int32(0);
    RebarSize='';TieSize='';TieSpacing=0;Num2DTieBars=int32(0);Num3DTieBars=int32(0);
    [ret,GradeLong,GradeConf,Pattern,ConfineType,Cover,NumberCBars,numR3bars,numR2bars,RebarSize,TieSize,TieSpacing,num2dtie,num3dtie]=SapModel.PropFrame.GetRebarColumn(PropColumn,GradeLong,GradeConf,Pattern,ConfineType,Cover,NumberCBars,NumberR3Bars,NumberR2Bars,RebarSize,TieSize,TieSpacing,Num2DTieBars,Num3DTieBars,true);
    numR3bars=int32(numR3bars-noR3dec);
    numR2bars=int32(numR2bars-noR2dec);
    num2dtie=int32(num2dtie-no2ddec);
    num3dtie=int32(num3dtie-no3ddec);
end
% Grade=cellstr(Grade)
% Depth=eval(['C' num2str(x(i)) '.Depth']);
% Width=eval(['C' num2str(x(i)) '.Width']);
eval(['ret=SapModel.PropFrame.SetRectangle(''ConcCol' num2str(i) '''' ',Grade,Depth,Width);']);
% gradeLong=eval(['C' num2str(x(i)) '.GradeLong']);
gradeLong=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+5)-1))];
% gradeConf=eval(['C' num2str(x(i)) '.GradeConf']);
gradeConf=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+5)-1))];

% RebarSize=num2str(eval(['C' num2str(x(i)) '.barsize']));

eval(['ret=SapModel.PropFrame.SetRebarColumn(''ConcCol' num2str(i) '''' ',gradeLong,gradeConf' ',1,1,40,0,' 'numR3bars,numR2bars,''12'',''8'',150,num2dtie,num3dtie,true);']);
end


%% Get list of names in the group 'BmGradeChange'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('BmGradeChange',NumberItems,ObjectType,ObjectName);
% BmGradeNo=str2num(ObjectName{1});
PropName='';
SAuto='';
clear BmGradeProp
eval(['[ret,BmGradeProp,SAuto]=SapModel.FrameObj.GetSection(char(ObjectName),PropName,SAuto);']);
clear BmGradeNo
    if size(BmGradeProp,2)==7
    BmGradeNo(1)=BmGradeProp(7);
    BmGradeNo=str2double(BmGradeNo);
    else
    BmGradeNo(1)=BmGradeProp(7);
    BmGradeNo(2)=BmGradeProp(8);
    BmGradeNo=str2double(BmGradeNo);
    end

%% assign sections to beams
for i=1:noOfBeamProp
Depth=eval(['B' num2str(x(i+noOfColProp)) '.Depth']);
Width=eval(['B' num2str(x(i+noOfColProp)) '.Width']);
% Grade=eval(['B' num2str(x(i+noOfColProp)) '.Grade']);
if i<=BmGradeNo
Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+3)-1))];
else
Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+4)-1))];
end
eval(['ret=SapModel.PropFrame.SetRectangle(''ConcBm' num2str(i) '''' ',Grade,Depth,Width);']);
% Topright=eval(['B' num2str(x(i+noOfColProp)) '.TopRight']);
% Topleft=eval(['B' num2str(x(i+noOfColProp)) '.TopLeft']);
% Botright=eval(['B' num2str(x(i+noOfColProp)) '.BotRight']);
% Botleft=eval(['B' num2str(x(i+noOfColProp)) '.BotLeft']);
% gradeLong=eval(['B' num2str(x(i+noOfColProp)) '.GradeLong']);
gradeLong=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+5)-1))];
% gradeConf=eval(['B' num2str(x(i+noOfColProp)) '.GradeConf']);
gradeConf=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+5)-1))];

eval(['ret=SapModel.PropFrame.SetRebarBeam(''ConcBm' num2str(i) '''' ',gradeLong,gradeConf,30,30,0,0,0,0);']);
end
%% Get number of wall groups (i.e. wall properties) 
% groupNos=SapModel.GroupDef.Count;
% noOfWlProp=groupNos-3;

%% Get list of names in the group 'WlGradeChange'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('WlGradeChange',NumberItems,ObjectType,ObjectName);
% WlGradeNo=str2num(ObjectName{1});
PropName='';
SAuto='';
clear WlGradeProp
eval(['[ret,WlGradeProp,SAuto]=SapModel.FrameObj.GetSection(char(ObjectName),PropName,SAuto);']);
clear WlGradeNo
    if size(WlGradeProp,2)==5
    WlGradeNo(1)=WlGradeProp(5);
    WlGradeNo=str2double(WlGradeNo);
    else
    WlGradeNo(1)=WlGradeProp(5);
    WlGradeNo(2)=WlGradeProp(6);
    WlGradeNo=str2double(WlGradeNo);
    end
%% Get list of names in the group 'NoOfWlLines'
NumberItems=0;
ObjectType=zeros(2,1,'int32');
ObjectType(1)=0;
ObjectName=cellstr(' ');
[ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('NoOfWlLines',NumberItems,ObjectType,ObjectName);
NoOfWlLines=NumberItems;

%% assign sections to walls
for i=1:noOfWlProp
% Thickness=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Thickness']);
% Grade=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Grade']);
if i<=WlGradeNo
    Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+1)-1))];
else
%    Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+1)-1)-5*(x(noOfColProp+noOfBeamProp+noOfWlProp+2)-1))];
% if strcmp(Grade,'M20')
%     Grade='M25';
% end
Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp+2)-1))];
end
if i<=NoOfWlLines
    
    PropWall=['Wall' num2str(i)];
    MatProp='';SSOverwrite='Default';Color=0;XCenter=0;YCenter=0;Length=0;Thickness=0;Rotation=0;Reinf=true;GradeLong='';
[ret,MatProp,SSOverwrite,Color,XCenter1,YCenter1,WlWidth,Thickness1,Rotation,Reinf,GradeLong]=...
    SapModel.PropFrame.SDShape.GetSolidRect(PropWall,'Rectangle1',MatProp,SSOverwrite,Color,XCenter,YCenter,Length,Thickness,Rotation,Reinf,GradeLong);
[ret,MatProp,SSOverwrite,Color,XCenter2,YCenter2,BEWidth,Thickness2,Rotation,Reinf,GradeLong]=...
    SapModel.PropFrame.SDShape.GetSolidRect(PropWall,'Rectangle2',MatProp,SSOverwrite,Color,XCenter,YCenter,Length,Thickness,Rotation,Reinf,GradeLong);
XCenter3=XCenter2;YCenter3=-YCenter2;

%     WlWidth=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Width']);
    Thickness=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Thickness']);
%     BEWidth=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.BEWidth']);
    ThicknessBE=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.ThicknessBE']);
    RebarSize=num2str(eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.BarDia']));
    Spacing=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Spacing']);
    SpacingBE=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.SpacingBE']);
%     Spacing=200;
else
    
    PropWall=['Wall' num2str(i-NoOfWlLines)];
    MatProp='';SSOverwrite='Default';Color=0;XCenter=0;YCenter=0;Length=0;Thickness=0;Rotation=0;Reinf=true;GradeLong='';
[ret,MatProp,SSOverwrite,Color,XCenter1,YCenter1,WlWidth,Thickness1,Rotation,Reinf,GradeLong]=...
    SapModel.PropFrame.SDShape.GetSolidRect(PropWall,'Rectangle1',MatProp,SSOverwrite,Color,XCenter,YCenter,Length,Thickness,Rotation,Reinf,GradeLong);
[ret,MatProp,SSOverwrite,Color,XCenter2,YCenter2,BEWidth,Thickness2,Rotation,Reinf,GradeLong]=...
    SapModel.PropFrame.SDShape.GetSolidRect(PropWall,'Rectangle2',MatProp,SSOverwrite,Color,XCenter,YCenter,Length,Thickness,Rotation,Reinf,GradeLong);
    XCenter3=XCenter2;YCenter3=-YCenter2;
    
     WlThLower=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.Thickness']);
     ThicknessBELower=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.ThicknessBE']);
%      WlWidth=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.Width']);
%      BEWidth=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.BEWidth']);
     RebarSize=num2str(eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.BarDia']));
     Spacing=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.Spacing']);
    [Thickness,ThicknessBE,SpacingBE]=WlDec1(x(i+noOfColProp+noOfBeamProp),WlThLower,ThicknessBELower,Spacing);
%     ThDec=50*(x(i+noOfColProp+noOfBeamProp)-1);
%     Thickness=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.Thickness'])-ThDec;
%     ThicknessBE=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfBELines)) '.ThicknessBE'])+75*(x(i+noOfColProp+noOfBeamProp+noOfWlProp-NoOfBELines)-1)-ThDec;
    if ThicknessBE<Thickness
        ThicknessBE=Thickness;
    end
%     Spacing=200;
%     Spacing=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfWlLines)) '.Spacing'])-SpacingChange;
end
MatRebar=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+5)-1))];
eval(['ret=SapModel.PropFrame.SetSDSection(''Wall' num2str(i) '''' ',Grade,3);']);
%% Assign data to stem portion of wall
eval(['ret=SapModel.PropFrame.SDShape.SetSolidRect(''Wall' num2str(i) '''' ',''Rectangle1'',Grade,''Default'',XCenter1,YCenter1,WlWidth,Thickness,0,-1,true,MatRebar);'])

eval(['ret=SapModel.PropFrame.SDShape.SetReinfCorner(''Wall' num2str(i) '''' ',''Rectangle1'',1,RebarSize,true);']);

eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle1'',1,RebarSize,Spacing,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle1'',3,RebarSize,Spacing,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle1'',2,''None'',Spacing,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle1'',4,''None'',Spacing,20);']);
%% Assign data to Boundary elements of the wall
eval(['ret=SapModel.PropFrame.SDShape.SetSolidRect(''Wall' num2str(i) '''' ',''Rectangle2'',Grade,''Default'',XCenter2,YCenter2,BEWidth,ThicknessBE,0,-1,true,MatRebar);'])
eval(['ret=SapModel.PropFrame.SDShape.SetReinfCorner(''Wall' num2str(i) '''' ',''Rectangle2'',1,RebarSize,true);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle2'',1,RebarSize,SpacingBE,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle2'',3,RebarSize,SpacingBE,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle2'',2,''None'',SpacingBE,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle2'',4,''None'',SpacingBE,20);']);

eval(['ret=SapModel.PropFrame.SDShape.SetSolidRect(''Wall' num2str(i) '''' ',''Rectangle3'',Grade,''Default'',XCenter3,YCenter3,BEWidth,ThicknessBE,0,-1,true,MatRebar);'])
eval(['ret=SapModel.PropFrame.SDShape.SetReinfCorner(''Wall' num2str(i) '''' ',''Rectangle3'',1,RebarSize,true);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle3'',1,RebarSize,SpacingBE,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle3'',3,RebarSize,SpacingBE,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle3'',2,''None'',SpacingBE,20);']);
eval(['ret=SapModel.PropFrame.SDShape.SetReinfEdge(''Wall' num2str(i) '''' ',''Rectangle3'',4,''None'',SpacingBE,20);']);
% eval(['ret=SapModel.PropFrame.SetWall(''ConcWall' num2str(i) '''' ',1,2,Grade,Thickness);']);
% 
% gradeLong=eval(['B' num2str(x(i+noOfColProp)) '.GradeLong']);
% gradeConf=eval(['B' num2str(x(i+noOfColProp)) '.GradeConf']);
% eval(['ret=SapModel.PropFrame.SetRebarBeam(''ConcWall' num2str(i) '''' ',gradeLong,gradeConf,30,30,0,0,0,0);']);
% Grade=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Grade']);
% % Grade=cellstr(Grade)
% Depth=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Depth']);
% Width=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Width']);
% eval(['ret=SapModel.PropFrame.SetRectangle(''ConcCol' num2str(i) '''' ',Grade,Depth,Width);']);
% gradeLong=eval(['W' num2str(x(i)) '.GradeLong']);
% gradeConf=eval(['W' num2str(x(i)) '.GradeConf']);
% numR3bars=int32(eval(['W' num2str(x(i)) '.no3dir']));
% numR2bars=int32(eval(['W' num2str(x(i)) '.no2dir']));
% % RebarSize=num2str(eval(['W' num2str(x(i)) '.barsize']));
% num2dtie=int32(eval(['W' num2str(x(i)) '.no2tie']));
% num3dtie=int32(eval(['W' num2str(x(i)) '.no3tie']));
% eval(['ret=SapModel.FrameObj.SetSection(''Wall' num2str(i) '''' ',''Wl' num2str(x(i+noOfColProp+noOfBeamProp)) '''' ',1);']);
end

% %% Get list of names in the group 'BEGradeChange'
% NumberItems=0;
% ObjectType=zeros(2,1,'int32');
% ObjectType(1)=0;
% ObjectName=cellstr(' ');
% [ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('BEGradeChange',NumberItems,ObjectType,ObjectName);
% % BEGradeNo=str2num(ObjectName{1});
% PropName='';
% SAuto='';
% clear BEGradeProp
% eval(['[ret,BEGradeProp,SAuto]=SapModel.FrameObj.GetSection(char(ObjectName),PropName,SAuto);']);
% clear BEGradeNo
%     if size(BEGradeProp,2)==3
%     BEGradeNo(1)=BEGradeProp(3);
%     BEGradeNo=str2double(BEGradeNo);
%     else
%     BEGradeNo(1)=BEGradeProp(3);
%     BEGradeNo(2)=BEGradeProp(4);
%     BEGradeNo=str2double(BEGradeNo);
%     end
% %% Get list of names in the group 'NoOfBELines'
% NumberItems=0;
% ObjectType=zeros(2,1,'int32');
% ObjectType(1)=0;
% ObjectName=cellstr(' ');
% [ret,NumberItems,ObjectType,ObjectName]=SapModel.Group.GetAssignments('NoOfBELines',NumberItems,ObjectType,ObjectName);
% NoOfBELines=NumberItems;


%% assign sections to boundary elements
% for i=1:noOfWlProp
% % Grade=eval(['C' num2str(x(i)) '.Grade']);
% if i<=WlGradeNo
% Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp*2+1)-1))];
% else
% Grade=['M' num2str(25+5*(x(noOfColProp+noOfBeamProp+noOfWlProp*2+3)-1))];
% end
% if i<=NoOfWlLines
% %     Depth=eval(['C' num2str(x(i)) '.Depth']);
%     Depth=2000;
%     Width=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Thickness'])+75*(x(i+noOfColProp+noOfBeamProp+noOfWlProp)-1);
% 
%     
% %     numR3bars=2;
% %     numR2bars=14;
% %     num2dtie=2;
% %     num3dtie=2;
% else
%     ThDec= 75*(x(i+noOfColProp+noOfBeamProp+noOfWlProp)-1);
% %     Depth=eval(['C' num2str(x(i-NoOfColLines)) '.Depth'])-Ddec;
%     Depth=2000;
%     Width=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp-NoOfBELines)) '.Thickness'])+75*(x(i+noOfColProp+noOfBeamProp+noOfWlProp-NoOfBELines)-1)-ThDec;
%     if Width<eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Thickness'])
%         Width=eval(['W' num2str(x(i+noOfColProp+noOfBeamProp)) '.Thickness']);
%     end
%     numR3bars=2;
%     numR2bars=14;
%     num2dtie=2;
%     num3dtie=2;   
% end
% % Grade=cellstr(Grade)
% % Depth=eval(['C' num2str(x(i)) '.Depth']);
% % Width=eval(['C' num2str(x(i)) '.Width']);
% eval(['ret=SapModel.PropFrame.SetRectangle(''BE' num2str(i) '''' ',Grade,Depth,Width);']);
% % gradeLong=eval(['C' num2str(x(i)) '.GradeLong']);
% gradeLong=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+noOfBEProp+5)-1))];
% % gradeConf=eval(['C' num2str(x(i)) '.GradeConf']);
% gradeConf=['HYSD' num2str(415+85*(x(noOfColProp+noOfBeamProp+noOfWlProp+noOfBEProp+6)-1))];
% 
% % RebarSize=num2str(eval(['C' num2str(x(i)) '.barsize']));
% 
% eval(['ret=SapModel.PropFrame.SetRebarColumn(''BE' num2str(i) '''' ',gradeLong,gradeConf' ',1,1,20,0,' 'numR3bars,numR2bars,''12'',''8'',150,num2dtie,num3dtie,true);']);
% end

