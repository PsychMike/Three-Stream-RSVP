function [Events Parameters Stimuli_sets Block_Export Trial_Export Numtrials] = Demo(Parameters, Stimuli_sets, Trial, Blocknum, Modeflag, Events, Block_Export, Trial_Export, Demodata)
load('blockvars')
if strcmp(Modeflag,'InitializeBlock')
    clear Stimuli_sets
    KbName('UnifyKeyNames');
    
    see_cdft = 0;
    
    %Current image dimension: 300x200
    currentimage_width = 300;
    
    
    %%%%%%%Taken from Wyble/Potter 2013%%%%%%
    %Central images: 98x65
    centralimage_width = 98;
    
    %Parafoveal images: 130x85
    paraimage_width = 130;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    centralimagescale = 1 - .2 -.2;
    %     centralimage_width/currentimage_width;
    
    paraimagescale = paraimage_width/centralimage_width -.2;
    %     paraimage_width/currentimage_width;
    
    %Fixation Cross & Instructions
    ins = 82;
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'+','A category will display on the screen for a brief time,','followed by three streams of images.','Focus ONLY on the CENTER stream.','Keep your eyes on the fixation cross','and try to detect an object that fits the category you''re given.','You will be asked to report the object','at the end of the trial using your keyboard.','Press the Spacebar to continue to the experiment.'};
    %     stimstruct.wrapat = 70;
    %     stimstruct.vSpacing = 1;
    stimstruct.stimsize = 25;
    Stimuli_sets(ins) = Preparestimuli(Parameters,stimstruct);
    
    %Questions & Symbols
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'.',',','Type the object you saw that fit the category and then hit Enter. If you did not see the object, type the word "nothing".','What symbol did you see?'};
    stimstruct.wrapat = 70;
    stimstruct.stimsize = 50;
    Stimuli_sets(83) = Preparestimuli(Parameters,stimstruct);
    
    %Questions
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'What object did you see?','What symbol did you see?','Displayed stimuli:' 'Press Spacebar when ready'};
    stimstruct.stimsize = 50;
    Stimuli_sets(84) = Preparestimuli(Parameters,stimstruct);
    
    %Press Spacebar When Ready
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'(Press Spacebar when ready)','Now time for the real thing! The main experiment is loading..'};
    stimstruct.stimsize = 25;
    Stimuli_sets(85) = Preparestimuli(Parameters,stimstruct);
    
    %Displayed Targets (Feedback)
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'Displayed Target:','Clothing','Plumbing','Now things will speed up!','Here is an example trial'};
    stimstruct.stimsize = 50;
    Stimuli_sets(86) = Preparestimuli(Parameters,stimstruct);
    
    %Instructions
    stimstruct = CreateStimStruct('text');
    stimstruct.stimuli = {'That trial only displayed one object that fit the category.','When you only see one object that fits the displayed category,','type "nothing" when asked about a second object.','If you are confused about any of the instructions,','ask the researcher to help explain before you begin.','Press Spacebar when you are ready to continue to the main experiment','Here is another example trial, but faster!'};
    stimstruct.stimsize = 25;
    Stimuli_sets(87) = Preparestimuli(Parameters,stimstruct);
    
    %Example trial 1
    for ex1 = 5000:5019
        ex_num1 = ex1 - 4999;
        stimstruct = CreateStimStruct('image');
        stimstruct.stimuli =  {[num2str(ex1) '.jpg']};
        stimstruct.stimsize = centralimagescale;
        Stimuli_sets(89+ex_num1) = Preparestimuli(Parameters,stimstruct);
    end
    
    %Example trial 2
    for ex2 = 6000:6019
        ex_num2 = ex2 - 5999;
        stimstruct = CreateStimStruct('image');
        stimstruct.stimuli =  {[num2str(ex2) '.jpg']};
        stimstruct.stimsize = centralimagescale;
        Stimuli_sets(109+ex_num2) = Preparestimuli(Parameters,stimstruct);
    end
    
    %%%Bigger set (for periph)%%%
    addtosettomakebigger = 300;
    %Example trial 1
    for ex1 = 5000:5019
        ex_num1 = ex1 - 4999;
        stimstruct = CreateStimStruct('image');
        stimstruct.stimuli =  {[num2str(ex1) '.jpg']};
        stimstruct.stimsize = paraimagescale;
        Stimuli_sets(89+ex_num1+addtosettomakebigger) = Preparestimuli(Parameters,stimstruct);
    end
    
    %Example trial 2
    for ex2 = 6000:6019
        ex_num2 = ex2 - 5999;
        stimstruct = CreateStimStruct('image');
        stimstruct.stimuli =  {[num2str(ex2) '.jpg']};
        stimstruct.stimsize = paraimagescale;
        Stimuli_sets(109+ex_num2+addtosettomakebigger) = Preparestimuli(Parameters,stimstruct);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Numtrials = 3;
    
