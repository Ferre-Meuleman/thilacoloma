---
id: 25c8b5f2-6789-4abc-def0-123456789abc
blueprint: kalender
title: Kalender
slug: kalender
template: kalender
layout: layouts/page
intro_title: 'Komende Evenementen'
intro_text: 'Hier vind je een overzicht van alle <span>kampen</span> en <span>weekends</span>. We vergaderen elke zondag (behalve de eerste zondag van de maand)!'
google_calendar_url: 'https://calendar.google.com/calendar/embed?src=c_0b7694ffe57801b2d61a0815a1138f0a1edf463dc0d5072490f1a10b9338aa7b%40group.calendar.google.com&ctz=Europe%2FBrussels'
agenda_title: Agenda

# Slideshow items (verplaatst van global)
news_slides:
  -
    id: slide-1
    type: slide
    enabled: true
    title: Pizzabak
    content: "TC organiseert weer een pizzabak voor onze nieuwe lokalen! Wij maken overheerlijke ambachtelijke pizza's die jullie 24 november kunnen komen ophalen op de scouts."
    image: images/slideshow/1image.jpg
    button_text: 'Meer info'
  -
    id: slide-2
    type: slide
    enabled: true
    title: Belofteweekend
    content: 'Het belofteweekend komt er weer aan! Vergeet zeker niet in te schrijven via stamhoofd, de deadline is 30 november.'
    button_text: 'Meer info'
  -
    id: slide-3
    type: slide
    enabled: true
    title: "TC's Cadeaupakket"
    content: 'Nog op zoek naar het perfecte cadeau voor onder de kerstboom? Verras je geliefden met ons cadeaupakket met typisch Mechelse lekkernijen!'
    button_text: 'Meer info'

# Vergaderingen - Bard content
vergaderingen_content:
  -
    type: heading
    attrs:
      level: 3
    content:
      -
        type: text
        text: 'Tijdstip'
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: bold
        text: 'Jongsten:'
      -
        type: text
        text: ' 14:00 tot 17:00'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Kapoenen t/m seniorwelpen & tictak'
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: bold
        text: 'Ouderen:'
      -
        type: text
        text: ' 14:00 tot 18:00'
  -
    type: paragraph
    content:
      -
        type: text
        text: "Jongverkenners t/m VT's"
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: bold
        text: 'Uitzonderingen:'
      -
        type: text
        text: ' Tijdens examenperiodes vaak op zaterdagavond vergadering. Afwijkingen worden steeds tijdig meegedeeld.'
  -
    type: heading
    attrs:
      level: 3
    content:
      -
        type: text
        text: 'Eerste Zondag'
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: bold
        text: 'Geen scouts op de eerste zondag van de maand!'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Dan hebben de leidingsploegen vergadering.'
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: italic
        text: "Uitzondering: Als er een weekend doorgaat, kan deze 'eerste zondag' toch een scouts-zondag worden."
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: bold
        text: 'Locatie:'
      -
        type: text
        text: ' Scoutslokalen Thila Coloma, Jubellaan / Geerdegemstraat, Mechelen'
  -
    type: heading
    attrs:
      level: 3
    content:
      -
        type: text
        text: 'Afwezigheid'
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: bold
        text: 'Kan je niet komen? Verwittig op tijd (vóór zondag!) zodat de takleiding daar rekening mee kan houden voor de activiteit.'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Het is belangrijk dat de leiding weet wie er komt, zodat ze de activiteiten kunnen aanpassen aan het aantal deelnemers.'
  -
    type: set
    attrs:
      id: afwezigheid-btn
      values:
        type: link_button
        button_text: 'Afwezigheid melden'
        button_url: 'https://stamhoofd.thilacoloma.be/afwezigheid'
        button_icon: 'fas fa-calendar-times'

