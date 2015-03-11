

% HOVEDFUNKSJON


function main()
    filename = 'test.mat';
    m = importdata(filename);
    disp(finn_tall(m));

    
end


function filteret = lagFiltre(Fs, bredde, frekvenser) %Funksjon som oppretter filteret
    filteret = []; %Oppretter en matrise til filteret
    n = 0:bredde-1; %Tallrekke fra 0 til bredde-1
    
    for i=1:length(frekvenser) %For-løkke som går gjennom alle frekvensene
        w0 = 2*pi*frekvenser(i)/Fs; %Vinkelfrekvens
        am = 2*cos(w0*n)/bredde; %Frekvenverdier til systemet/Signal vi ønsker å slippe gjennom BP-filteret
    
        filteret = [filteret; am]; %Legger frekvensverdier til i filteret
  
        %Plotter et filter i tidsdomenet
%         plot(am);
%          axis ([0 20 -0.005 0.005]);
%         %Plotter båndfiltrene i frekvensdomenet!
        [h w] = freqz(am, 1, bredde); %Beregner frekvensresponsen
%         plot(h);
        
        d = w*Fs/(2*pi); %
        plot(d, abs(h)); %Plotter BP-filterer
        axis ([0 2000 0 1]); %Setter aksene
        hold on %Legger alle plottene i samme figur
    end
end

function tallene = finn_tall(toner) %Funksjon som finner hvilke tall som er trykket utifra frekvensene
    Fs = 8000; %Samplingsfrekvens
    sum = 0; %Sum av frekvenser
    bredde = 300; %Bredden på filteret/Antall punkter
    frekvenser = [697 770 852 941 1209 1336 1477];%Frekvensene
    treffrate = 0.2;
    test = [];
    
    toneLengde = Fs*0.2; %Hvor lang hver tone er
    pauseLengde = Fs*0.05; %Hvor lang hver pause er
    antallTall = round(length(toner)/(toneLengde + pauseLengde)); %Finner antall tall som er trykker
    filter2 = lagFiltre(Fs, bredde, frekvenser); %Henter filtrene fra lagFiltre() som filter2
    tallene = []; %Tom matrise som vi ende opp med tallene som er trykket
    
    for s=0:antallTall-1 %Går gjennom alle tallene som er trykket
        resultat = []; %Tom matrise som vil inneholde frekvensene som er gått gjennom filteret
        start = round((s*(toneLengde + pauseLengde)) + 1); %Når de ulike tonene starter
        slutt = round((s*(toneLengde + pauseLengde)) + toneLengde); %Når de ulike tonene slutter
        tone = toner(start:slutt); %Fjerner alt annet enn kun den aktuelle tonen
        %Tone til frekvensdomenet
        
        
        
        for t=1:length(frekvenser) %Går gjennom alle frekvensene i filteret
            filter1 = filter(filter2(t,1:bredde),1,tone);%Kjører hver tone gjennom filteret og spytter ut hvor godt det passer
            test = [test filter1];
%           plot(filter1);
            %disp(max(filter1));
            if (max(filter1) > treffrate) %Passer tonen mer en 75%...
                resultat = [resultat t]; %...legges den til i resultatlisten
            end
        end
        if (length(resultat) ~= 2)
            disp('Ikke nok frekvenser innenfor gitt treffrate')
            tallene = [];
            break
        end
        frekvens1 = frekvenser(resultat(1)); %Hver tone består av 2 frekvenser, der de ligger i resultat(1) og resultat(2) 
        frekvens2 = frekvenser(resultat(2));
        sum = frekvens1 + frekvens2; %Summene av frekvensene brukes til å finne hvilke tall de stammer fra
        tallene = [tallene frekvensTilTall(sum)]; %Liste med hvilke tall som er trykket. Resultatet av frekvensTilTall legges inn
    end 
    %Plotter hvor godt det passer med filteret
    nummer = 11200;
    entil = 5;
    plot(test(nummer*(entil-1):nummer*entil));
end      


function tall = frekvensTilTall(sum) %Funksjon som finner hvilken sum av 2 frekvenser som hører til hvilket tastetrykk
    switch(sum)
        case(697+1209)
            tall = '1';
        case(697+1336)
            tall = '2';
        acase(697+1477)
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
        otherwise %Hvis summen av frekvenser ikke passer med noen av de gitte frekvensene
            tall = 'FEIL!';
            
    end
            
end

