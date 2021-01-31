//
//  Places.swift
//  B2Care
//
//  Created by Jakub Krahulec on 30.01.2021.
//

import Foundation


var helfstyn = Place(id: 1, name: "Hrad Helfštýn", wikiArticle: helfstyntext, imageURL: "https://www.kudyznudy.cz/files/20/20dcd4e7-7ff4-406b-a841-f1d8bc5243b2.jpg?v=20210101120935", latitude: 49.5322767, longtitude: 17.7506514, created: nil, updated: nil, description: nil)


let helfstyntext = "Helfštýn (též Helfštejn, německy Helfenstein [helfn̩štaɪ̯n]) je zřícenina hradu u Týna nad Bečvou v okrese Přerov. Od roku 1963 je chráněn jako kulturní památka ČR.[1] Hrad byl založen na počátku čtrnáctého století. K jeho významnému rozšíření došlo nejpozději na přelomu čtrnáctého a patnáctého století, kdy patřil pánům z Kravař. Další rozsáhlou pozdně gotickou přestavbu prováděsli Pernštejnové od poslední čtvrtiny patnáctého století. Posledním rodem, který na hradě sídlil, se stali Bruntálští z Vrbna, za nichž byl dokončen rozsáhlý renesanční palác. Na počátku třicetileté války byl hrad krátce obsazen stavovským vojskem, ale později na něm sídlila císařská posádka, která odolala dvěma obléháním. V pozdějších dobách byl hrad využíván již jen k vojenským účelům a od druhé poloviny osmnáctého století chátral. V polovině devatenáctého století proběhly první úpravy, jejichž cílem bylo zpřístupnění zříceniny návštěvníkům a pořádání kulturních akcí. Památkové úpravy ze druhé poloviny dvacátého století narušily historický vzhled a přizpůsobily zříceninu pro potřeby každoročního setkání uměleckých kovářů Hefaiston. Helfštýnským kastelánem (vedoucím správy hradu) je Jan Lauro.[2]"

var slavic = Place(id: 2, name: "Slavíčský tunel", wikiArticle: slavictext, imageURL: "https://www.historickasidla.cz/galerie/obrazky/imager.php?img=548952&x=1024&y=768&hash=7b7a1a9f19f541a3904c495a860e04e2&ratio=1", latitude: 49.5438122, longtitude: 17.6530272, created: nil, updated: nil, description: nil)

let slavictext = "Trať měla být původně vedena v zářezu hlubokém 12 m, kvůli nestabilnímu geologickému podloží navrhl vrchní inženýr Karel Hummel vybudování otevřeného tunelu v délce 258,9 m.[1] V srpnu 1845 byl projekt schválen a zahájena stavba z kamenných kvádrů s portály završenými atikovými nástavci.[2] Tunel byl dán do provozu v roce 1847 jako součást úseku Lipník nad Bečvou - Bohumín na Severní dráze císaře Ferdinanda (nyní součást trati Přerov – Bohumín). Tunel fungoval obousměrně až do roku 1873. Byla postavena druhá kolej na jih od obce, po této koleji se jezdilo do Bohumína. Do Rakouska se jezdilo stále tunelem. Tunel chátral a společnost nechtěla do tunelu příliš investovat, postavila druhou kolej ke koleji z roku 1873. To se stalo roku 1895. Tunel patřil drahám až do roku 1925, kdy byl převeden po správu obce Slavíč. V následujících sto letech byl tunel využíván mj. jako skladiště brambor a v 60. letech 20. století se dokonce uvažovalo o jeho znovu zprovoznění vedením třetí koleje hlavní tratě."



var zooZlin = Place(id: 3, name: "Zoologická zahrada Zlín", wikiArticle: zootext, imageURL: "https://turistou.cz/uploads/monthly_2020_02/536662606_ZOOZlnLen.jpg.2dc68885ed5846532e2ce3793b04c60c.jpg", latitude: 49.2729439, longtitude: 17.7164028, created: nil, updated: nil, description: nil)

let zootext = "Zoologická zahrada Zlín, zvaná také Zoo Lešná, je zoologická zahrada vzdálená asi 10 km od centra Zlína. První Zoo ve Zlíně založil Tomáš Baťa 1. května 1930.[2] Nejprve byla v parku u zlínského zámku a v roce 1934 byla přesunuta na vrchol Tlusté hory, kde byla do poloviny druhé světové války (a kde jsou v lese pod televizním vysílačem dodnes vidět betonové základy klecí). Provozována je jako příspěvková organizace ZOO a zámek Zlín – Lešná. Zoo chová přes 200 druhů zvířat, z nichž mezi atraktivní patří např. ptáci kivi (český unikát[3]), sloni afričtí nebo nosorožci. Zvláštností Zoo je také přímý vstup návštěvníků do expozice pštrosů emu a klokanů. Součástí areálu je botanická zahrada."

var placesHardCoded = PlacesData(places: [helfstyn,slavic,zooZlin])
