function [x,fval,exitflag,output,population,score] = GABuildingFunction(nvars,lb,ub,intcon,PopulationSize_Data,Generations_Data)
%% This is an auto generated MATLAB file from Optimization Tool.
xLast = []; % Last place computeall was called
myf = []; % Use for objective at xLast
myc = []; % Use for nonlinear inequality constraint
myceq = []; % Use for nonlinear equality constraint

fun = @objfun; % the objective function, nested below
cfun = @constr; % the constraint function, nested below

%% Start with the default options
options = gaoptimset;
% options = gaoptimset(options,'InitialPopulation', InitialPopulation_Data);
options = gaoptimset(options,'PopulationSize', PopulationSize_Data);
options = gaoptimset(options,'Generations', Generations_Data);
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', { @gaplotbestf });
options = gaoptimset(options,'UseParallel', true);
[x,fval,exitflag,output,population,score] = ...
ga(fun,nvars,[],[],[],[],lb,ub,cfun,intcon,options);

    function y = objfun(x)
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = ComputeAll(x);
            xLast = x;
        end
        % Now compute objective function
        y = myf; 
    end

    function [c,ceq] = constr(x)
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = ComputeAll(x);
            xLast = x;
        end
        % Now compute constraint functions
        c = myc; % In this case, the computation is trivial
        ceq = myceq;
%         if all(c<=0)
%             cPerf=PerfPointScript;
%         else
% %             cPerf=[1;1;1;1;5;5;10;10];
%             cPerf=[0;0;0;0;0;0;0;0];
%         end
%         c=[c;cPerf];
    end
end

