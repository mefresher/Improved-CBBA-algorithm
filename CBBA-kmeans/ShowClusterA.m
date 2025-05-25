
AA = readmatrix('Data\tasks.xlsx');
K = 4;
%[cc,Dsum2,z2] = kmeans(AA(:,[1,2,7]),K); %ccΪ������������, Dsum2Ϊ����λ��, z2Ϊ���ڵĵ㵽���ľ���֮��
[cc,Dsum2,z2] = kmeans(AA(:,[1,2]),K); %ccΪ������������, Dsum2Ϊ����λ��, z2Ϊ���ڵĵ㵽���ľ���֮��

A=[AA(:,[1,2]),cc];

%SHOWCLUSTERA �˴���ʾ�йش˺�����ժҪ
%���ݸ�ʽΪ���У�ǰ�����Ƕ�ά���ݣ����һ�������  x,y,c
%�����ʾ7�����ľ���

% colors=['r','g','b','y','m','c','k'];
[row,col]=size(A);
pointStyles=['+', '*', '.', 'x','o','s','d','p','h','>'];
L=unique(A(:,col));
N=length(L);
lineStyles = linspecer(N);
lineStyles=[[1,1,1];lineStyles];
figure;
for i=1:N
    ir = find(A(:,col)==L(i,1));         % ����������  
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
title('\fontname{����}������','FontSize',18);
xlabel('x','FontSize',18);
ylabel('y','FontSize',18);
saveas(1,'cluster.eps', 'epsc');
AL=[A(:,(1:3)),AA(:,[4,5])];
writematrix(AL, 'cluster.xlsx', 'Sheet', 1, 'Range', 'A1:E100');
writematrix(Dsum2, 'center.xlsx', 'Sheet', 1, 'Range', 'A1:B4');


