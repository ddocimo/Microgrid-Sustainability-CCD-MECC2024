%% runThis.m
%{
The purpose of this code is to enable simulation of a microgrid powering a
data center. This code supplements the following paper, originally
presented at the 2024 Modeling, Estimation and Control Conference (MECC).
Please cite the paper if you use this code for any work:  

\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Jahan, T. R., Ouedraogo, A. S., & Docimo, D. J. (2024). A Study on Control
Co-Design for Optimizing Microgrid Sustainability. IFAC-PapersOnLine,
58(28), 636-641.  
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

The paper is available for free at the following link:
https://doi.org/10.1016/j.ifacol.2025.01.037

Note that the function calc_x_a.m will be generated or overwritten each run
of the code. This is required for the simulation to run properly. If any
extra copies are generated (usually by switching folders when running the
code), please delete those.
%}

clear all
close all
clc

% Add path for functions folder:
addpath(genpath("./Functions/"));

%% User-Defined Settings

% Select the number of lithium-ion battery cells in parallel (needs to be
% between 10,000 and 28,000):
selected_NparLi = 28000;

% Select the value of the duty cycle perturbation magnitude (needs to be
% betweeen 0.01 and 0.06):
selected_deltaU = 0.01;

% Select the final simulation time in seconds, to be no more than 24*3600:
t_final = 3600*24;

% Load the map for P_{load,ref}=P_dem [W] vs. time t [s]. This is a scaled
% version based on Wang et al.'s 2012 work as cited in the paper. The
% profile information in "dc_profile" can be overwritten if other data
% center demands are to be tested. The end time in the map should be >=
% 87000 seconds, and the time step should not be smaller than 1 second:  
load('DC_Power.mat')

% Load the maps for environmental conditions the, T_{inf}=Tamb [deg C] and
% irradiation G=irrad [W/m^2]. The data in "amb_profile" can be
% overwritten, with the same conditions as listed previously:
load('Amb_Cond.mat')

%% Simulation and Plotting

% Run the code to simulate the system:
[t,x,u,P,J,var_names] = coreCode(selected_NparLi,selected_deltaU,t_final,dc_profile,amb_profile);
    % t         = time vector
    % x         = key states 
    % u         = inputs
    % P         = key power flows
    % var_names = identifying descriptions for the above variables

% Example plots:
figure
subplot(2,1,1)
hold on
plot(dc_profile.t/3600,dc_profile.P_dem,'k','linewidth',2)
plot(t/3600,P(1,:),'b','linewidth',2)
xlabel('Time [h]')
ylabel(var_names.P{1})
xlim([0 t_final/3600])
subplot(2,1,2)
plot(t/3600,x(8,:),'b','linewidth',2)
xlabel('Time [h]')
ylabel(var_names.x{8})
xlim([0 t_final/3600])