elseif strcmp(Modeflag,'InitializeTrial')
    
    %Center location of screen
    locx = Parameters.centerx;
    locy = Parameters.centery;
    
    Parameters.slowmotionfactor = 1;
    
    %Location Values
    
    %Parafoveal images centered at: central image width left & right
    para_offset = 275;
    %     centralimage_width*1.5;
    %     currentimage_width+currentimage_width/2;
    target_loc_left = locx - para_offset;
    target_loc_right = locx + para_offset;
    
%     feedback_symbol_locy = locy - 50;
    feedback_target_locy = locy + 50;
    feedback_category_locy = locy - 250;
    feedback_extratext_locy = locy - 175;
    
    %Timing Variables
    instruction_time = 0;
    
    start_time = .1;
    
    fixation_time = .2;
    
    %     starting_ins_y = -500;
    
    if Trial == 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Instructions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        screen_adj = 50;
        %         for instructions = 2:length(Stimuli_sets(ins))
        %             if instructions == 2
        %                 clear_screen = 'clear_yes';
        %             else
        %                 clear_screen = 'clear_no';
        %             end
        %             starting_ins_y = starting_ins_y + 100;
        %         Events = newevent_show_stimulus(Events,ins,instructions,locx,starting_ins_y,instruction_time,'screenshot_no',clear_screen);
        
        Events = newevent_show_stimulus(Events,ins,2,locx,locy-screen_adj*4,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,3,locx,locy-screen_adj*3,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,4,locx,locy-screen_adj*2,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,5,locx,locy-screen_adj,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,6,locx,locy,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,7,locx,locy+screen_adj,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,8,locx,locy+screen_adj*2,instruction_time,'screenshot_no','clear_no');
        Events = newevent_show_stimulus(Events,ins,9,locx,locy+screen_adj*3,instruction_time,'screenshot_no','clear_no');
%         Events = newevent_show_stimulus(Events,ins,10,locx,locy+screen_adj*4,instruction_time,'screenshot_no','clear_no');
        %         Events = newevent_show_stimulus(Events,ins,11,locx,locy+screen_adj*4,instruction_time,'screenshot_no','clear_no');
        %         Events = newevent_show_stimulus(Events,ins,12,locx,locy+screen_adj*5,instruction_time,'screenshot_no','clear_no');
        %
        %         end
        
        responsestruct = CreateResponseStruct;
        responsestruct.x = locx;
        responsestruct.y = locy;
        responsestruct.allowedchars = KbName('Space');
        
        Events = newevent_keyboard(Events,instruction_time,responsestruct);
        
        end_time = instruction_time + .01;
        
    elseif Trial == 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Example Trial 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        time_interval = .8;
        disp_time = 1.5 - time_interval; %time when the images start to display after fixation
        
        %Fixation Cross
        Events = newevent_show_stimulus(Events,ins,1,locx,locy,fixation_time,'screenshot_no','clear_yes');
        Events =  newevent_ParallelPort_mark(Events,fixation_time,Parameters.MARKERS.FIXATION); %EEG marker for fixation
        
        Events = newevent_show_stimulus(Events,86,2,locx,locy,start_time,'screenshot_no','clear_yes'); %category
        Events = newevent_show_stimulus(Events,86,5,locx,locy-300,start_time,'screenshot_no','clear_no'); %"Here is an example"
        Events = newevent_show_stimulus(Events,85,1,locx,locy+100,start_time,'screenshot_no','clear_no'); %press spacebar to continue
        
        responsestruct = CreateResponseStruct;
        
        responsestruct.x = locx;
        responsestruct.y = locy;
        
        responsestruct.allowedchars = KbName('Space');
        
        Events = newevent_keyboard(Events,start_time,responsestruct);
        
        Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval,'screenshot_no','clear_yes'); %fixation cross
        
        for ex_tar1 = 90:95
            ex_time1 = ex_tar1 - 89;
            Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,ex_tar1+25+addtosettomakebigger,1,target_loc_left,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1+10+addtosettomakebigger,1,target_loc_right,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
        end
        
        for ex_tar1 = 97:99
            ex_time1 = ex_tar1 - 90;
            Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,ex_tar1+25+addtosettomakebigger,1,target_loc_left,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1+10+addtosettomakebigger,1,target_loc_right,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
        end
        
        for ex_tar1 = 90:94
            ex_time1 = ex_tar1 - 81;
            Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,ex_tar1+25+addtosettomakebigger,1,target_loc_left,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1+10+addtosettomakebigger,1,target_loc_right,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
        end
        
        for ex_tar1 = 97:99
            ex_time1 = ex_tar1 - 83;
            Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,ex_tar1+25+addtosettomakebigger,1,target_loc_left,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1+10+addtosettomakebigger,1,target_loc_right,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar1,1,locx,locy,disp_time + time_interval * ex_time1,'screenshot_no','clear_no');
        end
        
