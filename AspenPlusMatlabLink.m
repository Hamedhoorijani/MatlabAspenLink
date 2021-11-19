clc
clear all
global Aspen
Aspen = actxserver('Apwn.Document.34.0'); %34.0 ---> V8.8; 35.0 ---> V9.0; and 36.0 ---> V10.0
[stat,mess]=fileattrib; % get attributes of folder (Necessary to establish the location of the simulation)
Simulation_Name = 'Test';% Aspeen Plus Simulation Name
Aspen.invoke('InitFromArchive2',[mess.Name '\' Simulation_Name '.bkp']);
Aspen.Visible = 1; % 1 ---> Aspen is Visible; 0 ---> Aspen is open but not visible
Aspen.SuppressDialogs = 1; % Suppress windows dialogs.
Aspen.Engine.Run2(1); % Run the simulation
x=[3 1.6 0.7];
Aspen.Tree.FindNode('\Data\Blocks\B3\Input\PRES').Value=x(1,1);
Aspen.Tree.FindNode('\Data\Streams\FEED\Input\PRES\MIXED').Value=x(1,2);
Aspen.Tree.FindNode('\Data\Blocks\B2\Input\VFRAC').Value=x(1,3);

 Aspen.Reinit;
 pause(4)
Aspen.Engine.Run2(1); % Run the simulation
while Aspen.Engine.IsRunning == 1 % 1 --> If Aspen is running; 0 ---> If Aspen stop.
    pause(0.5);
end

Conv = Aspen.Tree.FindNode('\Data\Results Summary\Run-Status\Output\PER_ERROR').Value; %Convergence Assessment
if Conv==0
    QCalc=Aspen.Tree.FindNode('\Data\Blocks\B2\Output\QCALC').Value;
    CQ=Aspen.Tree.FindNode('\Data\Blocks\B3\Output\QCALC').Value;
    Obj=CQ+QCalc; %optimizing objective function
else
    Obj  = 2e7; %Penalty
end
Aspen.Close;
Aspen.Quit;