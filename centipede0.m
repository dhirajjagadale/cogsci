%Experimental parameters
clear all;
rand('state', sum(100*clock)); 
Screen('Preference', 'SkipSyncTests', 1);
22
ErrorDelay=1; interTrialInterval = 0.1; 

KbName('UnifyKeyNames');
Key1=KbName('LeftArrow'); Key2=KbName('RightArrow');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');
corrkey = [80, 79]; % l eft and right arrow
gray = [127 127 127 ]; white = [ 255 255 255]; black = [ 0 0 0]; red = [255 0 0];
bgcolor = white; textcolor = black; textcolor1 = red;
siz=30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Login prompt and open file for writing data out
prompt = {'Outputfile', 'Subject''s number'};
defaults = {'ChoiceRT', '98'};
answer = inputdlg(prompt, 'CP', 2, defaults);
[output, subid] = deal(answer{:}); % all input variables are strings
outputname = [output subid '.csv'];

if exist(outputname)==2 % check to avoid overiding an existing file
    fileproblem = input('That file already exists! Append a .x (1), overwrite (2), or break (3/default)?');
    if isempty(fileproblem) | fileproblem==3
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end
outfile = fopen(outputname,'w'); % open a file for writing data out
fprintf(outfile, 'subid \t trialid \t Response \t ReactionTime \t \n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Screen parameters
[mainwin, screenrect] = Screen(0,'OpenWindow');
Screen('FillRect', mainwin, bgcolor);
center = [screenrect(3)/2 screenrect(4)/2];
Screen(mainwin, 'Flip');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Experimental instructions, wait for a spacebar response to start
timeStart = GetSecs;
%%%%%%%
Screen('FillRect', mainwin ,bgcolor);
Screen('TextSize', mainwin, siz);
Screen('DrawText',mainwin,'Calm Down' ,center(1)-50,center(2),textcolor);
Screen('Flip',mainwin );
rt=GetSecs-timeStart;
fprintf(outfile, '%6.2f\t \n', rt);
WaitSecs(50);
Screen('FillRect', mainwin ,bgcolor);
Screen('Flip',mainwin );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%change_here 
Player1 = 'Shubhi';
Player2 = 'Mayank';
%real game
trl = Player1;
p1=0;
p2=0;
for j = 1:10
    if(j==1 || j==3 || j==5 || j==7 || j==9)
        trl = Player1;
    elseif(j==2 || j==4 || j==6 || j==8 || j==10)
        trl = Player2;
    end
    if (j<6)
        plr1 = 2;
        plr2 = 1;
        else
        plr1 = 4;
        plr2 = 1;
    end
    for i = 1:10
       time1=GetSecs;
       keyIsDown=0;   correct=0; rt=0; out=0;
        %% keyboard response
        time2=GetSecs;
        prob=rand(1,1);
        if (prob>((i-1)/10))
            while (time2-time1)<6
                Screen('FillRect', mainwin ,bgcolor);
                Screen('TextSize', mainwin, siz);
                Screen('DrawText',mainwin,[Player1 ' : ' int2str(plr1)]  ,center(1)-350,center(2)-20,textcolor);
                Screen('DrawText',mainwin,[Player2 ' : ' int2str(plr2)] ,center(1)+300,center(2)-20,textcolor);
                Screen('DrawText',mainwin,['Turn :' trl ] ,center(1)-100,center(2)-100,textcolor1);
                Screen('DrawText',mainwin,['Turn No. :' int2str(i) '/' int2str(10) ] ,center(1)-50,center(2)+250,textcolor);  
                if ((time2-time1)<5 && time2-time1>0)
                Screen('DrawText',mainwin,['Time Remaining:' int2str(5-time2+time1)],center(1)-200,center(2)+100,textcolor1);
                Screen('Flip',mainwin );
                end
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('keyDown');
                if (time2-time1)>5
                     if keyIsDown
                            if keyCode(Key1)
                            rt =(GetSecs-timeStart);
                            temp=plr1;
                            plr1=plr2*2;
                            plr2=temp*2;
                            if strcmp(trl,Player1)
                            trl = Player2;
                            else
                            trl = Player1;
                            end
                            correct=0;
                            fprintf(outfile, '%s\t %d\t %d\t %6.2f\t \n', subid, i, correct, rt);
                            break;
                            elseif keyCode(Key2)
                            rt =(GetSecs-timeStart);
                            correct=1;
                            out=1;
                            fprintf(outfile, '%s\t %d\t %d\t %6.2f\t \n', subid, i, correct, rt);
                            break;
                            end
                       end 
                        keyIsDown=0; keyCode=0;
                end 
                    time2=GetSecs;
            end          
        else
            plr1=0;
            plr2=0;
            rt=(GetSecs-timeStart);
            correct=4;
            fprintf(outfile, '%s \t %d \t %d \t %6.2f \t \n', subid, i, correct, rt);
            break;
        end        
        Screen('FillRect', mainwin ,bgcolor); Screen('Flip', mainwin);
        if((time2-time1)>6 && correct==0)
            plr1=0;
            plr2=0;
            rt=(GetSecs-timeStart);
            correct=3;
            fprintf(outfile, '%s \t %d \t %d \t %6.2f \t \n', subid, i, correct, rt);
            break;
        end
        if(out==1)
            break;
        end
        % write data out
        if(i==10 && correct==1)
            plr1=0;
            plr2=0;
            correct=2;
            rt=(GetSecs-timeStart);
            fprintf(outfile, '%s \t %d \t %d \t %6.2f \t \n', subid, i, correct, rt);
        end
        WaitSecs(interTrialInterval); 
    end
Screen('FillRect', mainwin ,bgcolor);
Screen('TextSize', mainwin, siz);  
Screen('DrawText',mainwin,['Game Over']  ,center(1)-350,center(2)-150,textcolor1);
Screen('DrawText',mainwin,[Player1 ' : ' int2str(plr1)]  ,center(1)-350,center(2)-20,textcolor);
Screen('DrawText',mainwin,[Player2 ' : ' int2str(plr2)] ,center(1)+300,center(2)-20,textcolor);
Screen('Flip',mainwin );
keyIsDown=0;
pro=rand(1,1);
p1=p1+plr1*pro;
p2=p2+plr2*pro;
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break ;
        elseif keyCode(escKey)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
end
fprintf(outfile, '%s\t \n', subid );
end
Screen('FillRect', mainwin ,bgcolor);
Screen('TextSize', mainwin, siz);  
Screen('DrawText',mainwin,['10 Games Over']  ,center(1)-350,center(2)-150,textcolor1);
Screen('DrawText',mainwin,[Player1 ' : ' int2str(p1)]  ,center(1)-350,center(2)-20,textcolor);
Screen('DrawText',mainwin,[Player2 ' : ' int2str(p2)] ,center(1)+300,center(2)-20,textcolor);
Screen('Flip',mainwin );
WaitSecs(10);


Screen('CloseAll');
fclose(outfile);
fprintf('\n\n\n\n\nFINISHED this part! PLEASE GET THE EXPERIMENTER...\n\n');
