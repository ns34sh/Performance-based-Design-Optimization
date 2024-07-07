% function [x,fval,exitflag,output,population,score] = gaCostframe(nvars,lb,ub,intcon,PopulationSize_Data,Generations_Data)
%% This is an auto generated MATLAB file from Optimization Tool.
nvars=19;
% lb=ones(1,28);
% ub=[11 11 11 7 7 7 7 8 8 8 8 8 8 8 8 8 8 8 8 8 8 6 6 6 3 3 3 2];
lb=ones(1,19);
ub=[11 11 11 7 7 7 8 8 8 8 8 6 3 3 3 3 2 11 11];
intcon=1:19;
PopulationSize_Data=40;
Generations_Data=40;
% InitialPopulation_Data=population;
% for i=2:100,InitialPopulation_Data(i,:)=[randi(27) randi(27) randi(27) randi(27) randi(27) randi(27) randi(27) randi(27) randi(27) randi(27) randi(18) randi(18) randi(18) randi(18) randi(18)];end;
%% Start with the default options
% options = gaoptimset;
%% Modify options setting
% options = gaoptimset(options,'InitialPopulation', InitialPopulation_Data);
% options = gaoptimset(options,'PopulationSize', PopulationSize_Data);
% options = gaoptimset(options,'Generations', Generations_Data);
% options = gaoptimset(options,'Display', 'off');
% options = gaoptimset(options,'PlotFcns', { @gaplotbestf });
% options = gaoptimset(options,'UseParallel', true);
tic
[x,fval,exitflag,output,population,score] = ...
    GABuildingFunction(nvars,lb,ub,intcon,PopulationSize_Data,Generations_Data);

% GABuildingFunction(nvars,lb,ub,intcon,InitialPopulation_Data,PopulationSize_Data,Generations_Data);
time=toc;
% population2=population;
% x2=x;
% output2=output;
% score2=score;
% fval2=fval;
save Modelnonpushl x population output score fval time;
