



% HOVEDFUNKSJON

function main()
    telefon_nr = input('Vennligst skriv inn ditt telefonnummer: ', 's');    
    lag_og_spill_toner(telefon_nr);
    
end


function filteret = lagFiltre()
    filteret = [];
    frekvenser = [697 770 852 941 1209 1336 1477];
    Fs = 8000;
    bredde = 300;
    n = 0:bredde-1;
    
    for i=1:length(frekvenser)
        w0 = 2*pi*frekvenser(i)/Fs;
        am = 2*cos(w0*n)/bredde;
        
        filteret = [filteret; am];
  
        %Plotter båndfiltrene!
        [h w] = freqz(am, 1, bredde);
        d = w*Fs/(2*pi);
        plot(d, abs(h));
        axis ([0 2000 0 1]);
        hold on
    end
end

function tallene = finn_tall(toner)
    Fs = 8000;
    sum = 0;
    bredde = 300;
    frekvenser = [697 770 852 941 1209 1336 1477];
    toneLengde = Fs*0.2;
    pauseLengde = Fs*0.05;
    antallTall = round(length(toner)/(toneLengde + pauseLengde));
    filter2 = lagFiltre();
    tallene = [];
    
    for s=0:antallTall-1
        resultat = [];
        start = round((s*(toneLengde + pauseLengde)) + 1);
        slutt = round((s*(toneLengde + pauseLengde)) + toneLengde);
        tone = toner(start:slutt);
        for t=1:length(frekvenser)
            filter1 = filter(filter2(t,1:bredde),1,tone);
            if (max(filter1) > 0.75)
                resultat = [resultat t];
            end
        end
        frekvens1 = frekvenser(resultat(1));
        frekvens2 = frekvenser(resultat(2));
        sum = frekvens1 + frekvens2;
        tallene = [tallene frekvensTilTall(sum)];
    end 
end      

% LAGER OG SPILLER AV TONENE
function toner = lag_og_spill_toner(tall)
    

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
    %Finner nummeret utifra lyden
    k=['Nummeret var: ' finn_tall(toner)];
    disp(k);
end

function tall = frekvensTilTall(sum)
    switch(sum)
        case(697+1209)
            tall = '1';
        case(697+1336)
            tall = '2';
        case(697+1477)
            tall = '3';
        case(770+1209)
            tall = '4';
        case(770+1336)
            tall = '5';
        case(770+1477)
            tall = '6';
        case(852+1209)
            tall = '7';
        case(852+1336)
            tall = '8';
        case(852+1477)
            tall = '9';
        case(941+1209)
            tall = '*';
        case(941+1336)
            tall = '0';
        case(941+1477)
            tall = '#';
        otherwise
            tall = 'FEIL!';
            
    end
            
end


