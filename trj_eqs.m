function dydt = trj_eqs(t,y,RktSpc,psi,CL,CD,t_tot)

%***Remeber to co-ordinate shift functions of time with time elapsed t_tot*****
%Total mass
m_0=RktSpc(1)
%propellant flow rate
m_dot=RktSpc(2)
%Thrust
T=RktSpc(3)
%Reference Area
area=RktSpc(4)
%thrust angle
PSI=(psi(1)*(t-t_tot)^2)+(psi(2)*(t-t_tot))+(psi(3))
%mass at time t
m_t = m_0-(m_dot*(t-t_tot))

%CL at time t
CL_t=(CL(1)*(t-t_tot)^2)+(CL(2)*(t-t_tot))+(CL(3))
%CD at time t
CD_t=(CD(1)*(t-t_tot)^2)+(CD(2)*(t-t_tot))+(CD(3))

%g=(g_dot*y(4))+g_0 valid between 0 and 800 km
g_dot=-2.59*10^(-6)
g_0=9.82

%Density of air at 10km (AD HOC)
rho=0.4135

%dydt is the vector of dependant variables (in order) velocity(u),theta,X,Y
dydt = zeros(4,1);
%du/dt
dydt(1) = ((T/(m_t))*cos(PSI-y(2)))  - ( (CD_t/(2*m_t))*(rho*y(1)^2*area) ) -  (((g_dot*y(4))+g_0)*sin(y(2)));
%dtheta/dt
dydt(2) = (((T/y(1))/(m_t)).*sin(PSI-y(2))) +( (CL_t/(2*m_t))*(rho*y(1)*area) )  -  (((g_dot*y(4))+g_0*cos(y(2)))./y(1));
%dX/dt
dydt(3) = y(1)*cos(y(2));
%dh/dt
dydt(4) = y(1)*sin(y(2));

