# A warm wish for 2022 
This project contains the source of the puzzle game that Dynamo uses to wish the best for the year 2022.

## Announcement
We are announcing the wish on the intranet. For that we will use the following announcement.

> Software development is op de eerste plaats mensen werk. Het zijn de wensen van mensen die gerealiseerd worden. Het is een team van mensen die deze wensen vertaalt in een werkende applicatie. Datzelfde team onderhoudt de applicatie en zorgt ervoor dat deze beschikbaar is en blijft.
>
> Software development is vaak ook een puzzel. Er zijn tal van keuzes die gemaakt moeten worden tijdens software development. Het overzien van de gevolgen van deze keuzes en het omgaan met eerder gemaakte keuzes is een opgave.
>
> Beide genoemde aspecten wil het Dynamo team graag terug laten komen in een wens voor het nieuwe jaar.
>
> Afgelopen jaar was het namelijk moeilijk om de mens achter de ontwikkelaar te blijven herkennen, en te vinden in de bekende tegeltjes van de teams-vergaderingen.
>
> Vandaar dat wij dit jaar willen beginnen door iedereen een boodschap te sturen. Dit in stijl, met het hart van software development in gedachten.
>
> Hier is een [puzzel][wish]. Het doel van de puzzel is om de foto van het Dynamo team compleet te maken. Dit doe je door de tegels te schuiven in de open ruimte.
> Wanneer de foto compleet is verschijnt onze boodschap voor het nieuwe jaar.
>
> Mocht het niet helemaal lukken; geeft niet op! Na een aantal keer schuiven verschijnt er een knop die je helpt met het oplossen van deze puzzel. Net zo als het Dynamo team binnen Alliander helpt om wensen te realiseren.
> Hier vind jij ook de mogelijkheid om de tegeltjes van hints te voorzien in welke volgorde ze moeten. De tegels worden dan genummerd. Het is de bedoeling dat de nummers van links naar rechts en van onder naar boven in de goede volgorde komen te staan.


## Development
The wish is developed in [Elm][elm-lang]. You can build the wish by executing the following command

```plain
make
```

### Configuration
The wish can be configured by passing flags to the applications. The table below describes the flags.

|Section  |Option      |Type     |Example               | Explanation|
|---------|------------|---------|----------------------|-------|
| puzzlek | rows       | integer | 4                    | The number of rows of tiles |
|         | columns    | integer | 4                    | The number of columns of tiles |
| image   | src        | string  | image/star.jpg       | The image that will be shuffled |
|         | width      | integer | 197                  | The width of the image |
|         | height     | integer | 197                  | The height of the image |
| shuffle | minimum    | integer | 20                   | The minimum number of swaps when shuffling |
|         | maximum    | integer | 50                   | The maximum number of swaps when shuffling |
| wish    | message    | string  | SGVsbG8sIFdvcmxkIQo= | Base64 encoding of a Markdown message |
| hints   | indices    | boolean | false                | Determines if the indices are shown |
|         | solveAfter | integer | 10                   | How many swaps need to be made before solve button is shown |

[elm-lang]: https://elm-lang.org/
[wish]: https://alliander-opensource.github.io/dynamo-wish-2022/ 

# License
This project is licensed under the Mozilla Public License, version 2.0 - see [LICENSE](LICENSE) for details.

# Contributing
Please read [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) and [CONTRIBUTING](CONTRIBUTING.md) for details on the process 
for submitting pull requests to us.

# Contact
Please read [SUPPORT](SUPPORT.md) for how to connect and get into contact with the Power Gird Model project.
