%% *Project*
% *Part 1*



function main()
    telefon_nr = input('Vennligst skriv inn dit telefonnummer: ', 's');
    lag_toner(telefon_nr);
    %play_sound(toner);
    
    
    
end

function lag_toner(tall)
    
    kolonner = [1209, 1336, 1477];
    rader = [697, 770, 852, 941];
    total = [];
    for i=1:4
        for s =1:3
            total = [ total [rader(i); kolonner(s)]];
        end
    end
    disp(total)
    
    Fs = 8000;
    tmin = 0;
    tmax = 0.2;
    dt = 1/Fs;
    t = tmin:dt:tmax;
    toner = [];
    disp(tall)
    for i= tall
        
        siffer = i;
        disp(siffer);
        
        if siffer=='#'||siffer=='*'||siffer=='0'||siffer=='1'||siffer=='2'||siffer=='3'||siffer=='4'||siffer=='5'||siffer=='6'||siffer=='7'||siffer=='8'||siffer=='9'

            if siffer == '#'
                siffer = '12';
            elseif siffer == '*'
                siffer = '10';
            elseif siffer == '0'
                siffer = '11';
            end
            x1 = cos(total(1,str2num(siffer))*2*pi*t);
            x2 = cos(total(2,str2num(siffer))*2*pi*t);
            y = conv(x1,x2);
            toner = [toner; y];
        
        else
            disp('Det finnes en feil i nummeret du oppgav. Proev igjen.');
            main()
            
        end
    end
    
    
end



