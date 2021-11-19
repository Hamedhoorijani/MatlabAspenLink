%% Linking
function Obj=AspenMatlabLINK(x)
    global Aspen 
      Aspen.Tree.FindNode('\Data\Blocks\B3\Input\PRES').Value=x(1,1);
      Aspen.Tree.FindNode('\Data\Streams\FEED\Input\PRES\MIXED').Value=x(1,2);
      Aspen.Tree.FindNode('\Data\Blocks\B2\Input\VFRAC').Value=x(1,3);


    Aspen.Reinit;
    Aspen.Engine.Run2(1); % Run the simulation
    while Aspen.Engine.IsRunning == 1 % 1 --> If Aspen is running; 0 ---> If Aspen stop.
        pause(0.5);
    end

    Conv = Aspen.Tree.FindNode('\Data\Results Summary\Run-Status\Output\PER_ERROR').Value; %Convergence Assessment
    if Conv==0
%         RDuty=Aspen.Tree.FindNode('\Data\Blocks\B2\Output\REB_DUTY').Value; %Duty value of reactive column
        QCalc=Aspen.Tree.FindNode('\Data\Blocks\B2\Output\QCALC').Value;
%         CDuty=Aspen.Tree.FindNode('\Data\Blocks\B2\Output\COND_DUTY').Value; %Duty value of reactive column
        CQ=Aspen.Tree.FindNode('\Data\Blocks\B3\Output\QCALC').Value;
        Obj=CQ+QCalc; %optimizing objective function
    else
        Obj  = 2e7; %Penalty
    end

% Aspen.Close;
% Aspen.Quit;
end

    