clc
clear all
close all


filename = 'INPUT_DATA.xlsx';
sheet = 1;
A = xlsread(filename,sheet)

%initial conditions at t=0
%IC=[u(0) theta(0) X(0)(keep as zero) h(0)(initial height)]
sheet=2;
IC=xlsread(filename,sheet)'

%initialize time step cut-off time and total time
t_p=0
t_tot=0

%number of time steps
sheet=3;
n=xlsread(filename,sheet)'

%initialize figures for plotting
f1=figure('Name','u Vs Time')
f2=figure('Name','Theta Vs Time')
f3=figure('Name','Height Vs Time')
f4=figure('Name','Height Vs X')

%index 'i' scans through each time step
for i=1:n
    %-----Rocket Specifications-----------
    %RktSpc=[TotalMass PropellantFlowRate Thrust ReferenceArea]
    RktSpc=[A(1,i) A(2,i) A(3,i) A(4,i)]
    

    %------Maneouvering Prameters---------
    %acceleration due to gravity
    %g=A(5,i)

    %angle of thrust with x direction as a quadratic function of time
    %psi=at^2 +bt +c
    %psi=[a b c]
    psi=(pi/180)*[A(5,i) A(6,i) A(7,i)]


    %total time elapsed at beginning of time step
    t_tot=t_tot+t_p
    %cutoff time
    t_p=A(8,i)
    
    %Gravity turn yes/no
    g_turn=A(9,i)
    
    %Coefficient of lift
    CL=[A(10,i) A(11,i) A(12,i)]
    %Coefficient of Drag
    CD=[A(13,i) A(14,i) A(15,i)]
    
    %update IC for subsequent stages
    if i>1
    IC=[y(end,1) y(end,2) y(end,3) y(end,4)]
    end

    %Solve Governing ODE's
    if g_turn==0
    [t,y] = ode45(@(t,y) trj_eqs(t,y,RktSpc,psi,CL,CD,t_tot),[t_tot t_tot+t_p],IC)
    else
       [t,y] = ode45(@(t,y) trj_eqs_gt(t,y,RktSpc,CL,CD,t_tot),[t_tot t_tot+t_p],IC) 
    end
    
    %-------- Altitude and trajectory angle corrections for Earths curvature----
    R=6371000 %radius of the Earth
    beta=acos(y(:,3)/R)
    del_h=R*(1-sin(beta))
    %new corrected height
    H=y(:,4)+del_h
    %corrected trajectory angle
    theta=y(:,2)+(pi/2)-beta
    

    %-------------Plot Graphs-----------
    %plot u vs time
    figure(f1) 
    plot(t,y(:,1)/1000,'LineWidth',2)
    hold on
    scatter(t(end),y(end,1)/1000,80,'filled')
    hold on
    
    %plot theta vs time (theta converted to degree)
    figure(f2) 
    plot(t,theta*(180/pi),'LineWidth',2)
    hold on
    scatter(t(end),theta(end)*(180/pi),80,'filled')
    hold on
    
    %plot height vs time (height converted to km)
    figure(f3) 
    plot(t,H/1000,'LineWidth',2)
    hold on
    scatter(t(end),H(end)/1000,80,'filled')
    hold on
    
    %plot height vs X (both axis converted to km)
    figure(f4) 
    plot(y(:,3)/1000,H/1000,'LineWidth',2)
    hold on
    scatter(y(end,3)/1000,H(end)/1000,80,'filled')  
    hold on
     
               
end

%------Formatting the graphs---------
figure(f1)
xlabel('time(sec)','FontSize',20);
ylabel('u (km/s)','FontSize',20);

figure(f2)
xlabel('time(sec)','FontSize',20);
ylabel('theta (deg)','FontSize',20);

figure(f3)
xlabel('time(sec)','FontSize',20);
ylabel('height (km)','FontSize',20);

figure(f4)
xlabel('X distance(km)','FontSize',20);
ylabel('height (km)','FontSize',20);

disp('Run Complete')
