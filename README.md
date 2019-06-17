# Rocket-Trajectory

## Summary
This Matlab program implements a numerical 2D trajectory model for air launch to
orbit systems. Default values are for Orbital ATK's Pegasus XL mission to a 741 km circular polar orbit with 221 kg payload. 
missions.

## Note on Units
All input values should be in SI. Computations are also carried out in SI, however the plots are converted to km instead of m due to the large distances involved.
## Input Data
All input data is recorded in the spread sheet INPUT_DATA.xlsx.
## Sheet 1
Each column in sheet 1 represents a time step. The trajectory calculation can be divided into any arbitrary number of time steps simply by entering relevant values in the columns. The duration of each time step is determined by the value in the row marked “cut off time”. 
Each time step works within its own local time frame. That is to say, “cut off time” and other time dependent parameters should be in terms of time elapsed since beginning of that time step and not the total time elapsed. 
Each time step is modelled as “Constant Thrust and Propellant Flow Rate” Step. If there is considerable variation in the thrust generated within the same rocket stage, simply divide it into more time steps.
Rocket Staging information is captured as a time step by subtracting the jettisoned weight from the Total Mass at the beginning of each time step. Due to this reason, the total mass at the beginning of each time step must be calculated by the user separately considering burnt propellant as well as jettisoned structural weight.
Psi (ψ) is the thrust vector and is a user defined quadratic function of time : ψ=at^2+bt+c. Again it should be noted that the function is defined in the local time frame of the step. Switching on gravity turn (setting as ‘1’) overrides the psi function. 
'## Sheet 2
Sheet 2 contains all the initial conditions of velocity, trajectory angle, X distance and altitude. Caution: Setting the initial velocity to zero causes a division by zero in the code causing it to fail. 
## Sheet 3
User needs to explicitly state how many time steps the solver should take. For example, data can be entered for 10 time steps, but setting ‘time steps’ on sheet 3 to ‘5’ will cause the solver compute the trajectory only for the first 5 time steps.
## Solver
trj_solve.m is the main program (and the one that should be run). trj_eqs is definition for the governing equations with user defined ‘psi’ (thrust vector). trj_eqs_gt.m is the definition for the governing equations with a gravity turn.


