% assignment of agent group 3
%---------------------------------------------------------------------%

% Clear environment
close all; clear all;
addpath(genpath(cd));

profile on
AA = readmatrix('cluster.xlsx');
Dsum2 = readmatrix('center.xlsx');
A3 = 0;
A3mm=[10 0;10 0]; %(xmin xmax;ymin ymax)
A3task=[];
for i = 1:100
    if AA(i,3) == 3
        A3 = A3 + 1;
        A3task = [A3task;AA(i,:)];
        if AA(i,1) < A3mm(1,1)
            A3mm(1,1) = AA(i,1);
        end
        if AA(i,1) > A3mm(1,2)
            A3mm(1,2) = AA(i,1);
        end
        if AA(i,2) < A3mm(2,1)
            A3mm(2,1) = AA(i,1);
        end
        if AA(i,2) > A3mm(2,2)
            A3mm(2,2) = AA(i,2);
        end
    end
end

WORLD.CLR  = rand(A3,3);
WORLD.XMIN = A3mm(1,1);
WORLD.XMAX = A3mm(1,2);
WORLD.YMIN = A3mm(2,1);
WORLD.YMAX = A3mm(2,2);
WORLD.ZMIN = 0;
WORLD.ZMAX = 0;
WORLD.MAX_DISTANCE = sqrt((WORLD.XMAX - WORLD.XMIN)^2 + ...
                          (WORLD.YMAX - WORLD.YMIN)^2 + ...
                          (WORLD.ZMAX - WORLD.ZMIN)^2);
 
CBBA_Params = CBBA_Init(0,0);

% Initialize possible agent fields
agent_default.id    = 0;            % agent id
agent_default.type  = 0;            % agent type
agent_default.avail = 0;            % agent availability (expected time in sec)
agent_default.clr = [];             % for plotting

agent_default.x       = 0;          % agent position (meters)
agent_default.y       = 0;          % agent position (meters)
agent_default.z       = 0;          % agent position (meters)
agent_default.nom_vel = 0;          % agent cruise velocity (m/s)
agent_default.fuel    = 0;          % agent fuel penalty (per meter)

% Initialize possible task fields
task_default.id       = 0;          % task id
task_default.type     = 0;          % task type
task_default.value    = 0;          % task reward
task_default.start    = 0;          % task start time (sec)
task_default.end      = 0;          % task expiry time (sec)
task_default.duration = 0;          % task default duration (sec)
task_default.lambda   = 0.1;        % task exponential discount

task_default.x        = 0;          % task position (meters)
task_default.y        = 0;          % task position (meters)
task_default.z        = 0;          % task position (meters)

% FOR USER TO DO:  Set task fields for specialized tasks

%---------------------------%

% Create some default agents

agent_car           = agent_default;
agent_car.type      = CBBA_Params.AGENT_TYPES.CAR;  % agent type
agent_car.nom_vel   = 2;         % agent cruise velocity (m/s)
agent_car.fuel      = 1;         % agent fuel penalty (per meter)

task_rescue          = task_default;
task_rescue.type     = CBBA_Params.TASK_TYPES.RESCUE;      % task type
task_rescue.value    = 100;    % task reward
task_rescue.start    = 0;      % task start time (sec)
task_rescue.end      = 100;    % task expiry time (sec)
task_rescue.duration = 15;     % task default duration (sec)


%---------------------------------------------------------------------%
% Define sample scenario
%---------------------------------------------------------------------%

N = ceil(A3/4)+1;      % # of agents
M = A3;     % # of tasks

% Create random agents
for n=1:N,
    agents(n) = agent_car;%后几个小车
    agents(n).id   = n;%序号
%     agents(n).x    = rand(1)*(WORLD.XMAX - WORLD.XMIN) + WORLD.XMIN;%初始位置x
%     agents(n).y    = rand(1)*(WORLD.YMAX - WORLD.YMIN) + WORLD.YMIN;%初始位置y
    agents(n).x = Dsum2(3,1);
    agents(n).y = Dsum2(3,2);
    agents(n).clr  = WORLD.CLR(n,:);
end

% Create random tasks
for m=1:M,
    tasks(m) = task_rescue;
    tasks(m).id       = m;
    tasks(m).start    = A3task(m,4);%任务开始时间
    tasks(m).end      = A3task(m,5);%任务结束时间
    tasks(m).x        = A3task(m,1);%任务位置
    tasks(m).y        = A3task(m,2);
    tasks(m).z        = 0;
end


%---------------------------------------------------------------------%
% Initialize communication graph and diameter
%---------------------------------------------------------------------%

% Fully connected graph
Graph = ~eye(N);

%---------------------------------------------------------------------%
% Run CBBA
%---------------------------------------------------------------------%

[CBBA_Assignments Total_Score] = CBBA_Main(agents, tasks, Graph)

PlotAssignments(WORLD, CBBA_Assignments, agents, tasks, 1);

saveas(1,'sch_g3.eps', 'epsc');
saveas(2,'path_g3.eps', 'epsc');

profile off
profile report