# Weekends & Kampen - Bard content
weekends_kampen_content:
  -
    type: heading
    attrs:
      level: 3
    content:
      -
        type: text
        text: 'Weekends'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Elke tak gaat jaarlijks 3 keer op weekend. Dan zoekt de leiding een scouts- of chirolokaal op een andere locatie om daar een weekendje plezier te maken. De weekends kosten meestal €25 tot €35 - dit is de kost voor de locatie, het eten en soms ook voor een activiteit of een treinticket.'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'De drie jaarlijkse weekends:'
  -
    type: bulletList
    content:
      -
        type: listItem
        content:
          -
            type: paragraph
            content:
              -
                type: text
                marks:
                  -
                    type: bold
                text: 'Herfstvakantie - Overlevingsweekend:'
              -
                type: text
                text: " Voor verkenners en VT's is dit een stapweekend in de Ardennen. Van alle scoutsactiviteiten is dit misschien nog wel het meest scoutesk - rugzak vol, kaart en kompas en het avontuur tegemoet!"
      -
        type: listItem
        content:
          -
            type: paragraph
            content:
              -
                type: text
                marks:
                  -
                    type: bold
                text: 'Kerstvakantie - Belofteweekend:'
              -
                type: text
                text: ' Heel Thila Coloma trekt naar het mooie domein van de Hoge Rielen in Kasterlee. Op zaterdagavond krijgen alle eerstejaars vanaf de jongwelpen hun belofte. Een heel bijzonder moment!'
      -
        type: listItem
        content:
          -
            type: paragraph
            content:
              -
                type: text
                marks:
                  -
                    type: bold
                text: 'Paasvakantie - Kluisweekend:'
              -
                type: text
                text: ' De drie jongverkennertakken fietsen naar de Kluisberg in Oud-Heverlee om er in tenten te slapen en groepsspelen te spelen met alle jongverkenners van Thila Coloma.'
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: italic
        text: "Weekends lopen meestal van vrijdagavond tot zondagnamiddag. Voor kapoenen begint zo'n weekend pas op zaterdag en eindigt het zondag."
  -
    type: heading
    attrs:
      level: 3
    content:
      -
        type: text
        text: 'Kampen'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'Binnenlands Kamp (3-13 augustus)'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Thila Coloma mag zich trots de organisator van het grootste tentenkamp van België noemen! Met meer dan 450 leden, 70 man leiding en een goed uitgeruste kookploeg trekken we ieder jaar naar een mooi veld (meestal in Wallonië) waar we met de hele groep even deconnecteren van de rest van de wereld en 10 dagen ravotten en plezier maken.'
  -
    type: bulletList
    content:
      -
        type: listItem
        content:
          -
            type: paragraph
            content:
              -
                type: text
                marks:
                  -
                    type: bold
                text: '10 dagen'
              -
                type: text
                text: " voor welpen, Bagheera's, jongverkenners en verkenners"
      -
        type: listItem
        content:
          -
            type: paragraph
            content:
              -
                type: text
                marks:
                  -
                    type: bold
                text: '7 dagen'
              -
                type: text
                text: ' voor kapoenen en baloes'
      -
        type: listItem
        content:
          -
            type: paragraph
            content:
              -
                type: text
                text: 'Driedaagse, dagtocht, totemdag, woudloperskeuken en kampvuuravond'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'Buitenlands Kamp'
  -
    type: paragraph
    content:
      -
        type: text
        text: "Om de drie jaar trekken we met de verkenners, VT's, leiding en kookploeg naar een kampterrein in het buitenland voor ongeveer drie weken. Naast vaste scoutsactiviteiten zoals driedaagse en totemdag, doen we er ook een avontuurlijke activiteit, gaan we de lokale cultuur opsnuiven met een stadsbezoek - kortom: een onvergetelijke reis met je beste vrienden!"
  -
    type: paragraph
    content:
      -
        type: text
        marks:
          -
            type: italic
        text: 'De inschrijvingstool voor het kamp komt steeds in april online op de site.'

# Inschrijvingen - Bard content
inschrijvingen_content:
  -
    type: heading
    attrs:
      level: 3
    content:
      -
        type: text
        text: 'Nieuwe leden & Inschrijvingen'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Om verantwoordelijk leiding te kunnen geven beperken we de grootte van elke tak tot 35 leden. Het online aanmeldingssysteem komt elke zomervakantie beschikbaar.'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'Proefperiode'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Voor kinderen die zich graag willen inschrijven maar nog niet weten wat scouts inhoudt, is er een inloopperiode. Kinderen kunnen '
      -
        type: text
        marks:
          -
            type: bold
        text: '3 zondagen gratis komen proberen'
      -
        type: text
        text: '. Dit is gratis en verzekerd vanuit Scouts en Gidsen Vlaanderen.'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'Groepsgrootte & Voorrang'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Als er te veel leden inschrijven voor een tak, krijgen eerst de kinderen met voorrang een plaats: broertjes of zusjes van leden, of kinderen van oud-leiding. Daarna wordt er geloot.'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'Wachtlijst'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Als een tak vol zit, trekken we nog 5 extra namen voor op een wachtlijst. Als er in september-december nog een lid stopt, krijgt het eerste kind op de wachtlijst een plaats.'
  -
    type: heading
    attrs:
      level: 4
    content:
      -
        type: text
        text: 'Alternatieven'
  -
    type: paragraph
    content:
      -
        type: text
        text: 'Als jouw kind op de wachtlijst terechtkomt, kan je altijd proberen bij een andere scoutsgroep. In Mechelen zijn er nog scouts bij Sint-Rombout, Onze-Lieve-Vrouw-Waver en FOS Open Scouting.'

updated_by: 490dab97-40bc-46ac-8e07-29cd20111226
updated_at: 1738446000
---
Bekijk onze volledige evenementenkalender met alle scoutsactiviteiten.
