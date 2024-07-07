% function openmodel(i)
% i=labindex
% global EtabsObject1 EtabsObject2
% global SapModel1 SapModel2
%% Pass data to Etabs as one dimensional arrays
feature('COM_SafeArraySingleDim',1);
%% Pass non scalar arrays to Etabs by reference
feature('COM_PassSafeArrayByRef',1);
% global EtabsObject SapModel
% eval(['global ' 'EtabsObject' num2str(i) ';']);
% eval(['global ' 'SapModel' num2str(i) ';']);
% eval(['global ' 'EtabsObject' num2str(i) ';']);
global SapModel
% global dataBaseIndex
% dataBaseIndex=i;
% eval(['EtabsObject' num2str(i) '=actxserver(''CSI.ETABS.API.EtabsObject'');']);
% eval(['EtabsObject' num2str(i) '=actxserver(''CSI.SAP2000.API.SapObject'');']);
% eval(['EtabsObject' num2str(i) '.ApplicationStart' ';']);
% eval(['EtabsObject' num2str(i) '=actxserver(''CSI.SAP2000.API.SapObject'');']);
% EtabsObject=actxserver('CSI.SAP2000.API.SapObject');
   %% create OAPI helper object
      helper = actxserver('Sap2000v18.helper');
      helper = helper.invoke('cHelper');     
      ProgramPath = 'C:\Program Files\Computers and Structures\SAP2000 18\sap2000.exe';


   %% create Sap2000 object
      EtabsObject = helper.CreateObject(ProgramPath);

% EtabsObject=actxserver('CSI.ETABS.API.EtabsObject');

% eval(['EtabsObject' '=actxserver(''CSI.ETABS.API.EtabsObject'');']);
% eval(['EtabsObject' num2str(i) '.ApplicationStart' ';']);
EtabsObject.ApplicationStart;

% eval(['SapModel' num2str(i) '=EtabsObject' num2str(i) '.SapModel;']);
% eval(['SapModel' '=EtabsObject' num2str(i) '.SapModel;']);
SapModel=EtabsObject.SapModel;
% eval(['SapModel' num2str(i) '.File.OpenFile(''C:\Users\Home\Desktop\pump house\' 'sappumphouse' num2str(i) '.edb'');']);
% eval(['SapModel' '.File.OpenFile(''C:\Users\Home\Desktop\pump house\' 'sappumphouse' num2str(i) '.sdb'');']);
SapModel.File.OpenFile('C:\Users\Home\Desktop\New folder (7)\sym plan - sap\sym plan.sdb');
% SapModel.File.OpenFile('C:\Users\Home\Desktop\New folder (7)\Equi col model\equi col load distribution.edb');

% eval(['SapModel' '.File.OpenFile(''C:\Users\Home\Desktop\SAP\pushover\10 storey frame sap\' num2str(i) '\10 storey frame' num2str(i) '.SDB'');']);
% eval(['SapModel' num2str(i) '.SetModelIsLocked(false);']);
% eval(['SapModel' num2str(i) '.SetPresentUnits(5);']);
SapModel.SetModelIsLocked(false);
SapModel.SetPresentUnits(5);
% eval(['c=SapModel' num2str(i)])
% SapModel{i}.SetModelIsLocked(false)
%% Load section information
% for i=1:27
%     eval(['global' ' C' num2str(i)]);
% end
% for i=1:18
%     eval(['global' ' B' num2str(i)]);
% end
% for i=1:27,eval(['load section1.mat C' num2str(i)]),end
% for i=1:18,eval(['load section1.mat B' num2str(i)]),end
for j=1:11,eval(['load varlist1.mat C' num2str(j)]),end
for j=1:8,eval(['load varlist1.mat B' num2str(j)]),end
for j=1:24,eval(['load varlist1.mat W' num2str(j)]),end
% end