%         post_pic_delay = rand*.5 +.7;
        
%         symbol_time = disp_time + (time_interval*18);
        
%         Events = newevent_blank(Events,symbol_time); %blanks screen
        
        %Symbol
%         Events = newevent_show_stimulus(Events,83,1,locx,locy,symbol_time+post_pic_delay,'screenshot_no','clear_yes');
        
        %Responsestruct
        responsestruct = CreateResponseStruct;
        responsestruct.x = locx;
        responsestruct.y = locy;
        
        object_question_time = disp_time + (time_interval*18);
        
        %What object did you see?
        Events = newevent_show_stimulus(Events,84,1,locx,locy,object_question_time,'screenshot_no','clear_yes');
        
        object_answer_time = object_question_time + .01;
        
        %Word Responsestruct
        responsestruct = CreateResponseStruct;
        responsestruct.showinput = 1;
        responsestruct.x = locx - 100;
        responsestruct.y = locy + 100;
        responsestruct.maxlength = 50;
        responsestruct.minlength = 3;
        responsestruct.allowbackspace = 1;
        responsestruct.waitforenter = 1;
        
        allowed = [];
        for letter = 'abcdefghijklmnopqrstuvwxyz'
            allowed = [allowed KbName(letter)];
        end
        
        responsestruct.allowedchars = [allowed KbName('Space')];
        
        [Events,reported_object] = newevent_keyboard(Events,object_answer_time,responsestruct);
        
        %         symbol_question_time = object_answer_time + .01;
        
        %         %What symbol did you see?
        %         Events = newevent_show_stimulus(Events,84,2,locx,locy,symbol_question_time,'screenshot_no','clear_yes');
        %
        %         symbol_answer_time = symbol_question_time + .01;
        %
        %         %Symbol Responsestruct
        %         responsestruct = CreateResponseStruct;
        %         responsestruct.showinput = 1;
        %         responsestruct.x = locx;
        %         responsestruct.y = locy+100;
        %         responsestruct.maxlength = 1;
        %         responsestruct.minlength = 1;
        %         responsestruct.fontsize = 65;
        %         responsestruct.allowbackspace = 1;
        %         responsestruct.waitforenter = 1;
        %         responsestruct.allowedchars = [KbName('.>'),KbName(',<')];
        %
        %         [Events,symbol_response] = newevent_keyboard(Events,symbol_answer_time,responsestruct);
        %
        %Feedback
        feedback_time = object_answer_time + .01;
        
