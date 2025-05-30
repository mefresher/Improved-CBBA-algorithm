% Copyright 2010
% Massachusetts Institute of Technology
% All rights reserved
% Developed by the Aerospace Controls Lab, MIT

%---------------------------------------------------------------------%
% Plots CBBA outputs
%---------------------------------------------------------------------%

function fig = PlotAssignments(WORLD, CBBA_Assignments, agents, tasks, figureID)

%---------------------------------------------------------------------%
% Set plotting parameters
set(0, 'DefaultAxesFontSize', 12)
set(0, 'DefaultTextFontSize', 10, 'DefaultTextFontWeight','demi')
set(0,'DefaultAxesFontName','arial')
set(0,'DefaultTextFontName','arial')
set(0,'DefaultLineLineWidth',2); % < == very important
set(0,'DefaultlineMarkerSize',10)

%---------------------------------------------------------------------%
% Plot X and Y agent and task positions vs. time

offset = (WORLD.XMAX - WORLD.XMIN)/100;
fig    = figure(figureID);
Cmap   = colormap('lines');

% Plot tasks
for m=1:length(tasks)
    for n=1:length(agents)
        if(ismember(m,CBBA_Assignments(n).path))
            colors=n;
        end
    end
    plot3(tasks(m).x + [0 0], tasks(m).y + [0 0], [tasks(m).start tasks(m).end],'x:','color',Cmap(colors,:),'LineWidth',3);
    hold on;
    text(tasks(m).x+offset, tasks(m).y+offset, tasks(m).start, ['T' num2str(m)]);
end

% Plot agents
for n=1:length(agents)
    plot3(agents(n).x, agents(n).y, 0,'o','color',Cmap(n,:));
    text(agents(n).x+offset, agents(n).y+offset, 0.1, ['A' num2str(n)]);

    % Check if path has something in it
    if( CBBA_Assignments(n).path(1) > -1 )
        taskPrev = lookupTask(tasks, CBBA_Assignments(n).path(1));
        X = [agents(n).x, taskPrev.x];
        Y = [agents(n).y, taskPrev.y];
        T = [0, CBBA_Assignments(n).times(1)];
        plot3(X,Y,T,'-','color',Cmap(n,:));
        plot3(X(end)+[0 0], Y(end)+[0 0], [T(2) T(2)+taskPrev.duration],'-','color',Cmap(n,:));
        for m = 2:length(CBBA_Assignments(n).path)
            if( CBBA_Assignments(n).path(m) > -1 )
                taskNext = lookupTask(tasks, CBBA_Assignments(n).path(m));
                X = [taskPrev.x, taskNext.x];
                Y = [taskPrev.y, taskNext.y];
                T = [CBBA_Assignments(n).times(m-1)+taskPrev.duration, CBBA_Assignments(n).times(m)];
                plot3(X,Y,T,'-','color',Cmap(n,:));
                plot3(X(end)+[0 0], Y(end)+[0 0], [T(2) T(2)+taskNext.duration],'-','color',Cmap(n,:));
                taskPrev = taskNext;
            else
                break;
            end
        end
    end
end

hold off;
%title('\fontname{宋体}曲线图\fontname{Times new roman}sapi');
title('\fontname{宋体}任务-时间路线图','FontSize',14)
xlabel('X','FontSize',14);
ylabel('Y','FontSize',14);
zlabel('\fontname{宋体}时间');
grid on

% Plot agent schedules

fig = figure(figureID+1);
subplot(length(agents),1,1);
title('\fontname{宋体}任务执行时间表','FontSize',14)

for n=1:length(agents),
    subplot(length(agents),1,n);
    %ylabel(['R' num2str(n)])
    hold on;
    grid on;
    axis([0 120 0 2])
    if(n~=length(agents))
        set(gca,'XTickLabel',[]);
    end
     
    set(gca,'YTickLabel',[]);
     
    for m = 1:length(CBBA_Assignments(n).path),
        if (CBBA_Assignments(n).path(m) > -1)
            taskCurr = lookupTask(tasks, CBBA_Assignments(n).path(m));
            plot([CBBA_Assignments(n).times(m) CBBA_Assignments(n).times(m)+taskCurr.duration],[1 1],'-','color',Cmap(n,:), 'Linewidth',10)
            plot([taskCurr.start taskCurr.end],[1 1],'--','color',Cmap(n,:))
        else
            break;
        end
    end
end
xlabel('\fontname{宋体}时间','FontSize',14);

return

function task = lookupTask(tasks, taskID)

for m=1:length(tasks),
    if(tasks(m).id == taskID)
        task = tasks(m);
        return;
    end
end

task = [];
disp(['Task with index=' num2str(taskID) ' not found'])

return

    