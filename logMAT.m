%logMAT.m

clear
close all
clc

saveON = 1;

% Name of the LOG file
LOGname = "LOG\U09_T6_M2.mat";

% Serial port initialization:
SerialPort  = 'COM3'; %serial port
BaudRate    = 115200; 
srl = serialport(SerialPort,BaudRate);
configureTerminator(srl,"CR/LF");

% Create the dialog pop-up
f = figure;
f.Position = [500 500 250 100];
cbx = uicontrol(f,'Style','checkbox','String','Stop Acquisition','FontSize',12);
cbx.Position = [60 15 150 50];
txt = uicontrol(f,'Style','text','String', ['T = ',num2str(0.00,'%4.2f'),' s'],'FontSize',12);
txt.Position = [50 50 150 35];

% Variable initialization:
t = [];

xd_FB = []; yd_FB = []; gd_FB = [];
xd    = []; yd    = []; gd    = [];
Fx    = []; Fy    = []; Mz    = [];

pause(1); flush(srl); tic

while true
    data = str2num(readline(srl));

    if (length(data) == 9) 
        t = [t, toc];

        xd_FB = [xd_FB, data(1)];
        yd_FB = [yd_FB, data(2)];
        gd_FB = [gd_FB, data(3)];

        xd    = [xd, data(7)];
        yd    = [yd, data(8)];
        gd    = [gd, data(9)];

        Fx    = [Fx, data(4)];
        Fy    = [Fy, data(5)];
        Mz    = [Mz, data(6)];
    end

    if cbx.Value
        txt.String = 'Acquisition done :)'; pause(1); close(f);
        break
    end
    txt.String = ['T = ',num2str(toc,'%4.2f'),' s']; drawnow

    pause(0.001);
    flush(srl);
end

clear srl;

if saveON
    save(LOGname,"t","xd_FB","yd_FB","gd_FB","xd","yd","gd","Fx","Fy","Mz");
end

%% Odometry from SerialLOG data:

eta = nan(3,length(t)); eta(:,1) = [0,0,0]';

for i = 2:length(t)
    eta(1,i) = eta(1,i-1) + gd_FB(i)*(t(i) - t(i-1));
    Ri = [cos(eta(1,i)), - sin(eta(1,i)); sin(eta(1,i)), cos(eta(1,i))];
    eta(2:3,i) = eta(2:3,i-1) + Ri*[xd_FB(i); yd_FB(i)]*(t(i) - t(i-1));
end

% Plot data:
figure(); set(gcf,'color','w');
plot(eta(2,:),eta(3,:),'LineWidth',1.2); 
axis equal; grid;
xlabel("x, m"); ylabel("y, m");

figure()
plot(t,eta(1,:))