%         Events = newevent_show_stimulus(Events,83,1,locx,feedback_symbol_locy,feedback_time,'screenshot_no','clear_yes'); %symbol feedback
        Events = newevent_show_stimulus(Events,95,1,locx,feedback_target_locy,feedback_time,'screenshot_no','clear_yes'); %probed target
        Events = newevent_show_stimulus(Events,86,2,locx,feedback_category_locy,feedback_time,'screenshot_no','clear_no'); %displayed category
        Events = newevent_show_stimulus(Events,86,1,locx,feedback_extratext_locy,feedback_time,'screenshot_no','clear_no'); %displayed targets (feedback)
        
        responsestruct = CreateResponseStruct;
        responsestruct.x = locx;
        responsestruct.y = locy;
        responsestruct.allowedchars = KbName('Space');
        
        Events = newevent_show_stimulus(Events,85,1,locx,locy+300,feedback_time,'screenshot_no','clear_no');
        
        Events = newevent_keyboard(Events,feedback_time,responsestruct);
        
        %End trial
        end_time = feedback_time + 1;
        
    elseif Trial == 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Example Trial 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        time_interval = .3;
        
        %Fixation Cross
        Events = newevent_show_stimulus(Events,ins,1,locx,locy,fixation_time,'screenshot_no','clear_yes');
        Events =  newevent_ParallelPort_mark(Events,fixation_time,Parameters.MARKERS.FIXATION); %EEG marker for fixation cross
        
        Events = newevent_show_stimulus(Events,86,3,locx,locy-50,start_time,'screenshot_no','clear_yes'); %Example category
        Events = newevent_show_stimulus(Events,87,7,locx,locy-300,start_time,'screenshot_no','clear_no'); %"Here is an example"
        Events = newevent_show_stimulus(Events,85,1,locx,locy+50,start_time,'screenshot_no','clear_no'); %Press Spacebar when ready
        
        responsestruct = CreateResponseStruct;
        
        responsestruct.x = locx;
        responsestruct.y = locy;
        
        responsestruct.allowedchars = KbName('Space');
        
        Events = newevent_keyboard(Events,start_time,responsestruct);
        
        Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval,'screenshot_no','clear_yes'); %fixation cross
        
        for ex_tar2 = 110:118
            ex_time2 = ex_tar2 - 109;
            Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,ex_tar2-20+addtosettomakebigger,1,target_loc_left,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar2+10+addtosettomakebigger,1,target_loc_right,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar2,1,locx,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_no');
        end
        
        for ex_tar2 = 110:117
            ex_time2 = ex_tar2 - 100;
            Events = newevent_show_stimulus(Events,ins,1,locx,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_yes');
            Events = newevent_show_stimulus(Events,ex_tar2-20+addtosettomakebigger,1,target_loc_left,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar2+10+addtosettomakebigger,1,target_loc_right,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_no');
            Events = newevent_show_stimulus(Events,ex_tar2,1,locx,locy,disp_time + time_interval * ex_time2,'screenshot_no','clear_no');
        end
        
        %         post_pic_delay = rand*.5 +.7;
        
        %         symbol_time = disp_time + (time_interval*17);
        
        %Symbol
        %         Events = newevent_show_stimulus(Events,83,2,locx,locy,symbol_time+post_pic_delay,'screenshot_no','clear_yes');
        
        %Responsestruct
        responsestruct = CreateResponseStruct;
        responsestruct.x = locx;
        responsestruct.y = locy;
        
        %         object_question_time = symbol_time + post_pic_delay + .3;
        object_question_time = disp_time + (time_interval*17);
        
        %What object did you see?
        Events = newevent_show_stimulus(Events,84,1,locx,locy,object_question_time,'screenshot_no','clear_yes');
        
        object_answer_time = object_question_time + .01;
        
        %Word Responsestruct
        responsestruct = CreateResponseStruct;
        responsestruct.showinput = 1;
        responsestruct.x = locx - 100;
        responsestruct.y = locy + 100;
        responsestruct.maxlength = 50;
        responsestruct.minlength = 3;
        responsestruct.allowbackspace = 1;
        responsestruct.waitforenter = 1;
        
        allowed = [];
        for letter = 'abcdefghijklmnopqrstuvwxyz'
            allowed = [allowed KbName(letter)];
        end
        
        responsestruct.allowedchars = [allowed KbName('Space')];
        
        [Events,reported_object] = newevent_keyboard(Events,object_answer_time,responsestruct);
        
        %         symbol_question_time = object_answer_time + .01;
        
        %What symbol did you see?
%         Events = newevent_show_stimulus(Events,84,2,locx,locy,symbol_question_time,'screenshot_no','clear_yes');
        
        %         symbol_answer_time = symbol_question_time + .01;
        %
        %         %Symbol Responsestruct
        %         responsestruct = CreateResponseStruct;
        %         responsestruct.showinput = 1;
        %         responsestruct.x = locx;
        %         responsestruct.y = locy+100;
        %         responsestruct.maxlength = 1;
        %         responsestruct.minlength = 1;
        %         responsestruct.fontsize = 65;
        %         responsestruct.allowbackspace = 1;
        %         responsestruct.waitforenter = 1;
        %         responsestruct.allowedchars = [KbName('.>'),KbName(',<')];
        %
        %         [Events,symbol_response] = newevent_keyboard(Events,symbol_answer_time,responsestruct);
        
        %Feedback
        %         feedback_time = symbol_answer_time + .01;
        feedback_time = object_answer_time + .01;
        
        %         Events = newevent_show_stimulus(Events,83,2,locx,feedback_symbol_locy,feedback_time,'screenshot_no','clear_yes'); %symbol feedback
        Events = newevent_show_stimulus(Events,118,1,locx,feedback_target_locy,feedback_time,'screenshot_no','clear_yes'); %probed target
        Events = newevent_show_stimulus(Events,86,2,locx,feedback_category_locy,feedback_time,'screenshot_no','clear_no'); %displayed category
        Events = newevent_show_stimulus(Events,86,1,locx,feedback_extratext_locy,feedback_time,'screenshot_no','clear_no'); %displayed targets (feedback)
        
        responsestruct = CreateResponseStruct;
        responsestruct.x = locx;
        responsestruct.y = locy;
        responsestruct.allowedchars = KbName('Space');
        
        Events = newevent_show_stimulus(Events,85,1,locx,locy+300,feedback_time,'screenshot_no','clear_no');
        
        Events = newevent_keyboard(Events,feedback_time,responsestruct);
        
        continue_time = feedback_time + .01;
        
        Events = newevent_show_stimulus(Events,85,2,locx,locy,continue_time,'screenshot_no','clear_yes'); %end of practice trials
        
        %End trial
        end_time = continue_time + .01;
    end
    
    Events = newevent_end_trial(Events,end_time);
    
elseif strcmp(Modeflag,'EndTrial')
elseif strcmp(Modeflag,'EndBlock')
    
else   %Something went wrong in Runblock (You should never see this error)
    error('Invalid modeflag');
end
saveblockspace
end