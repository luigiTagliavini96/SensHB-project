% postPRO.m

clear 
close all
clc

% Name of the LOG file
LOGname = "LOG\U01_T6_M2.mat";
load(LOGname);

% Odometry from SerialLOG data:
eta = nan(3,length(t)); eta(:,1) = [0,0,0]';

for i = 2:length(t)
    eta(1,i) = eta(1,i-1) + gd_FB(i)*(t(i) - t(i-1));
end

% % Correzzione:
% gmax = max(eta(1,:)); dg = 2*pi;
% eta(1,:) = dg/gmax.*eta(1,:);

for i = 2:length(t)
    Ri = [cos(eta(1,i)), - sin(eta(1,i)); sin(eta(1,i)), cos(eta(1,i))];
    eta(2:3,i) = eta(2:3,i-1) + Ri*[xd_FB(i); yd_FB(i)]*(t(i) - t(i-1));
end

% Plot data:
figure(); set(gcf,'color','w');
subplot(1,2,1)
plot(eta(2,:),eta(3,:),'LineWidth',1.2); 
axis equal; grid;
xlabel("x, m"); ylabel("y, m");
subplot(1,2,2)
plot(t,eta(1,:),'LineWidth',1.2)
grid; xlabel("t, s"); ylabel("\gamma, rad");

figure(); set(gcf,'color','w');
plot(t,xd,t,yd,'LineWidth',1.2); 
grid;
xlabel("$t$, s",'Interpreter','latex'); ylabel("v, m$/$s",'Interpreter','latex');
legend("$\dot{x}$","$\dot{y}$",'Interpreter','latex');

figure(); set(gcf,'color','w');
plot(t,gd,'LineWidth',1.2)
grid; xlabel("t, s"); ylabel("$\dot{\gamma}$, rad$/$s",'Interpreter','latex');

figure(); set(gcf,'color','w');
plot(t,Fx,t,Fy,'LineWidth',1.2); 
grid;
xlabel("$t$, s",'Interpreter','latex'); ylabel("F, N",'Interpreter','latex');
legend("$F_x{x}$","$F_{y}$",'Interpreter','latex');

figure(); set(gcf,'color','w');
plot(t,Mz,'LineWidth',1.2)
grid; xlabel("t, s"); ylabel("$M_z$, Nm",'Interpreter','latex');


%% Multiple tests
clear
close all
clc

LOGnames = ["LOG\U01_T6_M2.mat","LOG\U02_T6_M2.mat","LOG\U04_T6_M2.mat","LOG\U03_T6_M2.mat","LOG\U05_T6_M2.mat"];

for j = 1:3
load(LOGnames(j));

% Odometry from SerialLOG data:
eta = nan(3,length(t)); eta(:,1) = [0,0,0]';

for i = 2:length(t)
    % eta(1,i) = eta(1,i-1) + gd(i)*(t(i) - t(i-1));
    eta(1,i) = eta(1,i-1) + gd_FB(i)*(t(i) - t(i-1));
end

% % Correzzione:
% gmax = max(eta(1,:)); dg = 2*pi;
% eta(1,:) = dg/gmax.*eta(1,:);

for i = 2:length(t)
    Ri = [cos(eta(1,i)), - sin(eta(1,i)); sin(eta(1,i)), cos(eta(1,i))];
    % eta(2:3,i) = eta(2:3,i-1) + Ri*[xd(i); yd(i)]*(t(i) - t(i-1));
    eta(2:3,i) = eta(2:3,i-1) + Ri*[xd_FB(i); yd_FB(i)]*(t(i) - t(i-1));
end

% Plot data:
figure(1); set(gcf,'color','w');
plot(eta(2,:),eta(3,:),'LineWidth',1.2); 
axis equal; grid;
xlabel("$x$, m",'Interpreter','latex'); ylabel("$y$, m",'Interpreter','latex'); hold on

figure(2); set(gcf,'color','w');
subplot(3,1,1)
plot(t,xd,'LineWidth',1.2); 
grid;
xlabel("$t$, s",'Interpreter','latex'); ylabel("$\dot{x}_b$, m$/$s",'Interpreter','latex');hold on
subplot(3,1,2)
plot(t,yd,'LineWidth',1.2); 
grid;
xlabel("$t$, s",'Interpreter','latex'); ylabel("$\dot{y}_b$, m$/$s",'Interpreter','latex');hold on
subplot(3,1,3)
plot(t,gd,'LineWidth',1.2)
grid; xlabel("$t$, s",'Interpreter','latex'); ylabel("$\dot{\gamma}_b$, rad$/$s",'Interpreter','latex'); hold on

figure(3); set(gcf,'color','w');
subplot(3,1,1)
plot(t,Fx,'LineWidth',1.2); 
grid;
xlabel("$t$, s",'Interpreter','latex'); ylabel("$F_x$, N",'Interpreter','latex'); hold on
subplot(3,1,2)
plot(t,Fy,'LineWidth',1.2); 
grid;
xlabel("$t$, s",'Interpreter','latex'); ylabel("$F_y$, N",'Interpreter','latex'); hold on
subplot(3,1,3)
plot(t,Mz,'LineWidth',1.2)
grid; xlabel("$t$, s",'Interpreter','latex'); ylabel("$M_z$, Nm",'Interpreter','latex'); hold on

end