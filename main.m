%% *Project*
% Part 1



% HOVEDFUNKSJON

function main()
    telefon_nr = input('Vennligst skriv inn ditt telefonnummer: ', 's');    
    lag_og_spill_toner(telefon_nr);    
end

% LAGER OG SPILLER AV TONENE
function lag_og_spill_toner(tall)
    

    % Her lager vi en matrise der hver kolone tilsvarer frekvensparene som representerer tastetrykket 
    kolonner = [1209, 1336, 1477];
    rader = [697, 770, 852, 941];
    total = [];
    for i=1:4
        for s =1:3
            total = [ total [rader(i); kolonner(s)]];
        end
    end

    % Her lager vi variabelene vi skal bruke
    Fs = 8000;      % Samplingsfrekvens
    dt = 1/Fs;      % Perioden
    t = 0:dt:0.2;   % Matrise for tiden ved hver sampling
    stille = zeros(1,Fs*0.05);   % Pause mellom tonene. 8000*0.05 = 400
    toner = [];     % Oppretter matrise som vi skal legge alle tonene inn i

    for i= tall
        siffer = i;
        % Sjekker om det fins ugyldig input
        if siffer=='#'||siffer=='*'||siffer=='0'||siffer=='1'||siffer=='2'||siffer=='3'||siffer=='4'||siffer=='5'||siffer=='6'||siffer=='7'||siffer=='8'||siffer=='9'
            % Endrer verdien for 0, * og # for å få riktig indeks i 'total'
            if siffer == '#'
                siffer = '12';
            elseif siffer == '*'
                siffer = '10';
            elseif siffer == '0'
                siffer = '11';
            end
            
            % Genererer signalet, og legger det til i toner
            x1 = cos(total(1,str2num(siffer))*2*pi*t);
            x2 = cos(total(2,str2num(siffer))*2*pi*t);
            y = x1+x2;      % Legger sammen de to signalene
            toner = [toner y];
            toner = [toner stille];
        
        else
            % Hvis det finnes ugyldig input, kaller den programmet på nytt.
            disp('Det finnes en feil i nummeret du oppgav. Proev igjen.');
            toner = [];
            main()
            break
            
            
        end
        
    end
    % Spiller av tonene med riktig frekvens
    sound(toner, Fs);
    
end



