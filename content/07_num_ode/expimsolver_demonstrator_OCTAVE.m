%graphics_toolkit (gt)

close all
clearvars

fi.fig = figure(1,'position',[0.5 0.5 1450 700]);
fi.ax = axes("position",[0.05 0.3 0.6 0.7]);
% get(0,"screensize")/2);%


function updatefig(obj, init)
  %global y0 tmin tmax tspan g g0 h_i lambda fi
  if nargin <2
    init = false;
  else
    init = true;
  endif
  
  fi = guidata(obj);
  replot = false;
  recalc = false;
  switch (obj)
    case {fi.update_button}
      recalc = true;
      replot = true;
    case {fi.quit_button}  
      close all;  
    case {fi.h_e_slide,fi.h_i_slide,fi.y0_slide,fi.update_button,fi.lambda_slide}
      recalc = true;
    case {fi.g_field}
      recalc = true;
  endswitch
  
  if (recalc || init)
    %% Input-Params
    h_e = get(fi.h_e_slide, 'value');
    fi.h_i = get(fi.h_i_slide, 'value');
    y0 = get(fi.y0_slide, 'value');
    fi.lambda = get(fi.lambda_slide, 'value');
    fi.fcn_g = str2func(get(fi.g_field,'string'));
    
    %% Explizite Form der DGL mit g nach finiter Differenz abgeleitet
    fi.fcn_proth = @(t,y) - fi.lambda* (y - fi.fcn_g(t)) + (fi.fcn_g(t+fi.h_i)-fi.fcn_g(t-fi.h_i))/(2*fi.h_i);
    
    %% Timescale
    tmin = 0;
    tmax = 10;
    tspan = tmin:0.1:tmax;
    
    %% Annäherungsfunktion
    g0 = fi.fcn_g(0);
    
    %% Schrittweite fuer explizite Loesung
    %h_lim = 2/abs(lambda);
    %h_e = 0.5 * h_lim;

    %% Loesung mit explizitem Eulerverfahren
    t_e = tmin:h_e:tmax;
    fi.y_e = zeros(size(t_e));
    y_e(1) = y0;
    for i = 2:length(t_e)
        y_e(i) = y_e(i-1) + h_e * fi.fcn_proth(t_e(i-1),y_e(i-1));
    end

    %% Loesung mit implizitem Eulerverfahren
    t_i = tmin:fi.h_i:tmax;
    y_i=zeros(size(t_i));
    y_i(1)=y0;
    for i = 2:length(t_i)
        %y_i(i) = ( y_i(i-1) + fi.h_i*fi.lambda*fi.fcn_g(t_i(i))) / (1+fi.h_i*fi.lambda);
        y_i(i) = ( y_i(i-1) + fi.h_i*fi.lambda*fi.fcn_g(t_i(i)) + fi.fcn_g(t_i(i))-fi.fcn_g(t_i(i-1))) / (1+fi.h_i*fi.lambda);
    end

    %% Graphische Ausgabe
    replot = true;
  endif
  
  if (replot)
    fi.plot = plot(t_i,y_i,t_e,y_e,tspan, fi.fcn_g(tspan) + exp(-fi.lambda*tspan)*(y0-g0), tspan, exp(-fi.lambda*tspan)*(y0-g0));
    
    fi.plotlabel = legend('implicit solution', 'explicit solution', 'exact solution', 'e-function contribution');
    
    %set(get(fi.ax,'title'),'string', sprintf('lambda = %.1f, h_e = %.3f', lambda, h_e));
    fi.h_e_label = uicontrol ("style", "text",...
                          "string", sprintf("h for explicit solver = %.3f, %d steps", h_e, tmax/h_e),...
                          "horizontalalignment", "left",...
                          "position", [600,10,400,30]);
                          
    
    fi.h_i_label = uicontrol ("style", "text",...
                          "string", sprintf("h for implicit solver = %.3f, %d steps", fi.h_i, tmax/fi.h_i),...
                          "horizontalalignment", "left",...
                          "position", [600,40,400,30]);
                          
    fi.y0_label = uicontrol ("style", "text",...
                          "string", sprintf("y0 for both solvers = %.2f", y0),...
                          "horizontalalignment", "left",...
                          "position", [600,70,300,30]);
                          
    fi.lambda_label = uicontrol ("style", "text",...
                          "string", sprintf("lambda = %.2f", fi.lambda),...
                          "horizontalalignment", "left",...
                          "position", [600,100,300,30]);
                          
    fi.lambda_check_label = uicontrol ('style', 'text',...
                          'string', sprintf('h_e = %.1f * h_lim (h_lim = 2/abs(lambda))', h_e / (2/abs(fi.lambda))),...
                          'horizontalalignment','left',...
                          'position', [900, 100, 500, 30]);
    
    if h_e / (2/abs(fi.lambda)) >= 1
      %set (get(fi.lambda_check_label,'string'), 'color', 'red');
      set (fi.lambda_check_label, 'foregroundcolor', 'red');
      set (fi.lambda_check_label, 'string', sprintf('h_e = %.1f * h_lim (h_lim = 2/abs(lambda)), divergence!', h_e / (2/abs(fi.lambda))));
    endif

  endif
endfunction

fi.update_button = uicontrol('style','pushbutton',...
                      'string','Update',...
                      'callback',@updatefig,...
                      'position',[10,10,100,30]);

fi.quit_button = uicontrol('style','pushbutton',...
                      'string','Quit',...
                      'callback',@updatefig,...
                      'position',[1000,10,100,30]);

fi.h_e_slide = uicontrol('style','slider',...
                      'min',0.01,...
                      'max',2,...
                      'value',0.5,...
                      'callback',@updatefig,...
                      'position',[150,10,400,30]);

fi.h_i_slide = uicontrol('style','slider',...
                      'min',0.01,...
                      'max',2,...
                      'value',0.5,...
                      'callback',@updatefig,...
                      'position',[150,40,400,30]);

fi.y0_slide = uicontrol('style','slider',...
                      'min',0.1,...
                      'max',10,...
                      'value',0.1,...
                      'callback',@updatefig,...
                      'position',[150,70,400,30]);

fi.lambda_slide = uicontrol('style','slider',...
                      'min',0.01,...
                      'max',10,...
                      'value',2,...
                      'callback',@updatefig,...
                      'position',[150,100,400,30]);

fi.g_field = uicontrol('style','edit',...
                      'string','@(t) cos(t)',...
                      'callback',@updatefig,...
                      'position',[1000,70,400,30]);
                      
set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"))
guidata(gcf,fi);
updatefig(gcf,true);