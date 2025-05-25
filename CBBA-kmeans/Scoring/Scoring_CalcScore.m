% Copyright 2010
% Massachusetts Institute of Technology
% All rights reserved
% Developed by the Aerospace Controls Lab, MIT

%---------------------------------------------------------------------%
% Calculates marginal score of doing a task and returns the expected
% start time for the task.
% 计算执行任务的边际得分，并返回任务的预期开始时间。
%---------------------------------------------------------------------%

function [score minStart maxStart] = Scoring_CalcScore(CBBA_Params,agent,taskCurr,taskPrev,timePrev,taskNext,timeNext)
    %分别从前一个任务和后一个任务得到任务开始时间，从时间上判断能否将此任务插在任务栏中
if((agent.type == CBBA_Params.AGENT_TYPES.QUAD) || ...
   (agent.type == CBBA_Params.AGENT_TYPES.CAR)),

 
    if(isempty(taskPrev)), % First task in path如果将此任务插在任务栏的第一个位置
        % Compute start time of task
        % 计算任务开始时间
        dt = sqrt((agent.x-taskCurr.x)^2 + (agent.y-taskCurr.y)^2 + (agent.z-taskCurr.z)^2)/agent.nom_vel;
        minStart = max(taskCurr.start, agent.avail + dt);%任务开始时间 与 机器人空闲时间+路程时间 取最大值 为机器人执行任务的实际开始时间
    else % Not first task in path后续任务则从前一个任务的位置开始计算
        dt = sqrt((taskPrev.x-taskCurr.x)^2 + (taskPrev.y-taskCurr.y)^2 + (taskPrev.z-taskCurr.z)^2)/agent.nom_vel;
        minStart = max(taskCurr.start, timePrev + taskPrev.duration + dt); %i have to have time to do task at j-1 and go to task m
                                                                           %完成前一个任务的时间+路程时间
    end
    
    if(isempty(taskNext)), % Last task in path如果将此任务插在任务栏的最后一个位置
        maxStart = taskCurr.end;
    else % Not last task, check if we can still make promised task
        dt = sqrt((taskNext.x-taskCurr.x)^2 + (taskNext.y-taskCurr.y)^2 + (taskNext.z-taskCurr.z)^2)/agent.nom_vel;
        maxStart = min(taskCurr.end, timeNext - taskCurr.duration - dt); %i have to have time to do task m and fly to task at j+1
    end

    % Compute score
    reward = taskCurr.value*exp(-taskCurr.lambda*(minStart-taskCurr.start));

    % Subtract fuel cost.  Implement constant fuel to ensure DMG.
    % 减去燃料成本。实施恒定燃油以确保DMG。
    % NOTE: This is a fake score since it double counts fuel.  Should
    % not be used when comparing to optimal score.  Need to compute
    % real score of CBBA paths once CBBA algorithm has finished
    % running.
    penalty = agent.fuel*sqrt((agent.x-taskCurr.x)^2 + (agent.y-taskCurr.y)^2 + (agent.z-taskCurr.z)^2);

    score = reward - penalty;

% FOR USER TO DO:  Define score function for specialized agents, for example:
% elseif(agent.type == CBBA_Params.AGENT_TYPES.NEW_AGENT), ...  

% Need to define score, minStart and maxStart

else
    disp('Unknown agent type')
end

return
