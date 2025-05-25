
AA = readmatrix('Data\tasks.xlsx');
K = 4;
%[cc,Dsum2,z2] = kmeans(AA(:,[1,2,7]),K); %cc为分组索引向量, Dsum2为质心位置, z2为簇内的点到质心距离之和
[cc,Dsum2,z2] = kmeans(AA(:,[1,2]),K); %cc为分组索引向量, Dsum2为质心位置, z2为簇内的点到质心距离之和

A=[AA(:,[1,2]),cc];

%SHOWCLUSTERA 此处显示有关此函数的摘要
%数据格式为三列，前两列是二维数据，最后一列是类别  x,y,c
%最多显示7中类别的聚类

% colors=['r','g','b','y','m','c','k'];
[row,col]=size(A);
pointStyles=['+', '*', '.', 'x','o','s','d','p','h','>'];
L=unique(A(:,col));
N=length(L);
lineStyles = linspecer(N);
lineStyles=[[1,1,1];lineStyles];
figure;
for i=1:N
    ir = find(A(:,col)==L(i,1));         % 返回行索引  
    if(~isempty(ir))
        if col>3
            scatter3(A(ir,1),A(ir,2),A(ir,3),'MarkerFaceColor',lineStyles(i+1,:),'MarkerEdgeColor',lineStyles(i+1,:));%,'Marker','.'
        else
            scatter(A(ir,1),A(ir,2),'MarkerFaceColor',lineStyles(i+1,:),'MarkerEdgeColor',lineStyles(i+1,:));
        end
        hold on
    end
end
for i=1:K
    scatter(Dsum2(i,1),Dsum2(i,2),'r');
end

hold off
title('\fontname{宋体}聚类结果','FontSize',18);
xlabel('x','FontSize',18);
ylabel('y','FontSize',18);
saveas(1,'cluster.eps', 'epsc');
AL=[A(:,(1:3)),AA(:,[4,5])];
writematrix(AL, 'cluster.xlsx', 'Sheet', 1, 'Range', 'A1:E100');
writematrix(Dsum2, 'center.xlsx', 'Sheet', 1, 'Range', 'A1:B4');


